#!/bin/sh

bad=0
# for monitor in pods.sh stale.sh pipeline.sh actions.sh ; do
for monitor in pods.sh stale.sh pipeline.sh ; do
    # echo "${monitor}"
    result=$(./${monitor} $*)
    status=$?
    out="${out} ${result}"
    echo ${result} > ${monitor}.out
    # echo $monitor ${status}
    if [ ${status} -gt ${bad} ] ; then
        bad=${status}
    fi
done

# echo "targets.py"
result="${out} $(python3 targets.py $*)"
status=$?
out="${out} ${result}"
echo ${result} > targets.out
# echo $monitor ${status}
if [ ${status} -gt ${bad} ] ; then
    bad=${status}
fi

case $bad in
    0) 
        echo "Turbonomic is up and running" > summary.out
        colour='green'
    ;;
    1)
        summary="Turbonomic has some minor non-critical errors but is running"
        colour='orange'
    ;;
    *)
        summary="Turbonomic has critical errors and needs investigation"
        colour='red'
    ;;
esac

# Send Notifications Here use ${out} for content
(echo "<h1 style="background-color:${colour}">Monitoring Status</h1>${summary}"
if [ ${bad} -ne 0 ] ; then
    echo 'The following problems were found with Turbonomic:'
    echo ''
    echo '<ul>'
    echo '  <li><img src="./images/low.svg"/> <a href="#pod_status">Pod Status</a> - 3 out of XX pods are not running correctly.</li>'
    echo '  <li><img src="./images/low.svg"/> <a href="#target_health">Target Health</a> - 2 targets have a bad status.</li>'
    echo '  <li><img src="./images/error.svg"/> <a href="#action_status">Action Status</a> - ERROR: No action generation message found in the rsyslog.</li>'
    echo '</ul>'
    echo '<p>Below summarises the Turbonomic problems found.</p>'
    echo "$out"
else
    echo '<h1 style="background-color:green">Monitoring Status</h1>'
    echo 'Turbonomic is working correctly'
fi) > summary.out

cat summary.out
