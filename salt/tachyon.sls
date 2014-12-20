
build-essential:
  pkg.installed

openmpi-bin:
  pkg.installed:
    - version: 1.4.3-2.1ubuntu3

openmpi-checkpoint:
  pkg.installed:
    - version: 1.4.3-2.1ubuntu3

openmpi-common:
  pkg.installed:
    - version: 1.4.3-2.1ubuntu3

openmpi-doc:
  pkg.installed:
    - version: 1.4.3-2.1ubuntu3

libopenmpi-dev:
  pkg.installed:
    - version: 1.4.3-2.1ubuntu3
    

/root/mpi_hosts:                        # ID declaration
  file:                                     # state declaration
    - managed                               # function
    - source: salt://mpi_hosts


