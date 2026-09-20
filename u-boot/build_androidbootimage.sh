#!/usr/bin/env sh
#
# build_androidbootimage.sh - Create a android bootimg, compatible with ABL
#
# Usage:
# ./build_androidbootimage.sh <path_to_u-boot-nodtb.bin> <path_to_dtb> <path_to_boot.img>

UBOOT_BIN=$1
DTB_PATH=$2
OUTPUT_BOOT=$3
OUTPUT_KERNEL=u-boot-nodtb.bin.gz-dtb # U-Boot compacted and concatenated with dtb

echo $1 $2 $3

if [ ! -f "$UBOOT_BIN" ]; then
    echo "Error: Path to u-boot-nodtb.bin is invalid"
    exit 1
fi
if [ ! -f "$DTB_PATH" ]; then
    echo "Error: Path to device.dtb is invalid"
    exit 1
fi
if [ -z "$OUTPUT_BOOT" ]; then
    echo "Error: Path to boot.img is invalid"
    exit 1
fi

# Create a empty ramdisk
echo "Creating an empty ramdisk"
TEMP_DIR="$(mktemp -d)"
TEMP_RAMDISK="$TEMP_DIR/empty_ramdisk.cpio.gz"
EMPTY_DIR="$(mktemp -d)"
(cd "$EMPTY_DIR" && find . | cpio -o -H newc 2>/dev/null | gzip -9 > "$TEMP_RAMDISK")
rm -rf "$EMPTY_DIR"
RAMDISK_FILE="$TEMP_RAMDISK"

# Compact u-boot
gzip -kf "$UBOOT_BIN" -c > "u-boot-nodtb.bin.gz"
cat "u-boot-nodtb.bin.gz" "$DTB_PATH" > "$OUTPUT_KERNEL"

# Execute mkbootimg
mkbootimg \
    --header_version 0 \
    --kernel "$OUTPUT_KERNEL" \
    --ramdisk "$RAMDISK_FILE" \
    --pagesize 0x00000800 \
    --base 0x00000000 \
    --kernel_offset 0x10000000 \
    --ramdisk_offset 0x10000000 \
    --second_offset 0x10000000 \
    --tags_offset 0x10000000 \
    --board '' \
    --cmdline '' \
    -o "$OUTPUT_BOOT"

if [ -n "$TEMP_RAMDISK" ] && [ -f "$TEMP_RAMDISK" ]; then
    rm -rf "$(dirname "$TEMP_RAMDISK")" u-boot-nodtb.bin.gz u-boot-nodtb.bin.gz-dtb
fi

echo "Done!"
ls -lh "$OUTPUT_BOOT"
