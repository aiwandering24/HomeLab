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
## 6. Reinstall GNOME Desktop Environment
```bash
sudo apt update
sudo apt install --reinstall ubuntu-gnome-desktop gdm3
Reset GNOME to Defaults (if configs are broken):
dconf reset -f /org/gnome/
```
## 7. Force Xorg instead of Wayland
```bash
sudo nano /etc/gdm3/custom.conf
WaylandEnable=false
sudo systemctl restart gdm
nvidia-smi
```
## 8. Install a Virtual Display Driver (Dummy Driver):
This tricks the NVIDIA card into thinking a monitor is plugged in so the desktop can start.
bash
```bash
sudo apt update
sudo apt install xserver-xorg-video-dummy
```
Step 3: Fix the "Phantom Monitor" Problem
The NVIDIA driver won't start a desktop session if it thinks there is no monitor. We need to "trick" it.
Generate a basic Xorg config:
```bash
sudo nvidia-xconfig --allow-empty-initial-configuration
```
Use code with caution.

Restart the Display Manager:
```bash
sudo systemctl restart gdm
```
## 9. Check if gpu is present and Install Driver
```bash
lspci | grep 01:00
sudo apt-add-repository -r ppa:graphics-drivers/ppa
sudo apt update
sudo apt remove nvidia*
sudo apt autoremove
sudo ubuntu-drivers autoinstall
```
if run nvidia-smi and get complaints, run below.
```bash
sudo rmmod nouveau
sudo modprobe nvidia
# https://unix.stackexchange.com/questions/219059/remove-nouveau-driver-nvidia-without-rebooting
```
## 10.This "loop" occurs when the kernel module and the driver are stuck in a half-installed state. Standard commands like apt install -f often fail because the system repeatedly attempts to configure the same corrupted files.

To break this cycle, you must force-remove the specific broken modules and start fresh.

1. Force the Removal of Stuck Packages
Run the following command to instruct dpkg to remove the packages regardless of dependency errors:

```bash
sudo dpkg --purge --force-all linux-modules-nvidia-535-6.17.0-20-generic linux-modules-nvidia-535-generic-hwe-24.04 nvidia-driver-535
```
2. Clean Up "Zombie" Dependencies
Clear out any remaining or unused cached files:

```bash
sudo apt autoremove -y
sudo apt clean
```
3. Update the Kernel First
Before reinstalling any drivers, ensure your kernel is fully updated and configured to avoid version mismatches:

```bash
sudo apt update
sudo apt install --reinstall linux-image-generic linux-headers-generic\
```
4. Reinstall a Stable Driver
Avoid the HWE version (which caused the initial mismatch). Instead, install the standard production driver.

Tip: I recommend version 550 for Ubuntu 24.04, as it is better optimized for the 6.x kernels than the older 535.

```bash
sudo apt install nvidia-driver-550
```
5. Final Configuration & Reboot
Once the installation finishes without errors, trigger the final configuration and update your boot RAM disk:

```bash
sudo dpkg --configure -a
sudo update-initramfs -u
sudo reboot
```
#run nvidia-smi to confirm presense of gpu.

#install nvidia container toolkit https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

#confirm install success docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
