# Continuous Delivery with Spinnaker and Kubernetes (in 40 minutes or less)

You've got code. It probably compiles. Now what? 

It's time to push code into production, cross your fingers, and pray! Right? On second thought, we should probably test the code and ensure it works BEFORE releasing it to the rest of the world. Ideally, we'll do this using open source, multi-cloud tools that will work whether we're using Java or Go, on-premise or in the cloud.

And that's where [Kubernetes](https://www.kubernetes.io) and [Spinnaker](https://www.spinnaker.io), the continuous delivery platform come in. 
In this workshop we'll  and explain the pros and cons, along the way.

In this workshop, you'll will:
* Setting up an example Continuous Delivery pipeline from scratch.
* Use your favorite tools (well, my favorite, at least) Kubernetes and Spinnaker
* Learn and overcome common Pitfalls and Obstacles of the above tools (because nothing's perfect)


## Labs

* [Workshop Setup](labs/workshop-setup.md)


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


# Workshop setup

## Account Setup
## Cloud Shell
## Get the Code

```
$ git clone https://github.com/askcarter/spinnaker-k8s-workshop
```

## Cluster Setup
### Create Cluster

Spinnaker takes up a lot of resources.  Plus we need read write access to GCS.
```
$ gcloud container clusters create workshop --scopes=storage-rw --machine-type=n1-standard-2
```

### Create Service Account
We need RW access because we’re storing data in gcs instead of minio.
 
```
$ gcloud iam service-accounts create spinnaker-bootstrap-account --display-name spinnaker-bootstrap-account
$ SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-bootstrap-account" \
$ PROJECT=$(gcloud info --format='value(config.project)')
```
 
```
$ gcloud projects add-iam-policy-binding $PROJECT --role roles/storage.admin --member serviceAccount:$SA_EMAIL
```
 
```
$ gcloud iam service-accounts keys create account.json --iam-account $SA_EMAIL
```

# Pipeline Overview

CI  --  tests and builds image
CD -- takes known good images and pushes to production  
 
Dev  tags commit -->[GSR] --> [GCR builds image based on tag] -> [Spin deploys off of new image] -> [k8s]

## App Explanation

# Installing Spinnnaker

## Install Helm
[OPTIONAL] make sure there’s a k8s cluster?
 
Download and install helm binary
From https://github.com/kubernetes/helm/blob/master/docs/quickstart.md
```
$ wget https://storage.googleapis.com/kubernetes-helm/helm-v2.4.2-linux-amd64.tar.gz
$ sudo tar -C /usr/local -xzf helm-v2.4.2-linux-amd64.tar.gz
```

Add Helm to PATH
```
$ export PATH=$PATH:/usr/local/linux-amd64
```
 
# Initialize local CLI
NOTE:  Does the directory matter for anything?
```
$ helm init
```

## Configure Spinnaker

### Spinnaker Overview

Spinnkaer has a lot of pieces and parts.  Below is a table listing everything.  You don't need to know *any* of this for the workshop, but it's here for completeness.

| Servivces | Port | Description |
| --- | --- | --- |
| Deck	| 9000 | Deck is a static AngularJS-based UI. |
| Clouddriver	| 7002 | Cloud Driver integrates with each cloud provider (AWS, GCP, Azure, etc.). It is responsible for all cloud provider-specific read and write operations. |
| Echo	| 8089 | Echo provides Spinnaker’s notification support, including integrations with Slack, Hipchat, SMS (via Twilio) and Email. |
| Front50	| 8080 | Front50 stores all application, pipeline and notification metadata. |
| Gate	| 8084 | Gate exposes APIs for all external consumers of Spinnaker (including deck). It is the front door to Spinnaker. |
| Igor	| 8088 | Igor facilitates the use of Jenkins in Spinnaker pipelines (a pipeline can be triggered by a Jenkins job or invoke a Jenkins job) |
| Orca	| 8083 | Orca handles pipeline and task orchestration (ie. starting a cloud driver operation and waiting until it completes). |
| Rosco	| 8087 | Rosco is a packer-based bakery. We believe in immutable infrastructure and rosco provides a means to take a Debian or Red Hat package and turn it into an Amazon Machine Image. Don’t worry, it also supports Google Compute Engine and Azure images. |
| Fiat	| 7003 | Fiat is the authorization server for the Spinnaker system.  It exposes a RESTful interface for querying the access permissions for a particular user. |


TODO: Make this a sed operation
```
$ nano values.yaml 
```
 
```
# Disable minio the default
minio:
  enabled: false
 
# Enable gcs
gcs:
  enabled: true
  project: <my-project-name>
  jsonKey: '<INSERT CLOUD STORAGE JSON HERE>'
 
# Name has to be unique in GCS.
storageBucket: <my-project-name>-spinnaker 
 
# Configure your Docker registries here
accounts:
- name: gcr
  address: https://gcr.io
  username: _json_key
  password: '<INSERT YOUR SERVICE ACCOUNT JSON HERE>'
  email: 1234@5678.com
```

# copy accounts.json text into 
```
$ SERVICE_ACCOUNT_JSON=$(cat account.json)
$ echo $SERVICE_ACCOUNT_JSON
```


## Deploy Spinnaker Chart

Everything in this helm chart will be labeled cd-spinnaker, so you can search for things like: 
```
$ kubectl get deployment -l app=cd-spinnaker
```

To delete everything
```
$ helm delete cd --purge
```
 
get the latest list of charts
```
$ helm repo update
```
 
install spinnaker
```
$ helm install stable/spinnaker --name cd -f values.yaml --timeout 1500 
```
 
NOTE: This is going to take a while. 
Let user know things are happening.  In another tab.  Errors will happen this is to be expected while the pods sync up.
```
$ kubectl get pods -w
```

NOTE: If you want to make a quick change.  Helm can do a blue green deployment via upgrade.
```
$ helm upgrade cd charts/stable/spinnaker -f updated-values.yaml
```

Access the spinnaker UI
```
$ export DECK_POD=$(kubectl get pods --namespace spinnaker -l "component=deck,app=cd-spinnaker" -o jsonpath="{.items[0].metadata.name}")
$ kubectl port-forward --namespace spinnaker $DECK_POD 9000 >>/dev/null &
```
 
Visit the Spinnaker UI by opening your browser to: [http://127.0.0.1:9000](http://127.0.0.1:9000])

# Setting up Source Control
TODO: This should before here, possibly in the overview

Cloning the repo
```
$ gcloud source repos clone default --project=askcarter-production-gke
```

Pushing the image to gcr.  Add v to semver so that we can use the v* tag as a build trigger
```
$ gcloud container builds submit -t gcr.io/askcarter-production-gke/gceme:v1.0.0 .
```

# Configuring Pipeline
All changes should be done from pipeline (as other configs will get overwritten when the pipeline pushes new versions from the old template).

Strategy=none is important for using deployments.  

## Create Application
Check to see that gcr is populated in the dropdown. 

## Create Load Balancers

## Create Deploy Pipeline


# Automating Pipleine

Until now, we've been manually triggering the pipeline when we want it to run. 
Now we'll use a build trigger to connect our Container Registry to Spinnaker, so that whenever we tag an image for release, we'll kick off a spinnaker deployment.

Note: Want to build on tag, not every check-in (to save disk space)

In gcr.io set up to: 
Changes pushed to "v.*" tag will trigger a build of "gcr.io/askcarter-production-gke/$REPO_NAME:$TAG_NAME"

```
$ git tag v2.0.0
$ git push origin --tags v2.0.0
```

Back in the Spinnaker UI, our build should've kicked off.

# Rolling Back
Use git to go back a commit, then push the image and bump the tag.
I workshop have user make two commits (the 2nd of which is bad).  When the user pushes them, have them follow this process.


You can also use the UI if you need an escape hatch.



