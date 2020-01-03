#!/bin/bash

# Get Controller ROOT CA certificate
# Copy CA file from container

docker cp edgecontroller_cce_1:/artifacts/certificates/ca/cert.pem /root/

#Install apache and mod_ssl

yum install -y httpd mod_ssl


# Acquire the Controller Root CA and Key

cd /etc/ssl/certs

docker cp edgecontroller_cce_1:/artifacts/certificates/ca/cert.pem . 
docker cp edgecontroller_cce_1:/artifacts/certificates/ca/key.pem .


# Generate the Apache Key and Crt

cert_domain="controller"

openssl genrsa -out apache.key 2048
openssl req -new -sha256 -key apache.key -subj "/C=IE/ST=Clare/O=ESIE/CN=$cert_domain" -out apache.csr
openssl x509 -req -in apache.csr -CA cert.pem -CAkey key.pem -CAcreateserial -out apache.crt -days 500 -sha256

# Edit Apache Config and Point it to the New Certs

sed -i 's|^SSLCertificateFile.*$|SSLCertificateFile /etc/ssl/certs/apache.crt|g' /etc/httpd/conf.d/ssl.conf
sed -i 's|^SSLCertificateKeyFile.*$|SSLCertificateKeyFile /etc/ssl/certs/apache.key|g' /etc/httpd/conf.d/ssl.conf


# Enable and Restart Apache After the Changes

systemctl enable httpd && systemctl restart httpd

EOL
