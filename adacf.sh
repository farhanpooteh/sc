#!/bin/bash
cd /root
clear
echo "
                             _---__
                          _-       /--______
                     __--( /     \ )XXXXXXXXXXX\v.
                   .-XXX(   O   O  )XXXXXXXXXXXXXXX-
                  /XXX(       U     )        XXXXXXX
                /XXXXX(              )--_  XXXXXXXXXXX
               /XXXXX/ (      O     )   XXXXXX   \XXXXX
               XXXXX/   /            XXXXXX   \__ \XXXXX
              XXXXXX__/          XXXXXX         \__---->
      ---___  XXX__/          XXXXXX      \__         /
         \-  --__/   ___/\  XXXXXX            /  ___--/=
          \-\    ___/    XXXXXX              '--- XXXXXX
            \-\/XXX\ XXXXXX                      /XXXXX
               \XXXXXXXXX   \                    /XXXXX/
                \XXXXXX      >                 _/XXXXX/
                  \XXXXX--__/              __-- XXXX/
                   -XXXXXXXX---------------  XXXXXX-
                      \XXXXXXXXXXXXXXXXXXXXXXXXXX/
                       ''VXXXXXXXXXXXXXXXXXXV''"
echo -e ""
echo -e ""
echo "==================================="
echo "  ANDA MEMPUNYAI AKAUN CLOUDFLARE  "
echo "==================================="
echo ""
read -p " Sila masukkan email Cloudflare anda:" CF_ID
read -p " Sila masukkan Api Key Cloudflare anda:" CF_KEY
read -p " Sila masukkan Domain anda :" domain
read -p " Sila masukkan SubDomain anda :" sub
echo -e ""
CF_ID=${CF_ID}
CF_KEY=${CF_KEY}
domain=$domain
sub=$sub
SUB_DOMAIN=${sub}.${domain}
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
cd
clear
echo ""
echo "DONE...!"
echo ""
echo "Updating DNS for ${SUB_DOMAIN}..."

ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${domain}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo ""
echo "====================================="
echo "Your Cloudflare & Domain Informattion"
echo "====================================="
echo "Email          : ${CF_ID}"
echo "Api Key        : ${CF_KEY}"
echo "Domain         : ${domain}"
echo "SubDomain      : ${SUB_DOMAIN}"
echo "====================================="
echo ""
echo $SUB_DOMAIN > /root/domain
echo $CF_ID > /root/mail1.conf
echo $CF_KEY > /root/mail2.conf
sleep 2
wget https://raw.githubusercontent.com/farhanpooteh/sc/main/afterjawab.sh && chmod +x afterjawab.sh && ./afterjawab.sh
