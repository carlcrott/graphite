#!/bin/sh

salt \* network.ip_addrs >> raw_out
MPI_HOSTS=$(cat raw_out | python master_scripts/salt_ip_parser.py)
echo "$MPI_HOSTS" > /srv/salt/mpi_hosts

## Configuring SSH for master + minions
mkdir /srv/salt/.ssh/  # corresponding minion dir

# Configuring SSH for master + minions
mkdir /srv/salt/etc/ && mkdir /srv/salt/etc/ssh/
cp /etc/ssh/ssh_config /srv/salt/etc/ssh/ # corresponding minion conf

# Copy the key to authorized key folder and change permissions to allow SSH logins:
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

cp ~/.ssh/id_rsa* /srv/salt/.ssh/ # copy keys for minions

# # make ssh dir + gen key
# mkdir ~/.ssh 
# chmod 700 ~/.ssh
# echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -C "Open MPI"

# Copy the key to authorized key folder and change permissions to allow SSH logins:
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
