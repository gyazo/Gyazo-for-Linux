FROM centos:7
ENV ruby_ver="2.5.7"

RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install git make autoconf curl wget rpm-build
RUN yum -y install gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel sqlite-devel bzip2

RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
RUN echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /root/.bashrc
RUN echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /root/.bashrc
RUN echo 'eval "$(rbenv init --no-rehash -)"' >> /root/.bashrc
RUN source /root/.bashrc;rbenv install ${ruby_ver}; rbenv global ${ruby_ver};

ADD ./ /tmp/build

RUN mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
RUN echo "%_topdir $HOME/rpmbuild" > ~/.rpmmacros
RUN source /root/.bashrc;gem install package_cloud
ENV LANG en_US.UTF-8
RUN chmod -v +x /tmp/build/rhel.sh
RUN source /root/.bashrc;cd /tmp/build && bash ./rhel.sh
