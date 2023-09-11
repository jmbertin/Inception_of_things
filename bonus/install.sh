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

install_package "   1/8 - Updating system......" "sudo apt-get update >>install_log.log 2>>install_error_log.log"
install_package "   2/8 - Upgrading system....." "sudo apt-get upgrade -y >>install_log.log 2>>install_error_log.log"
install_package "   3/8 - Installing Tools....." "sudo apt-get install ssh curl apt-transport-https ca-certificates software-properties-common -y >>install_log.log 2>>install_error_log.log"
install_package "   4/8 - Installing Docker...." "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - >>install_log.log 2>>install_error_log.log; sudo add-apt-repository -y \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" >>install_log.log 2>>install_error_log.log; sudo apt-get update >>install_log.log 2>>install_error_log.log; sudo apt-get install docker-ce -y >>install_log.log 2>>install_error_log.log"
install_package "   5/8 - Installing k3d......." "curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash >>install_log.log 2>>install_error_log.log"
install_package "   6/8 - Installing kubectl..." "sudo curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl>>install_log.log 2>>install_error_log.log; sudo chmod +x ./kubectl>>install_log.log 2>>install_error_log.log; sudo mv ./kubectl /usr/local/bin/kubectl>>install_log.log 2>>install_error_log.log"
install_package "   7/8 - Installing gitlab...." "sudo docker compose up -d >>install_log.log 2>>install_error_log.log"
install_package "   8/8 - Waiting for gitlab..." "while ! (curl -sI http://localhost:9999/users/sign_in | head -n 1 | grep -q \"HTTP/1.1 200\"); do sleep 5; done >>install_log.log 2>>install_error_log.log"

echo "======================================="
echo "${green}${bold}       Everything is installed !${reset}"
echo " Go to http://localhost:9999/users/sign_in"
echo " Create a repository named iot"
echo " Then run sudo bash deploy.sh"
echo "======================================="
