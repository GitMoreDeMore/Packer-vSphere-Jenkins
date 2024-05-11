#---- Updates ----
dnf install epel-release -y
dnf install -y sudo open-vm-tools perl dnf-utils wget vim python3 dnf-plugins-core jq curl
dnf upgrade -y
dnf update -y
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

#---- Remove host keys and machine-id ----
rm -f /etc/ssh/*key*;
rm -f /etc/machine-id
touch /etc/machine-idsyes