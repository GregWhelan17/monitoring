# monitor
monitoring scripts for turbonomic

This set of scripts monitors the following aspects of Turbonomic:

## Actions
The script checks that we see actions being generated within the ???? cycle by checking the rsyslog logs

## Pods
The script checks that all the pods are in the Running state and and that the expected number (e.g 1/1 2/2) of containers are active.

## targets
There are 2 scripts:
* `stale.sh` checks the rsyslog log for any stale target data reports.
* `targets.py` checks the current status of the targets and reports the status message of any whose heath is not *Normal*.  
The act of checking the targets also confirms that turbo's API is responding.

## Jenkins Pipeline
Link to [turbo_monitor](https://almjenkinsci-prod.systems.uk.hsbc/ctoss03/job/hsbc-12437542-turbonomic/job/turbo_monitor/) pipeline
