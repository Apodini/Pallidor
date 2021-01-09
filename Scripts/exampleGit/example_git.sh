#!/bin/bash

# if you experience an error caused by SwiftSyntax manually enter the following command:
# ln -s $(xcode-select -p)/../Frameworks/lib_InternalSwiftSyntaxParser.dylib /usr/local/lib

#########################################################
# 	Script for integrating an added endpoint.	#
#							#
# 	Created by Andre Weinkoetz on 21.08.20.		#
#	Copyright © 2020 TUM LS1. All rights reserved	#
#							#
#########################################################

###
### use the -g parameter to specify your remote git-repository
### e.g. https://github.com/USER/REPOSITORY
###

subpath="Scripts/exampleGit"

while getopts t:g: flag
do
    case "${flag}" in
        t) targetDirectory=${OPTARG};;
	g) gitrepo=${OPTARG};;
    esac
done

# Run Pallidor to generate new client library
swift run Pallidor -o "$subpath/openapi.json" -p "MyPetAPI" -s "none" -t "$targetDirectory"

# Publish result of Pallidor to specified Git repository
cd "$targetDirectory/MyPetAPI"
git init
git add .
git commit -m "new version of client library"
git branch -m develop
git remote add origin $gitrepo
git push --set-upstream origin develop
