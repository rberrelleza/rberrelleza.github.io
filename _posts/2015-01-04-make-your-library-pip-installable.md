---
layout: post
title:  "Make your module available from pypi"
date:   2015-01-04 20:30:00
categories: posts
---

Once you have a module that can be [pip installed from git](/posts/2014/12/14/pip-install.html), the next logical step is to make it available directly from pypi. Doing this will allow your users to install your module locally by simply calling: ```pip install your-module``` , instead of having to deal with git repository access and addresses.

## Create and setup your pypi account

The first thing to do is to create a [pypi account](https://pypi.python.org/pypi). All you need is an email, and to pick a username and a  password. I also recommend you to create an account on pypi's [test server](https://testpypi.python.org/pypi), so we can validate our module before pushing to production.

We're going to create a settings file for our pypi credentials, so we don't have to type the urls and usernames again and again. Create a ~/.pypirc file like this one (replace my username with yours):

{% highlight python %}
[distutils]
index-servers =
    pypi
    test

[pypi]
repository = https://pypi.python.org/pypi
username = MY_USERNAME
password = MY_PASSWORD

[test]
repository = https://testpypi.python.org/pypi
username = MY_USERNAME
password = MY_PASSWORD
{% endhighlight %}

*I chose to set have the password there for simplicity. If you don't think this is secure enough, you can remove the password lines and instead provide them manually everytime you run the upload commands*

## Generate the source distribution

In order to generate a source distribution, we need a version. Edit your setup.py file, and update the version of it to match the version you want to create. Remember that it needs to match [the public version identifier scheme](http://legacy.python.org/dev/peps/pep-0440/#public-version-identifiers). 

On your terminal, go to the root of your module, and create the distribution. I recommend you to use source distributions, unless you really know what you're doing and think that wheels is better:

```
python setup.py sdist
```

If the command ran successfully, a `dist` folder will be created, with the source distribution file inside. It's the one named YOUR_MODULE-YOUR_VERSION.tar.gz.

Once you have a source distribution file, it's time to upload it. Fist, you need to register your module in pypi, [by filling up this form](https://pypi.python.org/pypi?%3Aaction=submit_form). Do the same in the test serv

```
twine upload --repository test dist/YOUR_MODULE-YOUR_VERSION.tar.gz
```

Once the file is upload, install it locally at least once, to make sure everything works as expected:

{% highlight bash %}
virtualenv pip_test --clear
source pip_test/bin/activate
pip install -i https://testpypi.python.org/pypi YOUR_MODULE==YOUR_VERSION
{% endhighlight %}

If everything works fine, you will have a virtual environment with your module. I recommend you double check the version installed and run some tests, just to be sure. 

Finally, we push to pypi:

```
twine upload --repository test dist/YOUR_MODULE-YOUR_VERSION.tar.gz
```

If the upload finished successfully, your module will the available to the world in the next 2-3 minutes.

Hope it helps!