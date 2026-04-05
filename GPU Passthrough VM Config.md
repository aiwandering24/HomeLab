# Ubuntu 24.04 VM Configuration for GPU Passthrough

This guide covers the specific Proxmox VM settings and guest OS configuration required to successfully pass through a GPU to an Ubuntu 24.04 virtual machine.

---

## 1. Proxmox VM Creation Settings
When creating the VM in the Proxmox Web UI, use these specific parameters:


| Tab | Setting | Value |
| :--- | :--- | :--- |
| **General** | Name | e.g., `Ubuntu-GPU` |
| **System** | Machine | `q35` |
| **System** | BIOS | `OVMF (UEFI)` |
| **System** | Qemu Agent | `Enabled` (Checked) |
| **CPU** | Type | `host` |
| **Memory** | Ballooning | `Disabled` (Uncheck "Ballooning Device") |

---

## 2. Adding the GPU Hardware
After the VM is created, navigate to the **Hardware** tab of the VM:

1. Click **Add** > **PCI Device**.
2. Select **Raw Device** and choose your GPU address (e.g., `0000:04:00.0`).
3. Configure the following toggles:
   - **All Functions**: `Checked` (Ensures the HDMI Audio at `04:00.1` is included).
   - **ROM-Bar**: `Checked`.
   - **Primary GPU**: `Checked` (Enable if this is the VM's main display).
   - **PCI-Express**: `Checked`.

---

## 3. Guest OS Configuration (Inside Ubuntu 24.04)

Once Ubuntu is installed and booted, perform the following steps to initialize the hardware.

### A. Update the System
```bash
sudo apt update && sudo apt upgrade -y  
```

## 4. Assign GPU to VM
```bash
qm status 101
qm stop 101 --skipped
qm set <vmid> -args '-global q35-pcihost.pci-hole64-size=512G'
qm list
systemctl restart pve-cluster
```
## 5. Fix the Remote Desktop Freeze Directly
```bash
sudo apt-get install --reinstall gnome-remote-desktop
sudo reboot
```
## 5. Reinstall GNOME Desktop Environment
```bash
sudo apt update
sudo apt install --reinstall ubuntu-gnome-desktop gdm3

```
## 5. Force Xorg instead of Wayland
```bash
sudo nano /etc/gdm3/custom.conf
WaylandEnable=false
sudo systemctl restart gdm
nvidia-smi
```
## 6. Install a Virtual Display Driver (Dummy Driver):
This tricks the NVIDIA card into thinking a monitor is plugged in so the desktop can start.
bash
```bash
sudo apt update
sudo apt install xserver-xorg-video-dummy
```
