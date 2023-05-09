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

Answer “yes” when you're requested to. This process may take up to 10 minutes

### Setup Wordpress, Nginx and MariaDB

Then you can run the following commands to add Wordpress, Nginx and MariaDB to the kubernetes cluster

```bash
cd /home/ubuntu/web
./starter.sh
```

## Test the deployment

To test that the deployment was successful, you can start by listing all pods and making sure they are ready.

```bash
kubectl get pods -n web
```

Then you can find the ip of the node where the service runs by executing the following command with the pod name from the previous command.

```bash
kubectl describe pod <INSERT_POD_NAME_HERE> -n web
```

You should then see something like "Node:             w1/212.162.147.185" somewhere, where the ip of the node is stated. Then you can enter that ip in a browser followed by the port number of the deployment you want to test. Here is an overview of the different services and ports (there is no need to test MariaDB, as it cannot be accessed from the browser. If Wordpress is working however, MariaDB is working as well):
- 30000: Wordpress
- 30100: Nginx
- 30200: MariaDB

If Wordpress is located on Worker 1, you could for example use test it like this: \
212.162.147.185:30000

