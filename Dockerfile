FROM centos:latest

ADD ./ /tmp/build

RUN mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
RUN echo "%_topdir $HOME/rpmbuild" > ~/.rpmmacros
RUN yum install rpm-build -y
RUN chmod -v +x /tmp/build/rhel.sh
RUN cd /tmp/build && bash ./rhel.sh
