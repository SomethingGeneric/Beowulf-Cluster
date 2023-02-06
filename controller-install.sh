# SSH-Keys
if [ ! -f $HOME/.ssh/id_rsa ]; then
  ssh-keygen -q
fi

# Set hostname
if [ "$HOSTNAME" != controller ]; then
  sudo hostnamectl set-hostname controller
fi

#Chapel Setup
wget https://github.com/chapel-lang/chapel/releases/download/1.29.0/chapel-1.29.0.tar.gz
tar xzf chapel-1.29.0.tar.gz
cd chapel-1.29.0
source util/setchplenv.bash
sudo make
./util/printchplenv
export CHPL_COMM=gasnet
sudo make
chpl -o hello $CHPL_HOME/examples/hello6-taskpar-dist.chpl
export GASNET_SPAWNFN=S

echo 'export GASNET_SSH_SERVERS="host1 host2 host3 ..."'

# IP Address
echo "Subnet #: "  
read subnet  
ip addr | grep /$subnet | awk {'print $1'}
