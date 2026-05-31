#!/bin/bash
# Update system
sudo yum update -y
# Install required packages
sudo yum install -y java-17-amazon-corretto wget unzip
# Verify Java
java -version
# Create SonarQube user
sudo useradd sonar || true
# Download SonarQube LTS
cd /opt
sudo wget -O sonarqube.zip https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.8.100196.zip
# Extract SonarQube
sudo unzip -o sonarqube.zip
sudo mv sonarqube-9.9.8.100196 sonarqube
# Set ownership and permissions

sudo chown -R sonar:sonar /opt/sonarqube
sudo chmod -R 755 /opt/sonarqube
# Linux kernel settings required by SonarQube
echo "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=131072" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "sonar   -   nofile   131072" | sudo tee -a /etc/security/limits.conf
echo "sonar   -   nproc    8192" | sudo tee -a /etc/security/limits.conf

# Create SonarQube systemd service

sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube Service
After=network.target

[Service]
Type=forking

User=sonar
Group=sonar

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

Restart=always
LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd

sudo systemctl daemon-reload

# Enable and start SonarQube

sudo systemctl enable sonarqube
sudo systemctl start sonarqube

# Show status

sudo systemctl status sonarqube --no-pager

echo ""
echo "==========================================="
echo "SonarQube Installation Complete"
echo "URL: http://<EC2-PUBLIC-IP>:9000"
echo "Username: admin"
echo "Password: admin"
echo "==========================================="

