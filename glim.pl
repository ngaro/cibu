#!/usr/bin/env perl
#This script used to be bash, we keep it in a PoD to refer to it later.
#PoD's starting with '### REWRITTEN ###' are already rewritten in perl below.
#PoD's starting with '### TO REWRITE ###' are still in bash, and need to be rewritten in perl.

use strict; use warnings; use v5.30;
use FindBin;

sub myerror {
  say "ERROR: @_";
  exit(1);
}

sub mysystem {
  say "Running: @_";
  system(@_) == 0 or myerror "Command '@_' failed with exit code $?";
}

sub check_available_programs {
  say "Checking for required programs...";
  foreach(@_) {
    my $path = `which $_ 2>/dev/null`;
    #If the output the return code is 0 and the output is a path print it
    if($? == 0 && $path =~ /^\/.*$_$/) {
      print "Found required program '$_' at path: $path";
    } else {
      myerror "Required program '$_' not found in your \$PATH. Please install it and make sure it's available in your \$PATH before running this script.";
    }
  }
  say "All required programs are available.";
}

sub showdisclaimer {
    print << 'END';

This script will format a chosen empty block device (USB-stick, disk, ...) or disk image file with GLIM's recommended set-up.
Although I've tried to be careful, a bug could potentially wipe your whole computer !  So make sure you have a recent backup before executing this script !
Please read the 'README.md' documentation before using this script.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

END
}

sub ask_for_confirmation {
    my $defaultmessage = "Enter 'yes' to confirm or 'no' to cancel: ";
    my $message = $defaultmessage;
    $message = shift if @_;
    print $message;
    if(<STDIN> !~ /^\s*y(es)?\s*$/i) {
      say "Script cancelled by user.";
      exit(1);
    }
}

sub check_root {
  if($> != 0) {
      myerror "This script must be run as root. Please run it with 'sudo' or as root user.";
  }
}

sub grub_grub2_choice {
    say "Checking for grub or grub2";
    my $grubversion = {};
    my $path = `which grub2-install 2>/dev/null`;
    if($? == 0 && $path =~ /^\/.*grub2-install$/) {
      say "Found grub2-install";
      $grubversion->{installer} = 'grub2-install';
      $grubversion->{configdir} = 'grub2';
      return $grubversion;
    } else {
        $path = `which grub-install 2>/dev/null`;
        if($? == 0 && $path =~ /^\/.*grub-install$/) {
          say "Found 'grub-install'";
          $grubversion->{installer} = 'grub-install';
          $grubversion->{configdir} = 'grub';
          return $grubversion;
        } else {
          myerror "'grub2-install' or grub-install commands not found.";
        }
    }
}

sub find_and_check_grub_dir {
    my $grubconfigdir = $FindBin::Bin . '/grub2';
    return $grubconfigdir if -d $grubconfigdir && -f "$grubconfigdir/grub.cfg";
    myerror "grub.cfg not found.";
}

sub umount {
    my @devices = @_;
    say "Checking if any of the following devices are mounted and unmounting them if they are: @devices";
    my $mountoutput = `mount`;
    if($? != 0) {
      myerror "Failed to get mount output.";
    }
    my $mounts = {};
    foreach(split("\n", $mountoutput)) {
      if(/^\s*(\S+)\s+on\s+(\S+)/) {
        if(exists $mounts->{$1}) {
          push @{$mounts->{$1}}, $2;
        } else {
          $mounts->{$1} = [$2];
        }
      }
    }
    foreach my $dev (@devices) {
      if(exists $mounts->{$dev}) {
        foreach my $mnt (@{$mounts->{$dev}}) {
          say "Unmounting $dev from $mnt";
          mysystem("umount", $mnt);
        }
      }
    }
    say "All specified devices have been unmounted if they were mounted.";
}

sub mount {
    my @devices = @_;
    my $mounts= {};
    say "Mounting devices: @devices";
    foreach my $dev (@devices) {
      my $dir = `mktemp -d`;
      myerror "Failed to create temporary directory for mounting $dev" if $? != 0;
      say "Mounting $dev on temporary directory $dir";
      mysystem("mount $dev $dir");
      $mounts->{$dev} = $dir;
    }
}

sub check_bios_efi_support {
  my $support = {};
  $support->{BIOS} = 1 if( -d '/usr/lib/grub/i386-pc');
  $support->{EFI} = 1 if( -d '/usr/lib/grub/x86_64-efi');
  if(keys(%$support) == 0) {
    myerror "Neither support for BIOS or EFI was found in your grub";
  }
  if(exists $support->{BIOS}) {
    say "Grub BIOS support found.";
  } else {
    say "WARNING: no /usr/lib/grub/i386-pc dir. Skipping Grub BIOS support";
  }
  if(exists $support->{EFI}) {
    say "Grub EFI support found.";
  } else {
    say "WARNING: no /usr/lib/grub/x86_64-efi dir. Skipping Grub EFI support";
  }
  return $support;
}

sub install_grub {
  my ($grubinstaller, $support, $part1mountpoint, $usbdev) = @_;
  if(exists $support->{BIOS}) {
    say "Installing GRUB for BIOS boot mode...";
    mysystem("$grubinstaller --target=i386-pc --boot-directory '$part1mountpoint/boot' $usbdev");
    say "GRUB installed for BIOS boot mode.";
  }
  if(exists $support->{EFI}) {
    say "Installing GRUB for EFI boot mode...";
    mysystem("$grubinstaller --target=x86_64-efi --removable --no-nvram --efi-directory '$part1mountpoint' --boot-directory '$part1mountpoint/boot' $usbdev");
    say "GRUB installed for EFI boot mode.";
  }
}

sub copy_grub_config {
  my ($fromdir, $todir) = @_;
  say "Copying GRUB configuration to the USB device...";
  mysystem("rsync -rt --delete --exclude=i386-pc --exclude=x86_64-efi --exclude=fonts -- $fromdir/ $todir/");
  say "GRUB configuration copied.";
}

sub create_iso_dirs {
  my ($isomnt, $grubconfigdir) = @_;
  say "Creating the directory layout for the partition for ISO files...";
  for my $distroconfig (glob("$grubconfigdir/*")) {
    $distroconfig =~ /^.*\/inc-(\S+)\.cfg$/ or next;
    mysystem("mkdir -p '$isomnt/iso/$1'");
  }
  say "Directory layout for ISO files created.";
}

showdisclaimer();
ask_for_confirmation("If you have read, understood & fully accepted the above, then please enter 'yes' otherwise enter 'no' to cancel: ");
check_root();
say ""; check_available_programs(qw(mount mktemp rsync mount umount mkdir));
say ""; my $grubversion = grub_grub2_choice();
say ""; my $grubconfigdir = find_and_check_grub_dir();
my $usbdev = '/dev/sdb'; #TODO receive this from the previous script
my $part1 = '/dev/sdb1'; #TODO receive this from the previous script
my $part2 = '/dev/sdb2'; #TODO receive this from the previous script
my $part3 = '/dev/sdb3'; #TODO receive this from the previous script
my $BiosBoot = '21686148-6449-6e6f-744e-656564454649'; #TODO receive this from the previous script
my $NumOfPartitionsExpected = 3;
say ""; umount($part1, $part2);
say ""; my $mounts = mount($part1, $part2);
say ""; my $support = check_bios_efi_support();
say ""; install_grub($grubversion->{installer}, $support, $mounts->{$part1}, $usbdev);
say ""; copy_grub_config($grubconfigdir, "$mounts->{$part1}/boot/$grubversion->{configdir}");
say ""; create_iso_dirs($mounts->{$part2}, $grubconfigdir);
