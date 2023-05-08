# Deploy guide

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
