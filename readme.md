# Deploy guide

## Pre-deployment

The Safespring instances must first be started to be able to deploy the environment. Start the "Master V3" instance, the "Worker 1" instance and the "Elastic Stack" instance.
Wait a few minutes, and then you can proceed with the deployment.

## Deployment

### Setup the Terraform workers

The first step is to run the following commands from the master to create the Safespring worker instances.

```bash
cd /home/ubuntu/Terraform
terraform plan
terraform apply
```

Answer “yes” when you're requested to.

### Setup Wordpress, Nginx and MariaDB

Then you can run the following commands to add Wordpress, Nginx and MariaDB to the kubernetes cluster

```bash
cd /home/ubuntu/web
./starter.sh
```
