#!/bin/sh
# Read the kernel command line to get the findiso= path

#Figuring out the ISO_PATH from the kernel command line
echo 'INFO: Setting $ISO_PATH to the value of the findiso= kernel command line parameter'
echo "DEBUG: START OF /proc/cmdline"
cat /proc/cmdline
echo "DEBUG: END OF /proc/cmdline"
ISO_PATH=$(cat /proc/cmdline | sed -n 's/.*findiso=\([^ ]*\).*/\1/p')
echo "INFO: \$ISO_PATH is set to '$ISO_PATH'"

if [ -z "$ISO_PATH" ]; then
    echo "INFO: Seeing that \$ISO_PATH is empty, we will wait 10 seconds and then exit with code 0."
    sleep 10
    exit 0
fi

# Load loop module if not built-in
echo "INFO: We will now load the loop module in case it is not built-in to the kernel. This is needed to mount the ISO file."
modprobe loop 2>/dev/null

# Create a mount point for the partition on the USB drive that contains the ISO file
echo "INFO: We will now create a mount point (/mnt/isospart) for the partition on the USB drive that contains the ISO file"
mkdir -p /mnt/isospart

# Wait 10 seconds for the kernel to detect USB drives
echo "INFO: We will now wait 10 seconds for the kernel to detect USB drives"
sleep 10

echo "DEBUG: I will now show you everything in /dev and wait 10 seconds before continuing"
echo "DEBUG: START OF 'ls /dev' output"
ls /dev
sleep 10
echo "DEBUG: END OF 'ls /dev' output"
echo "DEBUG: I will now show you everything in /dev/disk and wait 10 seconds before continuing."
echo "DEBUG: START OF 'ls -l /dev/disk/by-* 2>/dev/null' output. It could be that /dev/disk/by-* does not exist yet"
ls -l /dev/disk/by-* 2>/dev/null
sleep 10
echo "DEBUG: END OF 'ls -l /dev/disk/by-* 2>/dev/null' output"
echo "INFO: We will now search for the ISO on all block devices (USB drives, NVMe drives, etc.)"
for dev in $(ls /dev/sd* /dev/nvme* /dev/vd* 2>/dev/null); do
    echo "INFO: Checking device $dev"
    [ -b "$dev" ] || { echo "INFO: $dev is not a block device, skipping."; continue; }
    # Skip loop devices to avoid infinite loops. (TODO: Check if this is really necessary)
    case "$dev" in */loop*) { echo "INFO: $dev is a loop device, skipping."; continue; } ;; esac
    
    echo "INFO: Attempting to mount $dev (read-only) to /mnt/isospart"
    mount -o ro "$dev" /mnt/isospart && echo "INFO: Successfully mounted $dev to /mnt/isospart" || { echo "INFO: Failed to mount $dev to /mnt/isospart. Continuing to the next device."; continue; }
    
    if [ -f "/mnt/isospart$ISO_PATH" ]; then
        echo "INFO: Found the ISO file at $ISO_PATH on device $dev, creating a loop device for it and exiting with code 0."
        # Map the ISO to the next available loop device
        losetup -f "/mnt/isospart$ISO_PATH" && echo "INFO: Successfully created a loop device for /mnt/isospart$ISO_PATH" || { echo "INFO: Failed to create a loop device for /mnt/isospart$ISO_PATH. Waiting 10 seconds and exiting with return code 1. '$dev' is still mounted at /mnt/isospart"; sleep 10; exit 1; }
        
        # Tell udev to rescan block devices so it sees the loop device's label
        echo "INFO: We will now run 'udevadm trigger' to tell udev to rescan block devices so it sees the loop device's label"
        udevadm trigger ; echo "'INFO: udevadm trigger' returned $?"
        echo "INFO: We will now run 'udevadm settle' to wait for udev to finish processing events"
        udevadm settle ; echo "'INFO: udevadm settle' returned $?"
        echo "INFO: We are done. We will now wait 10 seconds and then exit with code 0."
        echo "The result is that '$dev' is still mounted at /mnt/isospart and the ISO file at '$ISO_PATH' is now mapped to a loop device."
        echo "To figure out which loop device it is mapped to, run 'losetup -a' and look for the line that contains '/mnt/isospart$ISO_PATH'."
        sleep 10
        exit 0
    fi
    echo "INFO: $dev does not contain the ISO file at $ISO_PATH. Unmounting and continuing to the next device."
    umount /mnt/isospart 2>/dev/null
done
