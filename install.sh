#!/bin/bash
# install.sh 
# @author umutsevdi 
# A script that installs and configures desktop enviroment to your needs.
# Installs various tools.
# Designed for Fedora 3X Server Editions
# @requires dnf, https://www.github.com/umutsevdi/dotfiles

Help()
{
   # Display Help
   echo "install.sh - Umut Sevdi's install script for Fedora Server"
   echo
   echo "  Disclaimer: run --install with root privileges, --config"
   echo "with normal user. Run install first with your arguments"
   echo
   echo "Example: sudo sh install.sh --common --nvidia --install"
   echo "Example: sh install.sh --configure"
   echo "Syntax: [-h/C/i [c|n]]"
   echo
   echo "Options:"
   echo "-h/--help            Prints this menu."
   echo "-i/--install         Starts installation. Requires sudo."
   echo "-C/--config          Configures system files."
   echo "-c/--common          Installs common programs."
   echo "-n/--nvidia          Installs Nvidia softwares."
   echo
}

Install()
{
    echo "Beginning Installation - $(date +%H:%M) - $(date +' '%a' '%d' '%b' '%Y) "
    mkdir /tmp/install
    ## UPATE ##
    echo "╭────────────────────────────────╮"
    echo "│    Adding RPM Repositories     │"
    echo "╰────────────────────────────────╯"
    dnf -y install dnf-plugins-core
    sudo dnf install -y \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm && \
        echo "Added Non-Free Fedora Repositories"
    dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo >> /tmp/install/rpm.logs &&  \
        echo "Added GitHub CLI Repository"
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo >> /tmp/install/rpm.logs &&  \
        echo "Added Docker Repository"
    dnf copr enable agriffis/neovim-nightly -y && \
        echo "Added COPR Repository for neovim-nightly"
    dnf copr enable atim/lazygit -y && \
        echo "Added COPR Repository for lazygit"
    tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF 
&& echo "Added VS Codium Repository"
    echo "╭────────────────────────────────╮"
    echo "│ Updating programs and drivers  │"
    echo "╰────────────────────────────────╯"
    dnf update --refresh -y
    ## GRAPHIC UTILS ##
    echo "Installing and configuring Graphical Utility Tools"
    echo "Configuring SDDM"
    dnf install lightdm -y >> /tmp/install/graphic.logs
    systemctl enable lightdm >> /tmp/install/graphic.logs
    systemctl set-default graphical.target >> /tmp/install/graphic.logs
    ## Directories ##
    echo "Installing required programs"
    dnf install -y dbus-devel gcc git libconfig-devel libdrm-devel libev-devel libX11-devel libX11-xcb libXext-devel libxcb-devel mesa-libGL-devel meson pcre-devel pixman-devel uthash-devel xcb-util-image-devel xcb-util-renderutil-devel xorg-x11-proto-devel
    dnf install -y playerctl scrot xdotool  xrandr xinput xclip mpv gnome-online-accounts ImageMagick
    echo "Installing i3 window manager & compositor"
    dnf install -y --allowerasing i3-gaps rofi conky
    dnf install -y --allowerasing alacritty polybar
    dnf install -y --allowerasing pasystray blueman xfce4-power-manager nitrogen rofi xfce4-clipman-plugin glava 
    if [[ "$get_nvidia" = true ]];then
        dnf install akmod-nvidia -y
    fi
    # COMPILING PICOM
    echo "Compiling dccsillag/implement-window-animations"
    cd /tmp
    git clone https://github.com/dccsillag/picom/
    git checkout implement-window-animations
    cd picom
    git submodule update --init --recursive
    meson --buildtype=release . build
    ninja -C build

    ## REQUIRED PROGRAMS ##
    echo "Installing basic programs"
    dnf install -y firefox xed thunar xarchiver
    dnf install -y lazygit btop
    ## CLI PROGRAMS ##
    echo "╭────────────────────────────────╮"
    echo "│  Installing Development Tools  │"
    echo "╰────────────────────────────────╯"
    echo "Installing NodeJS Pip Lua"
    dnf install neovim python3-neovim gh -y
    dnf module install nodejs:16/common -y
    dnf install g++ fzf -y
    dnf install pip -y
    pip install neovim
    dnf install lua luarocks -y
    echo "Installing Java Development Kit 1.8/11/latest"
    dnf install -y java-1.8.0-openjdk-devel.x86_64 java-11-openjdk-devel.x86_64 java-latest-openjdk-devel.x86_64 maven
    echo "Installing Lombok"
    sudo mkdir /usr/local/share/lombok
    sudo wget https://projectlombok.org/downloads/lombok.jar -O /usr/local/share/lombok/lombok.jar
    cd /tmp
    echo "Installing Go"
    wget https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
    tar -xvf go1.18.2.linux-amd64.tar.gz -C /lib/
    for i in $(ls /home/); do
        path="/home/$i";
        tar -xvf go1.18.2.linux-amd64.tar.gz -C $path
    done
    echo "Installing Docker"
    ## DOCKER
    dnf install docker -y
    groupadd docker
    usermod -aG docker $USER
    systemctl start docker
    systemctl enable docker
    ## neovim get_config ##
    echo "Configuring Neovim"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    npm install -g neovim
    npm install -g coc-clangd
    npm install -g bash-language-server
    npm install -g instant-markdown-d
    mkdir $HOME/.config/nvim
    echo "package.path = package.path .. ';/home/umutsevdi/.dotfiles/nvim/?.lua;/home/umutsevdi/.dotfiles/nvim/pkg/?.lua'" \ 
        "\nvim.cmd('source /home/umutsevdi/.dotfiles/nvim/init.lua')" >> $HOME/.config/nvim/init.lua
    if [ "$get_common" = true ]; then
        echo "Installing Common Programs"
        echo "obs-studio midori btop telegram spotify discord teams libreoffice slack" \ 
            "krita kdenlive zoom jetbrains-toolbox git-kraken VirtualBox"
        dnf install -y elementary-calculator elementary-print gnome-disk-utility \
            geary elementary gnome-system-monitor eom dconf-edior
        dnf install -y telegram obs-studio cheese midori atril gnome-software
        dnf install -y flatpak >> /tmp/install/flatpak.logs
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo  
        flatpak update
        flatpak install com.getpostman.Postman \
            com.spotify.Client \
            com.discordapp.Discord \
            com.github.tchx84.Flatseal \
            com.microsoft.Teams \
            org.libreoffice.LibreOffice \
            com.slack.Slack \
            org.kde.krita \
            org.kde.kdenlive \
            us.zoom.Zoom
        echo "Installing JetBrains Toolbox"
        curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash
        echo "Installing Git Kraken"
        cd /tmp/
        wget https://release.gitkraken.com/linux/gitkraken-amd64.rpm
        dnf install gitkraken-amd64.rpm -y
        cd -
        echo "Installing Virtual Box"
        dnf install VirtualBox -y
    fi

    echo "╭────────────────────────────────╮"
    echo "│      Installing KDEConnect     │"
    echo "╰────────────────────────────────╯"
    dnf install kdeconnectd
    firewall-cmd --zone=public --permanent --add-port=1714-1764/tcp
    firewall-cmd --zone=public --permanent --add-port=1714-1764/udp
    systemctl restart firewalld.service
    ## Symbolic Links ##
    echo "╭────────────────────────────────╮"
    echo "│    Setting Fonts and Themes    │"
    echo "╰────────────────────────────────╯"
   echo "Installing Fonts"
    mkdir /usr/share/fonts/jetbrains-mono
    cd  /usr/share/fonts/jetbrains-mono
    wget https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
    unzip JetBrainsMono-2.242.zip; unzip JetBrainsMono.zip
    cd /usr/share/fonts/
    mkdir droidsans-nerd-fonts
    cd droidsans-nerd-fonts
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
    unzip DroidSansMono.zip
    mv /tmp/install $HOME/install

    echo "write: \nfastestmirror=True\ndeltarpm=True\nto  /etc/dnf/dnf.conf"
    # Theme config
    echo "Setting GTK theme"
    cd /tmp/
    git clone https://github.com/vinceliuice/Qogir-theme.git
    cd Qogir-theme

    sh ./install.sh -d ~/.themes/ -t default  -l fedora --tweaks round 
    sh ./install.sh -d /usr/share/themes/ -t default  -l fedora --tweaks round 
    flatpak override --filesystem=$HOME/.themes

    echo "Setting Icons"
    cd /tmp/
    wget https://github.com/bikass/kora/archive/refs/tags/v1.5.2.tar.gz
    tar -xvf kora-1.5.2.tar.gz
    cd kora-1.5.2
    cp kora* /usr/share/icons/ -r

    git clone https://github.com/vinceliuice/Qogir-icon-theme/archive/refs/tags/2022-01-12.zip
    unzip Qogir-icon-theme-2022-01-12.zip 
    cd Qogir-icon-theme-2022-01-12
    sh install.sh
    flatpak override --env=GTK_THEME=Qogir

    ## END OF get_install ##
    dnf clean all
    echo "Installation Complete  - $(date +%H:%M) - $(date +' '%a' '%d' '%b' '%Y) "
    echo "Type Y to reboot"
    read get_reboot

    if [[ "$get_reboot" = "Y" ]];then 
        reboot
    fi
}
Configure()
{
    echo "╭────────────────────────────────╮"
    echo "│     Starting Configuration     │"
    echo "╰────────────────────────────────╯"
    cd $HOME
    cp $HOME/dotfiles $HOME/.dotfiles
    echo "Extracting .dotfile configurations"
    chmod +x $HOME/.dotfiles/bin/*
    rm -rf $HOME/.config/autostart
    ln -s $HOME/.dotfiles/autostart $HOME/.config/autostart
    $HOME/.dotfiles/bin/dotfetch --root
    echo "Updating Neovim packages"
    nvim -c ":PackerInstall | CocUpdate " "Neovim Installation is completed"
}

for arg in $@;do
    case $arg in
        -h | --help)
            get_help=true
        ;;
        -n | --nvidia)
            echo "Nvidia software updates are enabled"
            get_nvidia=true
        ;;
        -c | --common)
            echo "Common software install is enabled"
            get_common=true
        ;;
        -i | --install)
            get_install=true
        ;;
        -C | --configure)
            get_config=true
        ;;
        *)
            echo -e "Error: Invalid arguments" 1>&2
            Help
            exit
        ;;
    esac
done

if   [ "$get_install" = true ]; then
    Install
elif [ "$get_help" = true ]; then
    Help
elif [ "$get_config" = true ]; then
    Configure
    echo "Configuration is successful"
elif [ $# -eq 0 ]; then
    Help
fi
