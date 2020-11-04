#!/bin/bash

GCR_PATH=/Users/seongpyo/workspace/settings/credentials
# Create Namespace
kubectl create ns argo
kubectl create ns argo-events

# Install CR For Argo Events
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/namespace-install.yaml

# Depoly Event Bus
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml

# Install CR For Argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/stable/manifests/namespace-install.yaml

# Set Secret
## Github Access
kubectl apply -f secret/github-access-argo-event.yaml
kubectl apply -f secret/github-access-argo-workflow.yaml

## GCR Credentials
kubectl create secret generic argo-gcr --namespace=argo --from-file=${GCR_PATH}/elasticsearch-helm-chart.json

# Set Cluster Role & Cluster Role Binding
kubectl apply -f argo-clusterrole.yaml

## Deploy Key For Github Repository
kubectl apply -f secret/source-key-argo.yaml
kubectl apply -f secret/deploy-key-argo.yaml

# Edit Workflow Controller Artifact to use GCS
kubectl edit configmap workflow-controller-configmap -n argo

# Deploy Event Source
kubectl apply -f event-source.yaml
kubectl apply -f event-source-svc.yaml

# Deploy Event Sensor
kubectl apply -f event-sensor.yaml

# Deploy Workflow template
kubectl apply -f workflow-template.yaml

# Print TODO List
echo -n "Create secret gcp credentials"
