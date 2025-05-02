#!/bin/bash

cd secrets
for f in * ; do
    ./$f
done
