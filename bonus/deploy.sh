GITLAB_IP=$(hostname -I | cut -d " " -f1)
sed -i "s|http://localhost|http://$GITLAB_IP|g" conf/appli.yaml >>deploy_log.log 2>>deploy_error_log.log

echo "===================================================="
echo " Cloning Wil-playground repository................."
sudo git clone http://$GITLAB_IP:9999/root/iot.git
echo " Copying configuration files......................."
cp conf/wilapp.yaml iot/wilapp.yaml >>deploy_log.log 2>>deploy_error_log.log
cd iot
echo " Pushing configuration files to git repository......"
git config --global --add safe.directory $(pwd)
git config --global user.email \"jmbcorp_house@hotmail.com\"
git config --global user.name \"jbertin\"
git add wilapp.yaml >>../deploy_log.log 2>>../deploy_error_log.log
git commit -m1 >>../deploy_log.log 2>>../deploy_error_log.log
git push >>../deploy_log.log 2>>../deploy_error_log.log
cd ..

green=$(tput setaf 2)
red=$(tput setaf 1)
reset=$(tput sgr0)
bold=$(tput bold)
blue=$(tput setaf 4)
up=$(tput cuu1)

perform_task() {
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

echo "===================================================="
echo "${blue}${bold}                     Deployement${reset}"
echo "===================================================="

perform_task "     Creating k3d cluster................" "mkdir -p ~/.kube/; sudo k3d cluster create mycluster-iot --api-port 6550 -p \"8888:8888@loadbalancer\" -p \"30000:30000@loadbalancer\" --agents 2 >>deploy_log.log 2>>deploy_error_log.log; sudo k3d kubeconfig get mycluster-iot > ~/.kube/config; sudo chmod 777 ~/.kube/config"
perform_task "     Creating namespaces................." "kubectl create namespace argocd >>deploy_log.log 2>>deploy_error_log.log; kubectl create namespace dev >>deploy_log.log 2>>deploy_error_log.log; kubectl create namespace gitlab >>deploy_log.log 2>>deploy_error_log.log"
perform_task "     Installing ArgoCD..................." "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml >>deploy_log.log 2>>deploy_error_log.log"
perform_task "     Waiting for ArgoCD to be ready......" "sudo kubectl wait --for=condition=Ready pods --all -n argocd --timeout=600s >>deploy_log.log 2>>deploy_error_log.log"
perform_task "     Patching ArgoCD service............." "kubectl patch svc argocd-server -n argocd --type='json' -p '[{\"op\": \"replace\", \"path\": \"/spec/type\", \"value\": \"NodePort\"}, {\"op\": \"add\", \"path\": \"/spec/ports/0/nodePort\", \"value\": 30000}]' >>deploy_log.log 2>>deploy_error_log.log"
perform_task "     Changing ArgoCD password............" "sudo kubectl -n argocd patch secret argocd-secret -p '{\"stringData\": {\"admin.password\": \"\$2a\$12\$T6QMngsiMiiRYowi7izwYeKyEVXnuQjNuBTq6V9jnW7DN8vSywZvm\",\"admin.passwordMtime\": \"'\"'$(date +%FT%T%Z)'\"'\"}}' >>deploy_log.log 2>>deploy_error_log.log"
perform_task "     Creating ArgoCD application........." "sudo kubectl apply -f ./conf/appli.yaml -n argocd >>deploy_log.log 2>>deploy_error_log.log"

echo "     ${bold}Waiting Wil-playground deployement..${reset}[....]"
while true; do
    if kubectl get svc/wil-playground-service -n dev >>deploy_log.log 2>>deploy_error_log.log; then
        echo "${up}     ${bold}Waiting Wil-playground deployement..${reset}[${green}DONE${reset}]"
        break
    else
        sleep 5
    fi
done
echo "===================================================="
echo "${green}${bold}             Everything is installed !${reset}"
echo "===================================================="
echo " To access ArgoCD, open a browser and go here :"
echo "  ${blue}${bold}https://localhost:30000 ${reset}"
echo " To access Wil-playground, open a browser and go here :"
echo "  ${blue}${bold}http://localhost:8888 ${reset}"
echo "===================================================="
