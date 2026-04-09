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

This is meant as replacement for [Ventoy](https://www.ventoy.net/en/index.html). Although Ventoy has way more features,
it can not be trusted and there are [valid concerns about it being malware](https://en.wikipedia.org/wiki/Ventoy#Concerns_over_software_security_and_validity_of_open_source_claim).
GLIM on the other hand is completely open and IMHO this version has source that
is easy to read and well documented. The only blob's inside are the images
(that you can replace if you want)

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

* Partitioning is done for you.

* Code is rewritten in perl, well documented.

* Some options I consider useless have been removed, other tiny improvements
have been added.


Installation
------------

* Make sure you have sudo and perl on your system.
(If you don't know, you probably do).

* Insert the USB-stick you want to use

* Run `./glim.pl` and just answer all questions.
It uses some external tools and will check their existence.
If you are missing some of them (You probably won't) install them.
The package manager of your distro will almost certainly have them.

Usage
-----

Copy your iso files to the appropriate sub-directories in the `iso` folder
on the the 2nd partition of the USB stick. If the iso of the distro you want to
add doesn't have a subdir yet, that means it's not supported yet.

Note that many iso's are not tested yet in this fork even if they have a subdir.
In the file [TESTED.md](TESTED.md) you can find a list of tested iso's.

If you require boot parameter tweaks, edit the appropriate `boot/grub2/inc-*.cfg`
file on the 1st partition.

Menu items for a distro are ordered by modification time of the iso files.
If you want to reorder them, just use `touch` to change the mtime's

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

Instead of immediately using it (and possibly breaking your system) you can test
it in a virtual machine. What I do is create a Linux VM in VirtualBox and give
it a extra drive and pretend that that drive is the USB stick.

Contributing
------------

Things you can do to contribute to GLIM and make it better for everyone:
 * Test more iso's and send a PR to the report the results in the [TESTED.md](TESTED.md) file.
 (Also report iso's that cause issues)
 * Send PR's with inc-*.cfg files for distros that are not supported yet,
 or with tweaks for distros that seem to fail
 * Send PR's with improvement for this README or the code itself

Just make sure to test everything properly before sending a PR.
Pull requests for the actual code or this README can be send to this repo.

Credits
-------

* Matthias Saou http://matthias.saou.eu/
* Chris Handley https://github.com/cshandley-uk
* Eugene Sanivsky (eugenesan) https://github.com/eugenesan
* Nikolas Garofil https://github.com/ngaro

Legal stuff
-----------

The file 'grub2/themes/invader/background.png' is © 2008 payalnic (DeviantArt)
In this version of GLIM all other files aree licensed under GPLv3.
See the LICENSE file for more details.
