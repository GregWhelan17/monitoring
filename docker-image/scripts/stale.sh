#!/bin/bash

stale=$(kubectl logs deployment/rsyslog | awk '/== Stale Data Report ==/ {go=1} ; (go == 1) {print $0} ; /== end of report ==/ {go=0}')

if [ "${stale}" != '' ] ; then
    echo
    echo 'Stale target data detected:'
    echo "${stale}"
    echo '=============================================================================================='
    exit 1
fi