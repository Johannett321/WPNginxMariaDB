#!/bin/bash
kubectl delete pv wp-pv &
kubectl delete pvc wp-pvc &
kubectl delete deployment wordpress &
