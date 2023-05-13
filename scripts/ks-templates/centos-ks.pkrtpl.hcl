cdrom
text
eula --agreed
lang en-US
keyboard us
network --bootproto=dhcp
rootpw ${build_password}
firewall --disabled

### Sets up the authentication options for the system.
### The SSDD profile sets sha512 to hash passwords. Passwords are shadowed by default
### See the manual page for authselect-profile for a complete list of possible options.
authselect select sssd

selinux --disabled
timezone UTC

# System bootloader configuration
bootloader --append=" crashkernel=auto" --boot-drive=sda
# Partition clearing information
zerombr
clearpart --all --initlabel
part /boot/efi --fstype=efi --ondisk=sda --size 511
part /boot --fstype=ext4 --ondisk=sda --size 511
part swap --fstype=swap --ondisk=sdb --size=16383
part / --fstype=ext4 --ondisk=sdc --size=16383
part /var --fstype=ext4 --ondisk=sdd --size=16383

### Modifies the default set of services that will run under the default runlevel.
services --enabled=sshd

### Do not configure X on the installed system.
skipx

### Packages selection.
%packages --ignoremissing --excludedocs
@core
-iwl*firmware
%end

### Post-installation commands.
%post

yum install epel-release -y
yum install -y sudo open-vm-tools perl yum-utils wget vim
yum upgrade -y
yum update -y
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

%end

reboot --eject