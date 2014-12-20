#!/bin/bash

## since we're not using the tutorial in which the entirety of the machine is cloned
# we need to copy the keys over to the directory where they're accessible to the minions

## test one
salt '*' cmd.run 'wget http://svn.open-mpi.org/svn/ompi/tags/v1.6-series/v1.6.4/examples/hello_c.c && mpicc hello_c.c -o hello'
salt '*' cmd.run 'mpicc hello_c.c -o hello'
salt '*' cmd.run 'mpirun ./hello'

## test two
salt '*' cmd.run 'wget http://svn.open-mpi.org/svn/ompi/tags/v1.6-series/v1.6.4/examples/connectivity_c.c'
salt '*' cmd.run 'mpicc connectivity_c.c -o connectivity'
salt '*' cmd.run 'mpirun ./connectivity'

## test connectivity
salt '*' cmd.run 'mpirun -v -np 2 --hostfile mpi_hosts ./connectivity'


## pick the first instance to act as the main mpi node
salt '*-01' cmd.run 'for i in `cat mpi_hosts`; do ssh root@$i "curl -l http://openstack.prov12n.com/files/tachyon.sh | bash"; done'

## run single processing node
salt '*-01' cmd.run 'cd /root/tachyon/compile/linux-mpi && ./tachyon ../../scenes/teapot.dat'

## run all processing nodes from primary MPI node
salt '*-01' cmd.run 'cd /root/tachyon/compile/linux-mpi && mpirun -np 4 --hostfile /root/mpi_hosts ./tachyon /root/tachyon/scenes/teapot.dat -format BMP'
