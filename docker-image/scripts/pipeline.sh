#!/bin/bash

bcast=$(kubectl logs deployment/rsyslog | awk '/======== Pipeline Summary ========/ {failed=0; go=1 ; out=""} ;/Status: FAILED/ {failed=1} ; (go == 1) {out = out"\n"$0} ; /Pipeline Duration/ {go=0} ; (failed == 1 && go == 0 && out != "") {print out ,"\n=================================="; failed=0 i; out=""}' )

if [ "${bcast}" != '' ] ; then
    echo
    echo 'Bad pipeline status detected:'
    echo "${bcast}"
    echo '=============================================================================================='
    exit 1
fi
