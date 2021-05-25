#!/bin/zsh

docker buildx build --platform linux/amd64 --push -t hub.agoralab.co/devops/ferry/ferry_api:latest .
