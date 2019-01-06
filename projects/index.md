---
layout: page
title: Projects
comments: false
modified: 2018-03-16
---

## Cloud Native Development
CND is a cli tool that helps you move your development workflow entirely to kubernetes, avoiding the time-consuming `docker build/push/pull/redeploy cycle`. 

[Available on github](https://github.com/okteto/cnd)

## Slack-Stargazer

Send a message to a slack channel when someone stars a github repository. Stars are a vanity metric, but it does give you a nice morale boost. I did this mostly to play around with the github API, slack and to try and develop something end-to-end on my mobile phone (close, but not quite there!)

[![Remix on Glitch](https://cdn.glitch.com/2703baf2-b643-4da7-ab91-7ee2a2d00b5b%2Fremix-button.svg)](https://glitch.com/edit/#!/remix/slack-stargazer)

## i2kit

i2kit is a cli tool to deploy container based applications on the cloud. The tool will create a minimalistic, linuxkit-based VM with the application containers, generate a cloudformation template based on a yaml manifest and launch it. The goal is to offer the same type of features that kubernetes and docker's universal control plane offer, but with cloud native services, and without requiring a cluster.

[Available on github](https://github.com/pchico83/i2kit)

## Bitbucket pull requests
A VSCode extension to start pull requests directly form the IDE.

[Install from here](https://marketplace.visualstudio.com/items?itemName=RamiroBerrelleza.bitbucket-pull-requests)

[Available on bitbucket](https://bitbucket.org/rberrelleza/bitbucket-pull-requests)

## SE Radio podcast player

An Amazon Echo skill to play episodes of [SE Radio](http://www.se-radio.net).
Currently in development.


## Where's my bus?

An Amazon Echo skill that helps you figure out when the next MUNI is coming.
[Install here](http://alexa.amazon.com/spa/index.html#skills/dp/B06WD8FQL1/?ref=skill_dsk_skb_sr_0)

## fiveoneone

Python library to consume transit data from http://511.org/
You can get it [from github](https://github.com/rberrelleza/511-transit), or install it [from pypi](https://pypi.python.org/pypi/fiveoneone)

## nose-xunitmp

Nose plugin to add xunit like reporting to nosetests when running in multiprocess mode.
You can get it [from github](https://github.com/rberrelleza/nose-xunitmp)
