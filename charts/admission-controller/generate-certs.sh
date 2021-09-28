#!/bin/bash

openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -days 100000 -out ca.crt -subj "/CN=admission_ca"

cat >helios.conf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ alt_names ]
DNS.1 = helios.lacework-dev.svc
DNS.2 = helios.lacework-dev.svc.cluster.local
DNS.3 = admission.lacework-dev.svc
DNS.4 = admission.lacework-dev.svc.cluster.local
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = @alt_names
EOF

openssl genrsa -out helios.key 2048
openssl req -new -key helios.key -out helios.csr -subj "/CN=helios.lacework-dev.svc" -config helios.conf
openssl x509 -req -in helios.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out helios.crt -days 100000 -extensions v3_req -extfile helios.conf