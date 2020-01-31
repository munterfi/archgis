# ArchGIS

## Get Arch Linux
Download the .iso file from [www.archlinux.org](https://www.archlinux.org/download/). Make a bootable USB stick or attach the iso to the VMs as optical drive.

## Boot Arch from ISO

Start the system or VM and you should see the following screen:
(screenshot)

Select "Boot Arch Linux (x86_64)"
Then set the keymap for your keyboard:

``` bash
loadkeys de_CH-latin1
setfont lat9w-16
```

## Partition the disk

Now the disk has to be partitioned. There are a variety of tools such as ´fdisk´ or ´cfdisk´ to do this. Create a primary partition and a swap partition. If desired, another partition can be created for home.

``` bash
cfdisk
```
Create:

* sda1 83
* sda2 82
* sda3 83

Write & Quit.

## Formatting
``` bash
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
```

## Mount partitions for pacstrap and generate fstab
Create home folder and mount partitions:
``` bash
mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda3 /mnt/home
```

Check results:
``` bash
lsblk /dev/sda
```

# Installation of Arch Linux
Adjust mirrorlist (for Switzerland):
``` bash
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
grep -E -A 1 ".*Switzerland.*$" /etc/pacman.d/mirrorlist.bak | sed '/--/d' > /etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist
```

Check Network:
``` bash
ping -c3 www.archlinux.org
```

Install arch base package, kernel some tools:
``` bash
pacstrap /mnt base base-devel linux linux-firmware vim bash-completion git
```

Generate FSTAB with UUID (partition descriptor):
``` bash
genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```


## Configure/Initialize system

Change to root in new system:
``` bash
arch-chroot /mnt/
```


## Configure and generate locale
``` bash
vim /etc/locale.gen

and uncomment:
``` bash
> #en_DK.UTF-8 UTF-8
> #en_DK ISO-8859-1
```

Generate locale:
``` bash
locale-gen
```

Create language configuration file
``` bash
echo LANG=en_DK.UTF-8 > /etc/locale.conf
export LANG=en_DK.UTF-8
```

Set CH keyboard configs to persist between sessions
``` bash
echo KEYMAP=de_CH-latin1 > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf
```

Set timezone and synchronize the hardware clock with the system
``` bash
ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime
hwclock --systohc --utc
```

## Installing packages
Intelspecific microcode:
``` bash
pacman -S intel-ucode

Ensure internet connection after startup
``` bash
pacman -S dhcpcd
```

and for wireless:
``` bash
pacman -S wpa_supplicant netctl dialog
```

Set hostname and hosts
``` bash
echo archgis > /etc/hostname
vim /etc/hosts
> 127.0.0.1   localhost
> ::1         localhost
> 127.0.1.1   archgis.localdomain   archgis
```


##  Root password and user
``` bash
passwd
```

Add user:
``` bash
useradd -m mufix
passwd mufix
usermod -a -G wheel,audio,video,optical,storage,power mufix
visudo
> uncomment: %wheel ALL=(ALL) ALL
```


## Configure GRUB bootloader
``` bash
pacman -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```


## Update all and exit arch-chroot
``` bash
pacman -Syu
exit
```

Unmount partitions:
``` bash
umount /mnt/home
umount /mnt
```

## Reboot
``` bash
reboot / shutdown now
```
Remove ISO

## Restart and login as Root
Configure the network first
Check the second entry:
``` bash
ip link
```

``` bash
vim /etc/systemd/network/enp0s3.network
> [Match]
> name=en*
> [Network]
> DHCP=yes
```

``` bash
systemctl restart systemd-networkd
systemctl enable systemd-networkd
```

Set the DNS nameserver from Google (Alternatives?):

``` bash
vim /etc/resolv.conf
> nameserver 8.8.8.8
> nameserver 8.8.4.4
```

## Desktop

GPU driver:
check the wiki and install video driver suitable for your GPU: In my case nvidia
Install video drivers before XOrg and Gnome to avoid bad bindings
``` bash
pacman -S nvidia-utils lib32-nvidia-utils nvidia-settings
```

Install display server:
``` bash
pacman -S xorg xorg-server
```


Install Gnome:
``` bash
pacman -S gnome gnome-extra
systemctl enable gdm
systemctl start gdm.service
```

