#### ======================================================================================
#### ====================================== GENTOO ========================================
#### ======================================================================================
####
####	ESTE SCRIPT SOH PODE SER UTILIZADO APOS A MONTAGEM:
####	> mount /dev/sda3 /mnt/gentoo
####
####	ALEM DISSO, ESTE SCRIPT DEVE SER BAIXADO NA PASTA:
####	/mnt/gentoo
####
####
#### =================================== AUTOMATICO 1 =====================================
####
#### ============= DATE
####
#date 020314372024
####
#### ============= TARBALL
####
#wget https://distfiles.gentoo.org/releases/amd64/autobuilds/20240204T134829Z/stage3-amd64-desktop-openrc-20240204T134829Z.tar.xz -O /mnt/gentoo/stage3.tar.xz
#tar xpvf /mnt/gentoo/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo/
####
#### ============= MAKE.CONF 1 (gcc, features, makeopts)
####
#sed -i 's/COMMON_FLAGS="-O2 -pipe"/COMMON_FLAGS="-O2 -pipe -march=native"/' /mnt/gentoo/etc/portage/make.conf
#echo 'FEATURES="candy"' >> /mnt/gentoo/etc/portage/make.conf
#echo 'MAKEOPTS="-j7 -l7"' >> /mnt/gentoo/etc/portage/make.conf
####
#### ============= DNS & MONTAGEM
####
#cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
#mount --types proc /proc /mnt/gentoo/proc
#mount --rbind /sys /mnt/gentoo/sys
#mount --make-rslave /mnt/gentoo/sys
#mount --rbind /dev /mnt/gentoo/dev
#mount --make-rslave /mnt/gentoo/dev
#mount --bind /run /mnt/gentoo/run
#mount --make-slave /mnt/gentoo/run
#### ======================================== MANUAL =====================================
####
#### ============= CHROOT
####
#chroot /mnt/gentoo /bin/bash
#source /etc/profile
#export PS1="(chroot) ${PS1}"
#### =================================== AUTOMATICO 2 =====================================
#### ============= EFI
####
#mkdir /efi
#mount /dev/sda1 /efi
####
#### ============= REPO
####
#mkdir -p /etc/portage/repos.conf
#cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
#emerge-webrsync
#emerge --sync
####
#### ============= PROFILE
####
#eselect profile list
#eselect profile set 5
####
#### ============= MAKE.CONF 2 (use, video_card)
####
#echo 'USE="X -wayland -systemd elogind xfce -gnome -kde gtk3 -qt4 -motif -dvd -ipod alsa -oss pulseaudio -pipewire mesa opengl vulkan -nvidia -intel"' >> /mnt/gentoo/etc/portage/make.conf
#echo 'VIDEO_CARDS="amdgpu radeonsi"' >> /mnt/gentoo/etc/portage/make.conf
####
#### ============= PACKAGE.USE 1 (cpu)
####
#emerge app-portage/cpuid2cpuflags
#cpuid2cpuflags
#echo "*/* $(cpuid2cpuflags)" >> /etc/portage/package.use/00cpu-flags
####
#### ============= MAKE.CONF 3 (license)
####
#echo 'ACCEPT_LICENSE="*"' >> /mnt/gentoo/etc/portage/make.conf
####
#### ============= UPGRADE
####
#emerge --verbose --update --deep --newuse @world
####
#### ============= TIMEZONE
####
#echo "Brazil/East" >> /etc/timezone
#emerge --config sys-libs/timezone-data
####
#### ============= LOCALE
####
#echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
#locale-gen
#eselect locale list
#### =================== A SELECAO TEM Q SER MANUAL PQ EU NAO SEI O NUMERO =================
#eselect locale set <NUMERO_LOCALE_pt_BR.UTF-8>
#env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
####
#### ============= FIRMWARES
####
#emerge sys-kernel/linux-firmware
####
#### ============= KERNEL
####
#echo ">=sys-kernel/installkernel-24 dracut" >> /etc/portage/package.use/gentoo-kernel-bin
#emerge sys-kernel/gentoo-kernel-bin
#eselect kernel list
#eselect kernel set 1
####
#### ============= FSTAB
####
#echo "/dev/sda1		/efi		vfat		defaults	0 2" >> /etc/fstab
#echo "/dev/sda2		none		swap		sw		0 0" >> /etc/fstab
#echo "/dev/sda3		/		ext4		defaults,noatime		0 1" >> /etc/fstab
#echo "UUID=32282e92-bd2d-477c-9b14-e9282db3c8ec		/media/alzg/HD	ext4		defaults	0 0" >> /etc/fstab
####
#### ============= HOSTNAME
####
#echo "alzg-pc" > /etc/hostname
####
#### ============= INTERNET
####
#emerge net-misc/dhcpcd
#rc-update add dhcpcd default
#emerge --noreplace net-misc/netifrc
#echo 'config_enp4s0="dhcp"' >> /etc/conf.d/net
#### =================== ABAIXO TEM QUE SER MANUAL PQ NAO SEI COMO FAZER ==================
#cd /etc/init.d
#ln -s net.lo net.enp4s0
#rc-update add net.enp4s0 default
####
#### ============= HOSTS
####
#sed -i 's/127.0.0.1	localhost/127.0.0.1	alzg-pc localhost/' /etc/hosts
#### =================== ABAIXO TEM QUE SER MANUAL PQ NAO SEI COMO FAZER ==================
#passwd
#sed -i 's/keymap="us"/keymap="br-abnt2"/' /etc/conf.d/keymaps
####
#### ============= TOOLS
####
#emerge app-admin/sysklogd
#rc-update add sysklogd default
#emerge sys-apps/mlocate
#emerge net-misc/chrony
#rc-update add chronyd default
#emerge sys-fs/e2fsprogs
#emerge sys-fs/dosfstools
####
#### ============= BOOTLOADER
####
#echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
#emerge sys-boot/grub
#grub-install --target=x86_64-efi --efi-directory=/efi
#grub-mkconfig -o /boot/grub/grub.cfg
####
#### ============= REBOOT
####
#exit
#cd
#umount -l /mnt/gentoo/dev{/shm,/pts,}
#umount -R /mnt/gentoo
#reboot