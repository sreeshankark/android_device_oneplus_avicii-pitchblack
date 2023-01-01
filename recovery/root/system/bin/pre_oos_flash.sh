#!/system/bin/sh
# OOS 12 requires a special partition named "apdp" inorder
# to flash OOS12 OTA update using custom recovery.
# This shell script enables the fake partition for OOS12 
# OTA flashing.
# This script enable symlinks: apdp_a & apdp_b to /apdp/apdp.img

LOGF=/tmp/recovery.log;

pre_oos_flash() {
    [ -f /apdp/apdp.img ];
    echo "Starting pre-oos-flash service..." >> $LOGF
    echo "pre-oos-flash: creating 'apdp' directory in root directory" >> $LOGF
    mkdir /apdp;
    echo "pre-oos-flash: creating fake partition image: apdp.img" >> $LOGF
    touch /apdp/apdp.img;
    echo "pre-oos-flash: linking 'apdp' dynamic partitions with fake partition image" >> $LOGF
    ln -sf /apdp/apdp.img /dev/block/by-name/apdp_a;
    ln -sf /apdp/apdp.img /dev/block/by-name/apdp_b;
    ln -sf /apdp/apdp.img /dev/block/bootdevice/by-name/apdp_a;
    ln -sf /apdp/apdp.img /dev/block/bootdevice/by-name/apdp_b;
}

pre_oos_flash;

exit 0;
#
