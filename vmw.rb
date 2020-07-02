require 'pp'
require 'yaml'
require 'rest_client'
require 'nokogiri'
require 'json'
require 'rbvmomi'

require 'credentials'
require 'resolv.rb'
require 'net/ping'

#@debug = true
@debug = true

# VM log prefix
@log_pref = 'LOG'
@log_api = false



def dump_ems()
  ems = $evm.root['ext_management_system']

  vcenter_ids = {}
  vcenter_ids['name'] = ems.name
  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Folders")
  vcenter_ids['folders'] = {}
  ems.ems_folders.each do |ef|
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        vcenter_ids['folders']["#{ef.folder_path}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Folders")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Datacenters")
  vcenter_ids['datacenters'] = {}
  ems.datacenters.each do |ef|
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        vcenter_ids['datacenters']["#{ef.name}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Datacenters")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Datastores")
  vcenter_ids['datastores'] = {}
  ems.storages.each do |ef|
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        vcenter_ids['datastores']["#{ef.name}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Datastores")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Hosts")
  vcenter_ids['hosts'] = {}
  ems.hosts.each do |ef|
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        vcenter_ids['hosts']["#{ef.name}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Hosts")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")


  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> Begin EMS Clusters")
  vcenter_ids['clusters'] = {}
  ems.ems_clusters.each do |ef|
    ef.attributes.sort.each do |k,v|
      if k == 'id'
        vcenter_ids['clusters']["#{ef.name}"] = "#{v}"
      end
    end
  end
  $evm.log("info","#{@log_prefix} - EMS:<#{ems.name}> End EMS Clusters")
  $evm.log("info","")

  $evm.log("info", "#{@log_prefix} - EMS:<#{ems.name}> vcenter_ids - #{vcenter_ids.inspect}")

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
  vcenter_ids['vcenter_ids'][vcenter] = data
  $evm.log("info", "#{@log_prefix} - YAML #{vcenter_ids.inspect}")

  File.open(yaml_file, "w") do |file|
    file.write(vcenter_ids.to_yaml)
    file.close
  end

  exit MIQ_OK
end

