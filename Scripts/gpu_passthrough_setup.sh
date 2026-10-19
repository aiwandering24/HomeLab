#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Starting Proxmox GPU Passthrough Setup ==="

# 1. Update GRUB configuration
echo "[1/6] Configuring GRUB..."
GRUB_FILE="/etc/default/grub"
# Backup grub
cp "$GRUB_FILE" "${GRUB_FILE}.bak"

# Replace GRUB line with IOMMU and isolation flags
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=".*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt pcie_acs_override=downstream,multifunction nofb nomodeset video=vesafb:off,efifb:off"/' "$GRUB_FILE"

echo "Updating GRUB..."
update-grub

# 2. Update Kernel Modules
echo "[2/6] Adding VFIO modules to /etc/modules..."
MODULES_FILE="/etc/modules"
for mod in vfio vfio_iommu_type1 vfio_pci vfio_virqfd; do
    if ! grep -Fxq "$mod" "$MODULES_FILE"; then
        echo "$mod" >> "$MODULES_FILE"
    fi
done

# 3. Allow Unsafe Interrupts
echo "[3/6] Configuring unsafe interrupts..."
echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/iommu_unsafe_interrupts.conf

# 4. Ignore MSRs (Prevents Windows 11 BSOD)
echo "[4/6] Configuring KVM MSR tweaks..."
echo "options kvm ignore_msrs=1" > /etc/modprobe.d/kvm.conf

# 5. Blacklist Host GPU Drivers
echo "[5/6] Blacklisting host GPU drivers..."
cat << 'EOF' > /etc/modprobe.d/blacklist.conf
blacklist radeon
blacklist nouveau
blacklist nvidia
blacklist nvidiafb
EOF

# 6. Update Initramfs
echo "[6/6] Updating initramfs..."
update-initramfs -u

echo "=== Setup Complete! ==="
echo "WARNING: Please verify your Step 6 (VFIO ID / Override script) configuration before rebooting."
read -p "Do you want to reboot now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
fi
