---
layout: post
title:  "Set the title of your terminal"
date:   2014-12-22 21:46:00
categories: posts
---

If you're anything like me, you always have multiple terminal tabs open at any given time. As soon as I have 5 or 6 tabs open, it becomes impossible to remember what I have running on each tab.

Here's a script that will allow you to update the title of a terminal tab and/or window:

```
# !/bin/bash
title=$1
echo -n -e "\033]0;$title\007"
```

Copy the script above into `/usr/bin/title` and give it executable permissions (`chomod +x /usr/bin/title`).  After that, typing `title My Title` will update the title of your current terminal or tab to the value provided. It works with both ASCII and Unicode characters.

Hope it helps!

