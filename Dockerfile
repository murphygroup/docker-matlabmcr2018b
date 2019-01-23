FROM ubuntu:latest as intermediate

###############################################################################################
MAINTAINER Ivan E. Cao-Berg <icaoberg@andrew.cmu.edu>
LABEL Description="Ubuntu 16.04 + MATLAB MCR 2018b"
LABEL Vendor="Murphy Lab in the Computational Biology Department at Carnegie Mellon University"
LABEL Web="http://murphylab.cbd.cmu.edu"
LABEL Version="2018b"
###############################################################################################

###############################################################################################
# UPDATE OS AND INSTALL TOOLS
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    wget \
    tree \
    curl \
    vim && \
    apt-get clean 
###############################################################################################

###############################################################################################
# INSTALL MATLAB MCR 2018b
USER root
RUN echo "Downloading Matlab MCR 2018b"
COPY mcr-install /mcr-install
RUN mkdir /opt/mc && \
    cd /mcr-install && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    echo "Removing temporary files" && \
    rm -rvf mcr-install
###############################################################################################

###############################################################################################
FROM ubuntu:latest
COPY --from=intermediate /opt/mcr /opt/mcr
###############################################################################################

###############################################################################################
# CONFIGURE ENVIRONMENT VARIABLES FOR MCR
RUN mv -v /opt/mcr/v95/sys/os/glnxa64/libstdc++.so.6 /opt/mcr/v95/sys/os/glnxa64/libstdc++.so.6.old
ENV LD_LIBRARY_PATH /opt/mcr/v95/runtime/glnxa64:/opt/mcr/v95/bin/glnxa64:/opt/mcr/v95/sys/os/glnxa64
ENV XAPPLRESDIR /opt/mcr/v95/X11/app-defaults
###############################################################################################

###############################################################################################
# CONFIGURE ENVIRONMENT
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL /bin/bash
ENV USERNAME murphylab
ENV UID 1000
RUN useradd -m -s /bin/bash -N -u $UID $USERNAME
RUN if [ ! -d /home/$USERNAME/ ]; then mkdir /home/$USERNAME/; fi
###############################################################################################
