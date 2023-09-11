# Inception_of_things
Welcome to the "Inception-of-Things (IoT)" project. Ft_nm is a project undertaken as part of the 42 school curriculum, a minimal introduction to Kubernetes. It's a deep dive into system administration, leveraging technologies such as K3S, K3D, Vagrant, and Argo CD to set up a virtual environment and deploy web applications.

**Developed and tested on a Linux Ubuntu 23.04.**

----

## Prerequisites
Ensure you have the following tools installed:

**Before installing tools**
````
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install curl
````

**Vagrant / virtualbox**
````
sudo apt-get install vagrant libvirt-daemon-system libvirt-clients virtualbox -y
````

**K3S**
````
curl -sfL https://get.k3s.io | sh -
````

**Kubectl**
````
sudo curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
````

**K3D**
````
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
````

**Docker**
````
sudo apt-get install -y ca-certificates gnupg
sudo install -y -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
````

----

## The project

**First, you have to git clone the project :**
````
git clone https://github.com/jmbertin/Inception_of_things
cd Inception_of_things
````

**General commands :**

- Connect to a virtual machine with ssh :
``sudo vagrant ssh [machine_name]``

- Cleaning :
``./scripts/clean.sh``


### Part 1: Setting up with K3S and Vagrant
Set up two machines with distinct roles: server and server worker, with the specifications outlined below:

- Operating System: Latest stable version of your choice
- Resources: 1 CPU, 512 MB to 1024 MB of RAM (minimum)
- Machine Names: Your login followed by "S" for the server and "SW" for the server worker
- IP Addresses: 192.168.56.110 (server), 192.168.56.111 (server worker)
- K3S Installation: Controller mode (server), Agent mode (server worker)
- Additional Setup: SSH access without a password, kubectl installation

````
cd p1
sudo vagrant up
````

### Part 2 : Deploying Applications with K3S
In this part, you will deploy three web applications in your K3S instance, accessible based on the HOST used in the request. The applications should have different versions (v1 and v2) available on Dockerhub. You can use the ready-made application available (wil-app) or create your own.

**Usage :**
````
cd p2
./scripts/editHosts.sh
sudo vagrant up
````

### Part 3: Setting up K3D and Argo CD
Transition from Vagrant to K3D, setting up a minimalistic version of K3S on your virtual machine. Understand the differences between K3S and K3D and set up a continuous integration infrastructure with two namespaces:

**Argo CD Namespace**: Dedicated to Argo CD
**Dev Namespace**: Contains an application deployed automatically by Argo CD using your GitHub repository

**Usage :**
````
cd p3
./scripts/install.sh
./scripts/deploy.sh
````


### Bonus part : Integrating GitLab
As an extra step, add GitLab to the lab created in part 3, enhancing the functionality of your setup.

**Usage :**
````
cd bonus
./install.sh
./deploy.sh
````
**Cleaning :**
``./cleaningBonus.sh``

----

## Contribution
If you encounter any bugs or wish to add features, please feel free to open an issue or submit a pull request.

----

**Authors are:**
- [Julien Branchet](https://github.com/blablupo)
- [Jean-michel Bertin](https://github.com/jmbertin)
