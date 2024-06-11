#!/bin/bash

# This script is designed to be ran from a minimal linux install to deploy a lightweight desktop enviroment, install python/pip and edit
# systemd to auto-start the smart mirror script

sudo apt update
sudo apt install -y --no-install-recommends xserver-xorg xinit openbox python3 python3-pip
pip3 install requests pillow

cat << 'EOF' > ~/smart_mirror.sh
#!/bin/bash
openbox-session &
python3 /home/pi/smart_mirror/smart_mirror.py
EOF
chmod +x ~/smart_mirror.sh

cat << 'EOF' > ~/start-smart-mirror.sh
#!/bin/bash
xinit /home/pi/smart_mirror.sh -- :0
EOF
chmod +x ~/start-smart-mirror.sh

sudo bash -c 'cat << EOF > /etc/systemd/system/smart-mirror.service
[Unit]
Description=Smart Mirror
After=network.target

[Service]
User=pi
ExecStart=/home/pi/start-smart-mirror.sh
WorkingDirectory=/home/pi
Environment=DISPLAY=:0
StandardOutput=inherit
StandardError=inherit
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl enable smart-mirror.service
sudo reboot
