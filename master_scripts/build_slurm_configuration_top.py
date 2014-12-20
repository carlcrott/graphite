## Common usage takes input from our formatted JSON file:
# cat minion_metadata.json | python build_slurm_configuration_top.py
## Expects input like:
# {"geisha-04": {"internal": "10.208.202.129", "external": "23.253.250.42"}, "geisha-03": {"internal": "10.208.202.126", "external": "23.253.250.35"}, "geisha-02": {"internal": "10.208.202.128", "external": "23.253.250.33"}, "geisha-01": {"internal": "10.208.202.97", "external": "23.253.250.29"}}


import sys
import json

data = json.load(sys.stdin)

output_config = []
node_count =[]

for i in data:
    if i.find("-01") != -1:
        instance_name = i.split("-")[0]
        output_config.append("ControlMachine={0}".format(i))
        output_config.append("ControlAddr={0}".format(data[i][0]))

output = "\n".join(output_config)

print output
