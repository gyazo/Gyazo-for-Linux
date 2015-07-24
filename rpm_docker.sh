#!/bin/bash

sudo service docker start
docker build -t centos:latest .
docker cp `docker ps -l -q`:/root/rpmbuild/RPMS/x86_64/${PACKAGE}-${VERSION}-1.x86_64.rpm ./
package_cloud push gyazo/gyazo-for-linux/el/6 ./gyazo*.rpm || true
package_cloud push gyazo/gyazo-for-linux/el/7 ./gyazo*.rpm || true
