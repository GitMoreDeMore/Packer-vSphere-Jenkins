#---- Install miked SSH key ----
mkdir -p /home/miked/.ssh
chmod 0700 /home/miked/.ssh
chown -R miked:miked /home/miked/.ssh

cat > /home/miked/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXxCqdsznp83xtyuEHw6zi048VT8k5BH9lxqSIpDJugZcNWwTlq7PaslAZ1tHCHc5LtsKqf0Z7CTpMvMhT+j6q7s+XK6jfBLz1e571hhrsll0w+JOxbs0PSAh2iZbxe7S4HzeLd0ueaPSt2oX5JbBQP1YLH7vD+0K1iBIJTaLug0UH3IF59rqovjfmSl/zQ7hXfSFWjbLFGbjXadfz/MFci2uDlRav29TU3uYCZHfktKcSEcp/R0JjrJFqH9iEQ63C4kJ808wtLnBNoyPWet5E7UgTB9Ssj0QutgJHwGN3llrKcuN7b91+ob8mNWJAUWaR6P5ExpDbi9IU11bbR/b3h05R81WlS5E7Wc5YyFSVRkdw8+wfPndt+o3zzPdHw3AmHTbcH1/iFrth7uhxFHLbcWcfXja909SdTS9LZPrTz0LAl/TGKjGX1okWYNpT0Yql6YQ6TD8Z1YXhxCD0cmcWJr93K7O4vtsc+7GZkbycFvEydKZxWMenyFm8WbZ465c=
EOF

### set permissions
chmod 0600 /home/miked/.ssh/authorized_keys
chown -R miked:miked /home/miked/.ssh/authorized_keys
echo 'miked ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/miked
chmod 0440 /etc/sudoers.d/miked
