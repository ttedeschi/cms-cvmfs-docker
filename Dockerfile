FROM centos:6
MAINTAINER Alexx Perloff "Alexx.Perloff@Colorado.edu"

ADD cvmfs/cernvm.repo /etc/yum.repos.d/cernvm.repo

RUN yum install emacs nano cvmfs man freetype openssl098e libXpm libXext wget git  tcsh zsh tcl  perl-ExtUtils-Embed perl-libwww-perl  compat-libstdc++-33  libXmu  libXpm  zip e2fsprogs krb5-devel krb5-workstation  strace libXft xdm ImageMagick ImageMagick-devel mesa-libGL mesa-libGLU glx-utils -y

RUN rpm -Uvh https://www.itzgeek.com/msttcore-fonts-2.0-3.noarch.rpm

ADD cvmfs/default.local /etc/cvmfs/default.local

RUN for repo in cms.cern.ch cms-ib.cern.ch oasis.opensciencegrid.org \
    cms-lpc.opensciencegrid.org sft.cern.ch cms-bri1.cern.ch cms-openddata-conddb.cern.ch; \
     do mkdir /cvmfs/$repo; echo "$repo /cvmfs/$repo cvmfs defaults 0 0" >> /etc/fstab; \
    done

RUN groupadd cmsuser && useradd -m -s /bin/bash -g cmsuser cmsuser

# the default limit of 1024 causes a problem if host UID == guest UID
RUN sed -i 's/1024/8192/' /etc/security/limits.d/90-nproc.conf

WORKDIR /home/cmsuser

ADD cvmfs/append_to_bashrc.sh .append_to_bashrc.sh
RUN cat .append_to_bashrc.sh >> .bashrc

ADD cvmfs/run.sh /run.sh
ENTRYPOINT ["/run.sh"]
