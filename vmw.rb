require 'pp'
require 'yaml'
require 'rest_client'
require 'nokogiri'
require 'json'
require 'rbvmomi'

require 'credentials'
require 'resolv.rb'
require 'net/ping'

require 'iaas_common'

#@debug = true
@debug = true

# VM log prefix
@log_pref = 'LOG'
@log_api = false



def dump_ems()
  ems = $evm.root['ext_management_system']

  vcenter_ids = {}

  #$evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin Attributes")
  #ems.attributes.sort.each { |k, v| $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> Attributes - #{k}: #{v.inspect}")}
  #$evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End Attributes")
  #$evm.log("info","")

  #$evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin Associations")
  #ems.associations.sort.each { |assc| $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> Associations - #{assc}")}
  #$evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End Associations")
  #$evm.log("info","")

  vcenter_ids['name'] = ems.name
  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Folders")
  #vcenter_ids['folder'] = []
  vcenter_ids['folders'] = {}
  #ems.ems_folders.each { |ef| ef.attributes.sort.each { |k,v| $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS Folder:<#{ef.name}> #{k}: #{v.inspect}") }}
  ems.ems_folders.each do |ef|
    #fullpath = ef.folder_path
    #$evm.log("info","#{@log_prefix} - EMS:<#{fullpath}> Begin EMS Folders")
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        #vcenter_ids['folder'].append({ "#{ef.name}" => "#{v}" })
        #vcenter_ids['folder'].append({ "#{ef.folder_path}" => "#{v}" })
        #vcenter_ids['folder'][ef.folder_path] = "#{v}"
        vcenter_ids['folders']["#{ef.folder_path}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Folders")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Datacenters")
  #vcenter_ids['datacenters'] = []
  vcenter_ids['datacenters'] = {}
  #ems.datacenters.each { |ef| ef.attributes.sort.each { |k,v| $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS Datacenter:<#{ef.name}> #{k}: #{v.inspect}")}}
  ems.datacenters.each do |ef|
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        #vcenter_ids['datacenters'].append({ "#{ef.name}" => "#{v}" })
        #vcenter_ids['datacenters'][ef.name] = "#{v}"
        vcenter_ids['datacenters']["#{ef.name}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Datacenters")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Datastores")
  #vcenter_ids['datastores'] = []
  vcenter_ids['datastores'] = {}
  #ems.storages.each { |ef| ef.attributes.sort.each { |k,v| $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS Datastore:<#{ef.name}> #{k}: #{v.inspect}")}}
  ems.storages.each do |ef|
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        #vcenter_ids['datastores'].append({ ))"#{ef.name}" => "#{v}" })
        #vcenter_ids['datastores'][ef.name] = "#{v}"
        vcenter_ids['datastores']["#{ef.name}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Datastores")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Hosts")
  #vcenter_ids['hosts'] = []
  vcenter_ids['hosts'] = {}
  #ems.hosts.each { |ef| ef.attributes.sort.each { |k,v| $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS Host:<#{ef.name}> #{k}: #{v.inspect}")}}
  ems.hosts.each do |ef|
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        #vcenter_ids['hosts'].append({ "#{ef.name}" => "#{v}" })
        #vcenter_ids['hosts'][ef.name] = "#{v}"
        vcenter_ids['hosts']["#{ef.name}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Hosts")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Clusters")
  #vcenter_ids['clusters'] = []
  vcenter_ids['clusters'] = {}
  #ems.ems_clusters.each { |ef| ef.attributes.sort.each { |k,v| $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS Cluster:<#{ef.name}> #{k}: #{v.inspect}")}}
  ems.ems_clusters.each do |ef|
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        #vcenter_ids['clusters'].append({ "#{ef.name}" => "#{v}" })
        #vcenter_ids['clusters'][ef.name] = "#{v}"
        vcenter_ids['clusters']["#{ef.name}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Clusters")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  #$evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin Virtual Columns")
  #ems.virtual_column_names.sort.each { |vcn| $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> Virtual Columns - #{vcn}: #{ems.send(vcn)}")}
  #$evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End Virtual Columns")
  #$evm.log("info","")


  #$evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS: #{ems.inspect}")
  #ems.ems_folders.each do |ef|
    #$evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS folder path: #{ef.inspect}")
    #$evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS child folders ======================================================== ")
    #$evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS child path: #{ef.folders}")
    #ef.attributes.sort.each do |k,v|
    #  if k == 'id'
    #    vcenter_ids['folder'].append({ "#{ef.name}" => "#{v}" })
    #  end
    #end
    #mypath = ef.folder_path()
    #$evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS my path: #{mypath}")
  #end
  #ems.get_folder_paths { |path| $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> EMS path: #{path.inspect}")}


  return vcenter_ids
end

def vmw_show_infos()
  $evm.log(:info, "SHOW INFOS")

  yaml_file = "/srv/miq-vms/group_vars/all/vcenter_ids.yml"
  data = dump_ems()
  
  $evm.log(:info, "Updating file")
  vcenter_fqdn = data['name']
  vcenter = vcenter_fqdn.split(".")[0] 
  $evm.log(:info, "#{ vcenter }")

  vcenter_ids = YAML.load_file(yaml_file)
  $evm.log("info", "#{@log_prefix} - YAML #{vcenter_ids.inspect}")
  #vcenter_ids = {}
  #vcenter_ids['vcenter_ids'] = {}
  vcenter_ids['vcenter_ids'][vcenter] = data
  $evm.log("info", "#{@log_prefix} - YAML #{vcenter_ids.inspect}")

  File.open(yaml_file, "w") do |file|
    file.write(vcenter_ids.to_yaml)
    file.close
  end

  exit MIQ_OK
end


