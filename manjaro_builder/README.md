Use this manjaro builder image to manjaro-chroot mount/imgdir into your images to debug and work with them.

# some useful commands
docker container run -it manjaro_custom /bin/bash

docker build --platform linux/amd64 -t manjaro_builder .
docker run -it --privileged -v `pwd`:/artifacts:rw manjaro_builder bash
mount -t auto -o loop,offset=$((2048*512)) artifacts/manjaro_x86_64 /mnt/img
manjaro-chroot /mnt/img

can be used to cat /boot/syslinux.cfg to add right /boot vmlinuz if you need to test

TODO setup ca certificates

