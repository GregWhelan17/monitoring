#!/usr/bin/python3

import requests
import re
import json
import sys
import urllib3
urllib3.disable_warnings(category=urllib3.exceptions.InsecureRequestWarning)


def get_hostname(file):
    hostfile=open(file,'r')
    for line in hostfile.read().splitlines():
        # print(f'LINE: {line}')
        if not re.match(r'^\s*#',line):
            return line
        

# LOGIN
def turbo_login(hostname,username,password):
    url=f'https://{hostname}/vmturbo/rest/login'
    # data={'username': 'Administrator', 'password': 'Whelan123!'}
    # data={'username': 'GB-svc-api', 'password': 'getDataFr0mMe!'}
    data={'username': username, 'password': password}

    # print (f'URL: {url}')
    r=requests.post(url,data=data,verify=False)
    if r.status_code != 200:
        print("Failed to log in to Turbonomic:")
        print(r.text)
        sys.exit(2)
    # head=json.loads(r.headers)
    # print(head)
    cookie=r.headers['Set-Cookie'].split(';')[0]
    return cookie


def get_targets(url, cookie):
    headers={
        "content-type": "application/json",
        "cookie": cookie
    }
    r=requests.get(
        url,
        headers=headers,
        verify=False
    )
    data=json.loads(r.text)
    datafile=open('targets.json','w')
    datafile.writelines(r.text)
    datafile.close()
    # print(r.text)
    return r.text


def list_bad_targets(targets):
    badTargets=[]
    for t in json.loads(targets):
        if t['healthSummary']['healthState'] == 'CRITICAL':
            badTarget={t['displayName']:(t['healthSummary']['healthState'],t['status'])}
            badTargets.append(t)
    # print(badTargets)
    if len(badTargets) != 0:
        print()
        print(f'The following {len(badTargets)} targets have a bad status:')
        for t in badTargets:
            print(f"{t['displayName']}")
            print('----------------------------------------------------------------------------------------------')
            print(f"health: {t['healthSummary']['healthState'] }")
            print('----------------------------------------------------------------------------------------------')
            print(f"status: {t['status']}")
            print('----------------------------------------------------------------------------------------------')
            print()
            print('==============================================================================================')
        sys.exit(1)

    # ================================= MAIN =================================

# turbo_user=sys.argv[1]
# turbo_pass=sys.argv[2]

turbo_user='administrator'
turbo_pass='Whelan123!'
file='turbohost'
hostname=get_hostname(file)
cookie=turbo_login(hostname, turbo_user, turbo_pass)
url=f'https://{hostname}/api/v3/targets'
targets=get_targets(url=url,cookie=cookie)
list_bad_targets(targets)
