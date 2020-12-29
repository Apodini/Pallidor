#!/bin/bash

#########################################################
# 	Script for changing the authorization		#
#	of `updatePet`(?) and `placeOrder`(!)		#
#							#
# 	Created by Andre Weinkoetz on 21.08.20.		#
#	Copyright © 2020 TUM LS1. All rights reserved	#
#							#
#########################################################

subpath="Scripts/changeAuth"

while getopts t:s: flag
do
    case "${flag}" in
        t) targetDirectory=${OPTARG};;
    esac
done

swift run Pallidor -o "$subpath/openapi.json" -p "MyPetAPIBefore" -s "none" -t "$targetDirectory"
swift run Pallidor -o "$subpath/openapi_changedAuth.json" -p "MyPetAPIAfter" -s "none" -t "$targetDirectory"

