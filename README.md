# Bluetooth Auto-Reconnect Utility

A lightweight Bash script to automatically reconnect problematic Bluetooth devices (like Sony speakers) on Linux, specifically solving the infamous `br-connection-page-timeout` error.

## The Problem
Many Bluetooth audio devices, especially speakers like the Sony ULT FIELD 1, suffer from connection timeout issues (`br-connection-page-timeout`) on Linux. This typically happens when the device is disconnected and immediately reconnected, or during system boot when the Bluetooth adapter and the device's link layer state are out of sync.

## The Solution
This script solves the issue by:
1. Automatically finding the device's MAC address by its friendly name.
2. Gracefully disconnecting the device to clear its internal state.
3. Patiently waiting for the device to fully process the disconnection (the crucial step to prevent timeouts).
4. Utilizing a robust retry loop to establish the connection instead of failing instantly.

## Installation & Usage

### 1. Make the script executable
```bash
chmod +x bluetooth-reconnect.sh
```

### 2. Run manually
Run the script, optionally passing your device name (defaults to "ULT FIELD 1"):
```bash
./bluetooth-reconnect.sh "Your Device Name"
```

### 3. Setup Auto-Run on Boot (Optional)
To run this automatically every time you log in, create a `.desktop` file in your autostart directory.

Create `~/.config/autostart/bluetooth-reconnect.desktop`:
```ini
[Desktop Entry]
Type=Application
Exec=/path/to/your/bluetooth-reconnect.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Bluetooth Auto-Reconnect
Comment=Restarts Bluetooth connection on startup to prevent timeouts
Terminal=false
```

Make sure to replace `/path/to/your/bluetooth-reconnect.sh` with the actual path to the script!

## Customization
If your device requires more time to reset its state, simply increase the `sleep` duration in the script.
