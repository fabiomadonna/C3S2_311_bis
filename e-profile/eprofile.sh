#!/bin/bash

# Define the directory paths in variables
SOURCE_DIR="/home/emanuele/owncloud/src/eprofile/ceda_pydap_cert_code/"
TRUSTROOTS_DIR="/home/emanuele/owncloud/src/eprofile/trustroots/"
DATA_URL="https://dap.ceda.ac.uk/badc/ukmo-metdb/data/winpro/"
#DOWNLOAD_DIR="/home/emanuele/owncloud/src/eprofile/data/"
DOWNLOAD_DIR="/Data/eprofile/"
CERTIFICATE_DIR="/home/emanuele/"

# Create the directory if it doesn't exist
mkdir -p $SOURCE_DIR || { echo "Failed to create directory $SOURCE_DIR"; exit 1; }

# Change to the created directory
cd $SOURCE_DIR || { echo "Failed to change to directory $SOURCE_DIR"; exit 1; }

# Clone the online_ca_client repository
if [ ! -d "online_ca_client" ]; then
    git clone https://github.com/cedadev/online_ca_client || { echo "Failed to clone repository"; exit 1; }
fi

# Change to the appropriate directory
cd online_ca_client/contrail/security/onlineca/client/sh/ || { echo "Failed to change to directory"; exit 1; }

# Run the script to get trust roots
./onlineca-get-trustroots.sh -U https://slcs.ceda.ac.uk/onlineca/trustroots/ -c $TRUSTROOTS_DIR -b || { echo "Failed to get trust roots"; exit 1; }

# Run the script to get a certificate
./onlineca-get-cert.sh -U https://slcs.ceda.ac.uk/onlineca/certificate/ -c $TRUSTROOTS_DIR -l fkarimian -o $CERTIFICATE_DIR/creds.pem || { echo "Failed to get certificate"; exit 1; }

# Create the download directory if it doesn't exist
mkdir -p $DOWNLOAD_DIR || { echo "Failed to create download directory $DOWNLOAD_DIR"; exit 1; }

# Download the files to the specified directory
wget --certificate=$CERTIFICATE_DIR"creds.pem" -r -P $DOWNLOAD_DIR -np -nH --cut-dirs=3 -R index.html $DATA_URL
