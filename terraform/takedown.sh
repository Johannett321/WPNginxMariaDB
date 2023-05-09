#!/bin/bash
sudo /opt/puppetlabs/bin/puppetserver ca clean --certname worker-test.kube
terraform destroy