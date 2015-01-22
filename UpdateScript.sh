#!/usr/bin/bash

# Copy configuration files to github

### ARCH
for file in '.bash_aliases' '.bash_logout' '.bash_profile' '.bashrc' '.config/gtk-2.0/gtkfilechooser.ini' '.config/gtk-3.0/settings.ini' '.config/gtk-3.0/bookmarks' '.emacs' '.i3/config' '.i3status.conf' '.Xdefaults' '.xinitrc' '.xprofile' '.Xresources' '.xsession'; do
	cp ~/$file Settings/$file;
done


