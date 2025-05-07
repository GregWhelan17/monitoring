#!/bin/bash

kubectl create ns turbomonitor
cd secrets
for f in * ; do
    ./$f
done
