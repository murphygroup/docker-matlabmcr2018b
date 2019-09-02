#!/bin/bash

wget --quiet -nc https://ssd.mathworks.com/supportfiles/downloads/R2018b/deployment_files/R2018b/installers/glnxa64/MCR_R2018b_glnxa64_installer.zip

if [ -d mcr-install ]; then
	rm -rfv mcr-install
fi

mkdir mcr-install
unzip MCR_R2018b_glnxa64_installer.zip -d mcr-install

docker build -t icaoberg/matlabmcr2018b .
