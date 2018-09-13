#!/usr/bin/env bash

mkdir -p /etc/systemd/system/docker.service.d
cat << EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://proxy.odl.local:3128" "HTTPS_PROXY=http://proxy.odl.local:3128" "NO_PROXY=localhost,127.0.0.0,my-registry:5000"
EOF

systemctl daemon-reload
systemctl restart docker
