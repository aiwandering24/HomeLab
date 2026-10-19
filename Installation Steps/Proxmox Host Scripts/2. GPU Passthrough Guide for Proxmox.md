# GPU Passthrough Guide for Proxmox (Windows 11 VM)

This tutorial provides a comprehensive guide on configuring GPU passthrough in Proxmox. It has been updated specifically to handle the **Dell PowerEdge R720** context and the "Identical GPU" scenario (where two GPUs share the same Vendor/Device ID but different PCI addresses).

---

## Prerequisites
* **BIOS Settings:** Ensure `Virtualization Technology` and `VT-for-Direct IO` (IOMMU) are **Enabled**. 
* **Memory Mapping:** For high-end GPUs, enable `Memory Mapped I/O above 4GB` in the System BIOS settings.

---

## Step-by-Step Configuration

### Step 1: Edit GRUB
Modify the bootloader to enable IOMMU and prevent the host from grabbing the GPU early.
```bash
nano /etc/default/grub
```
Change `GRUB_CMDLINE_LINUX_DEFAULT="quiet"` to:
```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt pcie_acs_override=downstream,multifunction nofb nomodeset video=vesafb:off,efifb:off"
```
*Save and exit.*

### Step 2: Update GRUB
```bash
update-grub
```

### Step 3: Edit Module Files
Add the necessary VFIO drivers to the kernel.
```bash
nano /etc/modules
```
Add these lines:
```text
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```
*Save and exit.*

### Step 4: IOMMU Remapping & KVM Tweaks
**a) Allow unsafe interrupts:**
```bash
nano /etc/modprobe.d/iommu_unsafe_interrupts.conf
```
Add: `options vfio_iommu_type1 allow_unsafe_interrupts=1`

**b) Ignore MSRs (prevents Windows 11 BSOD):**
```bash
nano /etc/modprobe.d/kvm.conf
```
Add: `options kvm ignore_msrs=1`

### Step 5: Blacklist Host GPU Drivers
Prevent Proxmox from loading standard drivers for the cards.
```bash
nano /etc/modprobe.d/blacklist.conf
```
Add:
```text
blacklist radeon
blacklist nouveau
blacklist nvidia
blacklist nvidiafb
```

### Step 6: Targeted GPU Isolation (Identical GPU Method)
If you have two identical GPUs (e.g., at `04:00.0` and `42:00.0`), do **not** use `ids=` in `vfio.conf`. Use a script to target specific PCI addresses.

**a) Create the override script:**
```bash
nano /usr/local/bin/vfio-pci-override.sh
```
Paste the following (replace with your specific addresses found via `lspci`):
```bash
#!/bin/sh
# Target only the GPU/Audio functions for the card you want to pass through
DEVS="0000:04:00.0 0000:04:00.1"

for DEV in $DEVS; do
    echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
done

modprobe -i vfio-pci
```
```bash
chmod +x /usr/local/bin/vfio-pci-override.sh
```

**b) Configure VFIO to use the script:**
```bash
nano /etc/modprobe.d/vfio.conf
```
Add:
```text
install vfio-pci /usr/local/bin/vfio-pci-override.sh
options vfio-pci disable_vga=1
```
better to use : options vfio-pci ids=10de:1b38 disable_vga=1

### Step 7: Update and Restart
```bash
update-initramfs -u
reboot
```

---

## Special Case: Intel Integrated GPU (iGPU)
If you are passing through an Intel iGPU (e.g., HD Graphics 630):

1. **GRUB:**
   `GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on i915.enable_gvt=1 iommu=pt pcie_acs_override=downstream,multifunction video=efifb:off video=vesa:off vfio_iommu_type1.allow_unsafe_interrupts=1 kvm.ignore_msrs=1 modprobe.blacklist=radeon,nouveau,nvidia,nvidiafb"`

2. **Modules:** Add `kvmgt` to `/etc/modules`.

3. **VFIO IDs:** Since iGPUs are usually unique in the system, you can use the ID method:
   `options vfio-pci ids=8086:xxxx disable_vga=1`

4. **Proxmox VM Hardware Settings:**
   * **Machine:** q35
   * **PCI Device:** Uncheck "All Function", Uncheck "ROM-Bar", Uncheck "PCI-Express".

