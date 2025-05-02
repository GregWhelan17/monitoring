# Monitor
Monitoring scripts for turbonomic

## Contents
- [Monitor](#monitor)
  - [Contents](#contents)
  - [Introduction](#introduction)
    - [Actions](#actions)
    - [Pods](#pods)
    - [Pipeline](#pipeline)
    - [Targets](#targets)
- [Deployment](#deployment)
  - [Requirements](#requirements)
  - [Deployment process](#deployment-process)
    - [Clone the repository](#clone-the-repository)
    - [Set up configuration values](#set-up-configuration-values)
    - [Set up LFS (Large File support)](#set-up-lfs-large-file-support)
    - [Configure the cluster Namespace](#configure-the-cluster-namespace)
    - [Import the image file](#import-the-image-file)
    - [Deploy the cronjob](#deploy-the-cronjob)
- [Mail Notifications](#mail-notifications)

## Introduction

This application runs a set of scripts that monitors the following aspects of Turbonomic:

### Actions
The script checks that we see actions being generated within the 10 minute cycle by checking the rsyslog logs.

### Pods
The script checks that all the pods are in the Running state and and that the expected number (e.g 1/1, 2/2, 4/4) of containers are active.

### Pipeline
The script checks for errors from the pipeline that provides communication beween the turbonomic components.

### Targets
There are 2 scripts:
- `stale.sh` checks the rsyslog log for any stale target data reports.
- `targets.py` checks the current status of the targets and reports the status message of any whose heath is not *Normal*.  
The act of checking the targets also confirms that turbo's API is responding.

# Deployment
This section describes how to deploy the monitoring application.

## Requirements
- git, including lfs (Large File Support)
 Access to the cluster where Turbonomic is running and permsssion to create a namespace, secrets and a cronjob.
- Access to an SMTP relay with permission to send emails.
- Credentials for API access to the Turbonomic instance.

## Deployment process 
There are 6 basic steps to the delpoyment process:
1. [Clone this Git repository](#clone-the-repository).
2. [Set up configuration values](#set-up-configuration-values).
3. [Set up LFS support and pull the image](#set-up-lfs-large-file-support).
4. [Configure the cluster Namespace](#configure-the-cluster-namespace).
5. [Import the image file](#import-the-image-file).
6. [Deploy the cronjob](#deploy-the-cronjob).

### Clone the repository
***Note: a zip of the contents will not work as you will not get access to the large file turbonomic.tar***.  
Clone this repository using http or ssh.  
cd into the setup directory in the repository directory  
    `cd monitoring/setup-monitor`  
There are scripts provided in this directory that will perform the other steps. 

### Set up configuration values
In the *setup-monitoring* directory edit the *values* file. Set the following:
- **scripts** - a comma seperated list of the scripts to run and the order to run them in. The full list of available scripts are as follows:
    -  *pods* - Checks the health of the pods
    -  *pipeline* - Checks communication between Turbonomic components for errors
    -  *stale* - Checks for stale target data
    -  *actions* - confirms that actions are being generated
    -  *targets* - checks the health of Targets defined in Turbonomic
- **noncriticalpods** - Comma seperated list of pods that are considered non-critical. If there is a problem with one of the pods listed here it will generte a '*Minor*' notification. Problems with all other pods wil generate a '*Critical*' notification.  
- **turbohost** - IP address or FQDN of the turbonomic host
- **turbouser** - turbonomic API username
- **turbopass** - turbonomic API password
- **smtp_host** - IP Address or FQDN of an SMTP relay
- **smtp_port** - Port for access to the SMTP relay
- **smtp_user** - User to access the smtp relay (Don't set this if you are using anonymous smtp access)
- **smtp_pass** Password to access the smtp relay (Don't set this if you are using anonymous smtp access)
- **from_email** - source email name 
- **to_email** - comma seperated list of mail recipients

### Set up LFS (Large File support)

Run the script: `1.setup-lfs.sh`
This will:
- Install git-lfs using either *yum* or *apt-get* depending on your OS.
- Call `git lfs pull` to pull the large tar file into the repository diretory.

### Configure the cluster Namespace

Run the script `2.create-secrets.sh`. This will:
- Create the *tubomonitor* namespace
- Run the scripts in the *secrets* directory. They will set up all the secrets and configmaps required by the monitors using the settings in the *values* file

### Import the image file

Run the script `3.import-image.sh` this will:
- Import the turbonomic.tar image file
- Check that the image appears in the kubernetes internal registry

### Deploy the cronjob

Check the schedule setting in the file cronjob.yaml.
The default entry:  
>  schedule: "0 8 * * *"  

 Mean that  By default the monitors run once a day at 8am.  
You can change this using standard crontab values:  

| * | * | * | * | * |
|:---:|:---:|:---:|:---:|:---:|
|Minutes|Hours|Day of Month|Month|Day of Week|
|0-59|0-23|1-31|1-12|0-6|

e.g 6:30 Monday to Friday:
>  schedule: "30 6 * * 1-5"  

Run `4.deploy-job.sh` to deploy the cronjob to the cluster.  
At the scheduled time you should see a container run in the turbomonitor namespace. Once it is complete all mail recipients should receive an email message.

# Mail Notifications
TBC... 