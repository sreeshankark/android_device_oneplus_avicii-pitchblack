#!/system/bin/sh
#
# Script by Sreeshankar K (@Sanju0910)
#
# Deal with situations where the ROM doesn't support wrappedkey encryption;
# In such cases, remove the wrappedkey flag from the fstab file
#
# the recovery log
LOGF=/tmp/recovery.log;

# file_getprop <file> <property>

file_getprop() {
  local F=$(grep -m1 "^$2=" "$1" | cut -d= -f2);
  echo $F | sed 's/ *$//g';
}

# NOTE: this function is hard-coded for a handful of ROMs which, at the time of writing this script, 
# did not support wrappedkey; if any of them starts supporting wrappedkey, the function will need to be amended

wrappedkey_fix() {
local D=/pb_temp/system_prop;
local S=/dev/block/bootdevice/by-name/system;
local F=/pb_temp/system-build.prop;
local found=0;
    cd /pb_temp;
    mkdir -p $D;
    mount -r $S $D;
    cp $D/system/build.prop $F;
    umount $D;
    rmdir $D;

    [ ! -e $F ] && {
    	return;
    }

    # check the ROM's SDK for >= A13
    local SDK=$(file_getprop "$F" "ro.build.version.sdk");
    [ -z "$SDK" ] && SDK=$(file_getprop "$F" "ro.system.build.version.sdk");
    [ -z "$SDK" ] && SDK=$(file_getprop "$F" "ro.vendor.build.version.sdk");

    # assume for the moment that no A13 ROM supports wrappedkey
    if [ -n "$SDK" -a $SDK -ge 33 ]; then
	found=1;
    fi

    # avicii A12 & A12.1 ROMs that don't support wrappedkey (as of the date of writing this script)
    if [ -n "$(grep pixys $F)" ]; then
    	found=1;
    fi
    if [ -n "$(grep bliss $F)" ]; then
       found=2;
    fi
    if [ -n "$(grep lineage $F)" ]; then
       found=2;
    fi
    if [ "$found" = "2" ]; then
       	  echo "I:Wrappedkey-fix-service: this ROM does not support wrappedkey. Correcting the fstab" >> $LOGF;
       	  cp /system/etc/recovery_semiwrap.fstab /system/etc/recovery.fstab;
       fi
    if [ "$found" = "1" ]; then
       	  echo "I:Wrappedkey-fix-service: this ROM does not support wrappedkey. Correcting the fstab" >> $LOGF;
       	  cp /system/etc/recovery_nowrap.fstab /system/etc/recovery.fstab;
       fi
    elif [ "$found" = "0" ]; then
       echo "I:Wrappedkey-fix-service: this ROM supports wrappedkey. Continuing with the default fstab" >> $LOGF;
    fi

    # cleanup
    rm $F;
}

wrappedkey_fix;

exit 0;
