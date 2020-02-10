# ArchGIS

This repository contains instructions for installing Arch Linux and expanding it with the most common spatial libraries (GDAL, GEOS and PROJ) and tools (Python, R, Julia, JupyterLab, Docker and QGIS).

## Get Arch Linux
Download the `.iso` file from [www.archlinux.org](https://www.archlinux.org/download/). Make a bootable USB stick or if the installation is done using Virtual Box, attach the `.iso` to the VM as optical drive.

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

Now the disk has to be partitioned. There are a variety of tools such as `fdisk` or `cfdisk` to do this. Create a primary partition and a swap partition. If desired, another partition can be created for `/home`. The swap partition should be about the same size as the systems RAM.

``` bash
cfdisk
> create: sda1 83 Linux filesystem
> create: sda2 82 Linux swap
> create: sda3 83 Linux filesystem
```

Write & Quit.

## Formatting
The main partition and the home partition are formatted using `mkfs.ext4` and the swap partition by `mkswap`. The command `swapon` makes the swap device available.
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

## Installation of Arch Linux
Adjust mirrorlist (for in this example for Switzerland, replace with your location):
``` bash
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
grep -E -A 1 ".*Switzerland.*$" /etc/pacman.d/mirrorlist.bak | sed '/--/d' > /etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist
```

Check network access:
``` bash
ping -c3 www.archlinux.org
```

Install arch base package, kernel and some commandline tools:
``` bash
pacstrap /mnt base base-devel linux linux-firmware vim bash-completion git
```

Generate FSTAB (partition descriptor) with UUID:
``` bash
genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```


## Configure/Initialize system

Change to root in new system:
``` bash
arch-chroot /mnt/
```

Open the loacle.gen file and uncomment the locales that should be generated. In this example en_DK.UTF-8 as it generates an english locale with continental European metrics.

``` bash
vim /etc/locale.gen
> uncomment: en_DK.UTF-8 UTF-8
> uncomment: en_DK ISO-8859-1
```

Generate locale:
``` bash
locale-gen
```

Create language configuration file:
``` bash
echo LANG=en_DK.UTF-8 > /etc/locale.conf
export LANG=en_DK.UTF-8
```

Set CH keyboard configuration to persist between sessions:
``` bash
echo KEYMAP=de_CH-latin1 > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf
```

Set timezone and synchronize the hardware clock with the system:
``` bash
ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime
hwclock --systohc --utc
```

## Installing packages
Intelspecific microcode:
``` bash
pacman -S intel-ucode
```

Ensure internet connection after startup and install packages needed for wireless connections:
``` bash
pacman -S dhcpcd
pacman -S wpa_supplicant netctl dialog
```

Set hostname and hosts:
``` bash
echo archgis > /etc/hostname
vim /etc/hosts
> 127.0.0.1   localhost
> ::1         localhost
> 127.0.1.1   archgis.localdomain   archgis
```

## Create user with sudo permission
Set root password:
``` bash
passwd
```

Create a new user and add important groups:
``` bash
useradd -m mufix
passwd mufix
usermod -a -G wheel,audio,video,optical,storage,power mufix
```

Enable `sudo` for the wheel group:
``` bash
visudo
> uncomment: %wheel ALL=(ALL) ALL
```


## Bootloader and shutdown system

Configure GRUB as bootloader:
``` bash
pacman -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

Update all packages and exit arch-chroot:
``` bash
pacman -Syu
exit
```

Unmount partitions:
``` bash
umount /mnt/home
umount /mnt
```

Reboot:
``` bash
shutdown now
```

Remove the `.iso` USB stick or detach as optical drive in the VM and start the system again.

## Restart and login as Root
Configure the network has to be configured. Check the second entry:
``` bash
ip link
```

Depending on the name, which was identified above, configure the `enp0s3.network` file:
``` bash
vim /etc/systemd/network/enp0s3.network
> [Match]
> name=en*
> [Network]
> DHCP=yes
```

Restart networkd:
``` bash
systemctl restart systemd-networkd
systemctl enable systemd-networkd
```

Set the DNS nameserver from Google (or an alternative...):
``` bash
vim /etc/resolv.conf
> nameserver 8.8.8.8
> nameserver 8.8.4.4
```

## Desktop

GPU driver: Check the wiki and install video driver suitable for your GPU: In my case nvidia...
Install video drivers before XOrg and Gnome to avoid bad bindings:
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

## Install ArchGIS
Clone the repo and run the installer script:
``` bash
git clone https://github.com/munterfinger/archgis.git
cd archgis
sudo ./install_archgis.sh
```
This will take a few minutes: Time for a coffee :)

![](/docs/install_archgis.png)


## Update ArchGIS
To update ArchGIS including the R, Python and  Julia packages run the updater script:
``` bash
sudo ./update_archgis.sh
```

## References

* Arch: www.archlinux.org
* Gnome: https://wiki.archlinux.org/index.php/GNOME
