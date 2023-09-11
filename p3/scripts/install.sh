green=$(tput setaf 2)
red=$(tput setaf 1)
reset=$(tput sgr0)
bold=$(tput bold)
blue=$(tput setaf 4)

install_package() {
    printf "%-30s" "${bold}$1${reset}"
    printf "[....]"
    eval "$2"
    if [ $? -eq 0 ]; then
        printf "\r%-30s[${green}DONE${reset}]\n" "${bold}$1${reset}"
    else
        printf "\r%-30s[${red}ERROR${reset}]\n" "${bold}$1${reset}"
    fi
}

clear

echo "======================================="
echo "${blue}${bold}  Updating system and installing tools${reset}"
echo "======================================="

install_package "   1/7 - Updating system......" "sudo apt-get update > /dev/null 2>&1"
install_package "   2/7 - Upgrading system....." "sudo apt-get upgrade -y > /dev/null 2>&1"
install_package "   3/7 - Installing SSH......." "sudo apt install ssh -y > /dev/null 2>&1"
install_package "   4/7 - Installing curl......" "sudo apt install curl -y > /dev/null 2>&1"
install_package "   5/7 - Installing Docker...." "sudo apt install docker docker.io -y > /dev/null 2>&1; sudo usermod -aG docker $(whoami) > /dev/null 2>&1"
install_package "   6/7 - Installing k3d......." "curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash > /dev/null 2>&1"
install_package "   7/7 - Installing kubectl..." "sudo curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl > /dev/null 2>&1; sudo chmod +x ./kubectl > /dev/null 2>&1; sudo mv ./kubectl /usr/local/bin/kubectl > /dev/null 2>&1"

echo "======================================="
echo "${green}${bold}       Everything is installed !${reset}"
echo "======================================="
