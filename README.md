Cross-ISO Boot Utility
======================

_This software is forked from https://github.com/thias/glim and includes many changes._


Overview
--------

CiBu is a tool to create a boot medium _(usually a USB stick)_ that can boot
multiple ISO images from different operating systems. This is meant for everyone who doesn't want to carry around
a different USB stick for every iso they want to boot from.

If you found this repo, you probably already found [Ventoy](https://www.ventoy.net/en/index.html) too.<br>
It's undeniable that Ventoy is a tool with way more features.<br>
But... **Ventoy has [well documented concerns](https://en.wikipedia.org/wiki/Ventoy#Concerns_over_software_security_and_validity_of_open_source_claim) about its security and the validity of its open-source claims !**<br>
Because of this it's usage is often forbidden in environments where security is an important factor.<br>
CiBu, on the other hand, is completely open and has source code that is easy to read and well documented.<br>
The only blobs inside are the images _(which you can replace if you want)_.

Screenshots
-----------

The main menu (listing all detected distros with their logos):
![Main Menu](https://github.com/ngaro/cibu/raw/perldev/screenshots/mainscreen.png)
The submenu for Mint (listing all detected Mint ISOs):
![Mint Submenu](https://github.com/ngaro/cibu/raw/perldev/screenshots/mintsubmenu.png)
Editing booting parameters before booting (you only see this if you press 'e' while on an entry, otherwise it just boots with the default parameters)
![Mint Edit](https://github.com/ngaro/glim/cibu/perldev/screenshots/mintedit.png)


Differences from [GLIM](https://github.com/thias/glim)
--------------

* The partition layout is different to support ISO files > 4GB

* The ISO folder has been moved from `boot/iso/` on the first to just `isos/` on the second partition

* Partitioning is done for you.

* Some questions and checks have been removed; others have been added

* The code has been rewritten in (well-documented) Perl.

* The "do-whatever-you-want" licensing has been changed to ensure forks must grant the same rights to everyone.

Installation
------------

* Make sure you have `sudo` and `perl` on your system. _(Most popular Linux distros have them preinstalled)._

* Clone this repo, run `./cibu`, and answer the questions.<br>
CiBu uses some external tools to build the stick, so it will check for their presence.<br>
If you are missing any _(you probably won't)_, install them.<br>
Your distribution's package manager will almost certainly provide them.

Usage
-----

Copy your ISO files to the appropriate subdirectories in the `isos/` folder on the second partition of the USB stick.<br>
If the ISO for the distro you want to add doesn't have a subdir yet, it is not supported.

Note that many ISO files are not yet tested in CiBu even if they have a subdir. But if they work in GLIM, they will probably also work here.<br>
In the file [TESTED.md](TESTED.md) you can find a list of tested ISO filey will also work here.

If you require boot-parameter tweaks, edit the appropriate `boot/grub2/inc-<distroname>_.cfg`
file on the first partition.<br>
_(It is also possible to do this at runtime by pressing 'e' while on an entry)_

Menu items for a distro are ordered by the modification time of the ISO files.<br>
If you want to reorder them, use `touch` on all the files in that subdir in the order that you want them to be listed.

Special Cases
-------------

_This list of special cases comes from the original repo; I haven't tested whether these are stil valid_

### iPXE

The `.iso` files don't work when booting using EFI; use `.efi` files instead.

### LibreELEC

LibreELEC isn't provided as ISO images, and it can only find the KERNEL and SYSTEM files at the root of a filesystem.
But it's useful to enable booting the installer by just copying both
files to the root of the USB memory stick.
Live booting is also supported, and the first launch will create a 512MB file
as /STORAGE.

### Memtest86+

The `.iso` file doesn't work. Use either the `.bin` or the `.efi` depending on
the boot mode used.

Testing
-------

Instead of immediately using it (and possibly breaking your system) it's possible to test it in a virtual machine.<br>
What I do is create a Linux VM in VirtualBox and give it a extra drive and pretend that that drive is the USB stick.

Contributing
------------

Ways to contribute to CiBu and improve it for everyone:
 * Test ISO files and send a PR with the updated [TESTED.md](TESTED.md) file.
 _(Also report ISO files that cause issues)_
 * Send PRs with `inc-distroname.cfg` files for distros that are not yet supported,
 or with tweaks for distros that fail. If possible, also add a picture of the distro's logo in high quality and a version that is shrunk with something like `convert -size 24x24 -background 'rgba(0,0,0,0)' original.svg small.png`
 * Send PRs that improve the inc-distroname.cfg files, the Perl script, or this README.md, ...

Make sure to test everything properly before sending a PR.
You might also want send a PR to [the GLIM repo](https://github.com/thias/glim), on which this software is based on, if it adds or improves an `inc-distroname.cfg` file.

Credits
-------

* Matthias Saou http://matthias.saou.eu/
* Chris Handley https://github.com/cshandley-uk
* Eugene Sanivsky (eugenesan) https://github.com/eugenesan
* Nikolas Garofil https://github.com/ngaro

Legal stuff
-----------

The file `grub2/themes/invader/background.png` is © 2008 payalnic (DeviantArt).<br>
All other files are licensed under GPLv3.
See the `LICENSE` file for all details.
