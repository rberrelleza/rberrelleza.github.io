---
layout: post
title:  "Share files using HipChat and python"
date:   2015-11-25 15:16:00
categories: posts
---

Sharing files via HipChat is a very useful feature. However, it's on my opinion,  one of the [hardest APIs to use](https://www.hipchat.com/docs/apiv2/method/share_file_with_room). Here's an example of how to do it in python:

```python
#!/bin/python

import argparse
import json
import os.path
import re
import requests
import sys
from email.mime.multipart import MIMEMultipart
from email.mime.nonmultipart import MIMENonMultipart

requests.packages.urllib3.disable_warnings()

def post_file(token, url, msg_body, file_path):
    headers = {"Content-Type": "application/json", "Authorization": "Bearer {}".format(token)}

    related = MIMEMultipart("related")

    part_body = MIMENonMultipart("application", "json", charset="utf8")
    part_body.add_header("Content-Disposition", 'attachment; name="body"')
    part_body.set_payload(json.dumps(msg_body))
    related.attach(part_body)

    file_name = os.path.basename(file_path)
    with open(file_path, 'rb') as f:
        file_data = f.read()

    part_file = MIMENonMultipart('application', "octet-stream")
    part_file.set_payload(file_data, "utf-8")
    part_file.add_header("Content-Disposition", 'attachment; name="file"; filename="{}"'.format(file_name))
    related.attach(part_file)
    body = related.as_string().split('\n\n', 1)[1]

    headers.update(dict(list(related.items())))

    resp = requests.post(url, data=body, headers=headers, verify=False)
    resp.raise_for_status()

def share_file_with_room(api_url, room_id, token, file_path, message):
    url = "{}/room/{}/share/file".format(api_url, room_id)
    post_file(token, url, {"message": message}, file_path)    

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Share a file with a room')

    parser.add_argument('-r', '--room', dest='room', type=str, help='The room id', required=True)
    parser.add_argument('-t', '--token', dest='token', type=str, help='The HipChat authorization token', required=True)
    parser.add_argument('-f', '--file', dest='file_path', type=str, help='The path to the file', required=True)
    parser.add_argument('-m', '--message', dest='message', type=str, help='The message to include with the file', required=False, default='')
    parser.add_argument('--api-url', dest='api_url', type=str, help='The HipChat API url', required=False, default="https://hipchat.com/v2")
    user_options = parser.parse_args()

    share_file_with_room(user_options.api_url, user_options.room, user_options.token, user_options.file_path, user_options.message)
```

Hope it helps!
