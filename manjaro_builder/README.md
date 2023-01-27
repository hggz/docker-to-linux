Use this manjaro builder image to manjaro-chroot mount/imgdir into your images to debug and work with them.

### some useful commands
docker container run -it manjaro_custom /bin/bash

### verify os release:
#### INSPECT YOUR IMAGES for architecture
cat /etc/os-release

docker build --platform linux/amd64 -t manjaro_builder .
docker run -it --privileged -v `pwd`:/artifacts:rw manjaro_builder bash
mount -t auto -o loop,offset=$((2048*512)) artifacts/manjaro_x86_64 /mnt/img
### for iso mounts
mount -o loop /artifacts/manjaro-xfce-22.0.1-230124-linux61.iso /mnt/iso
manjaro-chroot /mnt/img

can be used to cat /boot/syslinux.cfg to add right /boot vmlinuz if you need to test

TODO setup ca certificates
### run script example
./run amd # or arm

### Note
for arm setup, if you cant get a bootable img to work, use the arm template to build out your system config 'installer' scripts, and use on the baseline generic manjaro ARM VM you got working through QEMU. Run your installer scripts on blank variants of that to verify it.
For x86_64 images, you should be able to run the same 'installer' script out of the box, and the image thats spat out will have it, optimizing the space needed instead of using a prebuilt image. This is the current work around non bootable arm images.

### Update
Purpose of this project: build installer scripts via docker.

NOTE - amd64 on arm64 will be almost unusable outside of base terminal. Stick to building + testing your arm64 images on arm machines (or if you get a powerful amd64 system with qemu-engine-aarch64 installed)  and amd64 images on amd64 machines

Approach should be:

- have base amd64 + arm64 vm images (after install)
- build minimal docker images to set up xfce + users + same default environment on their respective platforms
- create your 'install scripts' on docker and validate there, testing the gui and running the same 'docker run commands' as a script on the base vm's when testing. 
    - even consider caching the package cache from docker images to install directly on the base vm image
    - NOTE: docker is setup currently to generate amd64 images you can also test your package order on...consider testing it on there first and migrating the same deps to the arm one since generating the working arm images on docker doesnt work yet


## Dev Environment Considerations
- amd64 machine - develop purely amd64 on qemu
- macOS amd64 - develop purely amd64 on parallels
- macOS arm64 - develop purely arm64 on parallels

TODO: adapt manjaro-arm-installer script to here to see about getting working arm img's to test directly like the amd64 images. Close but no cigar. Perhaps missing UEFI / GRUB loader? Or proper boot sector partion
