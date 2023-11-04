#!/bin/bash

# Colors
RED='\e[31m'
RESET='\e[0m'

# Functions
yn() {
    local prompt=""
    [ "$1" == "-p" ] && prompt="$2" && shift 2

    prompt="${prompt:-$1}"
    while true; do
        read -p "$prompt [y/n]: " choice
        case "$choice" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo -e "${RED}[error] Please input a valid option${RESET}";;
        esac
    done
}

if yn "Do you want to uninstall Hyprland?"; then
    if yn "ARE YOU SURE TO UNINSTALL HYPRLAND"; then
        sudo make uninstall
        rm -rf ~/HyprSource
        sudo rm /usr/share/xsessions/hyprland.desktop
        sudo sed -i 's/^user-session=.*/user-session=your_default_session/' /etc/lightdm/lightdm.conf
        packages=("meson" "wget" "build-essential" "ninja-build" "cmake" "gettext" "gettext-base" "fontconfig" "libfontconfig-dev" "libffi-dev" "libxml2-dev" "libdrm-dev" "libxkbcommon-x11-dev" "libxkbregistry-dev" "libxkbcommon-dev" "libpixman-1-dev" "libudev-dev" "libseat-dev" "seatd" "libxcb-dri3-dev" "libegl-dev" "libgles2" "libegl1-mesa-dev" "glslang-tools" "libinput-bin" "libinput-dev" "libxcb-composite0-dev" "libavutil-dev" "libavcodec-dev" "libavformat-dev" "libxcb-ewmh2" "libxcb-ewmh-dev" "libxcb-present-dev" "libxcb-icdmm4-dev" "libxcb-render-util0-dev" "libxcb-res0-dev" "libxcb-xinput-dev" "xdg-desktop-portal-wlr" "libpango-1.0-dev" "libgbm-1.0-dev" "vim" "git")
        for package in "${packages[@]}"; do
            sudo apt-get remove --purge -y "$package"
        done
        for package in "${packages[@]}"; do
            sudo apt-get purge -y "$package"
        done
        sudo apt-get autoremove -y
        echo -e "Hyprland has been uninstalled, and all related folders and packages have been removed."
    else
        echo -e "Uninstallation of Hyprland aborted. Hyprland is still installed."
    fi
else
    echo -e "Uninstallation of Hyprland aborted. Hyprland is still installed."
fi

