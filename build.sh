#!/bin/bash

#set -x

NAME="vmw"
VERSION="1.0"

SPEC=${NAME}.gemspec
MODULE=${NAME}-${VERSION}.gem

LIB="`gem list | grep -w $NAME | awk '{print $1}'`"
echo ${LIB}
if [ -z ${LIB} ]
then
	echo "$NAME not installed"
else
        echo "Removing gem ${NAME} ..."
        gem uninstall $LIB
fi

if [ -f ./${MODULE} ]
then
        echo "Deleting previous ${NAME} gem"
	rm -f ./${MODULE}
fi

echo "Building gem ${NAME} ..."
gem build ./${SPEC}

echo "Installing gem ${NAME} ..."
gem install ./${MODULE}

echo "Checking gem ${NAME} ..."
gem list | grep $NAME


