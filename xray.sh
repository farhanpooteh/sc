#!/bin/bash
domain=$(cat /root/domain)
ip=$(wget -qO- ipv4.icanhazip.com)

# Install Xray
apt-get install -y lsb-release gnupg2 wget lsof tar unzip curl libpcre3 libpcre3-dev zlib1g-dev openssl libssl-dev jq nginx uuid-runtime
curl -L https://raw.githubusercontent.com/farhanpooteh/sc/main/install-release.sh | bash -s -- install

echo $domain > /usr/local/etc/xray/domain
wget -qO /usr/local/etc/xray/config.json "https://raw.githubusercontent.com/farhanpooteh/sc/main/xray_tls_ws_mix-rprx-direct.json"
wget -qO /etc/nginx/conf.d/${domain}.conf "https://raw.githubusercontent.com/farhanpooteh/sc/main/web.conf"

sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/${domain}.conf
sed -i "s/x.x.x.x/${ip}/g" /etc/nginx/conf.d/${domain}.conf

wget -qO web.tar.gz "https://github.com/farhanpooteh/sc/raw/main/web.tar.gz"
rm -rf /var/www/html/*
tar xzf web.tar.gz -C /var/www/html
rm -f web.tar.gz
mkdir -p /kaizen/xray
curl -L get.acme.sh | bash
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
sed -i "6s/^/#/" /etc/nginx/conf.d/${domain}.conf
sed -i "6a\\\troot /var/www/html/;" /etc/nginx/conf.d/${domain}.conf
systemctl restart nginx
#/root/.acme.sh/acme.sh --issue -d "${domain}" --webroot "/var/www/html/" -k ec-256 --force
#/root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /kaizen/xray/xray.crt --keypath /kaizen/xray/xray.key --reloadcmd "systemctl restart xray" --ecc --force
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
/root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /kaizen/xray/xray.crt --keypath /kaizen/xray/xray.key --ecc
sed -i "7d" /etc/nginx/conf.d/${domain}.conf
sed -i "6s/#//" /etc/nginx/conf.d/${domain}.conf
chown -R nobody.nogroup /kaizen/xray/xray.crt
chown -R nobody.nogroup /kaizen/xray/xray.key

touch /kaizen/xray/xray-clients.txt
sed -i "s/\tinclude \/etc\/nginx\/sites-enabled\/\*;/\t# include \/etc\/nginx\/sites-enabled\/\*;asd/g" /etc/nginx/nginx.conf
mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" | tee /etc/systemd/system/nginx.service.d/override.conf
systemctl daemon-reload
systemctl restart nginx
systemctl restart xray
