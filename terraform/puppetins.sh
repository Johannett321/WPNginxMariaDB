# Update package list
apt-get update -y
# Installs puppet-agent
curl -LO https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i ./puppet7-release-focal.deb
apt update
apt-get install puppet-agent -y
sudo echo -e "[main]\ncertname = $(hostname).kube\nserver = puppetmaster.kube" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
sh -c 'echo "212.162.146.108 puppetmaster.kube puppetmaster" >> /etc/hosts'
#systemctl start puppet
sudo /opt/puppetlabs/bin/puppet agent -t --waitforcert 180
