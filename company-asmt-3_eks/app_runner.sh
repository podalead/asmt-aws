#!/usr/bin/env bash

# to be sure that you connected to the cluster
kubeconfig.sh

BASE_DIR="./kube/examples/simple-web-app"
CONF_FILES=(
  "namespace.yml"
  "configMap.yml"
  "secrets.yml"
  "deployment.yml"
  "service.yml"
  "ingress.yml"
)

for config in "${CONF_FILES[@]}"; do
  kubectl apply -f "${BASE_DIR}/${config}"
done
