#!/bin/bash;PathToClean="/home/cix_user/deploy/apps";cd $PathToClean;# Delete all files and directories except .tgz files;OldFiles=$(ls | grep -v .tgz);for file in $OldFiles; do;	rm -rf $file;done
