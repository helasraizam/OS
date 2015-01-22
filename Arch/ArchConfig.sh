#!/usr/bin/bash

case $1 in
	'update')
		from=~
		to=Settings;;
	'extract')
		from=Settings
		to=~;;
	*)			
		echo -e "Usage: Arch.sh [options]
Options include:
    update:     Update all configuration files to Settings folder.
    extract:    Overwrite all configuration files from Settings folder."
		exit 1		
esac

for file in '.bash_aliases' '.bash_logout' '.bash_profile' '.bashrc' '.config/gtk-2.0/gtkfilechooser.ini' '.config/gtk-3.0/settings.ini' '.config/gtk-3.0/bookmarks' '.emacs' '.i3/config' '.i3status.conf' '.Xdefaults' '.xinitrc' '.xprofile' '.Xresources' '.xsession'; do
	cp $from/$file $to/$file
done
