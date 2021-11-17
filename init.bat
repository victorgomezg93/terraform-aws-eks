set /P ACC_ID=Enter AWS RegistryID: 

aws ecr get-login-password | docker login --username AWS --password-stdin %ACC_ID%.dkr.ecr.us-east-1.amazonaws.com
aws ecr create-repository --repository-name go-ecs-app-repo
docker-compose build
docker-compose push
cd infraestructure
del .terraform.lock.hcl
del terraform.tfstate
del terraform.tfstate.backup
terraform init
terraform apply --auto-approve
cd ..
REM aws ecs describe-task-definition --task-definition go-task  --query taskDefinition > task-definition.json
aws eks --region us-east-1 update-kubeconfig --name eks-cluster
cd manifests
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
cd ..
PAUSE