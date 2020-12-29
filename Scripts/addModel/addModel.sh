#!/bin/bash

#########################################################
# 	Script for integrating an added model.		#
#	This new type is not used yet in the API.	#
#							#
# 	Created by Andre Weinkoetz on 21.08.20.		#
#	Copyright © 2020 TUM LS1. All rights reserved	#
#							#
#########################################################

subpath="Scripts/addModel"

while getopts t:s: flag
do
    case "${flag}" in
        t) targetDirectory=${OPTARG};;
    esac
done

swift run Pallidor -o "$subpath/openapi.json" -p "MyPetAPIBefore" -s "none" -t "$targetDirectory"
swift run Pallidor -o "$subpath/openapi_addedApiResponseModel.json" -p "MyPetAPIAfter" -s "none" -t "$targetDirectory"

