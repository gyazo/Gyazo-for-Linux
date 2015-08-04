FROM centos:latest

ADD ./ /tmp/build

RUN mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
RUN echo "%_topdir $HOME/rpmbuild" > ~/.rpmmacros
RUN yum install rpm-build ruby ruby-devel make rubygems gcc-c++ -y
RUN gem install package_cloud --no-ri --no-rdoc 
ENV LANG en_US.UTF-8
RUN chmod -v +x /tmp/build/rhel.sh
RUN cd /tmp/build && bash ./rhel.sh
