#!/bin/bash

GCP_CREDENTIAL_PATH={GCP_CREDENTIAL_PATH}
# Create Namespace
kubectl create ns argo
kubectl create ns argo-events
kubectl create ns argocd

# Install CR For Argo Events
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/namespace-install.yaml

# Depoly Event Bus
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml

# Install CR For Argo & expose argo-server
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/stable/manifests/namespace-install.yaml
kubectl patch svc argo-server -n argo -p '{"spec": {"type": "LoadBalancer"}}'

# Install CR For Argo CD & expose argocd-server
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Set Secret
## Github Access
kubectl apply -f secret/github-access-argo-event.yaml
kubectl apply -f secret/github-access-argo-workflow.yaml

## GCR Credentials
kubectl create secret generic argo-gcp --namespace=argo --from-file=google.json=${GCP_CREDENTIAL_PATH}

# Set Cluster Role & Cluster Role Binding
kubectl apply -f argo-clusterrole.yaml

## Deploy Key For Github Repository
kubectl apply -f secret/source-key-argo.yaml
kubectl apply -f secret/deploy-key-argo.yaml
kubectl apply -f secret/deploy-key-argocd.yaml

# Edit Workflow Controller Artifact to use GCS
kubectl edit configmap workflow-controller-configmap -n argo

# Deploy Event Source
kubectl apply -f event-source.yaml
kubectl apply -f event-source-svc.yaml

# Deploy Event Sensor
kubectl apply -f event-sensor.yaml

# Deploy Workflow template
kubectl apply -f workflow-template.yaml

# Set Repository Information
kubectl apply -f repository.yaml

# Create Application Template
kubectl apply -f application.yaml