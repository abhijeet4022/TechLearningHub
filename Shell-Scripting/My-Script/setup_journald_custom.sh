#!/bin/bash

# Define the custom configuration directory and file
CUSTOM_CONF_DIR="/etc/systemd/journald.conf.d"
CUSTOM_CONF_FILE="$CUSTOM_CONF_DIR/99-custom.conf"
JOURNAL_DIR="/var/log/journal"

# Create the journal directory if it doesn't exist
if [ ! -d "$JOURNAL_DIR" ]; then
    echo "Creating journal directory: $JOURNAL_DIR"
    sudo mkdir -p "$JOURNAL_DIR"
    sudo chmod 2750 "$JOURNAL_DIR"  # Set appropriate permissions
    # Ensure the journal directory and files are created properly
    echo "Ensuring correct setup for journal logs..."
    sudo systemd-tmpfiles --create --prefix /var/log/journal
else
    echo "Journal directory already exists: $JOURNAL_DIR"
fi

# Create the custom configuration directory if it doesn't exist
if [ ! -d "$CUSTOM_CONF_DIR" ]; then
    echo "Creating custom configuration directory: $CUSTOM_CONF_DIR"
    sudo mkdir -p "$CUSTOM_CONF_DIR"
else
    echo "Custom configuration directory already exists: $CUSTOM_CONF_DIR"
fi

# Check if the custom configuration file exists
if [ -f "$CUSTOM_CONF_FILE" ]; then
    echo "Custom configuration file already exists: $CUSTOM_CONF_FILE"
    # Check if the required configurations are already present
    if grep -q "^Storage=persistent" "$CUSTOM_CONF_FILE"; then
        echo "Persistent logging is already enabled in $CUSTOM_CONF_FILE"
    else
        echo "Enabling persistent logging in $CUSTOM_CONF_FILE"
        echo "[Journal]" | sudo tee -a "$CUSTOM_CONF_FILE" > /dev/null
        echo "Storage=persistent" | sudo tee -a "$CUSTOM_CONF_FILE" > /dev/null
    fi

    if grep -q "^MaxRetentionSec=7d" "$CUSTOM_CONF_FILE"; then
        echo "Log retention is already set to 7 days in $CUSTOM_CONF_FILE"
    else
        echo "Setting log retention to 7 days in $CUSTOM_CONF_FILE"
        echo "MaxRetentionSec=7d" | sudo tee -a "$CUSTOM_CONF_FILE" > /dev/null
    fi
else
    echo "Creating custom configuration file: $CUSTOM_CONF_FILE"
    {
        echo "[Journal]"
        echo "Storage=persistent"
        echo "MaxRetentionSec=7d"
    } | sudo tee "$CUSTOM_CONF_FILE" > /dev/null
fi

# Restart journald to apply changes
echo "Restarting systemd-journald service..."
sudo systemctl restart systemd-journald

# Confirm the configuration
echo "Current disk usage for journal logs:"
journalctl --disk-usage

echo "Custom persistent logging setup completed successfully."

# If we dont want to reboot the system try this
# Force a Log Flush: You can manually flush the journal logs to ensure they are written to disk:
# `sudo systemctl kill --kill-who=main systemd-journald`
# `sudo systemctl restart systemd-journald`
# `journalctl -b -1` # to check the logs on last reboot

