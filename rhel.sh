#!/bin/sh

PACKAGE=gyazo
VERSION=1.0

# archive preparation
mkdir ${PACKAGE}-${VERSION} && cp -r src icons ${PACKAGE}-${VERSION}
tar czvf ../${PACKAGE}_${VERSION}.orig.tar.gz ${PACKAGE}-${VERSION}
mv ../${PACKAGE}_${VERSION}.orig.tar.gz $HOME/rpmbuild/SOURCES/

rpmbuild -ba redhat/gyazo.spec      # build pkg
#rpm -i --test $HOME/rpmbuild/RPMS/ # test RPM
rm -rf ${PACKAGE}-${VERSION}        # cleanup
