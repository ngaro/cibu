# Tested ISO's

- In general iso's working in GLIM will also work here. These are only the ones that were actually tested on CIBU. Feel free to report it when an iso works for you
- If a ISO that fails has been fixed in a newer version of CIBU then it will be removed in the "Failing"-list

## Failing ISO's

| Distro | First tested version | Last tested version | Last tested ISO | Version | Tester | Notes |
| --- | --- | --- |  --- | --- | --- | --- |
| NixOS amd64 minimal | 26.05 | 26.05 | `nixos-minimal-26.05.5591.fd1462031fde-x86_64-linux.iso` | v0.2.2 | Nikolas Garofil | See _Notes_ |
| NixOS amd64 graphical | 26.05 | 26.05 | `nixos-graphical-26.05.5591.fd1462031fde-x86_64-linux.iso` | v0.2.2 | Nikolas Garofil | See _Notes_ |

### Notes:
- About NixOS:
  - 25.11 and older _do_ work _(both graphical and minimal)_.
  - I am working on a solution. My current _(not yet pushed)_ solution for 26.05 can boot the kernel, load initrd, start systemd stage 1 but hangs when trying to mount the iso on `/sysroot`. More info later...
  - If you just use the iso to install NixOS and not as a Live-system, you can use the (ugly) hack of installing 25.11 and upgrading

## Working ISO's

| Distro | First tested version | Last tested version | Last tested ISO | Version | Tester | Notes |
| --- | --- | --- |  --- | --- | --- | --- |
| Antix | 23.2 | 23.2 | `antiX-23.2-net_x64-net.iso` | v0.2.5 | Nikolas Garofil | No issues found |
| Antix runit | 23.2 | 23.2 | `antiX-23.2-runit-net_x64-net.iso` | v0.2.5 | Nikolas Garofil | No issues found |
| Arch Linux | 2026.04.01 | 2026.07.01 | `archlinux-2026.07.01-x86_64.iso` | v0.2.2 | Briella Bugs | No issues found |
| Artix dinit | 20260402 | 20260402 | `artix-base-dinit-20260402-x86_64.iso` | v0.2.5 | Nikolas Garofil | No issues found |
| Artix openrc | 20260402 | 20260402 | `artix-base-openrc-20260402-x86_64.iso` | v0.2.5 | Nikolas Garofil | No issues found |
| Artix runit | 20260402 | 20260402 | `artix-base-runit-20260402-x86_64.iso` | v0.2.5 | Nikolas Garofil | No issues found |
| CachyOS Desktop | 2026.06.28 | 2026.06.28 | `cachyos-desktop-260628.iso` | v0.2.4 | Nikolas Garofil | No issues found |
| CachyOS Handheld | 2026.06.28 | 2026.06.28 | `cachyos-handheld-260628.iso` | v0.2.4 | Nikolas Garofil | No issues found |
| Debian Live amd64 kde | 13.2.0 | 13.6.0 | `debian-live-13.6.0-amd64-kde.iso` | v0.2.2 | Briella Bugs | No issues found |
| Debian Live amd64 standard | 13.3.0 | 13.6.0 | `debian-live-13.6.0-amd64-standard.iso` | v0.2.2 | Nikolas Garofil | No issues found |
| Debian Netinst amd64 | 13.4.0 | 13.6.0 |`debian-13.6.0-amd64-netinst.iso` | v0.2.2 | Nikolas Garofil | Provides all it's boot options |
| EndeavourOS | 2025.3.19 | 2026.4.27 | `EndeavourOS_Titan-2026.04.27.iso` | v0.2.3 | Nikolas Garofil | No issues found |
| Fedora | 44.1.7 | 44.1.7 | `Fedora-Everything-netinst-44-1.7.iso` | v0.2.5 | Nikolas Garofil | No issues found |
| Fedora Immutable | 44.1.7 | 44.1.7 | `Fedora-Silverblue-ostree-x86_64-44.1.7.iso` | v0.2.5 | Nikolas Garofil | No issues found |
| Gparted | 1.8.0 | 1.8.0 | `gparted-live-1.8.0-2-amd64.iso` | v0.2.5 | Nikolas Garofil | No issues found |
| Kali Live amd64 | 2026.1  | 2026.2 | `kali-linux-2026.2-live-amd64.iso` | v0.2.2 | Nikolas Garofil | Both regular and forensic mode are tested |
| KDE neon | 20260723  | 20260723 | `neon-user-desktop-20260723-0523.iso` | v0.2.5 | Nikolas Garofil | No issues found |
| Linux Mint Cinnamon amd64 | 22.3 | 22.3 | `linuxmint-22.3-cinnamon-64bit.iso` | v0.1.0 | Nikolas Garofil | No issues found |
| Linux Mint XFCE amd64 | 22.3 | 22.3 | `linuxmint-22.3-xfce-64bit.iso` | v0.2.2 | Nikolas Garofil | No issues found |
| LMDE amd64 | 7 | 7 |`lmde-7-cinnamon-64bit.iso` | v0.1.0 | Nikolas Garofil | No issues found |
| MX Linux AHS amd64 | 25.1 | 25.2 | `MX-25.2_Xfce_ahs_x64.iso` | v0.2.2 | Nikolas Garofil | Before v0.2.2 this didn't work |
| NixOS amd64 graphical | 25.11 | 25.11 | `nixos-graphical-25.11.8107.1073dad219cb-x86_64-linux.iso` | v0.1.0 | Nikolas Garofil | Both Gnome and Plasma are tested |
| NixOS amd64 minimal | 25.11 | 25.11 | `nixos-minimal-25.11.8107.1073dad219cb-x86_64-linux.iso` | v0.1.0 | Nikolas Garofil | No issues found |
| SystemRescue amd64 | 13.0 | 13.01 | `systemrescue-13.01-amd64.iso` | v0.2.2 | Nikolas Garofil | Before v0.2.2 this didn't work |
| Tails amd64 | 6.14.1 | 7.10 | `tails-amd64-7.10.iso` | v0.2.2 | Nikolas Garofil | No issues found |
| Ubuntu Live Server amd64 | 24.04.4 | 26.04  | `ubuntu-26.04-live-server-amd64.iso` | v0.2.2 | Nikolas Garofil | No issues found |
