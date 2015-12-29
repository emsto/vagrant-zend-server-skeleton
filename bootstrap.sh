#!/usr/bin/env bash

printf '%s\n%s\n' '# Zend Server' 'deb http://repos.zend.com/zend-server/8.5/deb_apache2.4 server non-free' > /etc/apt/sources.list.d/zend.list
wget http://repos.zend.com/zend.key -O- | apt-key add -

wget https://repo.percona.com/apt/percona-release_0.1-3.$(lsb_release -sc)_all.deb
dpkg -i percona-release_0.1-3.$(lsb_release -sc)_all.deb
rm -f percona-release_0.1-3.$(lsb_release -sc)_all.deb
export DEBIAN_FRONTEND=noninteractive

aptitude update
aptitude install -y git percona-server-server-5.7 sendmail zend-server-php-5.6

echo 'export PATH=$PATH:/usr/local/zend/bin' >> /etc/profile.d/zend-server.sh
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/zend/lib' >> /etc/profile.d/zend-server.sh

chmod o+x /var/log/apache2
chmod o+r /var/log/apache2/{access,error}.log

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi
