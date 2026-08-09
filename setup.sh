#!/usr/bin/env bash
# ==============================================================================
# 08-devops-jenkins - Automated Jenkins & Java 21/17 Installation Script
# Works on: Amazon Linux 2023 / RHEL / Fedora / Ubuntu / Debian
# ==============================================================================

set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BOLD}${BLUE}==========================================================${NC}"
echo -e "${BOLD}${BLUE}           🏗️ Jenkins Automation Setup                     ${NC}"
echo -e "${BOLD}${BLUE}==========================================================${NC}"

OS_TYPE="unknown"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_TYPE=$ID
fi

echo -e "${BLUE}[INFO] Detected OS: ${OS_TYPE} (${PRETTY_NAME:-Linux})${NC}"

# Check if Jenkins is already installed
if command -v jenkins &>/dev/null; then
    echo -e "${GREEN}[SUCCESS] Jenkins is already installed: $(jenkins --version 2>/dev/null || echo 'active')${NC}"
    exit 0
fi

case "$OS_TYPE" in
    amzn|rhel|centos|fedora)
        echo -e "${BLUE}[INFO] Installing Java 21 & Wget via DNF/YUM...${NC}"
        sudo dnf install -y java-21-openjdk java-21-openjdk-devel wget || sudo yum install -y java-17-openjdk wget
        
        echo -e "${BLUE}[INFO] Adding Jenkins official RedHat repository...${NC}"
        sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
        
        echo -e "${BLUE}[INFO] Importing Jenkins GPG key...${NC}"
        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key || sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
        
        echo -e "${BLUE}[INFO] Installing Jenkins...${NC}"
        sudo dnf install -y jenkins || sudo yum install -y jenkins
        ;;
    ubuntu|debian)
        echo -e "${BLUE}[INFO] Installing Java 17 & Curl via APT...${NC}"
        sudo apt-get update -qq
        sudo apt-get install -y -qq openjdk-17-jdk wget curl gnupg
        
        echo -e "${BLUE}[INFO] Adding Jenkins official Debian repository key...${NC}"
        sudo mkdir -p /usr/share/keyrings
        curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
        
        echo -e "${BLUE}[INFO] Installing Jenkins...${NC}"
        sudo apt-get update -qq
        sudo apt-get install -y -qq jenkins
        ;;
    *)
        echo -e "${YELLOW}[WARN] Generic installation fallback using Docker...${NC}"
        if command -v docker &>/dev/null; then
            docker run -d --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts-jdk17
            echo -e "${GREEN}[SUCCESS] Jenkins started in Docker container on port 8080.${NC}"
            exit 0
        fi
        ;;
esac

# Start and Enable Jenkins Service
if command -v systemctl &>/dev/null; then
    echo -e "${BLUE}[INFO] Enabling and starting Jenkins service...${NC}"
    sudo systemctl daemon-reload || true
    sudo systemctl enable --now jenkins || true
fi

echo -e "\n${GREEN}==========================================================${NC}"
echo -e "${GREEN}  🎉 Jenkins Installation Completed Successfully!          ${NC}"
echo -e "${GREEN}==========================================================${NC}"
echo -e "${BLUE}Access Jenkins Web UI at: http://<SERVER-IP>:8080${NC}"
echo -e "${YELLOW}To retrieve initial admin password, run:${NC}"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
