# System misc configuration
cdrom
text
eula --agreed
lang en-US
keyboard us
network --bootproto=dhcp --device=ens192 --noipv6 --activate
firewall --disabled

# User configuration
rootpw "${build_password}"
user --groups=wheel --name=miked --uid=340 --gid=340 --password="${build_password}"

### Sets up the authentication options for the system.
### The SSDD profile sets sha512 to hash passwords. Passwords are shadowed by default
### See the manual page for authselect-profile for a complete list of possible options.
authselect select sssd

selinux --disabled
timezone UTC

# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda --timeout=30
# Partition clearing information
zerombr
clearpart --all --initlabel
part /boot/efi --fstype=efi --ondisk=sda --size 512 --fsoptions="umask=0077,shortname=winnt"
part /boot --fstype=ext4 --ondisk=sda --size 512
part / --fstype=ext4 --ondisk=sda --size=31700

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
%end

reboot --eject