#!/system/bin/sh
# OOS 12 requires a special partition named "apdp" inorder
# to flash OOS12 OTA update using custom recovery.
# The existance of this partition makes problem with
# bootctl hal and boot slot can't be changed after update
# This script unlink: apdp_a & apdp_b with /apdp/apdp.img

LOGF=/tmp/recovery.log;

post_oos_flash() {
    [ -f /apdp/apdp.img ];
    echo "Starting post-oos-flash service..." >> $LOGF
    echo "post-oos-flash: unlinking 'apdp' dynamic partitions from fake partition image" >> $LOGF
    unlink /dev/block/by-name/apdp_a;
    unlink /dev/block/by-name/apdp_b;
    unlink /dev/block/bootdevice/by-name/apdp_a;
    unlink /dev/block/bootdevice/by-name/apdp_b;
    echo "post-oos-flash: removing 'apdp' directory from root directory" >> $LOGF
    rm -rf /apdp;
}

post_oos_flash;

exit 0;
#
