#### =======================================================================================
#### ==========================	INSTALAÇÃO GENTOO ==========================================
#### =======================================================================================
####
####	Este script possui 5 etapas (das quais 3 são manuais):
####	
####	1º - MANUAL 1   -  01 a 06 - PARTIÇÃO
####	2º - AUTO 1	-  07 a 09 - PREPARAÇÃO
####	3º - MANUAL 2	-  09 	   - CHROOT
####	4º - AUTO 2	-  10 a 29 - INSTALAÇÃO
####	5º - MANUAL 3	-  30 a 32 - FINALIZAÇÃO
####
#### =======================================================================================
#### ==========================	MANUAL 1 - PARTIÇÃO ========================================
#### =======================================================================================
####
#### ==========================	01 - TECLADO & GENTOO.SH
####
#### 	> 5					(br-a layout do teclado)
####	> wget https://raw.githubusercontent.com/andreguio/gentoo/main/gentoo.sh
####
#### ==========================	02 - FDISK
####
####	> blkid					(veja qual partição é o SSD)
####	> fdisk /dev/sda			(execute fdisk na partição SSD)
####	> g					(gere uma nova tabela GPT)
####
####	> n					(crie: /dev/sda1 - fat32 - efi)
####	> 1
####	> "enter"
####	> +1G
####	> "remove signature"
####	> t
####	> 1
####	> 1
####
####	> n					(crie: /dev/sda2 - swap)
####	> 2
####	> "enter"
####	> +4G
####	> "remove signature"
####	> t
####	> 2
####	> 19
####
####	> n					(crie: /dev/sda3 - ext4 - root)
####	> 3
####	> "enter"
####	> "enter"
####	> "remove signature"
####
####	> p					(confira a tabela criada)
####	> w					(escreva a tabela criada no disco)
####
#### ==========================	03 - FILESYSTEM
####
####	> mkfs.fat -F 32 /dev/sda1		(aplique fat32	ao /dev/sda1)
####	> mkswap /dev/sda2			(aplique swap	ao /dev/sda2)
####	> mkfs.ext4 /dev/sda3			(aplique ext4	ao /dev/sda3)
####
#### ==========================	04 - SWAP & ROOT
####
####	> swapon /dev/sda2			(ative	/dev/sda2)
####	> mkdir -p /mnt/gentoo			(crie	diretório root temporário)
####	> mount /dev/sda3 /mnt/gentoo		(monte	/dev/sda3)
####	> cp gentoo.sh /mnt/gentoo/		(leve o script para o /mnt/gentoo)
####	> cd /mnt/gentoo			(entre	no /mnt/gentoo)
####
#### ==========================	05 - DATA
####
####	> date 021008402024			(mes-dia-hora-min-ano)
####
#### ==========================	06 - AUTO 1
####
####	> chmod +x gentoo.sh
####	> ./gentoo.sh
####
#### =======================================================================================
#### ==========================	AUTO 1 - PREPARAÇÃO ========================================
#### =======================================================================================
####
#### ==========================	07 - TARBALL
####
links https://www.gentoo.org/downloads/
tar xpvf stage3.tar.xz --xattrs-include='*.*' --numeric-owner
####
#### ==========================	08 - CHROOT PREP
####
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
####
#### =======================================================================================
#### ==========================	MANUAL 2 - CHROOT ==========================================
#### =======================================================================================
####
#### ==========================	09 - CHROOT
####
####	> chroot /mnt/gentoo /bin/bash
####	> source /etc/profile
####
#### =======================================================================================
#### ==========================	AUTO 2 - INSTALAÇÃO ========================================
#### =======================================================================================
####
#### ==========================	10 - MAKE.CONF
####
#sed -i 's/COMMON_FLAGS="-O2 -pipe"/COMMON_FLAGS="-O2 -pipe -march=native"/' /etc/portage/make.conf
#echo '' >> /etc/portage/make.conf
#echo '# ------------------------- ADICIONADO -----------------------------------' >> /etc/portage/make.conf
#echo 'MAKEOPTS="-j7 -l7"' >> /etc/portage/make.conf
#echo 'VIDEO_CARDS="amdgpu radeonsi"' >> /etc/portage/make.conf
#echo 'ACCEPT_LICENSE="*"' >> /etc/portage/make.conf
#echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
#echo 'FEATURES="candy"' >> /etc/portage/make.conf
#echo 'USE="X xinerama -wayland -systemd elogind xfce -gnome -kde -plasma gtk3 -qt4 -qt5 -qt6 -motif -accessibility -wifi -bluetooth -dvd -cdda -cdr -ipod -scanner alsa -oss pulseaudio -pipewire -emacs -xemacs vaapi mesa opengl vulkan -nvidia -cuda -nvenc -intel"' >> /etc/portage/make.conf
####
#### ==========================	11 - REPOSITÓRIO
####
#mkdir -p /etc/portage/repos.conf
#cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
#emerge-webrsync
#emerge --sync
####
#### ==========================	12 - PROFILE
####
#eselect profile list
#eselect profile set 5
####
#### ==========================	13 - CPUFLAGS
####
#emerge app-portage/cpuid2cpuflags
#cpuid2cpuflags
#echo "*/* $(cpuid2cpuflags)" >> /etc/portage/package.use/00cpu-flags
####
#### ==========================	14 - UPGRADE
####
#emerge -uDN @world
####
#### ==========================	15 - TIMEZONE
####
#echo "Brazil/East" >> /etc/timezone
#emerge --config sys-libs/timezone-data
####
#### ==========================	16 - LOCALE
####
#echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
#locale-gen
#eselect locale list
#eselect locale set 4
#env-update
####
#### ==========================	17 - FIRMWARE
####
#emerge sys-kernel/linux-firmware
####
#### ==========================	18 - KERNEL
####
#echo ">=sys-kernel/installkernel-24 dracut" >> /etc/portage/package.use/gentoo-kernel
#emerge sys-kernel/gentoo-kernel
#eselect kernel list
#eselect kernel set 1
####
#### ==========================	19 - FSTAB
####
#echo "/dev/sda1		/efi		vfat		defaults	0 2" >> /etc/fstab
#echo "/dev/sda2		none		swap		sw		0 0" >> /etc/fstab
#echo "/dev/sda3		/		ext4		defaults,noatime		0 1" >> /etc/fstab
#echo "UUID=32282e92-bd2d-477c-9b14-e9282db3c8ec		/media/alzg/HD	ext4		defaults	0 0" >> /etc/fstab
#mkdir -p /media/alzg/HD
####
#### ==========================	20 - HOSTNAME
####
#echo "alzg-pc" >> /etc/hostname
####
#### ==========================	21 - INTERNET
####
#emerge net-misc/dhcpcd
#rc-update add dhcpcd default
#emerge --noreplace net-misc/netifrc
#echo 'config_enp4s0="dhcp"' >> /etc/conf.d/net
#ln -s /etc/init.d/net.lo /etc/init.d/net.enp4s0
#rc-update add net.enp4s0 default
####
#### ==========================	22 - HOST
####
#sed -i 's/127.0.0.1	localhost/127.0.0.1	alzg-pc localhost/' /etc/hosts
####
#### ==========================	23 - KEYMAP
####
#sed -i 's/keymap="us"/keymap="br-abnt2"/' /etc/conf.d/keymaps
####
#### ==========================	24 - HWCLOCK
####
####	(em branco, por enquanto)
####
#### ==========================	25 - OPENRC
####
####	(em branco, por enquanto)
####
#### ==========================	26 - SERVIÇOS
####
#emerge app-admin/sysklogd
#rc-update add sysklogd default
#emerge net-misc/chrony
#rc-update add chronyd default
#emerge sys-process/cronie
#rc-update add cronie default
#emerge sys-apps/mlocate
####
#### ==========================	27 - FILESYSTEM TOOLS
####
#emerge sys-fs/e2fsprogs
#emerge sys-fs/dosfstools
#emerge sys-fs/ntfs3g
####
#### ==========================	28 - MOUNT EFI
####
#mkdir /efi
#mount /dev/sda1 /efi
####
#### ==========================	29 - BOOTLOADER
####
#emerge sys-boot/grub
#echo ">=sys-boot/grub-2.06-r9 mount" >> /etc/portage/package.use/grub
#emerge sys-boot/os-prober
#grub-install --target=x86_64-efi --efi-directory=/efi
#grub-mkconfig -o /boot/grub/grub.cfg
#echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
####
#### =======================================================================================
#### ==========================	MANUAL 3 - FINALIZAÇÃO =====================================
#### =======================================================================================
####
#### ==========================	30 - SENHA
####
####	> passwd
####
#### ==========================	31 - UNCHROOT
####
####	> exit
####
#### ==========================	32 - UMOUNT
####
####	> cd
####	> umount -l /mnt/gentoo/dev{/shm,/pts,}
####	> umount -R /mnt/gentoo
####	> reboot
####