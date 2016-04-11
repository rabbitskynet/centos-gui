#!/usr/bin/env bash
# 01. Установить Centos 7 Minimal
# 02. sudo yum update
# 03. sudo yum groupinstall "X Window System"
# 04. sudo yum install gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts
# 05. sudo yum install bzip2 kernel-devel gcc
# 06. sudo reboot
# 07. Подключаем образ дополнительной гостевой ОС
# 08. Монируем диск
# 09. Переходим каталог с диском
# 10. нужно найти каталог с ядром в /usr/src/kernels/ и сделать export KERN_DIR=/usr/src/kernels/3.10.0-327.13.1.el7.x86_64/
# 11. sudo ./VBoxLinuxAdditions.run
# 12. systemctl get-default graphical.target
# 13. sudo reboot

scr_name=$(realpath -s $0)
local=/etc/rc.d/rc.local
yum update -y
yum groupinstall -y "X Window System"
yum install -y gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts
yum install -y bzip2 kernel-devel gcc
res=$(grep $scr_name $local)
if [ "$res" ] ; then
	cp -v $local /tmp/rc.local.backup
	grep -v $scr_name $local > $local.new
	rm -v $local
	mv $local.new $local
	echo "complete installation"
	mkdir -v /tmp/cdrom
	mount /dev/cdrom /tmp/cdrom
	oldpath=$PWD
	cd /tmp/cdrom
	export KERN_DIR=/usr/src/kernerls/$(ls /usr/src/kernels/|sort|tail -n 1)
	echo "KERN_DIR" $KERN_DIR
	./VBoxLinuxAdditions.run << EOF
yes
EOF
	cd $oldpath
	systemctl set-default graphical.target
	umount /tmp/cdrom
	rm -rv /tmp/cdrom
else
	echo $scr_name >> $local
	chmod +x $local
	echo "reboot"
	reboot
fi;
