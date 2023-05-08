#!/bin/bash
kubectl apply -f pv.yaml
kubectl apply -f wp-pvc.yaml
kubectl apply -f wp-deployment.yaml
