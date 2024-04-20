#!/bin/bash

# update and remove unusable soft
dnf update

dnf remove abrt
dnf remove PackageKit gnome-software
systemctl disable libvirtd
systemctl --user mask evolution-addressbook-factory evolution-calendar-factory evolution-source-registry
dnf remove kde-connect kdeconnectd
dnf remove krdc dragon kontact ktorrent kget konversation konqueror falkon kmail krusader krfb akregator juk kamoso k3b calligra\* kfind kgpg kmouth kmag

# terminal
dnf install -y kitty

# zsh, ohmyzsh
dnf install -y zsh
touch ~/.zshrc
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ruby/rails dependencies
dnf install -y perl-core
dnf install -y libyaml-devel
dnf install -y openssl-devel
dnf group install -y "C Development Tools and Libraries"
dnf install -y ruby-devel zlib-devel

# asdf
dnf install -y curl git
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
cat << EOF > ~/.zshrc
. "$HOME/.asdf/asdf.sh"
EOF

# nodejs
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install -y nodejs latest
asdf global nodejs latest

# ruby
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
ASDF_RUBY_BUILD_VERSION=master asdf install ruby 3.3.0
asdf global ruby latest

# basic gems
gem install bundler
gem install pry
gem update --system 3.5.9


# postman

wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux-x64.tar.gz
tar xvzf postman-linux-x64.tar.gz -C /opt
ln -s /opt/Postman/Postman /usr/bin/postman

cat << EOF > ~/.local/share/applications/postman2.desktop
[Desktop Entry]
Name=Postman
GenericName=API Client
X-GNOME-FullName=Postman API Client
Comment=Make and view REST API calls and responses
Keywords=api;
Exec=/opt/Postman/Postman
Terminal=false
Type=Application
Icon=/opt/Postman/app/resources/app/assets/icon.png
Categories=Development;Utilities;
EOF

# telegram
dnf install telegram

# discord
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install discord

# rubymine
flatpak install -y flathub com.jetbrains.RubyMine

#docker
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker
groupadd docker && gpasswd -a ${USER} docker && systemctl restart docker
newgrp docker

# update for avoid old packages
dnf update