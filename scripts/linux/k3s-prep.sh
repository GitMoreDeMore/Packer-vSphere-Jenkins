#---- Updates ----
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Add the Docker CE repository
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install containerd
dnf install -y containerd.io

# Generate and save the default containerd configuration
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null