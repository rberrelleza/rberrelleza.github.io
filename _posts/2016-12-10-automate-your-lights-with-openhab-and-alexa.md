---
layout: post
title: "Automate your lights with openHAB and Alexa"
modified: 2016-12-10 13:27:23 -0800
categories: posts
---

I'm a huge fan of [Amazon Echo](https://www.amazon.com/Amazon-Echo-Bluetooth-Speaker-with-WiFi-Alexa/dp/B00X4WHP5E) (aka Alexa). I bought my first one
in the early days of the dev preview, and have been
using it daily ever since. Keeping track of my shopping and to-do lists, setting up timers while cooking, playing music
around the house, you name it. I like it so much that I even bought an extra [dot](https://www.amazon.com/All-New-Amazon-Echo-Dot-Add-Alexa-To-Any-Room/dp/B01DFKC2SO/)
for the bedroom. Can't recommend it enough.

After having Alexa in the house for a few months, the whole home automation bug bit me hard. Wouldn't it be cool to be able
to control other stuff around the house? Well, enter [Phillips Hue](https://www.amazon.com/Philips-White-Starter-light-bridge/dp/B014H2OZAC)
and a bunch of their ['smart' lightbulbs](https://www.amazon.com/Philips-468058-White-3-Pack-Amazon/dp/B01M1S6I1Y). They work great
together, and you can turn them on and off with your voice via Alexa. You can even dim them, set up color schemes, and even
group them together (e.g. 'Alexa, turn the living room off' or 'Alexa, turn the bedroom on'). Cool stuff!

I was a happy user until I ran into a very first world problem. At night we like to watch tv in the bedroom, with the light
in the nightstand on (a hue bloom), but all the other lights off (a few normal light bulbs). Making this happen through Alexa
required two different commands in sequence ('Alexa turn the lamps off', followed by 'Alexa turn the nightstand on'). Functional,
but clunky and very error prone. All I wanted was to be able to shout 'Alexa, turn movie mode on' across the room and have everything
setup for me (I know, first world problems).  Sadly, I found out that Alexa doesn't support this sort of orchestrations just yet.

After a couple of hours internet searches, I end up discovering a very exciting open-source home automation project, [openHAB](https://github.com/openHAB).
openHAB is a beast of a project, with a lot of home automation features. But it supported three key things that I needed to solve my problem: Alexa integration,
virtual devices, and custom orchestrations.

## Install and configure openHAB
It seems lke you can run openHAB on a [rasperry pi](https://www.makeuseof.com/tag/getting-started-openhab-home-automation-raspberry-pi/), but I already have a server running at home,
and went the lazy way by using their [docker container](https://hub.docker.com/r/openhab/openhab/):

{% highlight yml %}
version: "2"
services:
  openHAB:
    image: 'openHAB/openHAB:amd64-online'
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
      - 5555:5555
    network_mode: "host"
    volumes:
      - '/etc/localtime:/etc/localtime:ro'
      - '/etc/timezone:/etc/timezone:ro'
      - './opt/openHAB/userdata:/openHAB/userdata'
      - './opt/openHAB/conf:/openHAB/conf'
    command: "server"
{% endhighlight yml %}

Before starting it, I ran the following commands to create the initial directory structure. This was so that I wouldn't lose my configurations
when relaunching my container.

{% highlight bash %}
mkdir -p $(pwd)/opt/openHAB/userdata
mkdir -p $(pwd)/opt/openHAB/conf
{% endhighlight bash %}

After this, I just started my docker container, waited a couple of minutes, and my openHAB instance was up and running. Browse to http://${fqdn}:8080,
and follow the setup instructions. I went with the most basic option since I only wanted the basics on it.

After the wizard finished, I selected the paper UI option, went to the extensions menu, and installed the  following extensions:
+ On the bindings tab, the 'Hue Binding'(version binding-hue - 0.9.0.SNAPSHOT)
+ On the misc tab, the 'Hue Emulation' (version misc-hueemulation - 2.0.0.SNAPSHOT), and the 'Rule Engine' (version misc-ruleengine - 2.0.0.SNAPSHOT)

Once the bindings are ready, go to the main page, and click on the 'SEARCH FOR THINGS' button to discover your devices. You'll need to push the button in your
HUE hub to allow pairing. Once they have paired (it took a few seconds for me), you will see all the devices available on the UI. Add the ones that you want to control,
and give it a friendly name (If you run into any issues, I recommend looking at the logs on $(pwd)/openHAB/opt/openHAB/userdata/logs).

Make sure that you can control all your devices from the openHAB UI before going to the next step.

# Create your virtual switch
To add our virtual switch, go to $(pwd)/openHAB/opt/openHAB/conf/items, and create a file called home.items with the following content:
{% highlight bash %}
Switch  MovieToggler     "Movie Time Toggle" [ "Switchable" ]
{% endhighlight bash %}

The line follows the format Type Name FriendlyName ListOfCapabilities. Feel free to customize the name and friendly name if you want. Make sure the file with the '.items' extension
or openHAB won't pick it.

# Create the rule
Next, we are going to create our rule. Rules on openHAB are very straight forward, they are composed  of a trigger (e.g. when our switch is turned on), and a series of
actions ('turn on a series of lights'). All the commands require the item name (not the friendly one). I couldn't figure out a way to get them via the UI, but the REST API
was very handy for this. Just browse to http://{$fqd}:8080/rest/items to get a full list.

To create the rule, go to $(pwd)/openHAB/opt/openHAB/conf/rules, and create a file called home.rules with the following content:

{% highlight bash %}
rule "Movie time ON"
when
  Item MovieToggler received command ON
then
  sendCommand(MY_NIGHTSTAND_DEVICE_NAME, ON)
  sendCommand(MY_LAMP_DEVICE_NAME,  OFF)
end

rule "Movie time OFF"
when
  Item MovieToggler received command OFF
then
  sendCommand(MY_NIGHTSTAND_DEVICE_NAME, OFF)
  sendCommand(MY_LAMP_DEVICE_NAME,  ON)
end
{% endhighlight bash %}

Before saving the file, don't forget to update the commands with your device id. Make sure the file with the '.rules' extension or openHAB won't pick it.


You can do more complex lookups and rules, but I decided to keep simple and straigh forward. To test that your rule works, you can do the following POST request:
{% highlight bash %}
curl --header "Content-Type: text/plain" -XPOST  http://${fqdn}:8080/rest/items/MovieToggler --data "OFF"
curl --header "Content-Type: text/plain" -XPOST  http://${fqdn}:8080/rest/items/MovieToggler --data "ON"
{% endhighlight bash %}

If everything is setup correctly, you should see the two lights toggle when you send the request.

# Integrate with Alexa
Finally, it's time to put everything together. The first thing you need to do is to enable discovery on your openHAB server. To do this, go to
configuration -> services -> hue emulation -> configure  and enable device pairing by selecting the 'Pairing Enabled' option. Remember to turn this
off once you're done pairing your devices, for security.

After pairing is enabled, go to your Alexa app -> Smart Home -> Discover Devices. If everything is configured properly, you should see all the devices
configured on your openHAB there.  Once I had the devices listed, I created a new group (just so that I could give it a friendly name), added the
"Movie Time Toggle" device and saved it as 'Movie Time'.

After all of this, I was able to shout a single 'Alexa, turn movie time on', and all the right lights turned off and on, with a single magical
voice command! ![success](/images/success.png).

Hope it helps!



