
yum install httpd php -y
yum install gcc glibc glibc-common -y
yum install gd gd-devel -y

adduser nagios
yes nagios | passwd nagios

groupadd nagioscmd
usermod -a -G nagioscmd nagios
usermod -a -G nagioscmd apache

mkdir ~/downloads
cd ~/downloads


wget https://sourceforge.net/projects/nagios/files/nagios-4.x/nagios-4.0.8/nagios-4.0.8.tar.gz/download?use_mirror=udomain
wget https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz

tar zxvf nagios-4.0.8.tar.gz
cd nagios-4.0.8

./configure --with-command-group=nagioscmd
make all


make install -y
make install-init -y
make install-config -y
make install-commandmode -y


make install-webconf -y

htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
service httpd restart


cd ~/downloads
tar zxvf nagios-plugins-2.0.3.tar.gz
cd nagios-plugins-2.0.3

./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install -y


chkconfig --add nagios
chkconfig nagios on

/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

service nagios start
service httpd restart
