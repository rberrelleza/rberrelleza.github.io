---
layout: post
title: "Inject values into your golang binary at build time"
modified: 2019-02-07 07:13:13 +0000
categories: posts
---

I recently discovered that you can update the value of a string variable inside your golang code via compiler flags. This is very useful for scenarios where you want to set a value based on an external process,  but you don't want to let your users change it. We run into that issue recently when we wanted to add a `version` command to a binary we were building. 

Let's say we something like the program below:

```golang
package main

import "fmt"

var version = "0.0.0"

func main() {
    fmt.Printf("version %s \n", version)
}
````


If you compile and run this, the output will be:
```console
go build main.go
./main
version 0.0.0 
```

But by using the `-ldflags "-X importpath.name=val"` build parameters, you can set the value at build time:

```console
go build -ldflags "-X main.version=1.0.0" main.go
./main
version 1.0.0 
```

You pass the `-X` flag several times if you need it (e.g to set version and build time). 

Hope it helps!









