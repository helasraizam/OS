Win 8, Ubuntu, and Arch in UEFI/GPT
===================================

Countless times I've reinstalled Windows 8, Ubuntu and Arch, so I'm writing myself a little notes section on how I can repeat it.  This may not work for your hardware.  Obviously filesystem work carries the risk (read consequence) of losing all of your files; I make no guarantee of these instructions and take no responsibility for your actions.

Step 1: Install Windows 8
-------------------------

Days wasted tell me that the Windows installation disk I have doesn't even support UEFI.  So we install Windows in BIOS mode and then perform fs voodoo to convert it to a UEFI installation.

1. **Install Windows in Legacy Mode**: This one is easy; you have no choice.  Partitions can be created from within the installer itself.  I like to give 150G to the Windows partition.  The installation results in two legacy primary partitions; one 350 mb with offset 1024, and one installation partition ~150g.
2. **Convert to UEFI mode**: [This](http://social.technet.microsoft.com/wiki/contents/articles/14286.converting-windows-bios-installation-to-uefi.aspx) article from social.technet.microsoft.com wiki by [Crlos J S A](http://social.technet.microsoft.com/wiki/182951/ProfileUrlRedirect.ashx) helped immensely, but in case it ever goes down:
    1. Have the installation disk handy, boot into Win 8 and check that you are, indeed, in Legacy mode by running msinfo32.
   	2. Open a terminal and run
   	   ```
		diskpart
		list disk
		```
   		to find the name of the disk (corresponds to drive, not partition) with the Windows installation on it---if only using one drive, this is Disk 0.
	
	3. Download and unzip [gptgen](http://gptgen.sourceforge.net/), then run
   	   ```
   	   gptgen.exe -w \\.\physicaldrive0
   	   ```
   	   replacing 0 with your drive, if need be.  **Be prepared for BSOD at this point.**
	4. Boot into installation disk and get to the command prompt:
		> *Repair Your Computer > Troubleshoot > Advanced > Command Prompt*
   
	5. Delete the MBR partition using diskpart:
   	    ```
		diskpart
   		list disk
   		```
		Select the Windows directory drive:
   		```
   		select disk 0
   		list partition
   		```
   		Select and delete the MBR partition (350 mb, 1024 kb offset, usually Partition 1):
   		```
   		select partition 1
   		delete partition
   		```

   	6. Create the new partitions:
   	   ```
		create partition EFI size=100 offset=1
   		format quick fs=fat32 label="System"
   		assign letter=S
   		create partition msr size=128 offset=103424
    	```
   	7. Mount the Windows installation partition
   	   ```
   	   list volume
   	   ```
   	   Select the Windows installation volume (the larger one)
   	   ```
   	   select volume 3
   	   assign letter=C
   	   ```
   
	8. Exit and regenerate the boot partition data:
   	   ```
   	   exit
   	   bcdboot c:\windows /s s: /f UEFI
   	   ```
	   
3. **Update Windows to 8.1** to avoid overwriting grub later.
    1. Upgrade to Windows 8.1 by going to the store and downloading it.  It will install and update automatically, rebooting in the process. [~2.5 hrs]
	2. Upgrade Windows and sync steam library and configs.
	    1. Install and sync firefox, emacs, gimp, flash, java, vlc, libreoffice, dropbox, [etc.].
		2. Check all settings in menu.
		3. Install steam and nvidia, upgrade and download overnight.
	
4. **Configure Windows** for dual booting with Linux
    1. [Disable fast boot](https://sites.google.com/site/easylinuxtipsproject/windows); go to
	     *Control Panel > Power Options > Choose what the power buttons do*,
		 click `settings that are currently unavailable`, and remove `Turn on fast startup (recommended)`.
	2. Disable secureboot through the BIOS
		 
	3. [Set Windows HW clock to UTC](Set Windows to ) using regedit; change
	    ```
		HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation\RealTimeIsUniversal
		```
		to a DWORD of hexadecimal value 1.

4. **Resize the Windows partition** from within Windows itself to avoid shifting unmoveable files.
   1. Open up `diskmgmt.msc` and use it to cut down the Windows partition.
   2. Use defrag to move files around to make this more productive.
   3. If all else fails, you can try reinstalling Win8 onto a pre-partitioned drive, or just force the partition resize from linux at a risk (try the latter before the former).

Step 2: Abandon Ubuntu and Install Arch
---------------------------------------
I've figured out pretty much everything on Ubuntu on Arch and haven't touched it since, and the Ubuntu USB won't boot anyway, so we'll go straight to Arch.  Suffice it to say if you already have an Ubuntu installation, installing Arch from that is simpler than through USB.  The rest of this section covers the [Arch Beginner's Guide](https://wiki.archlinux.org/index.php/Beginners%27_guide#Prepare_the_latest_installation_medium) in less detail, so you're better off following that.
1. Prepare the Arch medium
    1. [Download](https://www.archlinux.org/download/) a copy of the arch distribution you want.  Download to the same folder and from the same source the gpg key (*.iso.sig).
	2. After both files are downloaded, check that the gpg key of the iso downloaded from the mirror matches the central archlinux gpg key with
	```
	gpg --verify [*].iso.sig
	```
	after adding the author's signature with
	```
	gpg --recv-keys [key id from gpg --very output]
	```
	3. Prepare the USB to be sacrificed and unmount it, run `lsblk` to make sure you know its name (/dev/sd*).  Now, copy the iso onto the USB with `dd` and `sync`.  Note: Don't put /dev/sdb1, just /dev/sdb.
	```
	sudo dd if=archlinux-[*].iso of=/dev/sd* bs=4M && sync
	```
	Note that there is no output, be patient.

	4. Boot the USB key with the appropriate BIOS settings (UEFI ON).  ***There are two entries for the USB, and one of them is UEFI (the one that you wouldn't choose first).  Make sure you're booted with EFI enabled by checking that `/sys/firmware/efi/efivars` exists.***

2. Install Arch from USB.

   1. Run
   ```
   modprobe efivarfs
   ```
   
   2. Then set up an internet connection using standard methods (eg, wifi-menu)

   3. Ensure clock accuracy:
   ```
   timedatectl set-ntp true
   ```

   4. Set up the partitions, including swap, /, and possibly home, using parted or fdisk.

   5. `mkfs.ext4` and `mkswap`->`swapon` the appropriate partitions, then mount root:
   ```
   mount /dev/sd?? /mnt
   ```

   6. Mount the EFI System directory on /mnt/boot:
   ```
   mkdir -p /mnt/boot
   mount /dev/sd?? /mnt/boot
   ```

   7. Choose a mirror:
   ```
   nano /etc/pacman.d/mirrorlist
   ```

   8. Install base and some other things (Note: if installing on an EFI with a previous Arch installation, remove /mnt/boot/vmlinuz-linux):
   ```
   pacstrap -i /mnt base base-devel iw wpa_supplicant dialog
   ```
   This is a good step to leave overnight.

   9. Save fstab with
   ```
   genfstab -U /mnt > /mnt/etc/fstab
   ```

   10. Finally, chroot into the system with
   ```
   arch-chroot /mnt /bin/bash
   ```

3. Making it bootable
   1. Now,
   ```
   mount -t efivarfs efivarfs /sys/firmware/efi/efivars
   ```

   2. Set regional settings by editing `/etc/locale.gen`, then generate with `locale-gen`.  Finally,
   ```
   echo LANG=en_US.UTF-8 > /etc/locale.conf
   ```

   3. Set the timezone with
   ```
   ln -sf /usr/share/zoneinfo/*Zone*/*Subzone* /etc/localtime
   ```
   from `/usr/share/zoneinfo`, then run
   ```
   hwclock --systohc --utc
   ```

   4. Create your hostname and `>` it to `/etc/hostname`, likewise updating `/etc/hosts` for both entries (IP.IP.IP.IP [myhostname].localdomain [myhostname]).

   5. Set the root password with `passwd`

   6. Configure a bootloader (grub)
   ```
   pacman -S grub efibootmgr os-prober
   grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck
   grub-mkconfig -o /boot/efi/EFI/GRUB/grub.cfg
   ```
   (Note: this didn't work this time, had to run
   ```
   grub-install --efi-directory=/boot --bootloader-id=[id] --recheck /dev/sda
   grub-mkconfig -o /boot/grub/grub.cfg
   ```
   )
   When W10 inevitable overwrites grub, I got a "no space left on disk" error or "ioctl invalid" or something, for which I had to run
   ```
   grub-install --efi-directory=/boot --bootloader-id=[id] --target=x86_64-efi --removable
   ```
   as per some internet thread I'll link if I find.

   Note: Turns out kernel updates are installed to /boot, so it's probably a good idea to set /boot as the mount point?  This means mounting /dev/sda1 (esp partition) to /boot directly, rather than /boot/efi (which would require copying the initramfs and vmlinuz files over to /boot/efi from /boot whenever there is a kernel update).  See [this](https://bbs.archlinux.org/viewtopic.php?id=178358) helpfule thread.

   7. Crossing fingers, reboot!

4. Configure

   1. Add a user
   ```
   groupadd {ssh,wireshark,tty}
   useradd -mG sys,disk,lp,wheel,uucp,http,video,audio,optical,storage,scanner,power,users,ssh,tty,lock,printadmin,wireshark [username]
   ```

   2. Install yaourt

   3. Install some things
   ```
   yaourt --noconfirm -S xorg-server i3 i3-gaps-git libreoffice emacs vlc firefox pipelight wireshark-qt thunar rxvt-unicode transmission-qt reflector wget tree  gimp xsane youtube-dl zip ttf-amiri ttf-computer-modern-fonts ttf-dejavu ttf-droid ttf-freefarsi ttf-freefont ttf-iran-nastaliq ttf-liberation ttf-mathtype ttf-ms-win8 ttf-irfonts ttf-borna ttf-x2 ttf-qurancomplex-fonts ttf-sil-scheherazade tor tor-browser-en texlive-fontsextra texlive-bibtextra texlive-humanities texlive-latexextra texlive-langextra texlive-science texlive-biblatexextra sudo spotify sshfs skype smbclient sagemath python2-yaml python2-scipy python2-pillow python2-notify python2-numpy python2-crypto python2-beautifulsoup4 python2-astropy python-yaml python-urllib3 python-scipy python-rsa python-requests python-pyqt4 python-pyqt5 python-pygame python-pillow python-openpyxl python-numpy python-moviepy python-matplotlib python-httplib2 python-google-api-python-client python-beautifulsoup4 alsa-plugins archey arduino ardour baobab cheese colordiff cups diffpdf djvulibre dropbox dropbox-cli emacs-lyqi-mode-git emacs-python-mode espeak evince feedthebeast feh file-roller gnuplot google-chrome google-talkplugin gparted xte hplip-plugin htop imagemagick irssi ix libdvdcss lsof maim mathjax me_quran mediterraneannight-theme minecraft mlocate mlterm mumble ntfs-3g openssh pulseaudio pkgfile xorg-utils alsa-utils
    ```
	
    4. Set up keyboard/X shortcuts
	```
	sudo localectl set-x11-keymap us,ir,fr "grp:shifts_toggle,terminate:ctrl_alt_bksp"
	```

Step 2: Install Ubuntu
----------------------
1. **Partition the hard drive** using an Ubuntu livedisk made with `dd if=ubuntu-14.10-desktop-amd64.iso of=/dev/sdb1 bs=512` with the obvious replacements, leaving the first four Win8 partitions be, to Ubuntu (~150g), its swap (~10g), the files (~150g), the Arch swap (~10g), and Arch (~150g).  Any recovery partitions, etc can also be added.  Everything but Windows should be ext4/swap.
2. **Install Ubuntu** with grub.  [This](http://askubuntu.com/questions/221835/installing-ubuntu-on-a-pre-installed-windows-8-64-bit-system-uefi-supported) is a particularly insightful article covering the obstacles and solutions when it comes to uefi.
3. **Upgrade Ubuntu** by enabling and introducing the proper repositories, updating, and downloading a few select apps.
4. **Update configs** (to be added)
5. **Delete grub** files on the second partition and *do not reboot* without installing Arch and its grub.

Step 3: Install Arch
--------------------
1. Still in the Ubuntu installation, install arch over arch-chroot from the provided tar.gz
    1. Make sure to mount /boot; Arch will keep Windows files.
2. Reboot when ready into Arch, complete installation, then [upgrade configs](Arch/ArchConfig.sh).
3. Cross fingers and reboot into newly installed system!


Troubleshooting
---------------

If at any time in Windows you want to know whether you're in UEFI mode, run msinfo32.
