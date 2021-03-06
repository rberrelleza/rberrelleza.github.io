---
title: "Talks"
nav_title: "Talks"
description: "Talks I've given"
include_nav: true
permalink: /talks/
---

## WebAssembly + OpenFaas, the Universal Runtime for Serverless Functions - (Serverless Practitioner Summit - Kubecon Amsterdam, July 2020)

WebAssembly was initially created as a sandbox for the Web. It was designed to be lightweight, portable and compatible with most programming languages. Given these characteristics, it's no surprise that a lot of people are starting to take it outside the browser and into the realm of desktop and cloud applications.

In this talk I discuss why WebAssembly is perfectly suited as a runtime for serverless functions. I talk about prior art, how WebAssembly can be used to build serverless functions, how it compares with Docker and other runtimes and how we can leverage it to make our functions more portable and faster to start.

I finish with a demo of how we can build functions in different languages, compile them to portable WebAssembly binaries and then use OpenFaaS to manage and deploy them to Kubernetes, with the help of Krustlet.

<iframe width="560" height="315" src="https://www.youtube.com/embed/so2dGQGKTpE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The code for the demo [is available here](https://github.com/rberrelleza/openfaas-plus-webassembly), if you want to try it out yourself. 

[Slides available here](/talks/resources/webassembly-plus-openfaas.pdf)

## Serverless in Kubernetes (HackMadrid - July 2020)

Talked about Serverless programing, how does it fit in Kubernetes, and how to use [OpenFaaS](https://github.com/openfaas/faas) to get started with serverless programming.

<iframe width="560" height="315" src="https://www.youtube.com/embed/vdbmJ0tX2ko" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

*This talk is in Spanish*

[Slides available here](/talks/resources/serverless-in-kubernetes.pdf)


## Add Cloud Services to your Development Environment (Crossplane Community Day - June 2020)

[Crossplane](http://crossplane.io/), for those of you unfamiliar with it, is an open source Kubernetes add-on that supercharges your Kubernetes clusters enabling you to provision and manage infrastructure, services, and applications from kubectl. In this talk, I give a demo of how to use Crossplane and Okteto together to create development environments that include Cloud and Kubernetes services.

<iframe width="560" height="315" src="https://www.youtube.com/embed/pH1PJkJqjaE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The code for the demo [is available here](https://github.com/rberrelleza/crossplane-community-day-2020), if you want to try it out yourself. I’m biased, but this is one of my favorite demos.


## Don't Build and Push, Move Your Inner Loop to Your cluster! (AllTheTalks.online, April 2020)

Snyk (and friends) organized AllTheTalks.online, a 23.9999 hour online-only conference on all things DevOps, Development & Security. Which doubled as a fundraiser for COVID19 victims.

I talked about [Okteto](https://github.com/okteto/okteto) and how to use it to simplify the development of Cloud Native applications. The talked covered the history of the project, community use cases and a demo of how to find and fix a bug on micro services-based app directly in Kubernetes.

<iframe width="560" height="315" src="https://www.youtube.com/embed/RqnltjxGtPk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The slides are [available here](https://okteto.com/blog/dont-build-and-push/slides.pdf)

## Painless Serverless Function Development In Kubernetes (Serverless Practitioner Summit - Kubecon San Diego, December 2019)

Gave a talk in the Serverless Practitioner Summit on how you can use [Okteto](https://github.com/okteto/okteto) and [OpenFaaS](https://github.com/openfaas/faas) to have a great development experience when building serverless applications.

[Slides available here](/talks/resources/painless-serverless-development-with-kubernetes.pdf)

<iframe width="560" height="315" src="https://www.youtube.com/embed/Yx1nGH2zh0k" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Cloud-Native and Kubernetes Meetup in Silicon Valley (Santa Clara, August 2019)

Spoke about best practices on how to develop Cloud Native Applications and gave a demo of how to use Okteto and Okteto Cloud to have an agile development workflow in Kubernetes.

[Slides available here](/talks/resources/cloud-native-meetup-silicon-valley-okteto.pdf)

### Screencast of the demo
<iframe width="560" height="315" src="https://www.youtube.com/embed/6nX0-dfSUI4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Cloud Native Development  (London Kubernetes Meetup, July 2019)
Spoke at the [London Kubernetes Meetup](https://www.meetup.com/Kubernetes-London/events/262636460/) on the how to develop cloud native applications directly in Kubernetes with [okteto](https://github.com/okteto/okteto)

[Slides available here](/talks/resources/kubernetes-london-meetup-kubeflare.pdf)

## CND demo (SIG-App meeting, January 2019)
Demoed how easy it is to develop a Kubernetes-native applications directly in the cluster with [CND](https://github.com/okteto/cnd) in one of the SIG-App weekly meetings. 

<iframe width="560" height="315" src="https://www.youtube.com/embed/UmDAGrdovRo?start=950" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Cloud Native Development Workflows (Madrid Docker Meetup, October 2018)
Spoke at the [Madrid Docker Meetup](https://www.meetup.com/Docker-Madrid/events/254821562/) on the how the [okteto](https://okteto) team uses docker and kubernetes to be more efficient. We presented a new open source project (https://github.com/okteto/cnd) to make it easier to develop directly in kubernetes.

[Slides available here](/talks/resources/docker-meetup-cloud-native-development.pdf)

##  Incidents and ChatOps (Atlassian User Group Barcelona, April 2018)
Spoke at the [Atlassian User Group Barcelona April 2018](https://aug.atlassian.com/events/details/atlassian-barcelona-presents-atlassian-barcelonacreando-comunidad) event on how to leverage the power of the Atlassian suite to improve how your team responds to incidents. The talk was centered on how to use Jira, StatusPage, and Stride to develop a [chatops culture](https://www.atlassian.com/it-unplugged/chatops) and improve your team's response to incidents.

[Slides available here](/talks/resources/chatops-and-incidents.pdf)

##  Just enough Docker( Madrid / Barcelona March 2018)
[@chico_de_guzman](https://twitter.com/chico_de_guzman) and I got together again and talked about traditional, applications, containers, and how to leverage the power of native cloud services to run container based applications. We gave the talk at [Madrid's](https://www.meetup.com/Docker-Madrid/events/248220421) and [Barcelona's](https://www.meetup.com/docker-barcelona-spain/events/247733700) docker meetup.

[Slides available here](/talks/resources/just-enough-docker.pdf)

We also spoke at [Stuart's Barcelona office](https://medium.com/stuart-engineering/from-legacy-applications-to-docker-in-production-1f8c173d7622). This version of the talk is available in [their youtube channel](https://www.youtube.com/watch?v=JZvSShfYnp4).

<iframe width="560" height="315" src="https://www.youtube.com/embed/JZvSShfYnp4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Docker for devops May 2017

[@chico_de_guzman](https://twitter.com/chico_de_guzman) and I chatted about  docker and how to build a devops-oriented engineering culture at a meetup in [Stuart's](https://stuart.com/) offices in Barcelona.

[Slides](/talks/resources/Docker-Devops-at-Stuart.pdf)

## Continuous Delivery and Self Service IT
Spoke at GlueCon 2015 about the benefits of CI/CD, and the benefits of self service systems vs opening IT tickets.

[Slides](https://www.slideshare.net/ElasticBox/ramiro-glucon)
