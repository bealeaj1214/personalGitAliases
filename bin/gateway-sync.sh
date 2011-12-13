#!/bin/bash

ORG_BRANCH=$(git status -b -s | awk ' /##/ {print $NF;} ' )
# hillbilly style script for sync svn gateway
for BRANCH in $( git branch | awk ' $NF~/^active\// {print $NF} ' | xargs); do 
    git checkout $BRANCH && git svn rebase 
done

git svn fetch

git checkout ${ORG_BRANCH}
# Improvements
  # fast fail if there unstored changes
  #  Collect which branches had errors and report