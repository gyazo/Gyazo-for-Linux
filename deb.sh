#!/bin/sh

PACKAGE=gyazo
VERSION=1.0

tar czvf ../${PACKAGE}_${VERSION}.orig.tar.gz src icons
debuild -us -uc -b || exit 1

package_cloud push gyazo/gyazo-for-linux/ubuntu/trusty ../gyazo*all.deb
package_cloud push gyazo/gyazo-for-linux/ubuntu/wheezy ../gyazo*all.deb
