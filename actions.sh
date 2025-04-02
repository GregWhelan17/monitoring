#!/bin/bash

# try for 12 mins
count=0
while [ "${actions}" == '' -a ${count} -lt 12 ] ; do
    actions=$(kubectl logs deployment/rsyslog | grep ActionStorehouse)
    count=$(expr ${count} + 1)
    # echo "${count}/10"
    sleep 60
done
# echo "${count} - ${actions}"

if [  "${actions}" == '' ] ; then
    echo
    echo 'ERROR: No action generation message found'
    echo '=============================================================================================='
    exit 1
fi
