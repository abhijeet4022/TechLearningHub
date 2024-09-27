#!/bin/bash

# Define the sudoers.d directory
SUDOERS_DIR="/etc/sudoers.d"
RESTRICTED_FILE="restricted_commands"

# Define the entry to be added
ENTRY="abhijeet ALL=(ALL) ALL, !/sbin/shutdown, !/sbin/init 0, !/sbin/poweroff, !/bin/su -, !/bin/su"

# Create the restricted_commands file with appropriate permissions if it doesn't exist
if [ ! -f "${SUDOERS_DIR}/${RESTRICTED_FILE}" ]; then
    {
        echo "## Allow sudo permission to user except su and shutdown command"
        echo "${ENTRY}"
    } | sudo tee "${SUDOERS_DIR}/${RESTRICTED_FILE}" > /dev/null
else
    # Check if the entry already exists
    if ! sudo grep -qF "${ENTRY}" "${SUDOERS_DIR}/${RESTRICTED_FILE}"; then
        echo "${ENTRY}" | sudo tee -a "${SUDOERS_DIR}/${RESTRICTED_FILE}" > /dev/null
    else
        echo "Entry already exists in ${SUDOERS_DIR}/${RESTRICTED_FILE}."
    fi
fi

# Set the correct permissions for the file
sudo chmod 440 "${SUDOERS_DIR}/${RESTRICTED_FILE}"

# Confirm the file was created and display its contents
echo "Updated ${SUDOERS_DIR}/${RESTRICTED_FILE} with the following content:"
sudo cat "${SUDOERS_DIR}/${RESTRICTED_FILE}"
