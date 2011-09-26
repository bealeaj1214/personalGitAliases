#!/bin/bash

ORG_BRANCH=$(git status -b -s | awk ' /##/ {print $NF;} ' )
# hillbilly style script for sync  of tracking branches ( git to git remote sync op)
for BRANCH in $( git branch | awk ' $NF~/^tracking\// {print $NF} ' | xargs); do 
    git checkout $BRANCH && git pull
done
git checkout ${ORG_BRANCH}

# Improvements
  # remember the branch that you started on and fast fail if there unstored changes
  #  Collect which branches had errors and report