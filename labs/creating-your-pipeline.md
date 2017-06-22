# Creating Your Pipeline

TODO:  Should look this nice (except going to upload yaml for pipelines.
https://www.spinnaker.io/guides/tutorials/codelabs/kubernetes-source-to-prod/


![](../docs/img/pipeline-overview.png)

## Configuring Pipeline
All changes should be done from pipeline (as other configs will get overwritten when the pipeline pushes new versions from the old template).

Strategy=none is important for using deployments.  

## Create Application

![](../docs/img/ui-create-application.png)

![](../docs/img/ui-configure-application.png)
Note:  Check to see that gcr is populated in the dropdown. 

## Create Load Balancers

![](../docs/img/lb-be.png)

![](../docs/img/lb-be-c.png)

![](../docs/img/lb-fe.png)

![](../docs/img/lb-fe-c.png)

## Create Deploy Pipeline

