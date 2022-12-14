#!/bin/bash

gitOwner="gitOwnerName"
gitRepo="gitRepoName"

versionNum=$( curl -sL https://api.github.com/repos/$gitOwner/$gitRepo/releases/latest | grep "tag_name" | cut -d : -f 2,3 | tr -d '"' | awk '{$1=$1};1' | rev | cut -c2- | rev | cut -c2- )

echo "$versionNum"
