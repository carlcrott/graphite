#!/bin/bash
## Example:
#./build_minions.sh 5 testinstance

# set node type 
echo gce-n1-standard-1: > cloud.map

# iterate for each node
for i in `seq 1 $1`; do
    printf "    - %s-%02d\n" ${2} ${i} >> cloud.map
done

# include monitoring node
echo "    - $2-monitor" >> cloud.map

# persist minion name
echo "${2}" > minion_name

## Deploy instances
yes | sudo salt-cloud -P -m cloud.map


# write out configs for general usage / parsing
#salt '*' network.ip_addrs --out=json --static > minion_metadata.json

# once the mpi list is built out pull it onto all the minions
#salt '*' state.highstate -l debug

## test connectivity
# salt '*' test.ping

## run remote commands
# salt '*' cmd.run 'uname -a'

## install dependencies
#salt '*' state.highstate -l all
#salt-call -l debug state.highstate


