#!/bin/bash

dnf update

systemctl disable libvirtd
systemctl --user mask evolution-addressbook-factory evolution-calendar-factory evolution-source-registry
dnf remove -y abrt PackageKit gnome-software kde-connect kdeconnectd krdc dragon kontact ktorrent kget konversation konqueror falkon kmail krusader krfb akregator juk kamoso k3b calligra\* kfind kgpg kmouth kmag

# ruby/rails dependencies
dnf install -y perl-core libyaml-devel openssl-devel ruby-devel zlib-devel
dnf group install -y "C Development Tools and Libraries"

# asdf for bash
dnf install -y curl git
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
echo ". "$HOME/.asdf/asdf.sh"" >> .bashrc
echo ". "$HOME/.asdf/completions/asdf.bash"" >> .bashrc

# nodejs
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest

# ruby
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby latest
asdf global ruby latest

# basic gems
gem install bundler pry
gem update --system 3.5.9


# postman
# FOR FEDORA that way is only correct
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
# install using vpn, proxy
flatpak install -y flathub com.jetbrains.RubyMine

# VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf install code

# Zed
curl -f https://zed.dev/install.sh | sh

#docker
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker
groupadd docker && gpasswd -a ${USER} docker && systemctl restart docker
newgrp docker

# update for avoid old packages
dnf update
