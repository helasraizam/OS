Installing Win 8, Ubuntu, and Arch in UEFI/GPT
==============================================

Countless times I've reinstalled Windows 8, Ubuntu and Arch, so I'm writing myself a little notes section on how I can repeat it.  This may not work for your hardware.

Step 1: Install Windows 8
-------------------------

Days wasted tell me that the Windows installation disk I have doesn't even support UEFI.  So we install Windows in BIOS mode and then perform fs voodoo to convert it to a UEFI installation.

1. **Install Windows in Legacy Mode**: This one is easy; you have no choice.  Partitions can be created from within the installer itself.  I like to give 150G to the Windows partition.  The installation results in two legacy primary partitions; one 350 mb with offset 1024, and one installation partition ~150g.
2. **Convert to UEFI mode**: [This](http://social.technet.microsoft.com/wiki/contents/articles/14286.converting-windows-bios-installation-to-uefi.aspx) site helped immensely, but in case it ever goes down:
   1. Does this work?


Troubleshooting
---------------

If at any time in Windows you want to know whether you're in UEFI mode, run msinfo32.
