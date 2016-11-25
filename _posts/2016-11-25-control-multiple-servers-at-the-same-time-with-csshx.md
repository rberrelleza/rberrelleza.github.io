---
layout: post
title: "Control multiple servers at the same time with csshx"
modified: 2016-11-25 13:21:00 -0800
categories: posts
---

For the past few months, I've been working a lot with clustered VMs ([wink wink ;)](https://www.hipchat.com/data-center)). Over and over again, I would run into this scenario:

- For each node in the cluster:
  + SSH into node 1
  + Fire vim and update a file
  + Restart services and test changes

This cycle gets old pretty quickly. I was chatting about this problem over lunch, when
one of my coworkers introduced me to the most excellent [CSSHX](https://github.com/brockgr/csshx)

CSSHX is a perl-based cluster SSH tool for Mac OSX. It's very straightforward to use, you just call, passing the user@IP:PORT of each server in your cluster.
```
> csshx admin@server1 admin@server2 admin@server3
```

With that command, CSSHX will open 3 terminals (one per server), and a master terminal. Anything you type in the master terminal will be automatically typed on all the other terminals. Simple, and effective.

If you have a series of clusters you interact with a lot, CSSHX also supports using a configuration file (it defaults to /etc/cluster). Every line of the file has to follow this format 'name user@IP:PORT user@IP:PORT user@IP:PORT...'.
You can have as many lines as you want.

If you had a file like this:

```

# /etc/cluster
test admin@server1 admin@server2 admin@server3
dogfood admin@server10 admin@server20 admin@server30

```

You could control the dogfood cluster like this:
```
> csshx test
```

One drawback I've found is that, when connecting to new servers, the 'clustered terminals' fail to connect when SSH prompts to accept a new server ssh key. As a workaround, I
connect to each server directly once, accept the host key, and then use CSSHX for any future connections.


