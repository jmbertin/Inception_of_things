sudo k3d cluster stop mycluster-iot
sudo k3d cluster delete mycluster-iot
sudo rm -rf iot
sudo rm *.log
sudo docker compose down
sudo docker system prune -a -f
sed -i 's/^    repoURL: http:\/\/.*/    repoURL: http:\/\/localhost:9999\/root\/iot.git/' conf/appli.yaml
clear
