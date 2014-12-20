## Expects input like
# ['testinstance-01:\n', '    - 10.208.169.158\n', '    - 23.253.231.13\n', 'testinstance-02:\n', '    - 10.208.201.190\n', '    - 23.253.248.231\n']


import sys
data = sys.stdin.readlines()

# infer instance names from first line of input
instance_name = data[0].split("-")[0]
joined = "".join(data).strip().replace("\n","")

salt_ip_string = joined.split(instance_name)

# clean whitespaces
salt_ip_string = filter(None, salt_ip_string) 

for ip in salt_ip_string:
    print ip.split("-")[2].strip()




