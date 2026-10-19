# How to Wipe a Proxmox Disk Locked by LVM
```bash
lsblk
lsblk -o Name, SIZE, SFTYPE, MOUNTPOINTS,TYPE
sgdisk --zap-all /dev/sda

Clean Disks- Prepare for Mount - Directory - Before GPT. 
sgdisk --zap-all /dev/sdX
wipefs -a /dev/sdX
dd if=/dev/zero of=/dev/sdX bs=1M count=100 conv=fdatasync


```
If you see partitions like `pveswap`, `root`, `data_tmeta`, and `data_tdata` under `sda3`, it means the partition is currently locked by active **LVM (Logical Volume Manager)** groups. 

> [!CAUTION]
> **STOP if this is your active Proxmox system disk.** You cannot wipe the drive you are currently booted into and running the operating system from.
>
> If this is an **old Proxmox drive** plugged into a different machine or a Live USB environment, follow the steps below to safely unlock and wipe it.

---

## Step-by-Step Removal Guide

### 1. Deactivate the Volume Group
Tell Linux to stop using the Proxmox volumes so they release their lock on `/dev/sda3`:
```bash
sudo vgchange -an pve
```
*(Note: If your volume group has a different name than `pve`, look at your `lsblk` tree—the text right before `-swap` or `-root` is your volume group name).*

### 2. Force-Remove the LVM Metadata
If deactivating doesn't clear them, or if you want to explicitly delete the volumes from the LVM database, run:
```bash
sudo lvremove /dev/pve/data -y
sudo lvremove /dev/pve/root -y
sudo lvremove /dev/pve/swap -y
```
Followed by removing the entire volume group:
```bash
sudo vgremove pve -y
```

### 3. Clear Device Mapper Anchors
Sometimes the device mapper holds onto thin-pool partitions (`_tmeta` and `_tdata`). Force them closed:
```bash
sudo dmsetup remove_all
```

### 4. Completely Wipe the Signatures
Now that the LVM layer is completely deactivated, use `wipefs` to strip all partition headers, LVM labels, and filesystem signatures from the partition and the raw disk:
```bash
sudo wipefs -af /dev/sda3
sudo wipefs -af /dev/sda
```

### 5. Run the Zap Command Again
Now that the drive is fully unlocked, your original `sgdisk` command will succeed flawlessly:
```bash
sudo sgdisk --zap-all /dev/sda
```

---

## Verification
Confirm that the drive is 100% clean by running:
```bash
lsblk
```
The target disk should now show up as a single, clean device with no partitions or logical volumes listed underneath it.
