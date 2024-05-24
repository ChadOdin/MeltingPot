#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with superuser privileges. Running with sudo..."
    sudo "$0" "$@"
    exit $?
fi

read -p "Enter the IP address allowed to connect via SSH: " ALLOWED_IP

if [[ ! $ALLOWED_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  exit 1
fi

read -p "Enter the SSH port (default is 22): " SSH_PORT
SSH_PORT=${SSH_PORT:-22}

ufw default deny incoming
ufw default allow outgoing

ufw allow from $ALLOWED_IP to any port $SSH_PORT proto tcp

ufw enable

ufw status verbose

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

sed -i 's/#Port 22/Port '"$SSH_PORT"'/' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
echo "AllowUsers odin" >> /etc/ssh/sshd_config

systemctl reload ssh

apt-get update
apt-get install -y fail2ban

cat <<EOL > /etc/fail2ban/jail.local
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = $SSH_PORT
logpath = %(sshd_log)s
EOL

systemctl restart fail2ban

apt-get install -y libpam-google-authenticator

echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd
echo "ChallengeResponseAuthentication yes" >> /etc/ssh/sshd_config

systemctl restart ssh

google-authenticator

apt-get install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades

ufw limit ssh/tcp

echo "SSH, UFW, 2FA, and automatic security updates configured with additional security enhancements."