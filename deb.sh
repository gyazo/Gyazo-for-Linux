#!/bin/sh

PACKAGE=gyazo
VERSION=1.3.0

tar czvf ../${PACKAGE}_${VERSION}.orig.tar.gz src icons
debuild -us -uc -b || exit 1
