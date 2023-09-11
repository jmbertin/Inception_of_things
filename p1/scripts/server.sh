echo "[SCRIPT] Installing K3s on server node (IP : $1)..."
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1 > /dev/null 2>&1"
curl -sfL https://get.k3s.io |  sh - > /dev/null 2>&1
echo "[SCRIPT] K3s installed successfully on server node !"

echo "[SCRIPT] Waiting for K3s to be ready..."
until kubectl cluster-info >/dev/null 2>&1; do
  sleep 2
done
echo "[SCRIPT] K3s is ready !"

sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/scripts/
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

echo 'GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"' | sudo tee -a /etc/default/grub > /dev/null 2>&1
sudo grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1

echo "[SCRIPT] Creating post-reboot script..."
echo '#!/bin/bash' > /home/vagrant/post_reboot.sh
echo 'echo "[SCRIPT] Waiting for all nodes to be ready..."' >> /home/vagrant/post_reboot.sh
echo '
until [ "$(kubectl get nodes --no-headers 2>/dev/null | grep -c " Ready")" -eq 2 ]; do
  sleep 2
done
' >> /home/vagrant/post_reboot.sh
echo 'echo "[SCRIPT] All nodes are ready !"' >> /home/vagrant/post_reboot.sh
echo 'sudo update-rc.d -f post_reboot.sh remove' >> /home/vagrant/post_reboot.sh
echo 'sudo rm -f /etc/init.d/post_reboot.sh' >> /home/vagrant/post_reboot.sh
echo 'echo "[SCRIPT] post_reboot.sh removed successfully !"' >> /home/vagrant/post_reboot.sh

chmod +x /home/vagrant/post_reboot.sh
sudo mv /home/vagrant/post_reboot.sh /etc/init.d/
sudo update-rc.d post_reboot.sh defaults

echo "[SCRIPT] Post-reboot script created successfully!"

echo "[SCRIPT] Rebooting server node..."
sudo reboot

