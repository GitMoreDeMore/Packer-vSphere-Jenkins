# #---- Remove host keys and machine-id ----
# rm -f /etc/ssh/*key*;
# rm -f /etc/machine-id
# touch /etc/machine-id

# #---- Install miked SSH key ----
# mkdir -p /home/miked/.ssh
# chmod 0700 /home/miked/.ssh
# chown -R miked:miked /home/miked/.ssh

# cat > /home/miked/.ssh/authorized_keys << EOF
# EOF

# ### set permissions
# chmod 0600 /home/miked/.ssh/authorized_keys
# chown -R miked:miked /home/miked/.ssh/authorized_keys
# echo 'miked ALL=(ALL) ALL' > /etc/sudoers.d/miked
# chmod 0440 /etc/sudoers.d/miked
# chmod 0600 /home/ptadmin/.ssh/authorized_keys