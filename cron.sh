#!/bin/bash
git fetch origin
git reset --hard origin/master
cd $(dirname ${BASH_SOURCE[0]})
./run
