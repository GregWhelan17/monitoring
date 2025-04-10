#!/bin/bash
kubectl create secret generic kube-secret --from-file=~/.kube/config
