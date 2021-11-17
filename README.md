# terraform-aws-eks

---
DEPLOYMENT
----

This project is build to provide an infraestructure in AWS to deploy a Go server.

In case you want to deploy it you have to do the following:

First in your command line you have to configure the access in aws

```sh
aws configure
```

Copy the AWS account_id and paste it on:

- .env file under the "registry" variable 

```sh
REGISTRY = <ACC_ID>
```

- deployment.yaml file under image variable

```sh
image: <ACC_ID>.dkr.ecr.us-east-1.amazonaws.com/go-ecs-app-repo:latest
```

Then you have an initialization script, it's called "init.bat", execute the script and he will prompts you and asks you for the ACCOUNT ID, give it again (as you did previously in .env and deployment.yaml) and the script will build the docker image, creates an ECR repository and push the image into the ECR, also the script checks for terraform configuration files because it's an init script so in case we have an tfstate or lock the script remove this files and finally the script runs terraform and deploys the container in Kubernetes.

```sh
init.bat
```

The result should be a Kubernetes on AWS with a service called go-service with a deployment with 2 replicas with an alb hostname accesible by https with a bootstrap html page.
```sh
C:\Users\victo\Desktop\terraform-aws-eks>kubectl get svc
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)         AGE
go-service   LoadBalancer   172.20.109.121   a475e56eb04a4452f86f0cb719c63233-620939036.us-east-1.elb.amazonaws.com   443:31309/TCP   114s
kubernetes   ClusterIP      172.20.0.1       <none>                                                                   443/TCP         8m49s
```
Example: https://a475e56eb04a4452f86f0cb719c63233-620939036.us-east-1.elb.amazonaws.com (Sometimes it takes like 1-2 minutes until you are able to access)

INFRAESTRUCTURE EXPLANATION
----

For our deployment in the cloud we are using terraform.

We have a Cluster with a service deployed with 2 replicas, this are our go image and they are communicated with a load balancer in port 443, also this load balancer is using a local certificate.

Using the application load balancer we can distribute  network traffic and information flows across multiple servers, a load balancer ensures no single server bears too much demand. This improves application responsiveness and availability, enhances user experiences, and can protect from distributed denial-of-service (DDoS) attacks.

Our container is a go server is running with https protocol in port 443, the aws credentials are gathered from the credentials aws file in $HOME/.aws/credentials.

We have an init.bat script to start the infraestructure and a destroy.bat script to destroy it.

CODE
----
We have a docker to deploy the application and to implement some api we have in the /health path a healtcheck checking if our sqlite3 database is connected or not, I didn't had time to implement the database so always return the same response in json:

```sh
{"status":"down","details":{"database":{"status":"down","timestamp":"2021-10-05T23:24:08.425492059Z","error":"Binary was compiled with 'CGO_ENABLED=0', go-sqlite3 requires cgo to work. This is a stub"},"search":{"status":"down","timestamp":"2021-10-05T23:24:06.309964687Z","error":"this makes the check fail"}}}
```

The only changing thing is the timestamp.

We have a bootstrap on the index page.


PIPELINE
----

In case you want to try the pipeline, the pipeline deploys on ECR and in EKS, you should go to github
secrets and add, then in every push you will be creating all yamls in kustomization.yaml

```sh
AWS_ACCESS_KEY_ID

AWS_ACCOUNT_ID

AWS_SECRET_ACCESS_KEY

COLLECTION

DB

MONGODB_URI


```