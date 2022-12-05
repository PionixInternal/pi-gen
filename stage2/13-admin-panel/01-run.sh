#!/bin/bash
#(
#cd /tmp
#rm -rf /tmp/everest-admin-panel
#git clone git@github.com:EVerest/everest-admin-panel.git
#cd everest-admin-panel
#git pull
#npm install
#npm run build
# target directory is /var/www/html
rm ${ROOTFS_DIR}/var/www/html/*
cp files/index.html ${ROOTFS_DIR}/var/www/html
cp files/01-dirlisting.conf ${ROOTFS_DIR}/etc/lighttpd/conf-enabled
#)
on_chroot <<EOF
systemctl enable lighttpd.service
ln -s /tmp/logs /var/www/html/logs
EOF
