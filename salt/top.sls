base:
  '*':
    - compute
    - curl
    - quantum_espresso
    - openmpi
    - shared_sshkeys
  '*-01':
    - quantum_espresso_control
    - openmpi