#!/bin/sh

PACKAGE=gyazo
VERSION=1.0

tar czvf ../${PACKAGE}_${VERSION}.orig.tar.gz src icons
debuild -us -uc -b || exit 1

# push to packagecloud.io
# ignore error when version is not increamented
package_cloud push gyazo/gyazo-for-linux/ubuntu/trusty ../gyazo*all.deb || true
package_cloud push gyazo/gyazo-for-linux/ubuntu/wheezy ../gyazo*all.deb || true
