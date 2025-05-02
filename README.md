# monitor
monitoring scripts for turbonomic
## Contents
- [monitor](#monitor)
  - [Contents](#contents)
  - [Introduction](#introduction)
    - [Actions](#actions)
    - [Pods](#pods)
    - [targets](#targets)
- [Deployment](#deployment)
  - [Requirements](#requirements)
  - [Deployment process](#deployment-process)
    - [Clone the repository](#clone-the-repository)
    - [Set up configuration values](#set-up-configuration-values)
    - [Set up LFS (Large File support)](#set-up-lfs-large-file-support)
    - [Configure the cluster Namespace](#configure-the-cluster-namespace)
    - [import the image file](#import-the-image-file)
    - [deploy the cronjob](#deploy-the-cronjob)
- [Mail Notifications](#mail-notifications)

## Introduction

This set of scripts monitors the following aspects of Turbonomic:

### Actions
The script checks that we see actions being generated within the ???? cycle by checking the rsyslog logs

### Pods
The script checks that all the pods are in the Running state and and that the expected number (e.g 1/1 2/2) of containers are active.

### targets
There are 2 scripts:
- `stale.sh` checks the rsyslog log for any stale target data reports.
- `targets.py` checks the current status of the targets and reports the status message of any whose heath is not *Normal*.  
The act of checking the targets also confirms that turbo's API is responding.

# Deployment
## Requirements
- git, including lfs (Large File Support)
- Access to the cluster running Turbonomic and permsssion to create and use a name space
- Access to an SMTP relay with permission to send emails
- Credentials for API access to the Turbonomic instance.
## Deployment process
there are 4 basic steps to the delpoyment process:
1. [Clone this Git repository](#clone-the-repository)
2. Set up configuration values
3. Set up LFS support and pull the image
4. Configure the cluster Namespace
5. import the image file
6. deploy the cronjob

### Clone the repository
**Note: a zip of the contents will not work as you need access to the large file turbonomic.tar**
Clone this repository using http or ssh.
cd into setup directory in the repository diretory  
    `cd monitoring/setup-monitor`  
There are scripts provided in this directory that will perform the other steps 

### Set up configuration values
In the *setup-monitoring* directory edit the values file. Set the following:
- **scripts** - a list of the scripts to run and the order to run them in. The full list of available scripts are as follows:
    -  *pods* - Checks the health of the pods
    -  *pipeline* - Checks communication between Turbonomic components for errors
    -  *stale* - Checks for stale target data
    -  *actions* - confirms that actions are being generated
    -  *targets* - checks the health of Targets defined in Turbonomic
- **noncriticalpods** - Comma seperated list of pods that are considered non-critical. If there is a problem with one of the pods listed here it will generte a '*Minor*' notification. Problems with all others wil generate a '*Critical*' notification. e.g 'grafana,timescaledb'
- **turbohost** - IP address or FQDN of the turbonomic host
- **turbouser** - turbonomic API username
- **turbopass** - turbonomic API password
- **smtp_host** - IP Address or FQDN of an SMTP relay
- **smtp_port** - Port for access of the SMTP relay
- **smtp_user** - User to access the smtp relay (Don't set this if you are using anonymous smtp access)
- **smtp_pass** Password to access the smtp relay (Don't set this if you are using anonymous smtp access)
- **from_email** - source email name 
- **to_email** comma seperated list of mail recipients
### Set up LFS (Large File support)
Run the script: `1.setup-lfs.sh`
This will:
- Install git-lfs using either *yum* or *apt-get* depending on your OS.
- run `git lfs pull` to pull the large tar file into the repository diretory.
### Configure the cluster Namespace
Run the script `2.create-secrets.sh`. This will:
- Create the *tubomonitor* namespace
- Run the scripts in the *secrets* directory to set up all the secrets and configmaps required by the monitors using the settings in the *values* file
### import the image file
Run the script `3.import-image.sh` this will:
- import the turbonomic.tar image file
- check that the image appears in internal registry
### deploy the cronjob
Check the schedule setting in the file cronjob.yaml. By default the monitors run once a day at 8am, with this entry:
>  schedule: "0 8 * * *"  

You can change this using standard crontab values:  

| * | * | * | * | * |
|:---:|:---:|:---:|:---:|:---:|
|Minutes|Hours|Day of Month|Month|Day of Week|
|0-59|0-23|1-31|1-12|0-6|

e.g 6:30 Monday to Friday:
>  schedule: "30 6 * * 1-5"  

# Mail Notifications