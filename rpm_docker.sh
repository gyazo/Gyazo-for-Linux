#!/bin/bash

sudo service docker start
docker build -t gyazo/build:latest .
docker run -e PACKAGECLOUD_TOKEN=$PACKAGECLOUD_TOKEN gyazo/build package_cloud push gyazo/gyazo-for-linux/el/6 /root/rpmbuild/RPMS/x86_64/$PACKAGE-$VERSION-1.x86_64.rpm || true
docker run -e PACKAGECLOUD_TOKEN=$PACKAGECLOUD_TOKEN gyazo/build package_cloud push gyazo/gyazo-for-linux/el/7 /root/rpmbuild/RPMS/x86_64/$PACKAGE-$VERSION-1.x86_64.rpm || true
