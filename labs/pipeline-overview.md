# Pipeline Overview

CI  --  tests and builds image
CD -- takes known good images and pushes to production  
 
Dev  tags commit -->[GSR] --> [GCR builds image based on tag] -> [Spin deploys off of new image] -> [k8s]

## App Explanation
