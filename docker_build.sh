#!/usr/bin/env bash

docker buildx build -t heryv1m/app-server-demo:latest \
                    -t heryv1m/app-server-demo:v1.1.0 \
                    -f ./app-server/Dockerfile \
                    --platform linux/amd64 \
                    --push \
                    ./app-server
