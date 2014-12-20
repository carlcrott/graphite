# workarounds for zeroMQ from:
# http://docs.saltstack.com/en/latest/topics/troubleshooting/#salt-master-stops-responding
net.core.rmem_max:
  sysctl:
    - present
    - value: 16777216

net.core.wmem_max:
  sysctl:
    - present
    - value: 16777216

net.ipv4.tcp_rmem:
  sysctl:
    - present
    - value: 4096 87380 16777216

net.ipv4.tcp_wmem:
  sysctl:
    - present
    - value: 4096 87380 16777216


# defaults: http://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html

/etc/salt/minion:
  file:
    - managed
    - source: salt://minion

