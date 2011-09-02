#!/bin/bash
git status --porcelain | awk ' $1~/??/ && $NF~/[.]orig$/ {print $NF}'