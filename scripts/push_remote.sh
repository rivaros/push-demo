#!/bin/bash


export CERTIFICATE_FILE_NAME=~/apple/apn_cert.pem
export CERTIFICATE_KEY_FILE_NAME=~/apple/apn_key.pem
export TOPIC="com.dtsx.PushDemo"
export DEVICE_TOKEN=806226e55d053292aa4e72673156787eaa19664d30182194422865eba961347b5824abc0891c163e8a042067b4d14fe4f21278fc517ac29b6a2ca86ba7e391090fdc393a6c12001bc369566df3d5d011
export APNS_HOST_NAME="api.sandbox.push.apple.com"

#openssl s_client -connect "${APNS_HOST_NAME}":443 -cert "${CERTIFICATE_FILE_NAME}" -certform PEM -key "${CERTIFICATE_KEY_FILE_NAME}" -keyform PEM

curl -v --header "apns-topic: ${TOPIC}" \
        --header "apns-push-type: alert" \
        --cert "${CERTIFICATE_FILE_NAME}" \
        --cert-type PEM \
        --key "${CERTIFICATE_KEY_FILE_NAME}" \
        --key-type PEM \
        --data '{"aps":{"alert":{"title":"PushOnSimulator","body":"You have sent it on simulator"},"sound":"default","badge":7}}' \
        --http2  "https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN}"


# Helpful commands
# DER - Distributed Encoding Rules
# PEM - Privacy Enhanced Email
# P12 - PFX - Personal Information Exchange



## exctract PEM cetificate from PFX 
# openssl pkcs12 -in development.p12 -clcerts -nokeys -out certificate.pem
## extract PEM key from PFX
# openssl pkcs12 -in development.p12 --nodes -clcerts -nocerts -out key.pem
## read certificated info
# openssl x509 -in certificate.pem --noout -text

bdba3d6f8230f4a3ac9064d2d344cddc5d53cc8153aa77e207a6fcf5cab4c0d3