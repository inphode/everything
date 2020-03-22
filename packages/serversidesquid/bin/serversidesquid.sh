#!/bin/bash

SSS_ENV="$HOME/.config/serversidesquid/sss.env"

# Terminate on error
set -e

# Check for .env file and copy example if it doesn't exist
if ! [[ -f "$SSS_ENV" ]]; then
    echo "$SSS_ENV file not found."
    read -n 1 -s -r -p "Copying example - please review and re-run."
    echo
    cp "$SSS_ENV.example" "$SSS_ENV"
    if [[ -n $EDITOR ]]; then
        $EDITOR "$SSS_ENV"
    else
        vim "$SSS_ENV"
    fi
    exit 1
fi

# Source the env config
set -a
. "$SSS_ENV"
set +a

# Check for missing required options
if [[ -z $SSS_WHITELIST_IP ]]; then
    echo "SSS_WHITELIST_IP requires a value in $SSS_ENV"
    read -p "Provide a value now, or leave empty to exit: " SSS_WHITELIST_IP
    [[ -z $SSS_WHITELIST_IP ]] && exit 1
fi

# Update system packages
sudo apt update
sudo apt upgrade -y

# Configure hostname
sudo hostnamectl set-hostname $SSS_HOSTNAME
sudo $HOME/bin/hosts add 127.0.1.1 $SSS_HOSTNAME

# Ensure user has standard Ubuntu groups
sudo usermod -a -G adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev,lxd $SSS_USER

# Install common packages
sudo apt install -y htop tar ripgrep fd-find wget nnn keychain

# Install Eternal Terminal
sudo add-apt-repository ppa:jgmath2000/et -y
sudo apt-get install -y et

# Set up firewall
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from $SSS_WHITELIST_IP to any
sudo ufw allow from 192.168.1.0/24
sudo ufw allow from 10.0.1.0/24
sudo ufw allow $SSS_SSH_PORT

# Add mysql 5.7 packages from Ubuntu 18.04 and install
sudo tee /etc/apt/sources.list.d/mysql.list > /dev/null <<EOT
deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-apt-config
deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-5.7
deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-tools
deb-src http://repo.mysql.com/apt/ubuntu/ bionic mysql-5.7
EOT
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5
sudo apt update
sudo apt install -y mysql-client=5.7.29-1ubuntu18.04
sudo apt install -y mysql-server=5.7.29-1ubuntu18.04

sudo tee /etc/apt/preferences.d/mysql > /dev/null <<EOT
Package: mysql-server
Pin: version 5.7.29-1ubuntu18.04
Pin-Priority: 1001

Package: mysql-client
Pin: version 5.7.29-1ubuntu18.04
Pin-Priority: 1001

Package: mysql-community-server
Pin: version 5.7.29-1ubuntu18.04
Pin-Priority: 1001

Package: mysql-community-client
Pin: version 5.7.29-1ubuntu18.04
Pin-Priority: 1001
EOT

# Install PHP
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt install -y php5.6-fpm php5.6 php5.6-bcmath php5.6-bz2 php5.6-cli php5.6-common php5.6-curl php5.6-dev php5.6-gd php5.6-gmp php5.6-imap php5.6-intl php5.6-json php5.6-ldap php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-odbc php5.6-pgsql php5.6-pspell php5.6-readline php5.6-snmp php5.6-soap php5.6-sqlite3 php5.6-tidy php5.6-xml php5.6-xmlrpc php5.6-xsl php5.6-zip
sudo apt install -y php7.0-fpm php7.0 php7.0-bcmath php7.0-bz2 php7.0-cli php7.0-common php7.0-curl php7.0-dev php7.0-gd php7.0-gmp php7.0-imap php7.0-intl php7.0-json php7.0-ldap php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-odbc php7.0-pgsql php7.0-pspell php7.0-readline php7.0-snmp php7.0-soap php7.0-sqlite3 php7.0-tidy php7.0-xml php7.0-xmlrpc php7.0-xsl php7.0-zip
sudo apt install -y php7.1-fpm php7.1 php7.1-bcmath php7.1-bz2 php7.1-cli php7.1-common php7.1-curl php7.1-dev php7.1-gd php7.1-gmp php7.1-imap php7.1-intl php7.1-json php7.1-ldap php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-odbc php7.1-pgsql php7.1-pspell php7.1-readline php7.1-snmp php7.1-soap php7.1-sqlite3 php7.1-tidy php7.1-xml php7.1-xmlrpc php7.1-xsl php7.1-zip
sudo apt install -y php7.2-fpm php7.2 php7.2-bcmath php7.2-bz2 php7.2-cli php7.2-common php7.2-curl php7.2-dev php7.2-gd php7.2-gmp php7.2-imap php7.2-intl php7.2-json php7.2-ldap php7.2-mbstring php7.2-mysql php7.2-odbc php7.2-pgsql php7.2-pspell php7.2-readline php7.2-snmp php7.2-soap php7.2-sqlite3 php7.2-tidy php7.2-xml php7.2-xmlrpc php7.2-xsl php7.2-zip
sudo apt install -y php7.3-fpm php7.3 php7.3-bcmath php7.3-bz2 php7.3-cli php7.3-common php7.3-curl php7.3-dev php7.3-gd php7.3-gmp php7.3-imap php7.3-intl php7.3-json php7.3-ldap php7.3-mbstring php7.3-mysql php7.3-odbc php7.3-pgsql php7.3-pspell php7.3-readline php7.3-snmp php7.3-soap php7.3-sqlite3 php7.3-tidy php7.3-xml php7.3-xmlrpc php7.3-xsl php7.3-zip
sudo apt install -y php7.4-fpm php7.4 php7.4-bcmath php7.4-bz2 php7.4-cli php7.4-common php7.4-curl php7.4-dev php7.4-gd php7.4-gmp php7.4-imap php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-odbc php7.4-pgsql php7.4-pspell php7.4-readline php7.4-snmp php7.4-soap php7.4-sqlite3 php7.4-tidy php7.4-xml php7.4-xmlrpc php7.4-xsl php7.4-zip
sudo apt install -y php-xdebug
sudo systemctl stop php5.6-fpm.service
sudo systemctl stop php7.0-fpm.service
sudo systemctl stop php7.1-fpm.service
sudo systemctl stop php7.2-fpm.service
sudo systemctl stop php7.3-fpm.service
sudo systemctl stop php7.4-fpm.service
sudo systemctl disable php5.6-fpm.service
sudo systemctl disable php7.0-fpm.service
sudo systemctl disable php7.1-fpm.service
sudo systemctl disable php7.2-fpm.service
sudo systemctl disable php7.3-fpm.service
sudo systemctl disable php7.4-fpm.service

# Switch to PHP version 5.6
sudo update-alternatives --set php /usr/bin/php5.6
sudo service php5.6-fpm start
sudo systemctl enable php5.6-fpm.service

# Install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Install valet
sudo apt-get install -y network-manager libnss3-tools jq xsel
composer global require cpriego/valet-linux
valet install
valet domain $SSS_DOMAIN

# Make sure we have working nameservers for resolving
sudo tee /opt/valet-linux/dns-servers > /dev/null <<EOT
nameserver 1.1.1.1
nameserver 1.0.0.1
EOT
sudo tee /opt/valet-linux/custom-nameservers > /dev/null <<EOT
nameserver 1.1.1.1
nameserver 1.0.0.1
EOT

# Install valet on every PHP version
sudo update-alternatives --set php /usr/bin/php7.0
sudo service php5.6-fpm stop
sudo systemctl disable php5.6-fpm.service
sudo service php7.0-fpm start
sudo systemctl enable php7.0-fpm.service
valet install
sudo update-alternatives --set php /usr/bin/php7.1
sudo service php7.0-fpm stop
sudo systemctl disable php7.0-fpm.service
sudo service php7.1-fpm start
sudo systemctl enable php7.1-fpm.service
valet install
sudo update-alternatives --set php /usr/bin/php7.2
sudo service php7.1-fpm stop
sudo systemctl disable php7.1-fpm.service
sudo service php7.2-fpm start
sudo systemctl enable php7.2-fpm.service
valet install
sudo update-alternatives --set php /usr/bin/php7.3
sudo service php7.2-fpm stop
sudo systemctl disable php7.2-fpm.service
sudo service php7.3-fpm start
sudo systemctl enable php7.3-fpm.service
valet install
sudo update-alternatives --set php /usr/bin/php7.4
sudo service php7.3-fpm stop
sudo systemctl disable php7.3-fpm.service
sudo service php7.4-fpm start
sudo systemctl enable php7.4-fpm.service
valet install

# Enable xdebug on all PHP versions
sudo tee /etc/php/5.6/mods-available/xdebug.ini > /dev/null <<EOT
zend_extension=xdebug.so
;xdebug.remote_autostart=1
xdebug.remote_enable=1
xdebug.remote_host=localhost
xdebug.remote_port=9000
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.idekey=Bugger
xdebug.max_nesting_level=1000
EOT
sudo cp /etc/php/5.6/mods-available/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
sudo cp /etc/php/5.6/mods-available/xdebug.ini /etc/php/7.1/mods-available/xdebug.ini
sudo cp /etc/php/5.6/mods-available/xdebug.ini /etc/php/7.2/mods-available/xdebug.ini
sudo cp /etc/php/5.6/mods-available/xdebug.ini /etc/php/7.3/mods-available/xdebug.ini
sudo cp /etc/php/5.6/mods-available/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini

# Install x2go
sudo add-apt-repository ppa:x2go/stable -y
sudo apt-get update
sudo apt-get install -y x2goserver x2goserver-xsession

# Install insync client
sudo tee /etc/apt/sources.list.d/insync.list > /dev/null <<EOT
deb http://apt.insync.io/ubuntu eoan non-free contrib
EOT
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A684470CACCAF35C
sudo apt update
sudo apt install -y insync
sudo mkdir -p /drive
sudo chown $SSS_USER:$SSS_USER /drive

# Project directory setup and basic tools install
mkdir -p ~/git/tools
wget -O ~/git/tools/adminer.php https://github.com/vrana/adminer/releases/download/v4.7.6/adminer-4.7.6-en.php
echo "<?php phpinfo();" > ~/git/tools/phpinfo.php
( cd ~/git && valet park )

echo
echo "Please connect to an x2go session and run insync to configure file syncing."
echo "Recommended location: /drive"
echo
