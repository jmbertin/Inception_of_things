echo "[SCRIPT] Installing k3s on server worker node (IP: $2)..."

export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file /vagrant/scripts/node-token --node-ip=$2"
curl -sfL https://get.k3s.io | sh - > /dev/null 2>&1
echo "[SCRIPT] K3s installed successfully on server worker node !"

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

echo 'GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"' | sudo tee -a /etc/default/grub > /dev/null 2>&1
sudo grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1

echo "[SCRIPT] Rebooting server worker to changing interface name..."
sudo reboot
