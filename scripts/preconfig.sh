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
if yn "Want to install required packages?"; then
    echo -e "$GREEN [ok]Installing waybar dependencies$RESET"
    sudo apt-get install gtkmm-3.0 jsoncpp libsigc++-2.0 libfmt-dev libwayland-dev libdate-dev libspdlog-dev libgtk-3-dev gtk-layer-shell gobject-introspection gtk-layer-shell libgirepository1.0-dev gtk-layer-shell libpulse-dev libnl-3-dev libappindicator3-1 libdbusmenu-gtk3-dev libmpdclient2 libsndio-dev libevdev2 xkbregistry upower
    echo -e "$GREEN [ok]Installing waybar$RESET"
    git clone https://github.com/Alexays/Waybar
    cd Waybar
    meson build
    ninja -C build
    ./build/waybar
    ninja -C build install
    clear
else
    echo -e "$RED [error]The packages are required. Exiting.$RESET"
    exit
fi

