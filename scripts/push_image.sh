#!/bin/bash

set -x

LABEL=$(date +"%Y-%m-%dT%H-%M-%S")

# Tag the current release in case of rollback
gcloud docker pull gcr.io/elizabeth-restaurant/web:latest
docker tag -f gcr.io/elizabeth-restaurant/web:latest gcr.io/elizabeth-restaurant/web:rollback
gcloud docker push gcr.io/elizabeth-restaurant/web:rollback

# Build the current release
docker build -t gcr.io/elizabeth-restaurant/web:latest .
docker tag -f gcr.io/elizabeth-restaurant/web:latest gcr.io/elizabeth-restaurant/web:${LABEL}
gcloud docker push gcr.io/elizabeth-restaurant/web:latest
gcloud docker push gcr.io/elizabeth-restaurant/web:${LABEL}

# Update the current release
gcloud config set container/cluster web
gcloud container clusters get-credentials web
kubectl config use-context gke_elizabeth-restaurant_us-central1-f_web

# Using deployments
#kubectl run web --image=gcr.io/elizabeth-restaurant/web:latest --port=8080 --replicas=2
#kubectl expose deployment hello-node --type="LoadBalancer"

# Using replication controllers
#kubectl create -f web.rc.yaml
#kubectl expose rc web --port=80 --target-port=8080 --type="LoadBalancer"
kubectl rolling-update web --update-period=10s --image=gcr.io/elizabeth-restaurant/web:${LABEL}
