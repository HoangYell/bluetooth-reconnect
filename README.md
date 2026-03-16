# Bluetooth Auto-Reconnect Utility
Many Bluetooth audio devices, like the Sony ULT FIELD 1, struggle to maintain a stable connection with PCs. Users often have to repeatedly forget, pair, or power-cycle the device to connect successfully. This utility solves that frustrating problem.

## How It Works
The utility automates the reconnection process by:
1. Identifying the device using its friendly name.
2. Disconnecting the device to clear its internal state.
3. Waiting for the disconnection to fully process (preventing timeouts).
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
Exec=/home/yell/Projects/bluetooth-reconnect/bluetooth-reconnect.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Bluetooth Auto-Reconnect
Comment=Restarts Bluetooth connection on startup to prevent timeouts
Terminal=false
```

Make sure the path matches where you placed the script!

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
