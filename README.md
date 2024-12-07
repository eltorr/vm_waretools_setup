# VMware Tools Setup

Simple script to automate VMware Tools installation, with support for both Debian-based and RHEL-based systems. The script also detects if the system is a desktop environment to include additional tools as needed.

## Quick Install

Run the following command to download and execute the script directly:

```bash
curl -sSL https://raw.githubusercontent.com/yourusername/vmware-tools-setup/main/vmware-setup.sh | sudo bash
```

## Alternative Installation

Download and run the script manually:

```bash
wget https://raw.githubusercontent.com/yourusername/vmware-tools-setup/main/vmware-setup.sh
chmod +x vmware-setup.sh
sudo ./vmware-setup.sh
```

## What it Does

1. **System Detection**: Checks if the system is Debian-based (e.g., Ubuntu) or RHEL-based (e.g., Rocky Linux).
2. **Desktop Environment Detection**: Determines if the system is using a desktop environment and installs additional packages accordingly.
3. **Install VMware Tools**: Installs `open-vm-tools` and additional desktop packages if required.
4. **Enable and Start Service**: Enables and starts the `vmtoolsd` service.
5. **Verification**: Confirms the successful installation of VMware Tools.

## Requirements

- Debian-based or RHEL-based system
- Root/sudo access
- Internet connection

## Features

- ✅ Automated installation
- ✅ System compatibility check (Debian/RHEL)
- ✅ Desktop environment detection
- ✅ Service verification
- ✅ Error handling

## Troubleshooting

If you encounter issues:

1. Check the `vmtoolsd` service status:
   ```bash
   systemctl status vmtoolsd
   ```
2. Verify installation of VMware Tools:
   - **RHEL-based**:
     ```bash
     rpm -qa | grep open-vm-tools
     ```
   - **Debian-based**:
     ```bash
     dpkg -l | grep open-vm-tools
     ```
3. Check logs:
   ```bash
   journalctl -u vmtoolsd
   ```

## License

MIT License - feel free to modify and reuse!


