---
layout: post
title: "Sort your test results with python"
modified: 2016-09-24 13:35:50 -0700
categories: posts
---

My team relays heavily on CI for our development process. However, as our test corpus has grown, so has the amount of time we have to
wait before we get our test results. And that's not good. While better that not having tests, having a very long test cycle tends to be
counter-productive, as developers grow restless, and stop leveraging CI during the dev process (if you have to wait 20 minutes for a suite, you'll
never run it locally).

Last week, I had some time on my hands, and decided to look a bit into it. My obvious question was, "why does it take this long?". Fortunately, our test driver
of choice [nose](https://nose.readthedocs.io), includes how long each test takes to run:

{% highlight xml %}
<testcase classname="test.integration.test_api_app.AppRest" name="test_info_requires_internal" time="0.003"/>
<testcase classname="test.integration.test_api_app.AppRest" name="test_info_requires_internal_no_query_param" time="0.004"/>
<testcase classname="test.integration.test_api_app.AppRest" name="test_info_requires_internal_no_query_param_with_header" time="0.003"/>
{% endhighlight %}

However, they are sorted by execution time, and not by time. Well, we code mostly in python, and if python is good for one thing,
is at string manipulation, analysis and scripting:

{% highlight python %}
import argparse
import sys
import xml.etree.ElementTree as ET

def getChildValue(val):
    try:
        return float(val)
    except:
        return val

def sortchildrenby(parent, attr):
    parent[:] = sorted(parent, key=lambda child: getChildValue(child.get(attr)))

parser = argparse.ArgumentParser(description='Sort junit files')
parser.add_argument('--field', dest='field', default='time',
                   help='sort tests by (default: time)')

args = parser.parse_args()

lines = sys.stdin.readlines()
tree = ET.fromstring("".join(lines))

sortchildrenby(tree, args.field)
for child in tree:
    sortchildrenby(child, args.field)

print(ET.tostring(tree, encoding='utf8', method='xml'))
{% endhighlight %}

With this script, I was able to post-process my test result files and discovered that 4 of our tests was taking about 10% of
the execution time of the entire suite. ![facepalm](/images/facepalm.png)

{% highlight bash %}
cat ~/Downloads/test-results.xml | python junit-sort.py
{% endhighlight %}

Hope it helps!

PS I am aware that nose has a [really good plugin](https://pypi.python.org/pypi/nose-timer) for this. We run a very diverse stack, so we needed
a more generic solution.

