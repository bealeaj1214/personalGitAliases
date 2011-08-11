#!/bin/bash

OLD_HEAD=$(git rev-parse HEAD) && \
    echo git reset --soft HEAD^ && \
    echo git add -- "$@" && \
    echo git commit -c ${OLD_HEAD}
