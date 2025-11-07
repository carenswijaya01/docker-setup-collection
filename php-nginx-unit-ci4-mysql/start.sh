#!/bin/bash
set -m

# Start Unit
unitd --no-daemon &

# Wait for the control socket to be ready
echo "Waiting for Unit control socket..."
for i in {1..100}; do
  if [ -S /var/run/control.unit.sock ]; then
    echo "Socket is ready!"
    break
  fi
  sleep 0.1
done

# Fail if socket never appears
if [ ! -S /var/run/control.unit.sock ]; then
  echo "ERROR: Unit socket not found after 10s"
  exit 1
fi

# Apply configuration
curl -X PUT --data-binary @/docker-entrypoint.d/config.json \
     --unix-socket /var/run/control.unit.sock http://localhost/config/

# Bring Unit to foreground
fg %1
