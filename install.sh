#!/bin/bash

curl --location 'https://search.maven.org/remotecontent?filepath=org/tuckey/urlrewritefilter/4.0.3/urlrewritefilter-4.0.3.jar' -o /opt/lucee/tomcat/lib/urlrewritefilter-4.0.3.jar

# Installs the latest CommandBox Binary
mkdir -p /tmp
curl -k --location "https://www.ortussolutions.com/parent/download/commandbox/type/bin" -o /tmp/box.zip
unzip /tmp/box.zip -d ${BIN_DIR} && chmod +x ${BIN_DIR}/box
echo "commandbox successfully installed"

# Cleanup CommandBox modules which would not be necessary in a Container environment
SYSTEM_EXCLUDES=( "coldbox" "contentbox" "cachebox" "forgebox" "logbox" "games" "wirebox" )
MODULE_EXCLUDES=( "cfscriptme-command" "cb-module-template" )

for mod in "${SYSTEM_EXCLUDES[@]}"
do
	rm -rf $HOME/.CommandBox/cfml/system/modules_app/${mod}-commands
done

for mod in "${MODULE_EXCLUDES[@]}"
do
	rm -rf $HOME/.CommandBox/cfml/modules/${mod}
done

${BIN_DIR}/box install commandbox-cfconfig --production

# Remove any temp files
rm -rf $HOME/.CommandBox/temp/*
# Remove any log files
rm -rf $HOME/.CommandBox/logs/*
# Remove cachebox caches
rm -rf $HOME/.CommandBox/cfml/system/mdCache/*
# Remove the felix cache
rm -rf $HOME/.CommandBox/engine/cfml/cli/lucee-server/felix-cache/*
# Clear downloaded artifacts
${BIN_DIR}/box artifacts clean --force

# Cleanup
# More unecessary files
rm -rf /var/lib/{cache,log}/
# Remove Unecessary OS files
rm -rf /usr/share/icons /usr/share/doc /usr/share/man /usr/share/locale /tmp/*.*