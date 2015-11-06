#!/bin/bash

sudo service docker start
docker build -t gyazo/build:latest .
docker run -e PACKAGECLOUD_TOKEN=$PACKAGECLOUD_TOKEN -e VERSION=$VERSION gyazo/build ruby /tmp/build/rpm_release.rb
