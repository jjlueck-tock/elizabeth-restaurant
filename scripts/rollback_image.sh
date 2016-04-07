#!/bin/bash

set -x

gcloud docker pull gcr.io/elizabeth-restaurant/web:rollback
docker tag -f gcr.io/elizabeth-restaurant/web:rollback gcr.io/elizabeth-restaurant/web:latest
gcloud docker push gcr.io/elizabeth-restaurant/web:latest
