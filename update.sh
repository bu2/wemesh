#!/bin/bash -x

cd paraview
git pull origin master
git submodule update --recursive
cd ..
