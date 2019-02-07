---
layout: post
title: "Develop Helm applications directly in your Kubernetes cluster"
modified: 2019-02-07 07:01:05 +0000
categories: posts
---

> This post was originally [published here](https://medium.com/okteto/develop-helm-applications-directly-in-your-kubernetes-cluster-cb385aa8328f).

Deploying applications in Kubernetes can be complicated. Even the simplest application will require creating a series of interdependent components (e.g.namespace, RBAC rules, ingress, services, deployments, pods, secrets ...), each with one or more YAML manifests.

[Helm](https://www.helm.sh/) is the *de-facto* package manager for Kubernetes applications that allows developers and operators to easily package, configure, and deploy applications onto Kubernetes clusters. If you're building an application that will run in Kubernetes, you should really look into leveraging Helm.

In this tutorial we'll show you how to build your first Helm chart and how to use [*CND](https://github.com/cloudnativedevelopment/cnd#cnd-a-tool-for-cloud-native-developers) *to* *develop your application directly in the cluster, saving you tons of time and integration problems.

*This tutorial assumes that you have some Kubernetes knowledge and that you have access to a cloud provider, or you can set it up locally.*

## Helm 101

If you are new to Helm, I recommend you first go through one of the following articles:

* [https://www.digitalocean.com/community/tutorials/an-introduction-to-helm-the-package-manager-for-kubernetes](https://www.digitalocean.com/community/tutorials/an-introduction-to-helm-the-package-manager-for-kubernetes)

* [https://scotch.io/@collinsd/helm-101](https://scotch.io/@collinsd/helm-101)

* [https://docs.helm.sh/using_helm/#quickstart](https://docs.helm.sh/using_helm/#quickstart)

## Setup a Kubernetes cluster

The official [Kubernetes setup guide](https://kubernetes.io/docs/setup/) covers this topic extensively. For the purpose of this tutorial, I recommend you either deploy a remote cluster via [Digital Ocean's Kubernetes](https://www.digitalocean.com/docs/kubernetes/quickstart/) service or locally with [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/).

## Install Helm

For OSX you can install it via brew by running the command below.

    $ brew install helm

You can also install it via curl.

    $ curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
    $ chmod 700 get_helm.sh
    $ ./get_helm.sh

Once it's installed, initialize it by running the command below.

    $ helm init

The full installation chart is [available here.](https://docs.helm.sh/using_helm/#installing-helm)

## Generate your initial chart

The easiest way to create a new chart is by using the *helm create* command to create the initial scaffold of your chart.

    $ helm create mychart

Helm will create a new directory called *mychart *with the structure shown *below.*

    mychart
    |-- Chart.yaml
    |-- charts
    |-- templates
    |   |-- NOTES.txt
    |   |-- _helpers.tpl
    |   |-- deployment.yaml
    |   |-- ingress.yaml
    |   `-- service.yaml
    `-- values.yaml

## Deploy your chart

The default chart is configured to run an NGINX server exposed via a service with a *ClusterIP*. To access it externally, we'll tell it to use a *NodePort *instead.

Deploy the chart using the *helm install* command.

    $ helm install --name myapp ./mychart --set service.type=NodePort
    NAME:   myapp
    LAST DEPLOYED: Tue Jan  8 16:08:05 2019
    NAMESPACE: default
    STATUS: DEPLOYED

    RESOURCES:
    ==> v1/Service
    NAME           AGE
    myapp-mychart  0s

    ==> v1beta2/Deployment
    myapp-mychart  0s

    ==> v1/Pod(related)

    NAME                           READY  STATUS   RESTARTS  AGE
    myapp-mychart-846949857-9d28t  0/1    Pending  0         0s

    NOTES:
    1. Get the application URL by running these commands:
      export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services myapp-mychart)
      export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
      echo [http://$NODE_IP:$NODE_PORT](http://$NODE_IP:$NODE_PORT)

The output of the install command displays a summary of the resources created, and it renders the contents of the NOTES.txt file. Run the commands listed there to get a URL to access the NGINX service.

For Minikube:

    $ export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services myapp-mychart)

    $ export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
      
    $ echo [http://$NODE_IP:$NODE_PORT](http://$NODE_IP:$NODE_PORT)

For a hosted Kubernetes cluster (like Digital Ocean's or GKE):

    $ export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services myapp-mychart)

    $ export NODE_IP=$(kubectl get nodes --selector=kubernetes.io/role!=master -o jsonpath={.items[*].status.addresses[?\(@.type==\"ExternalIP\"\)].address})
      
    $ echo [http://$NODE_IP:$NODE_PORT](http://$NODE_IP:$NODE_PORT)

Open the URL in your browser.

![](https://cdn-images-1.medium.com/max/4040/1*DfGEcYdtddhQXvPS82RCVw.png)

## Develop your application

Once we have a basic chart up and running, it's time to develop our own application. At this point, we would have to follow the typical developer workflow:

1. Build and test the application locally

1. Build a container

1. Give the container a label

1. Push the container to a registry

1. Update the values in our chart to match the new Docker image

1. Upgrade the chart

1. Test your changes

1. Go back to 1

Instead of following that workflow, we're going to save time and friction by developing our application **directly in the cluster**. The Cloud Native way.

### Cloud Native Development
> Cloud Native Development is THE way to develop Cloud Native Applications. Instead of wasting time and resources by developing locally and then testing in the cluster, we just do everything directly in the cluster. We open sourced[*CND](https://github.com/cloudnativedevelopment/cnd)* to make it easier than ever to become a Cloud Native Developer.

Install the latest version of CND.

    $ brew tap cloudnativedevelopment/cnd
    $ brew install cnd

The [installation guide](https://github.com/cloudnativedevelopment/cnd/blob/master/docs/installation.md) on the repo has instructions on how to do it for MacOS, Windows, and Linux.

For the purpose of this tutorial, we'll use a simplified version of Docker's famous [Voting App](https://github.com/dockersamples/example-voting-app). Run the following command to get the code locally.

    $ git clone [https://github.com/cloudnativedevelopment/vote](https://github.com/cloudnativedevelopment/vote)

Open a second terminal window, and go to the vote folder. From there, run the cnd createcommand to initialize your Cloud Native Development environment. This command will create a file called cnd.yml with the content displayed below.

    $ cnd create
    $ cat cnd.yml
    swap:
      deployment:
        name: vote
        image: python
        command:
        - sh
        - -c
        - pip install -r requirements.txt && python app.py
    mount:
      source: .
      target: /usr/src/app
    scripts:
      hello: echo Your cluster ♥ you

Open your favorite IDE, and replace the value of deployment.namewith the name of your deployment. It should look something like this:

    swap:
      deployment:
        **name: myapp-mychart**
        image: python
        command:
        - sh
        - -c
        - pip install -r requirements.txt && python app.py
    mount:
      source: .
      target: /usr/src/app
    scripts:
      hello: echo Your cluster ♥ you

Run the cnd up to start your Cloud Native Development environment.

    $ cnd up                                                                                    
    Activating your cloud native development environment...
    Linking '/Users/ramiro/code/vote' to default/myapp-mychart/mychart...
    Ready! Go to your local IDE and continue coding!
    Collecting Flask (from -r requirements.txt (line 1))
    ...
    ... 
    ...
    * Serving Flask app "app" (lazy loading)
     * Environment: production
       WARNING: Do not use the development server in a production environment.
       Use a production WSGI server instead.
     * Debug mode: on
     * Running on [http://0.0.0.0:80/](http://0.0.0.0:80/) (Press CTRL+C to quit)
     * Restarting with stat
     * Debugger is active!
     * Debugger PIN: 375-419-670

At this point, your application is running **directly in the cluster **([our github repo](https://github.com/cloudnativedevelopment/cnd/blob/master/docs/how-does-it-work.md#how-does-cnd-work) has an in-depth explanation of how this works).** **Notice the processed bytext near the bottom, it's your kubernetes namespace and pod name. Go back to your browser and reload your tab to see the application in action.

![](https://cdn-images-1.medium.com/max/4040/1*wF__KcNVHbLJN6R2jqdywA.png)

Try it out a few times, just to make sure everything works. Now open the source of the application on your favorite IDE. Edit the file vote/app.py and change the option_a in line 8 from "Cats" to "Otters". Save your changes.

Go back to the browser, refresh the Voting App UI, and notice that your code changes are instantly applied. Try a few more changes.

Once you are done developing, pressctrl+c on the terminal where cnd upis running to stop your environment (psst: Notice how you never used docker or kubectl while working on your app. Pretty cool no?).

### Final testing

Once you're satisfied with your code, let's test it end to end:

1. Run cnd down to restore the original deployment (this is so that helm can process the new changes).

    $ cnd down
    Deactivating your cloud native development environment...
    Cloud native development environment deactivated

2. Build a docker image for the voteapplication and push it to the registry.

    $ docker build -t $YOUR_DOCKER_USER/vote:cnd .
    $ docker push $YOUR_DOCKER_USER/vote:cnd

3. Create a file named updated-values.yaml inside the mychartfolder. We'll use this file to override the default configuration of the chart. Set the values of image.repository and image.tag to match your newly built image.

    image:
      repository: your_docker_user/vote**
      **tag: cnd

4. Upgrade your application using Helm by running the command below.

    $ helm upgrade myapp ./mychart --set service.type=NodePort --values=./mychart/updated-values.yaml

5. Open your browser, and verify that your application is running correctly.

Once your application is ready, you can package by using the helm package command and even distribute it via a repo, or with Kubeapps. [This article](https://medium.com/containerum/how-to-make-and-share-your-own-helm-package-50ae40f6c221) has a good explanation of the process.

## Conclusion

Helm is a great modern choice for deploying and managing applications. But developing charts and applications using the traditional developer workflow is slow and full of friction. Developing directly in the cluster makes the entire process a lot more efficient. [CND](https://github.com/cloudnativedevelopment/cnd) is here to help you with that.

*Interested in improving your Kubernetes and Docker development workflows? Contact [Okteto](https://okteto.com) and stop waiting for your code to build and redeploy.*
