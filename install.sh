#!/bin/bash
cp /etc/apt/sources.list /etc/apt/sources.list.bck
cp config/sources.list /etc/apt/sources.list
apt-get update -y
echo "Update Repository"
apt-get -y install build-essential autoconf automake1.11 libtool flex bison debhelper binutils
service sendmail stop; update-rc.d -f sendmail remove
apt-get install nginx mariadb-client mariadb-server -y
echo "Install Web Server and Database Done"
apt-get -y install php7.2 php7.2-common php7.2-gd php7.2-mysql php7.2-imap php7.2-cli php7.2-cgi php-pear mcrypt imagemagick libruby php7.2-curl php7.2-intl php7.2-pspell php7.2-recode php7.2-sqlite3 php7.2-tidy php7.2-xmlrpc php7.2-xsl memcached php-memcache php-imagick php-gettext php7.2-zip php7.2-mbstring php-soap php7.2-soap php7.2-fpm 
echo "Install PHP Component Done"
cp /etc/php/7.2/fpm/php.ini /etc/php/7.2/fpm/php.ini.bck
cp config/php.ini /etc/php/7.2/fpm/php.ini
service php7.2-fpm reload
apt-get -y install fcgiwrap
apt-get update -y
apt-get -y install phpmyadmin php-mbstring php-gettext
echo "Install Phpmyadmin Done"
apt-get -y install postfix postfix-mysql postfix-doc openssl getmail4 rkhunter binutils dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve dovecot-lmtpd 
echo "Install Mail Server"
cp /etc/postfix/master.cf /etc/postfix/master.cf.bck
cp config/master.cf /etc/postfix/master.cf
service postfix restart
cp /etc/mysq/mariadb.conf.d/50-server.cnf /etc/mysq/mariadb.conf.d/50-server.cnf.bck
cp config/50-server.cnf  /etc/mysq/mariadb.conf.d/50-server.cnf
apt-get -y install amavisd-new spamassassin clamav clamav-daemon unzip bzip2 arj nomarch lzop cabextract apt-listchanges libnet-ldap-perl libauthen-sasl-perl clamav-docs daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl postgrey libdbd-mysql-perl
echo "Install Mail Filtering Done"
service spamassassin stop
update-rc.d -f spamassassin remove
freshclam
service clamav-daemon start
cd config
cp config/ubuntu-amavisd-new-2.11.patch /tmp/
cd /usr/sbin
cp -pf amavisd-new amavisd-new_bak
patch < /tmp/ubuntu-amavisd-new-2.11.patch
cd
apt-get -y install hhvm
apt-get -y install certbot
echo "Install Letenscrypt Generator Done"
certbot register
apt-get -y install pure-ftpd-common pure-ftpd-mysql quota quotatool
cp config/pure-ftpd-common /etc/default/pure-ftpd-common
echo 1 > /etc/pure-ftpd/conf/TLS
mkdir -p /etc/ssl/private/
chmod 600 /etc/ssl/private/pure-ftpd.pem
service pure-ftpd-mysql restart
echo "Install FTP Server Done"
cp /etc/fstab /etc/fstab.bck
cp config/fstab /etc/
mount -o remount /
quotacheck -avugm
quotaon -avug
apt-get -y install bind9 dnsutils haveged
echo "Install DNS Server Done"
apt-get -y install vlogger webalizer awstats geoip-database libclass-dbi-mysql-perl
cp config/awstats /etc/cron.d/awstats
cd config/jailkit-2.19
echo 5 > debian/compat
./debian/rules binary
cd ..
dpkg -i jailkit_2.19-1_*.deb
rm -rf jailkit-2.19*
apt-get -y install fail2ban
cp config/jail.local /etc/fail2ban/jail.local
service fail2ban restart
apt-get -y install roundcube roundcube-core roundcube-mysql roundcube-plugins javascript-common libjs-jquery-mousewheel php-net-sieve tinymce
cp config/config.inc.php /etc/roundcube/config.inc.php
ln -s /usr/share/roundcube /usr/share/squirrelmail
echo "Install Webmail Done"
service apache2 stop
update-rc.d -f apache2 remove
service nginx restart
cd config
tar xfz ispconfig.tar.gz
cd ispconfig3*/install/
php -q install.php
cd
"Installation Complete"
