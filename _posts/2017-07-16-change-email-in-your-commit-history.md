---
layout: post
title: "Change email in your commit history"
modified: 2017-07-16 17:47:28 -0700
categories: posts
---

The other night I realized that I had being commiting to one of my personal open source projects using an email that I no longer use. I had being doing this for a while without noticing, until I enabled gpg signing on my github repos. At that point, github realized that the email I had configured on git didn't match the key it was expected, and didn't let me commit anymore. It took me some time to figure out what was going on, until I looked at my local git history and realized that I had the old email (facepalm). 

Once I realized the issue, I fixed my email cofiguration and it was all good. But my commit history looked messy, so I decided to fix it. 

git filter-branch lets you to rewrite your commit history, and it has a very powerful filtering system that lets you script your conditions. After searching online, and a bit of trial and error, [I ran into this](https://help.github.com/articles/changing-author-info/). I'm putting the script here for future reference.

{% highlight bash %}
 git filter-branch -f --env-filter '

OLD_EMAIL="old@example.com"
CORRECT_EMAIL="new@example.com"

if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
'
{% endhighlight %}

When you run this script, git will go over every commit, compare the author, and fix it if needed. After you're done, review your history, and if you're happy with it, force push your changes (since you're and you're all done. 

I ended up making this a bit more generic, and adding it as a git alias for future use on my ~/.gitconfig:

{% highlight bash %}
[alias]
 change-commits = "!fix() { var=$1; old=$2; new=$3; shift 3; git filter-branch --env-filter \"if [[ \\\"$`echo $var`\\\" = '$old' ]]; then export $var='$new'; fi\" $@; }; fix"
{% endhighlight %}

Do keep in mind that this script is changing your commit history, so DO NOT RUN THIS ON A SHARED REPOSITORY, unless you really know what you are doing. 

Hope it helps!

