#!/bin/bash
# Cloudinit script
# - to store in OBS s3://obs-jla-repo
# - to execute through cloudinit running the following command
#   sudo bash -c  "curl https://obs-jla-repo.oss.eu-west-0.prod-cloud-ocb.orange-business.com/DesktopInit.sh | tee DesktopInit.sh && chmod 755 DesktopInit.sh && ./DesktopInit.sh"

sudo echo "Cloudint is stating...\n" > /tmp/mycloudinit.log

sudo apt update

# INstall Ubuntu Desktop environment
sudo apt install ubuntu-desktop -y

# Add a specifica user fot Remote Access
sudo groupadd jlardouin --gid 1000
sudo useradd jlardouin --uid 1000 --home /home/jlardouin/ --create-home --groups jlardouin --gid jlardouin --shell /bin/bash
sudo bash -c "echo jlardouin:azerty | chpasswd"
sudo usermod -aG sudo jlardouin

# Install & configure Remote Destop with xrdp service
sudo apt install xrdp -y
sudo systemctl enable --now xrdp
sudo ufw allow from any to any port 3389 proto tcp

# Fix a Ubuntu Desktop issue
content = "polkit.addRule(function(action, subject) {
 if ((action.id == "org.freedesktop.color-manager.create-device" ||
 action.id == "org.freedesktop.color-manager.create-profile" ||
 action.id == "org.freedesktop.color-manager.delete-device" ||
 action.id == "org.freedesktop.color-manager.delete-profile" ||
 action.id == "org.freedesktop.color-manager.modify-device" ||
 action.id == "org.freedesktop.color-manager.modify-profile") &&
 subject.isInGroup("{users}")) {
 return polkit.Result.YES;
 }
});"
sudo echo "$content" > /tmp/02-allow-colord.conf
sudo cp /tmp/02-allow-colord.conf /etc/polkit-1/localauthority.conf.d

# Setup all Flexible Engine Agent for Monitoring, security & logging
sudo curl https://obs-jla-repo.oss.eu-west-0.prod-cloud-ocb.orange-business.com/EcsInit.sh | tee EcsInit.sh && chmod 755 EcsInit.sh && ./EcsInit.sh

# Then simply configure that desktop in Guacamole Remote Access
# And then rebbot to take in account all the modif
sudo echo "Cloudint is over..." >> /tmp/mycloudinit.log
sudo reboot
