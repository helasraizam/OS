Installing Win 8, Ubuntu, and Arch in UEFI/GPT
==============================================

Countless times I've reinstalled Windows 8, Ubuntu and Arch, so I'm writing myself a little notes section on how I can repeat it.  This may not work for your hardware.  Obviously filesystem work carries the risk (read consequence) of losing all of your files; I make no guarantee of these instructions and take no responsibility for your actions.

Step 1: Install Windows 8
-------------------------

Days wasted tell me that the Windows installation disk I have doesn't even support UEFI.  So we install Windows in BIOS mode and then perform fs voodoo to convert it to a UEFI installation.

1. **Install Windows in Legacy Mode**: This one is easy; you have no choice.  Partitions can be created from within the installer itself.  I like to give 150G to the Windows partition.  The installation results in two legacy primary partitions; one 350 mb with offset 1024, and one installation partition ~150g.
2. **Convert to UEFI mode**: [This](http://social.technet.microsoft.com/wiki/contents/articles/14286.converting-windows-bios-installation-to-uefi.aspx) article from social.technet.microsoft.com wiki by [Crlos J S A](http://social.technet.microsoft.com/wiki/182951/ProfileUrlRedirect.ashx) helped immensely, but in case it ever goes down:
   1. Have the installation disk handy, boot into Win 8 and check that you are, indeed, in Legacy mode by running msinfo32.
   2. Open a terminal and run
   ``` diskpart
    list disk'''
   to find the name of the disk (corresponds to drive, not partition) with the Windows installation on it---if only using one drive, this is Disk 0.
   3. Download and unzip [gptgen](http://gptgen.sourceforge.net/), then run
   `gptgen.exe -w \\.\physicaldrive0
   replacing 0 with your drive, if need be.  **Be prepared for BSOD at this point.**
   4. Boot into installation disk and get to the command prompt:
   ` *Repair Your Computer > Troubleshoot > Advanced > Command Prompt
   5. Delete the MBR partition using diskpart:
   ` diskpart
   ` list disk
   Select the Windows directory drive:
   ` select disk 0
   ` list partition
   Select and delete the MBR partition (350 mb, 1024 kb offset, usually Partition 1):
   ` select partition 1
   ` delete partition
   6. Create the new partitions:
   ` create partition EFI size=100 offset=1
   ` format quick fs=fat32 label="System"
   ` assign letter=S
   ` create partition msr size=128 offset=103424
   7. Mount the Windows installation partition
   ` list volume
   Select the Windows installation volume (the larger one)
   ` select volume 3
   ` assign letter=C
   8. Exit and regenerate the boot partition data:
   ` exit
   ` bcdboot c:\windows /s s: /f UEFI

Troubleshooting
---------------

If at any time in Windows you want to know whether you're in UEFI mode, run msinfo32.
