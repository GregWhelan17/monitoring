#!/usr/bin/python3

import smtplib
import os
import datetime
import sys
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


def read_envs(dir):
    envs_obj = {}
    for (root,dirs,files) in os.walk(dir,topdown=True,followlinks=True):
    # print(f"Directory path: {root}, Directory Names: {dirs}, Files Names: {files}")
      for file in files:
        f = open(f'{root}/{file}', 'r')
        envs_obj[file] = f.readline().splitlines()[0]
        f.close()
    return envs_obj

# =turbomonitor@gregwhelan.co.uk  --from-literal=smtppass='Welcome123!'

def send_email(message,to,envs):
    # Set Up the SMTP Server
    msg = MIMEMultipart('alternative')
    msg['From'] = envs['from-email']
    msg['To'] = to
    # msg['CC'] = params.get('email_cc', '')
    msg['Subject'] = "Turbonomic monitoring"
    msg.attach(MIMEText(message, 'html'))

    smtp_server = envs['smtp-host']
    port = envs['smtp-port']
    print(f"SMTP Server: {smtp_server}, Port: {port}")
    # Create SMTP Session
    server = smtplib.SMTP(smtp_server,port)

    # Create SMTP Session
    server.starttls()

    # Login to the Server
    print(f"User: {envs['smtp-user']}, Pass: {envs['smtp-pass']}")
    server.login(envs['smtp-user'], envs['smtp-pass'])

    # Compose the Email
    from_address = envs['from-email']
    to_address = to.split(',')
    subject = "Turbonomic monitoring"
    body = message
    subj = "hello"
    date = datetime.datetime.now().strftime( "%d/%m/%Y %H:%M" )

    # msg = f"From: {from_address}\nTo: {to}\nSubject: {subject}\nDate: {date}\n\n{body}"
    print (f"Message: {msg}")

    # Send the Email
    print(f"From: {from_address}, To: {to_address}")
    server.sendmail(from_address, to_address, msg.as_string())

    # Close the SMTP Session
    server.quit()

def prepare_message(message):
    html_message=f"""\
        <!doctype html>
        <html lang="en">
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Turbonomic Status Email</title>
         

        </head>
        <body {{ font-family: 'verdana', monospace; font-size: 12;}}>
            <table> <th> <td {{
                border: 1px solid black;
                border-collapse: collapse;
            }}>
            <th> <td {{
                padding: 5px;    
            }}>
            <th {{
            text-align: left
            }}>
            <div {{
                padding-bottom: 10px;
            }}>
            {message}
        </body>
        </html>
        """
    return html_message


tomail = "nick.freer@yahoo.co.uk,nick.freer@uk.ibm.com,nick.freer@ymail.com"
envs=read_envs('/config')
print(envs)
msg_body=prepare_message(' '.join(sys.argv))
send_email(msg_body,tomail,envs)

