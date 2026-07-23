- In general iso's working in GLIM will also work here. These are only the ones that were actually tested on CIBU. Feel free to report it when an iso works for you
- You might sometimes see a iso here that was marked "Failed" being replaced by a slightly newer version marked "Pass". This means that CIBU was updated in such a way that both the newer and the older version of that iso are fixed.
- An error in a change in the code might cause isos to fail in newer versions. If you need them urgently, use the Version-column to see in which CIBU version the last test was a success


**ISO's that FAIL**:
| Distro | First tested version | Last tested version | Last tested ISO | Result | Version | Tester | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| EndeavourOS | 2026.03.06 | 2026.03.06 | `EndeavourOS_Titan-2026.03.06.iso` | Fail | v0.2.2 | Briella Bugs | Kernel Panics, report at https://briellabugs.com/panic/eos2026 |

**ISO's that WORK**:
| Distro | First tested version | Last tested version | Last tested ISO | Result | Version | Tester | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Arch Linux x86_64 | 2026.04.01 | 2026.04.01 | `archlinux-2026.04.01-x86_64.iso` | Pass | v0.2.2 | Briella Bugs | No issues found |
| Debian Live  amd64 kde | 13.2.0 | 13.2.0 | `debian-live-13.2.0-amd64-kde.iso` | Pass | v0.2.2 | Briella Bugs | No issues found |
| Debian Live amd64 standard | 13.3.0 | 13.3.0 | `debian-live-13.3.0-amd64-standard.iso` | Pass | v0.1.0 | Nikolas Garofil | No issues found |
| Debian Netinst amd64 | 13.4.0 | 13.4.0 |`debian-13.4.0-amd64-netinst.iso` | Pass | v0.1.0 | Nikolas Garofil | Provides all it's boot options |
| Kali Live amd64 | 2026.1  | 2026.1 | `kali-linux-2026.1-live-amd64.iso` | Pass | v0.1.0 | Nikolas Garofil | Both regular and forensic mode are tested |
| EndeavourOS | 2025.3.19 | 2025.03.19 | `EndeavourOS_Mercury-Neo-2025.03.19.iso` | Pass | v0.2.2 | Briella Bugs | No issues found |
| LMDE amd64 | 7 | 7 |`lmde-7-cinnamon-64bit.iso` | Pass | v0.1.0 | Nikolas Garofil | No issues found |
| Linux Mint Cinnamon amd64 | 22.3 | 22.3 | `linuxmint-22.3-cinnamon-64bit.iso` | Pass | v0.1.0 | Nikolas Garofil | No issues found |
| Linux Mint XFCE amd64 | 22.3 | 22.3 | `linuxmint-22.3-xfce-64bit.iso` | Pass | v0.2.2 | Nikolas Garofil | No issues found |
| MX Linux AHS amd64 | 25.1 | 25.1 | `MX-25.1_Xfce_ahs_x64.iso` | Pass | v0.2.2 | Nikolas Garofil | Before v0.2.2 this didn't work |
| NixOS amd64 minimal | 25.11 | 25.11 | `nixos-minimal-25.11.8107.1073dad219cb-x86_64-linux.iso` | Pass | v0.1.0 | Nikolas Garofil | No issues found |
| NixOS amd64 graphical | 25.11 | 25.11 | `nixos-graphical-25.11.8107.1073dad219cb-x86_64-linux.iso` | Pass | v0.1.0 | Nikolas Garofil | Both Gnome and Plasma are tested |
| SystemRescue amd64 | 13.0 | 13.0 | `systemrescue-13.00-amd64.iso` | Pass | v0.2.2 | Nikolas Garofil | Before v0.2.2 this didn't work |
| Tails amd64 | 6.14.1 | 6.14.1 | `tails-amd64-6.14.1.iso` | Pass | v0.1.0 | Nikolas Garofil | No issues found |
| Tails amd64 | 7.0 | 7.0 |`tails-amd64-7.0.iso` | Pass | v0.1.0 | Nikolas Garofil | No issues found |
| Ubuntu Live Server amd64 | 24.0.4 | 24.0.4 | `ubuntu-24.04.4-live-server-amd64.iso` | Pass | v0.1.0 | Nikolas Garofil | No issues found |
