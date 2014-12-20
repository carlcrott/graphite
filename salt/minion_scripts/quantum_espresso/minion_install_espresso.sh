#!/bin/bash

echo "------------------------------------------"
echo " Install QE-5.0.2 "
echo "------------------------------------------"
cd
# apt-get -y install gfortran

wget http://e31988ff25324bcc4bee-5e538a3d413df2244613eca2213dab09.r81.cf1.rackcdn.com/qe_compiled.tar.gz

tar -xvf qe_compiled.tar.gz

# make dirs && download pseudopotentials
cd ~/
mkdir ./qe-test-run
cd ./qe-test-run
mkdir ./_pseudo/
wget http://www.quantum-espresso.org/pseudo/1.3/UPF/Si.pbe-hgh.UPF
mv Si.pbe-hgh.UPF ./_pseudo

# make input file
cat > ./scf.in << EOF
&control
    calculation = 'scf'
    disk_io='low'
    title = 'New Calculation - August 12 2014 10:57:56'
    outdir='_outdir'
    prefix='pref'
    wf_collect = .false.
    pseudo_dir = '_pseudo'
    tprnfor = .true.
    tstress = .true.
/
&system
    ecutwfc = 40.0
    ecutrho = 200.0
    occupations = 'smearing'
    degauss = 0.005
    nat = 2
    ntyp = 1
    ibrav = 2
    celldm(1) = 10.2
/
&electrons
    diagonalization = 'david'
    diago_david_ndim = 4
    diago_full_acc = .true.
/
&ions
/
&cell
/
ATOMIC_SPECIES
Si  28.0855  Si.pbe-hgh.UPF
ATOMIC_POSITIONS crystal
Si 0.00 0.00 0.00
Si 0.25 0.25 0.25
K_POINTS automatic
2 2 2 0 0 0
EOF

# run QE with mpi
#mpirun -np 4 ~/espresso-5.0.2/bin/pw.x -npool 2 -in ./scf.in

