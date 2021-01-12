#!/bin/bash

# if you experience an error caused by SwiftSyntax manually enter the following command:
# ln -s $(xcode-select -p)/../Frameworks/lib_InternalSwiftSyntaxParser.dylib /usr/local/lib

#########################################################
# 	Script for performing a full migration  	#
#							#
# 	Created by Andre Weinkoetz on 21.08.20.		#
#	Copyright © 2020 TUM LS1. All rights reserved	#
#							#
#########################################################

subpath="Scripts/fullMigration"

while getopts t:s: flag
do
    case "${flag}" in
        t) targetDirectory=${OPTARG};;
    esac
done

swift run Pallidor -o "$subpath/openapi.json" -p "MyPetAPI" -s "none" -t "$targetDirectory"
swift run Pallidor -o "$subpath/openapi_modified.json" -p "MyPetAPI" -t "$targetDirectory" -m "$subpath/guide.json"

