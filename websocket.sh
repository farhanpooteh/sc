#!/bin/bash
cleae
echo Installing Websocket-SSH AUTOSCRIPT BY AJ
sleep 1
echo Cek Hak Akses...
sleep 0.5
cd
cd /etc/systemd/system/

#Install system auto run
wget -O /etc/systemd/system/ws-ssh.service https://raw.githubusercontent.com/farhanpooteh/sc/main/ws-ssh.service && chmod +x /etc/systemd/system/ws-ssh.service
wget -O /etc/systemd/system/ws-dropbear.service https://raw.githubusercontent.com/farhanpooteh/sc/main/ws-dropbear.service && chmod +x /etc/systemd/system/ws-dropbear.service
wget -O /etc/systemd/system/ws-ovpn.service https://raw.githubusercontent.com/farhanpooteh/sc/main/ws-ovpn.service && chmod +x /etc/systemd/system/ws-ovpn.service
wget -O /etc/systemd/system/ws-stunnel.service https://raw.githubusercontent.com/farhanpooteh/sc/main/ws-stunnel.service && chmod +x /etc/systemd/system/ws-stunnel.service

#Install Websocket-SSH
wget -O /usr/local/bin/ws-ssh https://raw.githubusercontent.com/farhanpooteh/sc/main/ws-ssh && chmod +x /usr/local/bin/ws-ssh
wget -O /usr/local/bin/ws-dropbear https://raw.githubusercontent.com/farhanpooteh/sc/main/ws-dropbear && chmod +x /usr/local/bin/ws-dropbear
wget -O /usr/local/bin/ws-ovpn https://raw.githubusercontent.com/farhanpooteh/sc/main/ws-ovpn && chmod +x /usr/local/bin/ws-ovpn
wget -O /usr/local/bin/ws-stunnel https://raw.githubusercontent.com/farhanpooteh/sc/main/ws-stunnel && chmod +x /usr/local/bin/ws-stunnel

#Enable, Start & Restart ws-ssh service
systemctl enable ws-ssh.service
systemctl start ws-ssh.service
systemctl restart ws-ssh.service

#Enable, Start & Restart ws-dropbear service
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service

#Enable, Start & Restart ws-ovpn service
systemctl enable ws-ovpn.service
systemctl start ws-ovpn.service
systemctl restart ws-ovpn.service

#Enable, Start & Restart ws-stunnel service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service
