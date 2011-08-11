#!/bin/bash

OLD_HEAD=$(git rev-parse HEAD) && \
    git reset --soft HEAD^ && \
    git add -- "$@" && \
    git commit -c ${OLD_HEAD}

