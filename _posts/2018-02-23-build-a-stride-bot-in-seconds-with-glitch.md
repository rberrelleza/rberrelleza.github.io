---
layout: post
title: "Build a stride bot in seconds with glitch"
modified: 2018-02-23 00:45:39 +0000
categories: posts
---

After a few months on beta, Stride's developer API is finally open [to the world](https://blog.stride.com/custom-apps-all-aboard-strides-api-6ee2c753c303). Since I work at Atlassian, I've had access to it for a while, but I was still curious to see how it had changed since the early days.

I looked around, and the [stride api tutorial](https://bitbucket.org/atlassian/stride-api-tutorial) seemed like the easiest way to get started. I cloned the repo, and then realized that I didn't have node installed on my machine. I was at a coffee shop and didn't felt like downloading gigs and gigs of stuff into my machine. I was about to give up when I remember reading about [glitch](https://medium.com/glitch/welcome-to-glitch-fe161d0fc39b). It's supposed to be a great dev environment for node, so it seemed like a perfect fix for my project. 

I signed up using my GitHub account (no new password, yay!), copied the files of the bot app, and updated my secrets. But then nothing happened. It took me a couple of seconds to realize that the app's dependencies where being installed, and that there was a `logs` button flashing. I clicked on it, and it said `/tmp/.__glitch__start.sh: line 1: null: command not found`. After googling for a minute or two, I found [the culprit](https://support.glitch.com/t/command-not-found-error/2974), my `package.json` was missing a start script.

I went back to my code in the browser, and updated `package.json` with a start script:

```json
"scripts": {
    "start": "node app.js"
  }
```

After a second or two, the logs tab showed me this:


![logs](/images/stride-logs.png).

Really? That simple? I clicked on `show` button in the top right, and I was welcomed by my bot's descriptor json. It worked! 


![json](/images/stride-descriptor.png).


Once the bot was running, I followed the rest of the instructions on the [getting started guide](https://developer.atlassian.com/cloud/stride/getting-started/), and after a couple I minutes I had my very own stride bot up and running. ![success](/images/success.png).


![stride-bot](/images/stride-bot.png)


15 minutes, a browser and a bunch of APIs. That's all it took to get a chatbot up and running. Mindblowing. But then I found two features that are even more interesting than that. 

First, it auto reloads everytime you stop typing. No need to redeploy anything, it just magically works in the background. It's probably not the best pattern for a mission critical system (and even this is debatable), but it makes for an insanely fast dev cycle. 

Second, and way more important. It makes sharing your running code super easy (they call it remix). Find it directly on glitch, link to it, or just click on the button below. 

[![Remix on Glitch](https://cdn.glitch.com/2703baf2-b643-4da7-ab91-7ee2a2d00b5b%2Fremix-button.svg)](https://glitch.com/edit/#!/remix/stride-glitch). 



I only spent a few minutes playing with this, but the possibilities are exciting. Sharing samples, live documentation, teaching others to code (all you need is a browser!). And all you need is a browser.

[Remix the stride bot](https://glitch.com/edit/#!/remix/stride-glitch), extend the code and play with it. It's a lot of fun.


