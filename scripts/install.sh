#!/bin/bash

# Colors
RED='\e[31m'
RESET='\e[0m'
YELLOW='\e[33m'
GREEN='\e[32m'

# Functions
yn() {
    local loop=false
    local prompt=""
    [ "$1" == "-L" ] && loop=true && shift
    [ "$1" == "-p" ] && prompt="$2" && shift 2

    prompt="${prompt:-$1}"
    while true; do
        read -p "$prompt [y/n]: " choice
        case "$choice" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo -e "${RED}[error] Please input a valid option${RESET}";;
        esac

        if [ "$loop" = false ]; then
            echo -e "${RED}[error] Invalid input. Exiting.${RESET}"
            exit 1
        fi
    done
}

clear
if yn "Want to update the system?"; then
    sudo apt update && sudo apt upgrade -y
fi
clear

if yn -L "Want to install required packages?"; then
    packages=("meson" "wget" "build-essential" "ninja-build" "cmake" "gettext" "gettext-base" "fontconfig" "libfontconfig-dev" "libffi-dev" "libxml2-dev" "libdrm-dev" "libxkbcommon-x11-dev" "libxkbregistry-dev" "libxkbcommon-dev" "libpixman-1-dev" "libudev-dev" "libseat-dev" "seatd" "libxcb-dri3-dev" "libegl-dev" "libgles2" "libegl1-mesa-dev" "glslang-tools" "libinput-bin" "libinput-dev" "libxcb-composite0-dev" "libavutil-dev" "libavcodec-dev" "libavformat-dev" "libxcb-ewmh2" "libxcb-ewmh-dev" "libxcb-present-dev" "libxcb-icccm4-dev" "libxcb-render-util0-dev" "libxcb-res0-dev" "libxcb-xinput-dev" "xdg-desktop-portal-wlr" "libpango-1.0-dev" "libgbm-1.0-dev" "vim" "git")
    sudo apt-get install -y "${packages[@]}"
    clear
    echo -e "${GREEN}[ok] Packages installed${RESET}"
else
    echo -e "${YELLOW}[warning] The packages are required to install Hyprland, which may cause future errors${RESET}"
fi


if yn -L "Want to install default apps?"; then
    default_apps=("kitty" "thunar")
    sudo apt-get install -y "${default_apps[@]}"
    clear
    for app in "${default_apps[@]}"; do
        echo -e "${GREEN}[ok] $app installed${RESET}"
    done
else
    echo -e "${YELLOW}[ok] Installation of default apps aborted${RESET}"
fi

echo "[normal] Started Hyprland setup...."
mkdir -p HyprSource
cd HyprSource

wget https://github.com/hyprwm/Hyprland/releases/download/v0.24.1/source-v0.24.1.tar.gz
tar -xvf source-v0.24.1.tar.gz
wget https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.31/downloads/wayland-protocols-1.31.tar.xz
tar -xvJf wayland-protocols-1.31.tar.xz
wget https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.22.0/downloads/wayland-1.22.0.tar.xz
tar -xzvJf wayland-1.22.0.tar.xz
wget https://gitlab.freedesktop.org/emersion/libdisplay-info/-/releases/0.1.1/downloads/libdisplay-info-0.1.1.tar.xz
tar -xvJf libdisplay-info-0.1.1.tar.xz

cd wayland-1.22.0
mkdir -p build
cd build

meson setup .. \
    --prefix=/usr \
    --buildtype=release \
    -Ddocumentation=false

ninja
sudo ninja install

cd ../..

cd wayland-protocols-1.31
mkdir -p build
cd build

meson setup --prefix=/usr --buildtype=release
ninja
sudo ninja install

cd ../..

cd libdisplay-info-0.1.1/
mkdir -p build
cd build

meson setup --prefix=/usr --buildtype=release
ninja
sudo ninja install

cd ../..

chmod a+rw hyprland-source
cd hyprland-source/
sed -i 's/\/usr\/local/\/usr/g' config.mk

sudo make install

echo "[normal] Creating a Hyprland session for LightDM..."
hyprland_session_file="/usr/share/xsessions/hyprland.desktop"
echo "[Desktop Entry]
Name=Hyprland
Comment=Hyprland Desktop Environment
Exec=/home/void/HyprSource/hyprland-source/build/Hyprland
Type=Application
X-LightDM-DesktopName=Hyprland" | sudo tee "$hyprland_session_file" > /dev/null

echo "[normal] Configuring LightDM to use Hyprland..."
sudo sed -i 's/^user-session=.*/user-session=hyprland/' /etc/lightdm/lightdm.conf

clear

echo "[normal] The setup runned till the end,if theres any other error please report it"
