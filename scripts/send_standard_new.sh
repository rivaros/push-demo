#!/bin/bash

export CACERT_FILE_NAME=~/apple/apple_root_ca.pem
export CERTIFICATE_FILE_NAME=~/apple/development.cer
export CERTIFICATE_KEY_FILE_NAME=~/apple/key.pem
export TOPIC=com.dtsx.PushDemo
export DEVICE_TOKEN=805031f9b6fee6f737ff29e856703301259fb62ed2784e61b71ea336225cad7b
export APNS_HOST_NAME=api.sandbox.push.apple.com

openssl s_client -connect "${APNS_HOST_NAME}":443 -cert "${CERTIFICATE_FILE_NAME}" -certform DER -key "${CERTIFICATE_KEY_FILE_NAME}" -keyform PEM

# curl -v --header "apns-topic: ${TOPIC}" \
#         --header "apns-push-type: alert" \
#         --cert "${CERTIFICATE_FILE_NAME}" \
#         --cert-type DER \
#         --key "${CERTIFICATE_KEY_FILE_NAME}" \
#         --key-type PEM \
#         --data '{"aps":{"alert":{"title":"PushOnSimulator","body":"You have sent it on simulator"},"sound":"default","badge":7}}' \
#         --http2  https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN}
