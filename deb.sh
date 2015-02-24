#!/bin/sh

PACKAGE=gyazo
VERSION=1.0

tar czvf ../${PACKAGE}_${VERSION}.orig.tar.gz src icons
debuild -us -uc || exit 1
lintian -Ivi ../${PACKAGE}_*.dsc
