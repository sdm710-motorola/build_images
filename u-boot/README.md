# U-Boot Image builder for docker
### Based on alpine 3.24.2

#### How to build (inside this image)
```bash
cd <path to u-boot src>
# Configure
make <configs>
# Build
make -j $(nproc)
# U-Boot is available in out/u-boot-nodtb.bin
# DTB is available in out/dts/upstream/src/<arch>/<soc_oem>/<device>.dtb
```

### How to make a boot.img(inside this image)
```bash
build_androidbootimage <path_to_u-boot-nodtb.bin> <path_to_dtb> <path_to_boot.img>
```