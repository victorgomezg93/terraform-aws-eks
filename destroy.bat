cd infraestructure
terraform apply -destroy --auto-approve
del .terraform.lock.hcl
del terraform.tfstate
del terraform.tfstate.backup

PAUSE