# Installation:

#### SSH into server + clone over git repo:
<pre>
$ nano init.sh && chmod 0755 init.sh
</pre>

##### Paste the below contents into init.sh:

<pre>
echo -n github username: 
read GITHUB_USERNAME

echo -n password: 
read -s GITHUB_PASSWORD

GITHUB_AUTH_STRING=($GITHUB_USERNAME":"$GITHUB_PASSWORD)

sudo apt-get -y update
sudo apt-get -y install git curl

ssh-keygen -t rsa -f /root/.ssh/id_rsa -C $GITHUB_USERNAME -N ''

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa


echo {\"key\":\"$(cat ~/.ssh/id_rsa.pub)\"} > github_push_key.json
curl -u "$GITHUB_AUTH_STRING" -H "Content-Type: application/json" -d @github_push_key.json https://api.github.com/repos/Exabyte-io/saltstack/keys
rm github_push_key.json

echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ssh -T git@github.com

git clone git@github.com:Exabyte-io/saltstack.git
</pre>


##### Run initialization:
<pre>
$ ./init.sh
</pre>


##### Begin salt-master config:
<pre>
$ cd saltstack/
$ ./master_config.sh
</pre>

##### Provision 4 minions named "testinstance":
<pre>
$ ./build_minions.sh 4 testinstance
</pre>

##### -- OPTIONAL: Install SLURM:
<pre>
$ ./install_slurm.sh
</pre>

##### -- OPTIONAL: Test cluster functionality with Tachyon:
<pre>
$ ./install_test_tachyon.sh
</pre>
