#!/bin/bash

cd test
for file in $(ls *.sh); do
    ./$file
done
