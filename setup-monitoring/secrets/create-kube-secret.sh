#!/bin/bash
cd

kubectl -n turbomonitor delete secret kube-secret --ignore-not-found
kubectl -n turbomonitor create secret generic kube-secret --from-file=.kube/config
