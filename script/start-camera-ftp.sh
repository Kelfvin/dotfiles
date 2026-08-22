#!/bin/bash

set -e

PURE_FTPD="/opt/homebrew/sbin/pure-ftpd"
PUREDB="/opt/homebrew/etc/pureftpd.pdb"

echo "Stopping existing pure-ftpd..."
sudo killall pure-ftpd 2>/dev/null || true

IP=$(ipconfig getifaddr en0)

if [ -z "$IP" ]; then
  echo "Error: Could not get IP from en0."
  echo "Check your network interface with: ifconfig"
  exit 1
fi

if [ ! -f "$PUREDB" ]; then
  echo "Error: PureDB file not found: $PUREDB"
  echo "You may need to run: sudo pure-pw mkdb $PUREDB"
  exit 1
fi

echo "Starting camera FTP server..."
echo "FTP server IP: $IP"
echo "Passive ports: 50000-51000"
echo
echo "Use this IP in your camera FTP settings:"
echo "$IP"
echo

sudo "$PURE_FTPD" \
  -p 50000:51000 \
  -P "$IP" \
  -l puredb:"$PUREDB" \
  -j \
  -E \
  -H \
  -u 1 \
  -d
