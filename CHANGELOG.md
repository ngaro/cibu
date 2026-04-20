# CIDU Change Log
All notable changes to this project will be documented in this file
- Versioning uses the `x.y.z` format, where:
  - `x` jumps to 1 when I have 5 known testers and from that point on only when a new feature breaks compatibility with previous versions
  - `y` increases with new features. As long as there no 5 testers compatibility breaking features will update `y` and not `x`
  - `z` increases with bug fixes

## Version 0.2.2 - Date of release: 2026-04-20 epoch time 1776720663
### Bug fixes

- Fixes issue https://github.com/ngaro/cibu/issues/3 _(ISOS that depend on the $rootuuid variable now work correctly)_

## Version 0.2.1 - Date of release: 2026-04-20 epoch time 1776707817
### Bug fixes

- Fixes issue https://github.com/ngaro/cibu/issues/2 _(CIBU no longer errors out but just warns with "strange" block devices and allows the user to force their usage )_

## Version 0.2.0 - Date of release: 2026-04-17 epoch time 1776432123
### Features

- Shows more info about the found devices to help users choose.
- Makes it possible to upgrade/reinstall CIDU without wiping the ISOS-partition (forcing you to manually copy all your iso's back).

## Version 0.1.0 - Date of release: 2026-04-14 epoch time 1776196058
### Changes

- Added file `CHANGELOG.md`
- Changed `grub2/inc-debian.cfg` to support Debian Netinst images
- Changed screenshots of GLIM to those of CIDU
- Acknowledged the authors of GLIM and added a `LICENSE` file with the GNU General Public License v3.0
- Added a `TESTED.md` file with a list of tested isos and some info
- Rewrote `README.md` only keeping the "Special Cases" section
- Added a mention of the version (on the 2nd line of `grub2/grub.cfg`)
- Removed `glim.sh` and took the main ideas to rewrite into `cidu`. Main changes:
  - Perl instead of shell to make it easier to maintain and add features
  - Code is split into lots of separate well-documented functions
  - Hardcoding is avoided as much as possible
  - More interactive with advice when questions are asked
  - Show lots of info about what is actually happening
  - Checks for all necessary tools before starting the real work
  - Setting up the partitions and filesystems instead of letting the user do it manually
  - Block devices that already contain CIDU are detected and marked as such
  - 2 partitions instead of one are created
  - The 1st one is almost identical to the one GLIM creates, but the label is GLIMSYS and the dir 'isos' has been removed
  - The 2nd one is an ext4 with the label ISOS and now has the dir 'isos' that used be in the first partition
  - Because of ext4 large iso's ( > 4GB ) are now also supported
  - Inner workings of the script are different, but the end result is reasonably similar to a device created with GLIM

# Features that I plan to add in the future
- Add support for booting Windows installer iso's
- Add support for exFAT to make it possible to add iso's from more operating systems (like Windows) that only support ext4 with 3rd party software
- Make it possible to boot iso's on systems with secure boot enabled
- Make sure there can't be any dependency problems by adding a Nix flake and/or Docker image
- Let github build a zip file for each new version
- Add support for more isos
- Find a large testaudience
