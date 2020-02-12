# Arch Linux Setup

Author: Merlin Unterfinger
Date: 2020-02-12

**Note:** There are many different ways to install and configure Arch Linux.
This installation sets the `en_DK.UTF-8` locale, which provides an English version
with continental European metrics (e.g. meters, euros, dd-mm-yyyy...).
Further it is initializing a Swiss keyboard layout and a fond that supports german
"Umlauts" (ä, ö and ü). This is just one possible ways of installing Arch,
feel free to adjust the steps accordingly ;)

## Get Arch Linux distro
Download the `.iso` file from [www.archlinux.org](https://www.archlinux.org/download/).
Make a bootable USB stick or if the installation is done using Virtual Box,
attach the `.iso` to the VM as optical drive.

## Boot Arch Linux from ISO
Start the system or VM and you should see the following screen:
(screenshot)

Select `Boot Arch Linux (x86_64)` and set the keymap for your keyboard:
``` bash
loadkeys de_CH-latin1
setfont lat9w-16
```

## Partition the disk
As next step the disk has to be partitioned. There are a variety of tools such as
`fdisk` or `cfdisk` to do this. Create a primary partition and a swap partition.
If desired, another partition can be created for `/home`.
The swap partition should be about the same size as the systems RAM.
``` bash
cfdisk
> create: sda1 83 Linux filesystem
> create: sda2 82 Linux swap
> create: sda3 83 Linux filesystem
> write and quit
```

## Format and mount partitions
The main partition and the home partition are formatted using `mkfs.ext4` and
the swap partition by `mkswap`. The command `swapon` makes the swap device available.
``` bash
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
```

Create a home folder and mount the partitions:
``` bash
mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda3 /mnt/home
```

Finally, check the results:
``` bash
lsblk /dev/sda
```

## Install Arch Linux
Adjust the mirrorlist for your location (in this example it is Switzerland,
replace it with your location):
``` bash
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
grep -E -A 1 ".*Switzerland.*$" /etc/pacman.d/mirrorlist.bak | sed '/--/d' > /etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist
```

Test the internet connection:
``` bash
ping -c3 www.archlinux.org
```

Install the arch base package, the linux kernel and some command line tools:
``` bash
pacstrap /mnt base base-devel linux linux-firmware vim bash-completion git
```

Generate the file system table (FSTAB: partition descriptor) with UUIDs:
``` bash
genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```


## Configure and initialize system
Change to root in the newly installed Arch Linux:
``` bash
arch-chroot /mnt/
```

Open the `loacle.gen` file and uncomment the locales that should be generated.
In this example `en_DK.UTF-8` is used as it generates an english locale with
continental European metrics.
``` bash
vim /etc/locale.gen
> uncomment: en_DK.UTF-8 UTF-8
> uncomment: en_DK ISO-8859-1
> write and quit: :wq
```

Now the locale can be generated:
``` bash
locale-gen
```

Next, create the language configuration file:
``` bash
echo LANG=en_DK.UTF-8 > /etc/locale.conf
export LANG=en_DK.UTF-8
```

Write the CH keyboard ti the configuration to be persistent:
``` bash
echo KEYMAP=de_CH-latin1 > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf
```

Set the timezone and synchronize the hardware clock with the system:
``` bash
ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime
hwclock --systohc --utc
```

## Install important packages
Intel processors install Intel-specific microcode:
``` bash
pacman -S intel-ucode
```

For AMD processors, install the `amd-ucode` package.

Ensure the internet connection after startup and install packages needed
for wireless connections:
``` bash
pacman -S dhcpcd
pacman -S wpa_supplicant netctl dialog
```

Set the hostname and hosts:
``` bash
echo archgis > /etc/hostname
vim /etc/hosts
> 127.0.0.1   localhost
> ::1         localhost
> 127.0.1.1   archgis.localdomain   archgis
> write and quit: :wq
```

## Add user with sudo permission
Set the root password:
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
> write and quit: :wq
```

## Bootloader

Configure GRUB as bootloader:
``` bash
pacman -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

Update all packages and exit `arch-chroot`:
``` bash
pacman -Syu
exit
```

Unmount the partitions:
``` bash
umount /mnt/home
umount /mnt
```

Finally, shut down the system:
``` bash
shutdown now
```

Remove the `.iso` USB stick or detach as optical drive in the VM and start
the system again.

## Restart and login as Root
The network has to be configured.
Therefore check the second entry:
``` bash
ip link
```

Depending on the name, which was identified above (mostly it is `enp0s3`),
configure the `enp0s3.network` file:
``` bash
vim /etc/systemd/network/enp0s3.network
> [Match]
> name=en*
> [Network]
> DHCP=yes
> write and quit: :wq
```

For help in this step check this [page](https://wiki.archlinux.org/index.php/Systemd-networkd).

Now restart the `networkd` system daemon that manages network configurations:
``` bash
systemctl restart systemd-networkd
systemctl enable systemd-networkd
```

Finally set a DNS nameserver, in this example from Google (or any alternative as for example 1.1.1.1):
``` bash
vim /etc/resolv.conf
> nameserver 8.8.8.8
> nameserver 8.8.4.4
> write and quit: :wq
```

## Desktop environment
Check the wiki and install the video driver suitable for your GPU (In my case Nvidia).
Install the video drivers before XOrg and Gnome to avoid bad bindings:
``` bash
pacman -S nvidia-utils lib32-nvidia-utils nvidia-settings
```

Install a display server (an alternative is wayland, which is used by default by Gnome):
``` bash
pacman -S xorg xorg-server
```

Install Gnome and enable it as desktop environment:
``` bash
pacman -S gnome gnome-extra
systemctl enable gdm
systemctl start gdm.service
```

## References

* ArchGIS: https://munterfinger/archgis
* Arch: https://archlinux.org
* Gnome: https://wiki.archlinux.org/index.php/GNOME
