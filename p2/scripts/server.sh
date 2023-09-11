echo "[SCRIPT] Installing K3s on server node..."

export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1 > /dev/null 2>&1"

curl -sfL https://get.k3s.io |  sh - > /dev/null 2>&1
echo "[SCRIPT] K3s installed successfully !"

echo "[SCRIPT] Waiting for K3s to be ready..."
until kubectl cluster-info >/dev/null 2>&1; do
  sleep 2
done
echo "[SCRIPT] K3s is ready !"

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

echo "[SCRIPT] Deploying app 1..."
kubectl apply -f /vagrant/conf/app1.yml > /dev/null 2>&1;
echo "[SCRIPT] App 1 deployed successfully !"

echo "[SCRIPT] Deploying app 2..."
kubectl apply -f /vagrant/conf/app2.yml > /dev/null 2>&1;
echo "[SCRIPT] App 2 deployed successfully !"

echo "[SCRIPT] Deploying app 3..."
kubectl apply -f /vagrant/conf/app3.yml > /dev/null 2>&1;
echo "[SCRIPT] App 3 deployed successfully !"

echo "[SCRIPT] Deploying ingress..."
kubectl apply -f /vagrant/conf/ingress.yml > /dev/null 2>&1;
echo "[SCRIPT] Ingress deployed successfully !"

echo "[SCRIPT] Waiting for all pods to be running..."
while [ $(kubectl get pods --all-namespaces --field-selector=status.phase=Running 2>/dev/null | grep app- | wc -l) -ne 5 ]; do
  sleep 5
done
echo "[SCRIPT] All pods are running !"

echo "[SCRIPT] Waiting for applications to be operational..."
until $(curl --output /dev/null --silent --head --fail http://app1.com); do
    sleep 5
done
echo "[SCRIPT] Applications are operational !"

echo "[SCRIPT] All apps deployed and running !"
echo "[SCRIPT] You can access the apps at http://app1.com or http://app2.com or http://192.168.56.110"
