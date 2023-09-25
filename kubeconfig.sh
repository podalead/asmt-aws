#!/usr/bin/env bash

REGION=$(aws configure get region)
CLUSTER_NAME=$(aws eks list-clusters | jq -r .clusters[0])

aws eks update-kubeconfig \
          --region ${REGION} \
          --name ${CLUSTER_NAME} \
          --profile admin
#          --role-arn arn:aws:iam::270930892402:role/aws-node
