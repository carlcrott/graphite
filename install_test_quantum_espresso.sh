#!/bin/bash

echo "------------------------------------------"
echo " Install QE-5.0.2 "
echo "------------------------------------------"
cd
apt-get -y install gfortran
wget http://master.exabyte.io/api/file/localhost//exabyte/apps/_tar/espresso-5.0.2.tar.gz?download=true 
mv espresso-5.0.2.tar.gz?download=true espresso-5.0.2.tar.gz
tar -xvf espresso-5.0.2.tar.gz 
cd espresso-5.0.2/
./configure
wget http://0baec9afc0558ac86084-b228c0c1ee57108673cafb198e238e84.r52.cf5.rackcdn.com/pw.x 
mv pw.x /root/espresso-5.0.2/PW/src/
make
make pwall
#cd PW/tests/
#./check-pw.x.j
