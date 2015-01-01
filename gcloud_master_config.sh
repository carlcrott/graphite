#!/bin/sh




###
# Install salt dependencies
###
apt-get -y install curl sshpass
sh bootstrap-salt.sh -M -N git v2014.1.0
apt-get -y install python-dev build-essential
apt-get -y install python-pip
pip install pycrypto==2.6.1

# Install libcloud
if [ ! -d src/apache-libcloud/ ]; then
  # Clone repo, reset to specific working sha and install with pip
  cd ~/ && git clone git@github.com:apache/libcloud.git && cd libcloud
  git reset --hard 0486f77e7b3c6a70ce11fff45401b8d3767876bc && cd .. && pip install git+file:/root/libcloud

  # OPTIONAL: install libcloud trunk using github tag
  # pip install -e git+https://git-wip-us.apache.org/repos/asf/libcloud.git@trunk#egg=apache-libcloud

  # OPTIONAL: install libcloud 0.16.0 using github tag
  # pip install -e git+https://git-wip-us.apache.org/repos/asf/libcloud.git@v0.16.0#egg=apache-libcloud
fi





###
# Verify salt dependency versions ( working versions )
###
salt --versions-report
       #           Salt: 2014.1.0
       #         Python: 2.7.3 (default, Feb 27 2014, 19:58:35)
       #         Jinja2: 2.6
       #       M2Crypto: 0.21.1
       # msgpack-python: 0.1.10
       #   msgpack-pure: Not Installed
       #       pycrypto: 2.6.1
       #         PyYAML: 3.10
       #          PyZMQ: 13.0.0
       #            ZMQ: 3.2.2
python -c "import libcloud ; print libcloud.__version__" 
       # 0.16.0




###
# Salt master configurations
###

# Ensure firewall ports are open for salt
ufw allow 4505
ufw allow 4506

# Restart salt-master
pkill salt-master && salt-master -d

# Auto configure salt-master IP from localmachine IP
CURRENT_IP=$(ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')

envsubst <<EOF > /etc/salt/cloud
providers:
  gce-config:

    project: "black-inf"
    service_account_email_address: "845929625302-f5dqut87aipunjgl2jhq5lgvjbv7c2ul@developer.gserviceaccount.com"
    service_account_private_key: "/root/.ssh/black-d214749bfe98.pem"
    provider: gce

    ssh_username: ubuntu
    ssh_keyfile: /root/.ssh/id_rsa
EOF

envsubst <<EOF > /etc/salt/cloud.profiles
gce-n1-standard-1:
  minion:
    master: $CURRENT_IP
  image: ubuntu-1204-precise-v20141031
  size: n1-standard-1
  location: us-central1-a
  network: default
  tags: '[ "http-server", "https-server", "minion", "salt"]'
  metadata: '{"sshKeys": "ubuntu: $(cat /root/.ssh/id_rsa.pub) "}'
  use_persistent_disk: False
  delete_boot_pd: True
  deploy: True
  make_master: False
  provider: gce-config


master_gce-n1-standard-1:
  image: ubuntu-1204-precise-v20141031
  size: n1-standard-1
  location: us-central1-a
  network: default
  tags: '[ "http-server", "https-server", "minion", "salt"]'
  metadata: '{"sshKeys": "ubuntu: $(cat /root/.ssh/id_rsa.pub) "}'
  use_persistent_disk: False
  delete_boot_pd: True
  deploy: True
  make_master: True
  provider: gce-config
EOF


# Place master config
cp ~/graphite/salt/master /etc/salt/master
# Place minion config
cp ~/graphite/salt/minion /etc/salt/minion


# Default formula dir structure and parents
mkdir -p /srv/formulas/ && cd /srv/formulas/
# Clone the graphite formula
git clone https://github.com/saltstack-formulas/graphite-formula /srv/formulas/graphite


# Default location for salt state files
mkdir -p /srv/salt/
cp ~/graphite/salt/*.sls /srv/salt/

# Default location for salt state files
mkdir -p /srv/pillar/

# Make pillar topfile
envsubst <<EOF > /srv/pillar/top.sls
base:
  '*-monitor':
    - graphite
EOF

# Make graphite pillar file
envsubst <<EOF > /srv/pillar/graphite.sls
# this example illustrates key you can overwrite in pillar (or grains)
# the values given here are the default ones already included

graphite:
  config:
    port: 2003
    pickle_port: 2004
    dbtype: sqlite3
    dbname: '/opt/graphite/storage/graphite.db'
    dbuser: 'test'
    dbpassword: 'test'
    dbhost: '127.0.0.1'
    dbport: '8080'
    admin_user: 'admin'
    admin_password: 'pbkdf2_sha256$10000$wZuRMciV2VKr$OAtsP+BksbR2DPQUEsY728cbIJmuYf4uXg4tLLGsvi4='
    admin_email: 'admin@example.com'
    max_creates_per_minute: 50
    max_updates_per_second: 500

# a mysql example
    #dbtype: mysql
    #dbname: 'graphite'
    #dbuser: 'graphite'
    #dbpassword: 'graphite'
    #dbhost: 'localhost'
    #dbport: '3306'
    #admin_user: 'admin'
    #admin_password: 'pbkdf2_sha256$10000$wZuRMciV2VKr$OAtsP+BksbR2DPQUEsY728cbIJmuYf4uXg4tLLGsvi4='
    #admin_email: 'admin@example.com'
EOF



#mkdir -p /srv/

#mkdir /etc/salt/
# place master config
#cp ~/graphite/salt/master /etc/salt/


# # place rackspace profiles
# mkdir /etc/salt/cloud.profiles.d
# cp ~/graphite/salt/cloud.profiles.d/gcloud.conf /etc/salt/cloud.profiles.d/



# ### Misc openmpi installs
# cd master_scripts
# salt \* network.ip_addrs >> ../raw_out
# MPI_HOSTS=$(cat raw_out | python salt_ip_parser.py)
# echo "$MPI_HOSTS" > /srv/salt/mpi_hosts
# cd ..


# ## Configuring SSH for master + minions
# mkdir /srv/salt/.ssh/  # corresponding minion dir

# # Configuring SSH for master + minions
# mkdir /srv/salt/etc/ && mkdir /srv/salt/etc/ssh/
# cp /etc/ssh/ssh_config /srv/salt/etc/ssh/ # corresponding minion conf

# # Copy the key to authorized key folder and change permissions to allow SSH logins:
# cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

# cp ~/.ssh/id_rsa* /srv/salt/.ssh/ # copy keys for minions

# Restart salt-master
pkill salt-master && salt-master -d



