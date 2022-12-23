#
# Copyright (C) 2022 The Android Open Source Project
# Copyright (C) 2022 PitchBlack Recovery Project 
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/oneplus/avicii

# A/B support
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm \
    product \
    recovery \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    checkpoint_gc \
    update_engine_sideload

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

BOARD_USES_RECOVERY_AS_BOOT := false
    
# API
PRODUCT_SHIPPING_API_LEVEL := 29

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-service \
    android.hardware.boot@1.2-impl-wrapper.recovery \
    android.hardware.boot@1.2-impl-wrapper \
    android.hardware.boot@1.2-impl.recovery \
    bootctrl.$(PRODUCT_PLATFORM) \
    bootctrl.$(PRODUCT_PLATFORM).recovery \
    
PRODUCT_PACKAGES_DEBUG += \
    bootctl
        
# Health HAL
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl.recovery

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# qcom ncryption
PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe 

# tzdata
PRODUCT_PACKAGES_ENG += \
    tzdata_twrp

# Hidl Service
PRODUCT_ENFORCE_VINTF_MANIFEST := true

# Recovery
RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@2.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/libdisplayconfig.qti.so

# OEM otacert
PRODUCT_EXTRA_RECOVERY_KEYS += \
    $(LOCAL_PATH)/security/local_OTA
    
# Manifest
PRODUCT_COPY_FILES += \
    device/oneplus/avicii/manifest/system_manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/manifest.xml \
    device/oneplus/avicii/manifest/vendor_manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/manifest.xml
