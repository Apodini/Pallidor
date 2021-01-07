#!/bin/bash

# if you experience an error caused by SwiftSyntax manually enter the following command:
# ln -s $(xcode-select -p)/../Frameworks/lib_InternalSwiftSyntaxParser.dylib /usr/local/lib

#########################################################
# 	Script for changing the boundaries		#
#	of `orderId` parameter of  `getOrderById`	#
#							#
# 	Created by Andre Weinkoetz on 21.08.20.		#
#	Copyright © 2020 TUM LS1. All rights reserved	#
#							#
#########################################################

subpath="Scripts/changeBoundaries"

while getopts t:s: flag
do
    case "${flag}" in
        t) targetDirectory=${OPTARG};;
    esac
done

swift run Pallidor -o "$subpath/openapi.json" -p "MyPetAPIBefore" -s "none" -t "$targetDirectory"
swift run Pallidor -o "$subpath/openapi_changedBoundaries.json" -p "MyPetAPIAfter" -s "none" -t "$targetDirectory"

