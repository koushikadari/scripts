#!/bin/bash
# System Update
sudo yum update -y
sudo yum upgrade -y
# Add Jenkins Repository
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo
# Import Jenkins Key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# Install Java 21
sudo yum install java-21-amazon-corretto -y
# Install Jenkins and Git
sudo yum install jenkins git -y
# Reload Systemd
sudo systemctl daemon-reload
# Enable Jenkins Service
sudo systemctl enable jenkins
# Create Separate Temp Directory
sudo mkdir -p /var/tmp_disk
# Set Proper Permissions
sudo chmod 1777 /var/tmp_disk
# Bind Mount /tmp
sudo mount --bind /var/tmp_disk /tmp
# Permanent Mount Entry
echo '/var/tmp_disk /tmp none bind 0 0' | sudo tee -a /etc/fstab
# Mask tmp.mount
sudo systemctl mask tmp.mount
# Verify Temp Mount
df -h /tmp
# Start Jenkins
sudo systemctl start jenkins
# Restart Jenkins
sudo systemctl restart jenkins
# Check Jenkins Status
sudo systemctl status jenkins --no-pager
# Show Java Version
java -version
# Show Jenkins Initial Password
echo "Jenkins Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
-------------------------------------------------------------- master and slave ----------------------
+ paste this commands in slave server + 
sudo mkdir -p /var/tmp_disk
sudo chmod 1777 /var/tmp_disk
sudo mount --bind /var/tmp_disk /tmp
echo '/var/tmp_disk /tmp none bind 0 0' | sudo tee -a /etc/fstab
sudo systemctl mask tmp.mount
df -h /tmp


