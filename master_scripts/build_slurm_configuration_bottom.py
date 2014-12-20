## Common usage takes input from our formatted JSON file:
# cat minion_metadata.json | python build_slurm_configuration.py

import sys
import json

data = json.load(sys.stdin)



output_config = []
node_count =[]

for i in data:
    output_config.append("") 

for i in data:
    if i.find("-01") == -1:
        instance_name = i.split("-")[0]
        instance_count = int( i.split("-")[1] )
        node_count.append(i.split("-")[1])
        
        output_config[instance_count-1] = "NodeName={0} NodeAddr={1} CPUs=4 Sockets=1 CoresPerSocket=2 ThreadsPerCore=2".format(i, data[i][0])

output_config.insert(0, "PartitionName=debug Nodes={0}-[{1}] Default=YES MaxTime=INFINITE State=UP".format( instance_name, ",".join(sorted(node_count)) ))

# get instance names
# pop off *-01 name + ip
# iterate through remaining minions 


output = "\n".join(output_config)

print output

## verify
#junk = open('data.txt')
#final_data = json.load(junk)
#print "==================="
#print final_data['ghengis-02']['external']
#print final_data['ghengis-02']['internal']

#print"""
#ControlMachine={0}
#ControlAddr=

#PartitionName=debug Nodes=slurm-[02,03,04] Default=YES MaxTime=INFINITE State=UP

#NodeName=slurm-02 NodeAddr=10.208.170.105 CPUs=4 Sockets=1 CoresPerSocket=2 ThreadsPerCore=2
#NodeName=slurm-03 NodeAddr=10.208.170.94 CPUs=4 Sockets=1 CoresPerSocket=2 ThreadsPerCore=2
#NodeName=slurm-04 NodeAddr=10.208.170.111 CPUs=4 Sockets=1 CoresPerSocket=2 ThreadsPerCore=2
#""".format()
