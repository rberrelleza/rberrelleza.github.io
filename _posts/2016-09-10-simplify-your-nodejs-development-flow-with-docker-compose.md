---
layout: post
title: "Simplify your NodeJS development flow with docker-compose"
modified: 2016-09-10 13:05:25 -0700
categories: posts
---

At [Atlassian](https://www.atlassian.com), we have a quarterly company-wide hackathon called [ShipIt](https://www.atlassian.com/company/shipit). On the last one (a few days ago),
I got together with two of my colleagues and decided to try and build a [HipChat addon](https://developer.atlassian.com/hipchat/getting-started). We wanted
to explore the new glances and addons capabilities and see if we could build something cool with them. 

After a brief, 5 minute research (we only had one day to build the addon, after all), the [atlassian-connect-express](https://bitbucket.org/atlassian/atlassian-connect-express) looked to be the more user-friendly and
advanced. Their [getting started guide](https://developer.atlassian.com/hipchat/tutorials/getting-started-with-atlassian-connect-express-node-js) is fantastic, 
you get a running addon that says hello in 5-10 minutes. It also uses NodeJS, which is a platform that I wanted to learn more about, so this gave me the 
perfect excuse. 

The getting started guide asked for node, redis, and ngrok. I didn't have the first two installed on my work machine, and I didn't want to deal with 
the hassle of installing it, configuring it, etc. Why do all that if I already have docker installed? Instead, I wrote this docker-compose file:

{% highlight yml %}
version: '2'
services:
    redis:
        command: redis-server --appendonly yes
        image: redis
        ports:
        - "6379:6379"
        volumes:
        - ./data:/data
    web:
        build: .
        environment:
        env_file: .env
        ports:
        - "8080:8080"
        depends_on:
        - redis
{% endhighlight %}

With this, running ```docker-compose --build up``` gave me a fully functional working environment in no time. As soon as we started to write our addon code
we started to see a big problem in our workflow. Every time we wanted to try the new code, we had to stop the containers, run ```docker-compose --build up```
again, and wait the 2-3 seconds it took to start over. 

Waiting 3 seconds per debugging cycle it's not a lot, but it gets annoying very quickly. Fortunately, a quick google search brought up that someone in the 
Node community had already solved that problem with [nodemon](https://github.com/remy/nodemon). 
I followed the instructions and updated my package.json script to look like this:

{% highlight json %}
{
  "name": "hello-world",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "start": "node app.js",
    "watch": "nodemon"
  },
  "dependencies": {
    "atlassian-connect-express": "^1.0.10",
    "atlassian-connect-express-hipchat": "^0.3.5",
    "atlassian-connect-express-redis": "^0.1.6",
    "body-parser": "^1.15.2",
    "compression": "^1.6.2",
    "cors": "^2.7.1",
    "errorhandler": "^1.4.3",
    "express": "^4.14.0",
    "express-hbs": "^1.0.1",
    "lodash": "^4.13.1",
    "morgan": "^1.7.0",
    "request": "^2.72.0",
    "rsvp": "^3.2.1",
    "static-expiry": "^0.0.11",
    "uuid": "^2.0.2",
    "nodemon": "^1.10.0"
  }
}
{% endhighlight %}

Restarted my containers, wrote some more code, saved my files, and nothing happened. nodemon refused to do its magic. I spent a few minutes reading
the documentation, double checking all my configurations, restarting my containers and the docker service a few times (hey, you never know) until it 
hit me. Since we were using docker, the source code files were being copied over, so nodemon was monitoring the files inside the container, not the ones
on my machine.

Added the source code as docker volumes on my docker-compose file, restarted the containers, and nodemon started to reload the process every time 
I saved a file.

{% highlight yml %}
version: '2'
services:
    redis:
        command: redis-server --appendonly yes
        image: redis
        ports:
        - "6379:6379"
        volumes:
        - ./data:/data
    web:
        build: .
        command: npm run watch
        env_file: .env
        ports:
        - "8080:8080"
        depends_on:
        - redis
        volumes:
        - ./app.js:/usr/src/app/app.js
        - ./routes:/usr/src/app/routes
        - ./public:/usr/src/app/public
        - ./views:/usr/src/app/views
        - ./lib:/usr/src/app/lib
{% endhighlight %}

Once we had this up and running, our workflow became much more efficient. Every time we reached a certain milestone, it was only a matter of pushing
the container into our registry and let the container service reload our containers in the production instances, hands-free. ![success](/images/success.png) 


Hope it helps!






