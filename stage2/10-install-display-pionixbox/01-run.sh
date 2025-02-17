#!/bin/bash -e

#install -m 755 files/install_update "${ROOTFS_DIR}/usr/bin"
install -m 644 files/display-app.service "${ROOTFS_DIR}/lib/systemd/system/"

# update font cache
on_chroot <<EOF
#apt install -y ttf-mscorefonts-installer
fc-cache
EOF

mkdir -p $WORK_DIR/pionixbox

(
cd $WORK_DIR/pionixbox
git clone https://github.com/ardera/flutter-engine-binaries-for-arm.git || true
cd flutter-engine-binaries-for-arm
git pull || true
#git checkout deaf44bacae971edfa1ffe84ba39874118a622cc
git checkout 917589cb12829cd58779af9b36a8114bca6c962b
#sudo ./install.sh: dont run this as it will install on the host OS!
ARM=arm
install ./$ARM/libflutter_engine.so.* ./$ARM/icudtl.dat ${ROOTFS_DIR}/usr/lib
install ./flutter_embedder.h ${ROOTFS_DIR}/usr/include
)

(
cd $WORK_DIR/pionixbox
git clone https://github.com/ardera/flutter-pi.git || true
cd flutter-pi
git pull || true
#git checkout a11107b95920861e4bb8f19c4e71cb870c3aa42e
git checkout 20483a1195c88bd44ff48be45582deb8cc3b1fb7
mkdir -p build && cd build
cmake ..
make -j8
DESTDIR=${ROOTFS_DIR} make install
)

(
 mkdir -p ${ROOTFS_DIR}/opt/displayapp
 cp -r files/flutter_assets/*  ${ROOTFS_DIR}/opt/displayapp
)

on_chroot <<EOF
systemctl enable display-app.service
EOF

