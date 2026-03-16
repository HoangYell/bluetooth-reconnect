# Bluetooth Auto-Reconnect Utility

A lightweight utility to automatically reconnect problematic Bluetooth devices (like Sony speakers) on Linux and Windows, specifically solving connection timeout and startup sync issues.

## The Problem
Many Bluetooth audio devices, especially speakers like the Sony ULT FIELD 1, suffer from connection timeout issues (e.g., `br-connection-page-timeout` on Linux) or simply fail to connect automatically on system boot when the host Bluetooth adapter and the device's link layer state are out of sync.

## The Solution
This utility solves the issue by:
1. Automatically finding the device's identifier by its friendly name.
2. Gracefully disconnecting the device to clear its internal state.
3. Patiently waiting for the device to fully process the disconnection (the crucial step to prevent timeouts).
4. Reconnecting the device.

---

## 🐧 Linux Installation & Usage (Bash)

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

---

## 🪟 Windows Installation & Usage (PowerShell)

Due to Windows limitations with command-line Bluetooth management, the Windows version operates by temporarily disabling and re-enabling the device's driver via Plug-and-Play (PnP). **This requires Administrator privileges.**

### 1. Run manually
Open **PowerShell as Administrator**, navigate to the script directory, and run it:
```powershell
.\bluetooth-reconnect.ps1 "Your Device Name"
```
*(If no name is provided, it defaults to "ULT FIELD 1")*

### Note on Execution Policies
If you receive an execution policy error, you may need to bypass it for the current session:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\bluetooth-reconnect.ps1
```

### 2. Setup Auto-Run on Boot (Task Scheduler)
Because the script requires Administrator privileges, the standard Windows Startup folder won't work without prompting you every time. Instead, use the **Task Scheduler**:

1. Open the Start Menu, search for and open **Task Scheduler**.
2. On the right panel, click **Create Task...** (Not "Create Basic Task").
3. **General Tab:**
   - Name: `Bluetooth Auto-Reconnect`
   - Check the box at the bottom: **Run with highest privileges**.
4. **Triggers Tab:**
   - Click **New...**
   - Begin the task: **At log on** -> Click OK.
5. **Actions Tab:**
   - Click **New...**
   - Action: **Start a program**
   - Program/script: `powershell`
   - Add arguments: `-WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\path\to\your\bluetooth-reconnect.ps1"`
   *(Make sure to replace the path with where you actually saved the script)* -> Click OK.
6. Click **OK** on the main Create Task window.

The script will now run silently in the background with necessary permissions every time you log into Windows!

---

## Customization
If your device requires more time to reset its state, simply increase the `sleep` duration in the respective script.
