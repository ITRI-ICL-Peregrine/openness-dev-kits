#!/bin/bash

ENV=Controller

if [ "$( hostname )" != "controller" ]; then echo; echo ">>> Plz Execute this Script on $ENV <<<"; echo; exit; fi

# --------------------------------------

yum -y install httpd mod_ssl
cd /etc/ssl/certs

docker cp edgecontroller_cce_1:/artifacts/certificates/ca/cert.pem .
docker cp edgecontroller_cce_1:/artifacts/certificates/ca/key.pem .

openssl genrsa -out apache.key 2048
openssl req -new -key apache.key -out apache.csr





openssl x509 -req -in apache.csr -CA cert.pem \
-CAkey key.pem -CAcreateserial -out apache.crt \
-days 500 -sha256 -extensions req_ext -extfile /etc/pki/tls/openssl.cnf

sed -i 's|^SSLCertificateFile.*$|SSLCertificateFile /etc/ssl/certs/apache.crt|g' /etc/httpd/conf.d/ssl.conf
sed -i 's|^SSLCertificateKeyFile.*$|SSLCertificateKeyFile /etc/ssl/certs/apache.key|g' /etc/httpd/conf.d/ssl.conf

firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp --dport 80 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp --dport 443 -j ACCEPT


systemctl enable httpd
systemctl restart httpd


openssl genrsa -out apache.key 2048
openssl req -new -sha256 -key apache.key -subj "/C=IE/ST=Clare/O=ESIE/CN=$(hostname -f)" -out apache.csr
openssl x509 -req -in apache.csr -CA cert.pem -CAkey key.pem -CAcreateserial -out apache.crt -days 500 -sha256
