#!/bin/bash
set -m
unitd --no-daemon &
curl -X PUT --data-binary @/docker-entrypoint.d/config.json --unix-socket /var/run/control.unit.sock http://localhost/config/
fg %1
