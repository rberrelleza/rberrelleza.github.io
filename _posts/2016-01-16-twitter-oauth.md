---
layout: post
title:  "Generate a Twitter oauth2 token with python"
date:   2016-01-16 13:40:00
categories: posts
---

This took me a while to figure out, so I'm sharing it here in case you ever need a Twitter OAUTH2 token (e.g to [reenable previews on your HipChat Server](https://confluence.atlassian.com/display/HIPCHATKB/How+to+Generate+API+Keys+for+Content+Previews+and+Configure+it+in+HipChat+Server))

{% highlight python %}

import base64
import requests
import urllib

apikey=urllib.unquote("YOUR_KEY")
apisecret=urllib.unquote("YOUR_API_SECRET")
bearer_creds="{}:{}".format(apikey, apisecret)
base64encoded_creds = base64.b64encode(bearer_creds)

twitter_api_url="https://api.twitter.com/oauth2/token"

headers = {"Content-Type": "application/x-www-form-urlencoded;charset=UTF-8", "Authorization": "Basic {}".format(base64encoded_creds)}

response = requests.post(
	twitter_api_url,
	data="grant_type=client_credentials",
	headers=headers)

print("Your token is: {}".format(response.json()))
# Output would be something like Your token is:
# {u'token_type': u'bearer', u'access_token': u'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA%2FAAAAAAAAAAAAAAAAAAAA%3DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'}
{% endhighlight %}

Hope it helps!
