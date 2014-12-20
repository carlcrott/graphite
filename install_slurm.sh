#!/bin/bash

echo "------------------------------------------"
echo " Install SLURM on: $MINION_NAME "
echo "------------------------------------------"

# Set variables for accessing minion names
MINION_NAME=$(cat minion_name)
CONTROL_MINION=$MINION_NAME"-01"
echo "control minion: $CONTROL_MINION"

salt "$MINION_NAME-*" cmd.run 'apt-get -y install slurm-llnl'

# Create the munge key on the controller
# https://computing.llnl.gov/linux/slurm/quickstart_admin.html
salt $CONTROL_MINION cmd.run 'sudo /usr/sbin/create-munge-key'
salt $CONTROL_MINION cmd.run 'cat /etc/munge/munge.key'

# push munge.key from minion to master
salt $CONTROL_MINION cp.push /etc/munge/munge.key -l all -t 60
#salt '*' cp.push /etc/munge/munge.key


if [ -f /var/cache/salt/master/minions/$CONTROL_MINION/files/etc/munge/munge.key ]; then
    ls /var/cache/salt/master/minions/$CONTROL_MINION/files/etc/munge/munge.key
else
    echo "=== MISSING munge.key ==="
    exit
fi

# move
mv /var/cache/salt/master/minions/$CONTROL_MINION/files/etc/munge/munge.key /srv/salt

# copy key over to the other minions
salt "$MINION_NAME-*" cp.cache_file salt://munge.key
salt "$MINION_NAME-*" cmd.run 'mv /var/cache/salt/minion/files/base/munge.key /etc/munge'
salt "$MINION_NAME-*" cmd.run 'chown munge /etc/munge/munge.key'

# verify placement + ownership
salt "$MINION_NAME-*" cmd.run 'chmod 400 /etc/munge/munge.key'
salt "$MINION_NAME-*" cmd.run 'stat /etc/munge/munge.key'

cd master_scripts/

## build the specifics of this SLURM configuration
cat ../minion_metadata.json | python build_slurm_configuration_top.py > /srv/salt/slurm.conf

envsubst <<EOF >> /srv/salt/slurm.conf
MpiDefault=none
ProctrackType=proctrack/pgid
ReturnToService=1
SlurmctldPidFile=/var/run/slurmctld.pid
SlurmdPidFile=/var/run/slurmd.pid
SlurmdSpoolDir=/var/spool/slurmd
SlurmUser=slurm
StateSaveLocation=/var/spool
SwitchType=switch/none
TaskPlugin=task/none

# SCHEDULING
FastSchedule=1
SchedulerType=sched/backfill
SelectType=select/linear

# LOGGING AND ACCOUNTING
AccountingStorageType=accounting_storage/none
ClusterName=cluster
JobAcctGatherType=jobacct_gather/none
EOF

cat ../minion_metadata.json | python build_slurm_configuration_bottom.py >> /srv/salt/slurm.conf

cd ..

# TODO: build into salt states
salt "$MINION_NAME-*" cp.cache_file salt://slurm.conf
salt "$MINION_NAME-*" cmd.run 'mv /var/cache/salt/minion/files/base/slurm.conf /etc/slurm-llnl/slurm.conf'


salt "$MINION_NAME-*" cmd.run 'cat /etc/slurm-llnl/slurm.conf'
salt "$MINION_NAME-*" cmd.run 'chown slurm /etc/slurm-llnl/slurm.conf'

salt $CONTROL_MINION cmd.run 'killall slurmctld && slurmctld &'

# start MUNGE
echo "starting munge:"
salt "$MINION_NAME-*" cmd.run '/etc/init.d/munge start'

# verify munge
# https://code.google.com/p/munge/wiki/InstallationGuide
salt "$MINION_NAME-*" cmd.run 'munge -n'
#salt "$MINION_NAME-*" cmd.run 'munge -n | unmunge'
#salt $MINION_NAME* cmd.run 'munge -n | ssh 10.208.170.111 unmunge'
#salt "$MINION_NAME-*" cmd.run 'remunge'


# configure controller
salt $CONTROL_MINION cmd.run 'mkdir /var/spool/slurmd'
salt $CONTROL_MINION cmd.run 'sudo chown slurm /var/spool'

# on the servers / nodes
salt "$MINION_NAME-*" cmd.run 'sudo /etc/init.d/slurm-llnl start'



# start slurm on processing nodes
salt "$MINION_NAME-*" cmd.run 'sudo /etc/init.d/slurm-llnl stop && sudo /etc/init.d/slurm-llnl start'

# on the controller
#salt $CONTROL_MINION cmd.run 'sudo slurmctld -Dcvvvv &'
salt $CONTROL_MINION cmd.run 'sudo slurmctld &'
#salt $CONTROL_MINION cmd.run 'scontrol ping'

salt $CONTROL_MINION cmd.run 'sinfo'

### Running Tests
#envsubst <<EOF > /srv/salt/slurm.out
##!/bin/bash
##SBATCH -p debug
##SBATCH -A slurm
##SBATCH -n 4
##SBATCH --ntasks-per-node=3
##SBATCH -t 12:00:00
##SBATCH -J some_job_name
#sleep 300
#EOF

salt $CONTROL_MINION cp.cache_file salt://slurm.out
salt $CONTROL_MINION cmd.run 'mv /var/cache/salt/minion/files/base/slurm.out /root/'


#salt $CONTROL_MINION cmd.run 'sudo slurmctld &'
#salt $CONTROL_MINION cmd.run 'sbatch slurm.out'
#salt $CONTROL_MINION cmd.run 'squeue'


salt "$MINION_NAME-*" cmd.run 'sudo /etc/init.d/slurm-llnl stop && sudo /etc/init.d/slurm-llnl start'


sleep 4 # prevents us from showing unk on the final sinfo command

echo "to verify installation: NODES count should equal total minion count -1"
salt $CONTROL_MINION cmd.run 'sinfo'

