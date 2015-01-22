#! /bin/bash

HDIRECTORY='/mnt/Helasraizam/'

alias gotoH='cd ${HDIRECTORY}'
alias gotoW='cd ${HDIRECTORY}/\{W\}/'
alias gotoSchool='cd ${HDIRECTORY}/School/Grad\ School/DePaul/2013-2014\ Physics/Spring/'
alias upgradeSync='sudo apt-get update;
sudo apt-get upgrade -y --force-yes;
unison -auto -batch "home";
unison -batch -auto "{H}";'
alias minecraft='${HDIRECTORY}/\{G\}/Minecraft/Minecraft.sh'
alias matlab='/usr/local/MATLAB/R2012a/bin/matlab'
alias editXServer='sudo gedit /etc/X11/xorg.conf'
alias editSamba='sudo gedit /etc/samba/smb.conf'
alias editCommands='gedit ~/.bash_aliases'
alias editMounts='sudo gedit /etc/fstab'
alias editRepositories='sudo gedit /etc/apt/sources.list'

alias Fancy='sudo apt-get update;
sudo apt-get upgrade -y --force-yes;
cp /etc/X11/xorg.conf /media/Helasraizam/\{H\}/\{P\}/Linux/Ubuntu/Settings/XServer/xorg.conf;
cp /etc/samba/smb.conf /media/Helasraizam/\{H\}/\{P\}/Linux/Ubuntu/Settings/Samba/smb.conf;
cp ~/.bash_aliases /media/Helasraizam/\{H\}/\{P\}/Linux/Ubuntu/Settings/Aliases/.bash_aliases;
cp /etc/apache2/sites-available/default /media/Helasraizam/\{H\}/\{P\}/Linux/Ubuntu/Settings/Apache/default;
cp /etc/fstab /media/Helasraizam/\{H\}/\{P\}/Linux/Ubuntu/Settings/Mounts/fstab;
cp /etc/apt/sources.list /media/Helasraizam/\{H\}/\{P\}/Linux/Ubuntu/Installation/DB/sources.list;
cp ~/.emacs /media/Helasraizam/\{H\}/\{P\}/Linux/Ubuntu/Settings/emacs/.emacs;
cp -r ~/texmf /media/Helasraizam/\{H\}/School/General/Latex/texmf/ -u;
grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/* >> /media/Helasraizam/\{H\}/\{P\}/Linux/Ubuntu/Installation/DB/Sources.list;
sudo dpkg --get-selections > /media/Helasraizam/\{H\}/\{P\}/Linux/Ubuntu/Installation/DB/Packages.list;
unison -auto -batch "home";'

alias FancySync='Fancy
unison -batch -auto "{H}";'

alias FancyOff='Fancy
sudo shutdown -h now'

alias FancyOffSync='FancySync
sudo shutdown -h now'
