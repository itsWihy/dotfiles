

MAIN_DIR="/home/wihy/Packages/dotfiles"
CONFIG_DIR="$HOME/.config"
FONTS_DIR="/usr/share/fonts"
GTK_THEME_DIR="/usr/share/themes"

initialize_packages() {
    mkdir Packages Pictures Scripts Desktop Downloads
    mkdir Pictures/Wallpapers/
    sudo mkdir -p /usr/local/bin
    sudo mkdir -p /usr/share/themes

    cd Packages/ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm

    sudo pacman -Syu --noconfirm zsh btop zathura flatpak packagekit alsa-utils brightnessctl xorg xorg-xinit xterm xf86-video-intel acpilight picom polybar nitrogen dunst dex alacritty maim polkit-gnome neovim ttf-jetbrains-mono libnotify rofi i3-gaps sddm i3 pulseaudio pulseaudio-bluetooth pavucontrol qt5 qt5-quickcontrols qt5-graphicaleffects
    yay -S --noconfirm --needed dhcpcd gimp iwd libreoffice ntfs-3g ntp pulsemixer vnstat noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra i3lock-color i3-resurrect ffcast acpi alsa-utils base-devel curl git pulseaudio pulseaudio-alsa xorg xorg-xinit alacritty btop code dunst feh ffcast firefox i3-gaps i3lock-color i3-resurrect libnotify light mpc mpd ncmpcpp nemo neofetch neovim oh-my-zsh-git pacman-contrib papirus-icon-theme picom polybar ranger rofi scrot slop xclip zathura zathura-pdf-mupdf most nerd-fonts-jetbrains-mono-160 zsh zsh-autosuggestions zsh-syntax-highlighting ttf-rubik ttf-firacode-nerd waterfox-current spotify-adblock polybar-spotify-module ttf-iosevka-nerd ttf-icomoon-feather ttf-font-awesome ttf-droid ttf-noto-nerd
}

github_cloning() {
    cd ~/Packages/
    git clone https://github.com/itsWihy/dotfiles/
    git clone https://github.com/vinceliuice/grub2-themes
    git clone --depth 1 https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme
}

install_gtk_theme() {
    cd ~/Packages/
    sudo cp -r ./Rose-Pine-GTK-Theme/themes/RosePine-Main-BL  /usr/share/themes/RosePine-Main
    mkdir -p "$HOME"/.config/gtk-4.0
    sudo cp -r ./Rose-Pine-GTK-Theme/themes/RosePine-Main-BL/gtk-4.0/* "$HOME"/.config/gtk-4.0
}   

grub_rice() {
    cd ~/Packages/grub2-themes/
    sudo ./install.sh -t tela -i color -s 1080p
    sudo mount /dev/nvme0n1p1 /boot/efi
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

i3_polybar_rice() {
    cd $MAIN_DIR

    DIR=`pwd`
    FDIR="$HOME/.local/share/fonts"
    PDIR="$HOME/.config/polybar"
    
    [[ ! -d "$FDIR" ]] && mkdir -p "$FDIR"
	cp -rf $DIR/fonts/* "$FDIR"

    chmod +x ~/.config/polybar/launch.sh 

    for file in "$HOME/.config/polybar/scripts"/*; do
        if [ -f "$file" ]; then
            chmod +x "$file"
            echo "Made $file executable."
        fi
    done
}

sddm_rice() {
    systemctl enable sddm
    sudo tar -xzvf $MAIN_DIR/sddm-chili.tar.gz -C /usr/share/sddm/themes
    sudo sed -i 's/Current=/Current=chili/g' /usr/lib/sddm/sddm.conf.d/default.conf
}

copy_info() {
    mv $MAIN_DIR/nord.jpg ~/Pictures/Wallpapers/

    cp -r ./config/* "$CONFIG_DIR"
    sudo cp -r ./fonts/* "$FONTS_DIR"
    
    fc-cache -v

    chsh -s /usr/bin/zsh
    homectl update --shell=/usr/bin/zsh

    mv $MAIN_DIR/.zshrc ~/

    sudo chmod +s /usr/bin/light
}


clean() {
    cd ~/Packages
    rm -Rf dotfiles grub2-themes 
}

initialize_packages
github_cloning
install_gtk_theme

copy_info

grub_rice
i3_polybar_rice
sddm_rice

clean
    
