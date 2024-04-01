#!/bin/bash

PathToClean="/home/cix_user/deploy/apps";

cd $PathToClean

# Delete all files and directories except .tgz files
OldFiles=$(ls | grep -v .tgz)

for file in $OldFiles;
do
	rm -rf $file
done

latest=$(ls -rt | tail -n 1)

# Keep only the latest version
if [ $(ls | wc -l) -ge 1 ]; then
	OldFiles=$(ls)

	for file in $OldFiles;
	do
        	if [ $file != $latest ]; then
                	rm $file
        	fi
	done
	mv $latest OLD-$latest
fi
