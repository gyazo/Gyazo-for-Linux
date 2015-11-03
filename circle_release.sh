#!/bin/bash

declare -a deb_targets=(
  "linuxmint/petra"
  "linuxmint/qiana"
  "linuxmint/rebecca"
  "linuxmint/rafaela"
  "linuxmint/rosa"
  "debian/squeeze"
  "debian/wheezy"
  "debian/jessie"
  "debian/stretch"
  "debian/buster"
  "ubuntu/precise"
  "ubuntu/quantal"
  "ubuntu/raring"
  "ubuntu/saucy"
  "ubuntu/trusty"
  "ubuntu/utopic"
  "ubuntu/vivid"
  "ubuntu/wily"
)

for e in ${deb_targets[@]}; do
    package_cloud push gyazo/gyazo-for-linux/$e ../gyazo*all.deb || true
done
