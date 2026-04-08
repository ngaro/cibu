#!/usr/bin/env perl
#This script used to be bash, we keep it in a PoD to refer to it later.
#PoD's starting with '### REWRITTEN ###' are already rewritten in perl below.
#PoD's starting with '### TO REWRITE ###' are still in bash, and need to be rewritten in perl.

use strict; use warnings; use v5.30;

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

sub find_available_disks {
  my @disks = `lsblk -o name -lpn --nodeps -e7`;
  chomp @disks;
  return @disks;
}

sub choose_disk {
    my @options = ("Cancel", find_available_disks());
    print << 'END';
Choose the number of a blockdevice to overwrite. Choose option 0 to cancel.
You can also enter the full path. This is useful if you want to use a disk image file instead of a physical block device.
If you use a file, make sure it exists and is large enough to hold the partitions that will be created.
END
    for(my $i=0; $i<@options; $i++) {
      say "[$i] $options[$i]";
    }
    print "Choose a optionnumber or enter a path: "; my $answer = <STDIN>; chomp $answer;
    if($answer =~ /^\s*0\s*$/) {
        say "Script cancelled by user."; exit(1);
    } elsif($answer =~ /^\s*(\d+)\s*$/ && exists $options[$1]) {
        return $options[$1];
    } elsif($answer =~ /^\s*(\S.*?)\s*$/ && -f $1 or -b $1) {
        return $1;
    } else {
        myerror "Invalid input. Please enter a valid number or path to a (existing) file or block device.";
    }
}

sub check_if_mounted {
    my $disk = shift;
    my @partitions = `lsblk -o mountpoint -n $disk`;
    foreach(@partitions) {
        chomp;
        myerror "$disk has one or more partitions that are still mounted. (I already found a partition mounted at '$_').\nPlease unmount all partitions on the disk before running this script." unless $_ =~ /^\s*$/;
    }
}

sub diskinfo_and_confirmation {
    my $disk = shift;
    say "You have chosen to overwrite '$disk'. Here is some more info about it (found with 'fdisk -l $disk'):";
    system("fdisk -l $disk");
    ask_for_confirmation("\nIf you are sure you have chosen the correct disk, then please enter 'yes' to confirm and continue, otherwise enter 'no' to cancel: ");
}

sub find_partitions_on_disk {
    my $disk = shift;
    my $fdisk_output = `fdisk -l $disk 2>/dev/null`;
    my @partitions;
    foreach(split("\n", $fdisk_output)) {
        if(/^\s*($disk\d+)\s+/) {
            push @partitions, $1;
        }
    }
    return \@partitions;
}

sub wipe_and_create_table {
    my $disk = shift;
    my $partitions = find_partitions_on_disk($disk);
    say "Wiping '$disk' and creating a new GPT partition table on it...";
    foreach(@$partitions) {
        mysystem("dd if=/dev/zero of=$_ bs=512 count=1024 conv=fsync"); #Wipe the first 512k of each partition, to make sure the old filesystem is gone.
    }
    mysystem("sgdisk --zap-all $disk");   #Remove the partition table
    mysystem("sgdisk --mbrtogpt $disk");  #Create a new GPT partition table
    mysystem("partprobe $disk && sleep 3"); # Tell the OS about the new partition table, before we create the partitions
    say "$disk has been wiped and a new GPT partition table has been created on it.";
}

sub create_partitions {
    my $disk = shift;
    my $glim_size = "100M";
    say "Creating the 3 partitions on '$disk' needed by GLIM.";
    say "The 1st partition will be used for GLIM and will have a size of $glim_size, the 2nd partition for the iso files and the 3rd partition will be used as the BIOS Boot partition by GRUB.";
    mysystem("sgdisk --new=1:0:+$glim_size $disk"); # Create the first partition, starting at the beginning of the disk, and using the specified size
    mysystem("sgdisk --new=3:-1M:0 --typecode=3:ef02 --partition-guid=3:21686148-6449-6E6F-744E-656564454649 $disk"); # Create the third partition, starting at the end of the disk, and using the specified size.
    #The 3rd partition will be used as the BIOS Boot partition by GRUB, so we have to make sure to use 21686148-6449-6E6F-744E-656564454649 as special GUID and typecode ef02 to indicate it's a BIOS Boot partition.
    mysystem("sgdisk --new=2:0:0 $disk"); # Create the second partition, using the remaining space on the disk.
    mysystem("partprobe $disk && sleep 3"); #Tell the OS about the new partitions, before we format them
    say "The 3 partitions needed by GLIM have been created on '$disk'.";
}

sub name_and_format_partitions {
    my $disk = shift;
    say "Naming and formatting the partitions on '$disk'.";
    say "The first partition will be named 'GLIM' and formatted as FAT32, the second partition will be named 'GLIMISO' and formatted as ext4, and the third partition will be named 'BIOS Boot' and left unformatted.";
    mysystem("sgdisk --change-name=1:GLIM $disk");
    mysystem("sgdisk --change-name=2:GLIMISO $disk");
    mysystem("sgdisk --change-name=3:'BIOS Boot' $disk");
    mysystem("partprobe $disk && sleep 3"); #Tell the OS about the new partition names, before we format them
    say "Naming the partions on '$disk' is done. Now formatting the partitions...";
    mysystem("mkfs.fat -F 32 -n GLIM ${disk}1"); # Format the first partition as FAT32, and set its label to 'GLIM'
    mysystem("mkfs.ext4 -L GLIMISO ${disk}2"); # Format the second partition as ext4, and set its label to 'GLIMISO'
    mysystem("partprobe $disk && sleep 3"); #Tell the OS about the new partition formats, before we continue
    say "The partitions on '$disk' have been named and formatted.";
}

showdisclaimer();
ask_for_confirmation("If you have read, understood & fully accepted the above, then please enter 'yes' otherwise enter 'no' to cancel: ");
check_root();
say ""; check_available_programs(qw/lsblk fdisk sgdisk partprobe mkfs.fat mkfs.ext4/);
say ""; my $disk = choose_disk();
check_if_mounted($disk) if -b $disk; # Only check if it's a block device, not if it's a file
say ""; diskinfo_and_confirmation($disk);
say ""; wipe_and_create_table($disk);
say ""; create_partitions($disk);
say ""; name_and_format_partitions($disk);
say "\nSuccesfully finished preparing '$disk' for GLIM installation";
