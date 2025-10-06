#!/bin/bash

set -e

echo "🚀 INSTALAÇÃO AUTOMÁTICA ARCH LINUX"

# Instalar pacotes base
echo "📥 INSTALANDO PACOTES BASE..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    nano pipewire pipewire-alsa pipewire-jack wireplumber \
    gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly ffmpeg \
    git hyprland hyprlock hypridle hyprcursor hyprpaper hyprpicker \
    waybar kitty rofi-wayland dolphin dolphin-plugins ark kio-admin \
    polkit-kde-agent qt5-wayland qt6-wayland xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk dunst cliphist vlc pavucontrol \
    xdg-user-dirs-gtk ttf-font-awesome ttf-jetbrains-mono-nerd \
    ttf-opensans noto-fonts firefox fastfetch breeze breeze-gtk \
    papirus-icon-theme nwg-look kde-cli-tools archlinux-xdg-menu

# Instalar pacotes AUR (AGORA COM YAY JÁ INSTALADO)
echo "📥 INSTALANDO PACOTES AUR..."
yay -S --noconfirm hyprshot wlogout qview visual-studio-code-bin

# Copiar dotfiles
echo "📁 CONFIGURANDO DOTFILES..."
cp -r ~/dotfiles/config/* ~/.config/

# Configurar serviços
echo "⚙️ CONFIGURANDO SERVIÇOS..."
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber

# Configurações finais
echo "🎯 CONFIGURAÇÕES FINAIS..."
xdg-user-dirs-update
echo "export QT_QPA_PLATFORM=wayland" >> ~/.bashrc
echo "export MOZ_ENABLE_WAYLAND=1" >> ~/.bashrc
echo "if [ -z \"\$DISPLAY\" ] && [ \"\$(tty)\" = \"/dev/tty1\" ]; then" >> ~/.bashrc
echo "  exec Hyprland" >> ~/.bashrc
echo "fi" >> ~/.bashrc

echo "✅ INSTALAÇÃO COMPLETA! Reinicie o sistema."
