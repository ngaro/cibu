GRUB2 Live ISO Multiboot
========================

This version: https://github.com/ngaro/bash_glim

Forked from:  https://github.com/thias/glim | https://glee.thias.es/GLIM


Overview
--------

GLIM is a tool to create a bootmedium (usually a USB stick) that can boot 
multiple ISO images from different operating systems, using GRUB2
as the bootloader. This is meant for users that don't want to carry around
multiple USB sticks, each with a different iso to run as live environments
(or install from), but instead want to have them all on a single USB stick.

Disadvantages :

 * There is no persistence overlay for distributions which normally support it.
 * Not all operating systems are supported/tested.

Screenshots
-----------

![Main Menu](https://github.com/ngaro/glim/raw/master/screenshots/GLIM-3.0-shot1.png)
![Ubuntu Submenu](https://github.com/ngaro/glim/raw/master/screenshots/GLIM-3.0-shot2.png)


Differences from the original GLIM (from thias)
--------------

* GLIM now supports ISO files >4GB through the use of a second partition.

* The ISO folder has been moved from `boot/iso/` to just `iso/`, so that it's 
easier to find, and also is in the same location whether you use one or two 
partitions.

* Added the `formatdisk.pl` script.


Installation
------------

* Run `./formatdisk.pl`. It will ask you which block device (disk / USB stick)
you want to use and will create the necessary partitions and filesystems.

* It will now have 3 partitions. Mount the first 2 partitions somewhere.
(Doesn't matter where)

* Run `./glim.sh` to actually install all necessary files

* Copy your iso files to the appropriate sub-directories in the `iso` folder.
Below are the `iso` sub-directories.
(note that unless mentioned they haven't been tested in this glim fork)

[//]: # (distro-list-start)

* [`almalinux`](https://almalinux.org/) - _Live Media only_
* [`antix`](https://antixlinux.com/)
* [`arch`](https://archlinux.org/)
* [`artix`](https://artixlinux.org/)
* [`bodhi`](https://www.bodhilinux.com/)
* [`calculate`](https://wiki.calculate-linux.org/desktop)
* ~~[`centos`](https://www.centos.org/)~~ - _Live was discontinued_
* [`clonezilla`](https://clonezilla.org/)
* [`debian`](https://www.debian.org/CD/live/) - _live & `mini.iso`_
* [`elementary`](https://elementary.io/)
* [`fedora`](https://fedoraproject.org/)
* [`finnix`](https://www.finnix.org/)
* [`gentoo`](https://www.gentoo.org/)
* [`gparted`](https://gparted.org/)
* [`grml`](https://grml.org/)
* [`ipxe`](https://ipxe.org/) - _.iso or .efi_
* [`kali`](https://www.kali.org/)
* [`kubuntu`](https://kubuntu.org/)
* [`libreelec`](https://libreelec.tv/)
* [`linuxmint`](https://linuxmint.com/)
* [`lubuntu`](https://lubuntu.me/)
* [`manjaro`](https://manjaro.org/)
* [`memtest`](https://memtest.org/) - _Only .bin/.efi, not .iso_
* [`mxlinux`](https://mxlinux.org/)
* [`netrunner`](https://www.netrunner.com/)
* [`nixos`](https://nixos.org/)
* [`openbsd`](https://www.openbsd.org/)
* [`opensuse`](https://www.opensuse.org/) - _Live from Alternative Downloads only_
* [`peppermint`](https://peppermintos.com/)
* [`popos`](https://pop.system76.com/)
* [`porteus`](http://www.porteus.org/)
* [`rhel`](https://www.redhat.com/rhel) - _Installation only_
* [`rockylinux`](https://rockylinux.org/)
* [`slitaz`](https://slitaz.org/)
* [`supergrub2disk`](https://www.supergrubdisk.org/)
* [`systemrescue`](https://www.system-rescue.org/)
* [`tails`](https://tails.net/)
* [`ubuntubudgie`](https://ubuntubudgie.org/)
* [`ubuntu`](https://ubuntu.com/)
* [`void`](https://voidlinux.org/)
* [`xubuntu`](https://xubuntu.org/)
* [`zorinos`](https://zorin.com/os/)

[//]: # (distro-list-end)

Any unpopulated directory will have the matching boot menu entry automatically
hidden, so to skip any distribution, just don't copy any files into it.

Download the right ISO image(s) to the matching directory. If you require
boot parameter tweaks, edit the appropriate `boot/grub2/inc-*.cfg` file.

Items order in the menu
-----------------------

Menu items for a distro are ordered by modification time of the iso files
starting from the most recent ones. If some iso files have the same mtime, their
menu items are ordered alphabetically.

Here is a generic idea how to keep it nicely ordered when you have multiple
releases of some distro:

- touch your **release** iso files with the release date
- touch your **point release** iso files with the original release date plus a
  day per point. This is a way to ensure point releases never pop above the next
  release like Debian 10.13.0 (released 10 Sep 2022) would still be below Debian
  11.0.0 (released 14 August 2021)
- in case there are multiple flavours of some iso but the version is the same,
  touch all of them with the same date for the whole group to be ordered
  alphabetically

Sample ordered menu:

|                                    | iso mtime               |
|------------------------------------|-------------------------|
| Debian Live 12.0.0 amd64 standard  | 10 June 2023            |
| Debian Live 11.7.0 amd64 gnome     | 14 August 2021 + 7 days |
| Debian Live 11.7.0 amd64 kde       | 14 August 2021 + 7 days |
| Debian Live 11.7.0 amd64 standard  | 14 August 2021 + 7 days |
| Debian Live 11.0.0 amd64 gnome     | 14 August 2021          |
| Debian Live 11.0.0 amd64 kde       | 14 August 2021          |
| Debian Live 11.0.0 amd64 standard  | 14 August 2021          |
| Debian Live 10.13.0 amd64 standard | 6 July 2019 + 13 days   |
| Debian Live 9.13.0 amd64 standard  | 17 June 2017 + 13 days  |

Special Cases
-------------

### iPXE

The `.iso` files don't work when booting using EFI, you simply need to use
`.efi` files instead.

### LibreELEC

LibreELEC isn't provided as ISO images, nor is it able to find the `KERNEL` and
`SYSTEM` files it needs anywhere else than at the root of a filesystem.
But it's useful to enable booting the installer by just copying both
files to the root of the USB memory stick.
Live booting is also supported, and the first launch will create a 512MB file
as /STORAGE.

### Memtest86+

The `.iso` file doesn't work. Use either the `.bin` or the `.efi` depending on
the boot mode used.

Testing
-------

With KVM it should "just work". The `/dev/sdx` device should be configured as
an IDE or SATA disk (for some reason, as USB disk didn't work for me on Fedora
17), that way you can easily and quickly test changes.
Make sure you unmount the disk from the host OS before you start the KVM
virtual machine that uses it.
For UEFI testing, you'll need to use one of the `/usr/share/edk2/ovmf/*.fd`
firmwares.


Contributing
------------

If you find GLIM useful but the configuration of the OS you require is missing
or simply outdated, please feel free to contribute! What you will need is to
create a GitHub pull request to the original repo of thias which includes :
 * All changes properly and fully tested.
 * New entries added similarly to the existing ones :
   * In alphabetical order.
   * With all possible variants supported (i.e. not just the one spin you want).
 * An original icon of high quality, and a shrunk 24x24 png version. Using
   `convert -size 24x24 -background 'rgba(0,0,0,0)' original.svg small.png`
   may work.
 * An updated supported directories list in this README file.
Pull requests for the actual code or this README can be send to this repo.

Credits
-------

* Matthias Saou http://matthias.saou.eu/
* Chris Handley https://github.com/cshandley-uk
* Eugene Sanivsky (eugenesan) https://github.com/eugenesan
* Nikolas Garofil https://github.com/ngaro

In this version of GLIM all files except 'grub2/themes/invader/background.png'
are licensed under GPLv3. See the LICENSE file for more details.
'grub2/themes/invader/background.png' is © 2008 payalnic (DeviantArt)
