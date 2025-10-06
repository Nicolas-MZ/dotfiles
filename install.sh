#!/bin/bash

# Script de instalação para Arch Linux
# Execute com: chmod +x install.sh && ./install.sh

set -e # Para o script se encontrar algum erro

echo "=== Iniciando instalação do sistema ==="

# Arrays para armazenar pacotes com problemas
FAILED_PACMAN_PACKAGES=()
FAILED_AUR_PACKAGES=()
FAILED_SERVICES=()

# Função para verificar se um pacote está instalado
check_package_installed() {
    if pacman -Qi "$1" &>/dev/null || pacman -Qg "$1" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Função para verificar se um pacote AUR está instalado
check_aur_package_installed() {
    if yay -Qi "$1" &>/dev/null 2>/dev/null || pacman -Qi "$1" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Função para verificar serviço
check_service_enabled() {
    if systemctl --user is-enabled "$1" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Função para instalar pacotes com verificação
install_pacman_packages() {
    local package_list=("$@")
    local failed_temp=()
    
    for package in "${package_list[@]}"; do
        echo "Instalando $package..."
        if sudo pacman -S --noconfirm "$package" 2>/dev/null; then
            if check_package_installed "$package"; then
                echo "✓ $package instalado com sucesso"
            else
                echo "✗ $package instalado mas não encontrado no sistema"
                failed_temp+=("$package")
            fi
        else
            echo "✗ Falha ao instalar $package"
            failed_temp+=("$package")
        fi
    done
    
    FAILED_PACMAN_PACKAGES+=("${failed_temp[@]}")
}

# Função para instalar pacotes AUR com verificação
install_aur_packages() {
    local package_list=("$@")
    local failed_temp=()
    
    for package in "${package_list[@]}"; do
        echo "Instalando $package do AUR..."
        if yay -S --noconfirm "$package" 2>/dev/null; then
            if check_aur_package_installed "$package"; then
                echo "✓ $package (AUR) instalado com sucesso"
            else
                echo "✗ $package (AUR) instalado mas não encontrado no sistema"
                failed_temp+=("$package")
            fi
        else
            echo "✗ Falha ao instalar $package do AUR"
            failed_temp+=("$package")
        fi
    done
    
    FAILED_AUR_PACKAGES+=("${failed_temp[@]}")
}

# Atualizar sistema primeiro
echo "Atualizando sistema..."
sudo pacman -Syu --noconfirm
echo "✓ Sistema atualizado"

# Pacotes Básicos
echo "=== Instalando Pacotes Básicos ==="
BASIC_PACKAGES=(
    nano pipewire pipewire-alsa pipewire-jack wireplumber 
    streamer gst-libav gst-plugins-base gst-plugins-good 
    gst-plugins-bad gst-plugins-ugly ffmpeg
)
install_pacman_packages "${BASIC_PACKAGES[@]}"

# Instalar yay (AUR helper)
echo "=== Instalando Yay ==="
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay/
    if makepkg -si --noconfirm; then
        cd ..
        sudo rm -rf yay/
        echo "✓ Yay instalado com sucesso"
    else
        echo "✗ Falha ao instalar yay"
        FAILED_AUR_PACKAGES+=("yay")
    fi
else
    echo "✓ Yay já está instalado"
fi

# Hyprland e aplicações básicas
echo "=== Instalando Hyprland e Aplicações ==="
HYPRLAND_PACKAGES=(
    hyprland hyprlock hypridle hyprcursor hyprpaper hyprpicker 
    waybar kitty rofi-wayland dolphin dolphin-plugins ark 
    kio-admin polkit-kde-agent qt5-wayland qt6-wayland 
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk dunst 
    cliphist vlc pavucontrol xdg-user-dirs-gtk ttf-font-awesome 
    ttf-jetbrains-mono-nerd ttf-opensans noto-fonts firefox
)
install_pacman_packages "${HYPRLAND_PACKAGES[@]}"

# Pacotes Yay (AUR)
echo "=== Instalando Pacotes do AUR ==="
AUR_PACKAGES=(hyprshot wlogout qview visual-studio-code-bin)
install_aur_packages "${AUR_PACKAGES[@]}"

# Configurar serviços do pipewire
echo "=== Configurando Serviços ==="
SERVICES=(pipewire pipewire-alsa wireplumber)
for service in "${SERVICES[@]}"; do
    if systemctl --user enable "$service" 2>/dev/null; then
        if check_service_enabled "$service"; then
            echo "✓ Serviço $service habilitado"
        else
            echo "✗ Serviço $service não pôde ser habilitado"
            FAILED_SERVICES+=("$service")
        fi
    else
        echo "✗ Falha ao habilitar serviço $service"
        FAILED_SERVICES+=("$service")
    fi
done

# Comandos posteriores
echo "=== Executando Configurações Pós-Instalação ==="

# Atualizar diretórios de usuário
if sudo xdg-user-dirs-update; then
    echo "✓ Diretórios de usuário atualizados"
else
    echo "✗ Falha ao atualizar diretórios de usuário"
fi

# Instalar fastfetch
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
systemctl --user enable pipewire pipewire-alsa wireplumber
systemctl --user start pipewire pipewire-alsa wireplumber

# Configurações finais
echo "🎯 CONFIGURAÇÕES FINAIS..."
xdg-user-dirs-update
echo "export QT_QPA_PLATFORM=wayland" >> ~/.bashrc
echo "export MOZ_ENABLE_WAYLAND=1" >> ~/.bashrc
echo "if [ -z \"\$DISPLAY\" ] && [ \"\$(tty)\" = \"/dev/tty1\" ]; then" >> ~/.bashrc
echo "  exec Hyprland" >> ~/.bashrc
echo "fi" >> ~/.bashrc

echo "✅ INSTALAÇÃO COMPLETA! Reinicie o sistema."e" "kitty" "firefox")
for package in "${CRITICAL_PACKAGES[@]}"; do
    if check_package_installed "$package"; then
        echo "✓ $package está instalado e funcionando"
    else
        echo "✗ ATENÇÃO: $package NÃO está instalado corretamente"
    fi
done

echo ""
echo "=== CONCLUSÃO ==="
if [ ${#FAILED_PACMAN_PACKAGES[@]} -eq 0 ] && [ ${#FAILED_AUR_PACKAGES[@]} -eq 0 ]; then
    echo "✅ Instalação principal concluída com sucesso!"
    echo ""
    echo "🎯 Próximos passos:"
    echo "   1. Reinicie o sistema"
    echo "   2. Execute 'fastfetch' para ver as informações do sistema"
    echo "   3. Configure o Hyprland conforme necessário"
    echo "   4. Execute 'nwg-look' para configurar temas"
else
    echo "⚠️  Instalação concluída com alguns problemas."
    echo "   Reveja o relatório acima e corrija as instalações falhas."
fi
