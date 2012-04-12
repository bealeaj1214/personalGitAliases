#!/bin/bash

ORG_BRANCH="$(git symbolic-ref HEAD 2>/dev/null)" || exit 1
ORG_BRANCH=${ORG_BRANCH##refs/heads/}

#echo "saving branch ${ORG_BRANCH} "

# hillbilly style script for sync  of tracking branches ( git to git remote sync op)
for BRANCH in $( git branch | awk ' $NF~/^tracking\// {print $NF} ' | xargs); do 
    git checkout $BRANCH && git pull
done

#echo "switching back to ${ORG_BRANCH} "

git checkout ${ORG_BRANCH}

# Improvements
  # remember the branch that you started on and fast fail if there unstored changes
  #  Collect which branches had errors and report