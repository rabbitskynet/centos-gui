#!/usr/bin/env bash
yum update
yum -y groupinstall "X Window System"
yum -y install gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts
yum install -y bzip2 kernel-devel gcc
mkdir -v /tmp/cdrom
mount /dev/cdrom /tmp/cdrom
cd /tmp/cdrom
export KERN_DIR=$(ls /usr/src/kernels/|sort|tail -n 1)
./VBoxLinuxAdditions.run
systemctl get-default graphical.target
rm -rv /tmp/cdrom
echo "now you should reboot system : sudo reboot"
