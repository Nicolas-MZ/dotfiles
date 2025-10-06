#!/bin/bash

#Pacotes Básicos

sudo pacman -S nano pipewire pipewire-alsa pipewire-jack pipewire-alsa wireplumber streamer gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly ffmpeg 

git clone https://aur.archlinux.org/yay
cd yay/ 
makepkg -si 
cd .. 
sudo rm -rf yay 

sudo pacman -S hyprland hyprlock hypridle hyprcursor hyprpaper hyprpicker waybar kitty rofi-wayland dolphin dolphin-plugins ark kio-admin polkit-kde-agent  qt5-wayland qt6-wayland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk dunst cliphist vlc pavucontrol xdg-user-dirs-gtk ttf-font-awesome ttf-jetbrains-mono-nerd ttf-opensans noto-fonts Firefox

#ttf-droid
#ttf-roboto

#Pacotes Yay

yay -S --noconfirm  hyprshot wlogout qview visual-studio-code-bin

#Comando sistema

systemctl --user enable pipewire pipewire-alsa wireplumber


#Comandos posteriores/após a instalação dos #pacotes Básicos


sudo xdg-user-dirs-update

sudo pacman -S fastfetch

sudo pacman -S breeze breeze5 breeze-gtk papirus-icon-theme

sudo pacman -S nwg-look

yay -S --noconfirm qt5ct-kde qt6cy-kde

sudo pacman -S kde-cli-tools

sudo pacman -S archlinux-xdg-menu


