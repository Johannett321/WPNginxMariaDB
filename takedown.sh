#!/bin/bash
kubectl delete deployment wordpress -n web
kubectl delete deployment nginx -n web
kubectl delete deployment mariadb -n web
kubectl delete service wordpress -n web
kubectl delete service nginx -n web
kubectl delete service mariadb -n web
kubectl delete configmap mariadb-initdb-config -n web
kubectl delete pvc wp-pvc -n web
kubectl delete pv wp-pv