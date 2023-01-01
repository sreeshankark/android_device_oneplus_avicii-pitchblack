#!/system/bin/sh
# This script deal with situations where the ROM doesn't support wrappedkey encryption;
# In such cases, remove the wrappedkey flag from the fstab file

LOGF=/tmp/recovery.log;

file_getprop() {
  local F=$(grep -m1 "^$2=" "$1" | cut -d= -f2);
  echo $F | sed 's/ *$//g';
}

fix_unwrap_decryption() {
echo "Starting wrappedkey-fix-service..." >> $LOGF;
local D=/FFiles/temp/system_prop;
local S=/dev/block/bootdevice/by-name/system;
local F=/FFiles/temp/system-build.prop;
local found=0;
    cd /FFiles/temp/;
    mkdir -p $D;
    mount -r $S $D;
    cp $D/system/build.prop $F;
    umount $D;
    rmdir $D;

    [ ! -e $F ] && {
    	echo "wrappedkey-fix-service: $F does not exist. Quitting." >> $LOGF;
    	return;
    }

    # avicii A12 ROMs that don't support wrappedkey (as of the date of writing this script)
    if [ -n "$(grep pixys_avicii $F)" ]; then
    	found=1;
    fi

    if [ "$found" = "1" ]; then
       local wrap0=$(grep "/userdata" "/system/etc/recovery.fstab" | grep "wrappedkey_v0"); # check for FBEv2 wrappedkey_v0, and skip, if found
       if [ -z "$wrap0" ]; then
       	  echo "wrappedkey-fix-service: This ROM does not support wrappedkey. Removing the wrappedkey flags from the fstab" >> $LOGF;
       	  sed -i -e "s/,wrappedkey//g" /system/etc/recovery.fstab;
       fi
    elif [ "$found" = "0" ]; then
       echo "wrappedkey-fix-service: This ROM supports wrappedkey. Continuing with the default fstab" >> $LOGF;
    fi

    # cleanup
    rm $F;
}

V=$(getprop "ro.orangefox.variant");

[ "$V" = "FBEv1" ];

fix_unwrap_decryption;

[ "$V" != "FBEv1" ];

exit 0;
#
