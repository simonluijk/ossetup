#!/usr/bin/env bash

sudo apt-get update
sudo apt-get dist-upgrade

# Setup firewall
function interface_ip4 {
    ifconfig $1 | grep inet | grep -v inet6 | cut -d ":" -f 2 | cut -d " " -f 1
}
EXTERNAL_IP=`interface_ip4 wlan0`

# Clear all rules
sudo iptables -F

# Allow all outgoing traffic
sudo iptables -A OUTPUT -j ACCEPT

# Allows all loopback (lo0) and drop all to 127/8 not using lo0
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

# Accepts all established inbound connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -d $EXTERNAL_IP -j ACCEPT

# Allow ping
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

# Reject all other inbound
sudo iptables -A INPUT -j REJECT
sudo iptables -A FORWARD -j REJECT

sudo sh -c 'iptables-save > /etc/iptables.up.rules'

sudo sh -c 'echo "#!/usr/bin/env bash" > /etc/network/if-pre-up.d/iptables'
sudo sh -c 'echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-pre-up.d/iptables'
sudo chmod +x /etc/network/if-pre-up.d/iptables

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
sudo apt-get -y install python-reportlab python-beautifulsoup python-libcloud

# Utilities
sudo apt-get -y install virtualbox-ose virtualbox-guest-additions tasque liferea artha cryptsetup sqlite3 sqlite3-doc istanbul contacts keepassx hamster-applet getmail4 openjdk-6-jre-headless banshee python-pygraphviz

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

chmod +x $HOME/Dropbox/Dotfiles-Private/symlink.py
$HOME/Dropbox/Dotfiles-Private/symlink.py

# Link Hamster data
mkdir -p ~/.local/share/hamster-applet
ln -s ~/Dropbox/Data/Hamster/hamster.db ~/.local/share/hamster-applet/hamster.db

# Tidy up
rm ~/examples.desktop

chmod 0700 ~/.ssh
chmod 0600 ~/.ssh/*
