---
layout: post
title:  "Make your git project pip installable"
date:   2014-12-14 13:07:00
categories: posts
---

[Pip](https://pip.pypa.io/en/latest/) is, in my opinion, one of the best Python features out there. There are very little dependency managers out there that have something as simple and elegant as `pip install`. 

One of the less well known features of pip is the fact that you can install directly from git repositories. This can be especially useful when you're developing beta, or internal libraries that can't leverage pypi's  infraestructure.

The first thing to do is to Add a `setup.py` file to the root of your repository. Setup.py is the setup script of your module, and it includes the definition and metadata required by pypi to install a library locally. You can review [the full specification](https://docs.python.org/2/distutils/setupscript.html) later, but for now, you can use this basic template:

```python
"""
My module
-------------

A description of my module
"""
 
from setuptools import setup
 
setup(
    name='useful-module',
    version='0.1',
    license='MIT',
    author='Ramiro Berrelleza',
    author_email='rberrelleza@example.com',
    description='A very useful module',
    packages=['package'],
    include_package_data=True,
    zip_safe=False,
    platforms='any',
    install_requires=['required_dependency'],
    entry_points={
    },
    classifiers=[
        'Environment :: Web Environment',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Topic :: Internet :: WWW/HTTP :: Dynamic Content',
        'Topic :: Software Development :: Libraries :: Python Modules'
    ]
)
```

The main parts here are the `packages` and `dependencies` sections. These tell pip which packages come, and which dependencies need to be installed. It's very handy to include the dependencies so that your fellow developers don't have to install something else manually.

Once you have your `setup.py` script, commit it and push it to your repo. Once this is done, you can install it using this command:

``` 
pip install -e git+git@github.com:rberrelleza/repo.git#egg=module_name
```

This example assumes that your machine has access to the git repo. You can also use http (in case the repo is public) or even locally:

```
pip install -e git+https://github.com/rberrelleza/repo#egg=module_name
```

```
pip install -e /my/local/path
```

You can also refer specific commits or branches:

``` 
pip install -e git+git@github.com:rberrelleza/repo.git@COMMIT_HASH#egg=module_name
```

## Handle dependencies programatically
When I was developing my module, one thing that stuck out was that I had to list the dependencies twice, once in the setup.py, and one in the requirements.txt. Duplicated files tend to get stale, and in python the requirements.txt file is pretty much standard, so I found it much simpler to load them programmatically by using the `pip.req.parse_requirements` function (lines 11-13):

```python
"""
My module
-------------

A description of my module
"""
 
from setuptools import setup
from pip.req import parse_requirements
 
install_reqs = parse_requirements("requirements.txt")
requirements = [str(ir.req) for ir in install_reqs]
 
setup(
    name='useful-module',
    version='0.1',
    license='MIT',
    author='Ramiro Berrelleza',
    author_email='rberrelleza@example.com',
    description='A very useful module',
    packages=['package'],
    include_package_data=True,
    zip_safe=False,
    platforms='any',
    install_requires=requirements,
    entry_points={
    },
    classifiers=[
        'Environment :: Web Environment',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Topic :: Internet :: WWW/HTTP :: Dynamic Content',
        'Topic :: Software Development :: Libraries :: Python Modules'
    ]
)
```

## Handle static files
You will notice that in line 11 of the gist above I'm referring to the 'requirements.txt' file of my module. Physical files are not included by default, and your installation will fail because of this. There are several ways of doing this, but the simplest I found was to include a ```MANIFEST.in```file along with your ```setup.py``` file in the root of your repo. With this you can include your README.md, data files, your documentation, etc... My manifest looked like this:

```
include requirements.txt
include README.md
```

Hope it helps!