#!/bin/bash

TARGET_IP="root@212.162.146.164"
TARGET_DIR="/mybackup/master/$(date +"%d-%m-%Y")"

# Check if the user is running the script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Create the target directory on the remote machine if it doesn't exist
echo "Creating target directory on remote machine if it doesn't exist..."
ssh "${TARGET_IP}" "mkdir -p '${TARGET_DIR}'"

# Perform the rsync operation
echo "Starting SCP of the entire root directory. This may take a while..."
rsync -avz --progress \
  --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found/*","/proc/kcore"} \
  / "${TARGET_IP}:${TARGET_DIR}"
echo "SCP operation complete."