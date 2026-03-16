#!/bin/bash

# Default device name if none provided
DEFAULT_DEVICE_NAME="ULT FIELD 1"

# Use the provided argument or the default
DEVICE_NAME="${1:-$DEFAULT_DEVICE_NAME}"

echo "=========================================="
echo " Bluetooth Reconnect Utility "
echo " Target Device: '$DEVICE_NAME'"
echo "=========================================="

# 1. Find the MAC address of the device by its name
# Wait up to 30 seconds for the device to appear (useful for running on system boot)
echo "Looking for device in Bluetooth manager..."
for ((w=1; w<=15; w++)); do
    MAC_ADDRESS=$(bluetoothctl devices | grep "$DEVICE_NAME" | head -n 1 | awk '{print $2}')
    if [ -n "$MAC_ADDRESS" ]; then
        break
    fi
    echo "Waiting for Bluetooth device list to be ready..."
    sleep 2
done

if [ -z "$MAC_ADDRESS" ]; then
    echo "Error: Device '$DEVICE_NAME' not found in your Bluetooth devices list."
    echo "Make sure it has been paired at least once."
    exit 1
fi

echo "Found '$DEVICE_NAME' with MAC address: $MAC_ADDRESS"

# 2. Disconnect the device
echo "Disconnecting..."
bluetoothctl disconnect "$MAC_ADDRESS"

# 3. Wait to ensure the device fully processes the disconnection
# Some devices require more time to clear their link layer state
echo "Waiting to ensure disconnection is processed..."
sleep 5

# 4. Reconnect the device with a retry loop
MAX_RETRIES=3
for ((i=1; i<=MAX_RETRIES; i++)); do
    echo "Reconnecting (Attempt $i of $MAX_RETRIES)..."
    if bluetoothctl connect "$MAC_ADDRESS"; then
        echo "Successfully reconnected to '$DEVICE_NAME'!"
        exit 0
    else
        echo "Connection failed (br-connection-page-timeout usually means the device isn't ready)."
        if [ "$i" -lt "$MAX_RETRIES" ]; then
            echo "Retrying in 5 seconds..."
            sleep 5
        fi
    fi
done

echo "Error: Could not reconnect to '$DEVICE_NAME' after $MAX_RETRIES attempts."
exit 1
