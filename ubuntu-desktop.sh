#!/usr/bin/env bash

sudo apt-get update
sudo apt-get dist-upgrade

# Dropbox
cd ~ && wget http://dl-web.dropbox.com/u/17/dropbox-lnx.x86-0.8.107.tar.gz && killall dropbox; rm -rf .dropbox-dist/ && tar xzf dropbox* && rm dropbox*
dropbox start

# Plugins
sudo apt-get -y install gstreamer0.10-ffmpeg mozilla-plugin-gnash gedit-plugins

# DVCS and svn
sudo apt-get -y install git-gui git-doc git-svn mercurial subversion

# Fonts
sudo apt-get -y install ttf-mscorefonts-installer ttf-dejavu ttf-larabie-deco ttf-larabie-straight ttf-larabie-uncommon gnome-specimen

# Ntp
sudo apt-get -y install ntp
if !(grep -q '^## Pool servers' /etc/ntp.conf); then
    sudo sh -c 'echo "" >> /etc/ntp.conf'
    sudo sh -c 'echo "## Pool servers" >> /etc/ntp.conf'
    sudo sh -c 'echo "server 0.europe.pool.ntp.org" >> /etc/ntp.conf'
    sudo sh -c 'echo "server 1.europe.pool.ntp.org" >> /etc/ntp.conf'
    sudo sh -c 'echo "server 2.europe.pool.ntp.org" >> /etc/ntp.conf'
    sudo ntpdate
    sudo /etc/init.d/ntp restart
fi

# Python tools
sudo apt-get -y install python-virtualenv python-pip fabric
sudo apt-get -y install python-reportlab python-beautifulsoup

# Utilities
sudo apt-get -y install virtualbox-ose tasque liferea artha cryptsetup localepurge

# Vim
sudo apt-get -y install vim-gnome vim-doc

# Remove un-needed packages
sudo apt-get -y purge gnome-sudoku gnome-mahjongg gnomine quadrapassel aisleriot gbrainy computer-janitor rhythmbox vino ubuntuone-client

# Cleanup
sudo apt-get autoremove
sudo apt-get clean

# Wait for dropbox
echo -n "Once Dropbox is synced hit [ENTER]: "
read -n 0 dropbox_done

# Link dotfiles
chmod +x $HOME/Dropbox/Dotfiles/symlink.py
$HOME/Dropbox/Dotfiles/symlink.py
