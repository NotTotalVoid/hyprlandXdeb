# Colors & variable
RED='\e[31m'
RESET='\e[0m'
YELLOW='\e[33m'
GREEN='\e[32m'
script_dir="$(dirname "$(realpath "$0")")"

# Functions

clear
echo "Welcome to hyprXdeb"
echo "1) install hyprland & Preconfig it (Recommended)"
echo "2) install hyprland only"
echo "3) uninstall hyprland"
read -n 1 -p "Select:" input

case "$input" in
    [1]* )
        bash "$script_dir/scripts/install.sh"
        bash "$script_dir/scripts/preconfig.sh"
        ;;
    [2]* )
        bash "$script_dir/scripts/install.sh"
        ;;
    [3]* )
        bash "$script_dir/scripts/uninstall.sh"
        ;;
esac

