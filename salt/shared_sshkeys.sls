
/root/.ssh:
  file.directory:
    - dir_mode: 700  

/etc/ssh/ssh_config:
  file:
    - managed
    - source: salt://etc/ssh/ssh_config

/root/.ssh/id_rsa:                        # ID declaration
  file:                                     # state declaration
    - managed                               # function
    - source: salt://.ssh/id_rsa
    - mode: 600

/root/.ssh/id_rsa.pub:                        # ID declaration
  file:                                     # state declaration
    - managed                               # function
    - source: salt://.ssh/id_rsa.pub

/root/.ssh/authorized_keys:                        # ID declaration
  file:                                     # state declaration
    - managed                               # function
    - source: salt://.ssh/id_rsa.pub
    - mode: 600
