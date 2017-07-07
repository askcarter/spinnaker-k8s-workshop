# Continuous Delivery with Spinnaker and Kubernetes (in 40 minutes or less)

You've got code. It probably compiles. Now what? 

It's time to push code into production, cross your fingers, and pray! Right? On second thought, we should probably test the code and ensure it works BEFORE releasing it to the rest of the world. Ideally, we'll do this using open source, multi-cloud tools that will work whether we're using Java or Go, on-premise or in the cloud.

And that's where [Kubernetes](https://www.kubernetes.io) and [Spinnaker](https://www.spinnaker.io), the continuous delivery platform come in. 
In this workshop we'll setup a CICD pipeline and explain the pros and cons, along the way.

[See a video of the pipleine you'll create here!](https://youtu.be/dpbWpzAs-RwD)

In this workshop, you'll will:
* Setting up an example Continuous Delivery pipeline from scratch.
* Use your favorite tools (well, my favorite, at least) Kubernetes and Spinnaker
* Learn and overcome common Pitfalls and Obstacles of the above tools (because nothing's perfect)


## Labs

1. [Workshop Setup](labs/workshop-setup.md)
1. [Building Container Images](labs/building-container-images.md)
1. [Installing Spinnaker](labs/installing-spinnaker.md)
1. [Creating Your Pipeline](labs/creating-your-pipeline.md)
1. [Triggering Deployments](labs/triggering-deployments-v2.md)

## TODO

* Extra Credit: Create Deploy v2, manually
* IAM / RBAC Integration
* Halyard Setup

## What Next?

* PLACEHOLDER

## Resources

* https://cloud.google.com/solutions/spinnaker-on-compute-engine
* http://www.spinnaker.io/docs/troubleshooting-guide
* https://medium.com/continuous-delivery-scale/scaling-spinnaker-at-netflix-part-1-8a5ae51ee6de
* https://medium.com/continuous-delivery-scale/scaling-spinnaker-at-netflix-metrics-and-more-dbc4910b74e3
* https://medium.com/continuous-delivery-scale/lifting-the-sail-how-spinnaker-maps-resources-to-kubernetes-57da9c1657ba
* http://www.spinnaker.io/v1.0/docs/target-deployment-configuration#section-google-cloud-platform
* https://github.com/kubernetes/helm/blob/master/docs/quickstart.md
* https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes
* [Spinnaker Video Codelabs](https://www.youtube.com/watch?v=N9VnJlKn734&list=PL4yLrwUObNkttE526AAj_ykc5UlIPjz8m&index=1)
* https://github.com/spinnaker/roer
* https://www.spinnaker.io/guides/tutorials/codelabs/kubernetes-source-to-prod/




