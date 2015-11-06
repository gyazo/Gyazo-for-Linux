#!/bin/bash

sudo service docker start
docker build -t gyazo/build:latest .
docker run -e PACKAGECLOUD_TOKEN=$PACKAGECLOUD_TOKEN gyazo/build  || /root/rpm_release.rb
