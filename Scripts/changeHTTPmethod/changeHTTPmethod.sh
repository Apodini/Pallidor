#!/bin/bash

#########################################################
# 	Script for integrating an changing the		#
#	HTTP methods of `updatePet` and `addPet`	#
# 	Created by Andre Weinkoetz on 21.08.20.		#
#	Copyright © 2020 TUM LS1. All rights reserved	#
#							#
#########################################################

subpath="Scripts/changeHTTPmethod"

while getopts t:s: flag
do
    case "${flag}" in
        t) targetDirectory=${OPTARG};;
    esac
done

swift run Pallidor -o "$subpath/openapi.json" -p "MyPetAPIBefore" -s "none" -t "$targetDirectory"
swift run Pallidor -o "$subpath/openapi_updateHTTPmethods.json" -p "MyPetAPIAfter" -s "none" -t "$targetDirectory"

