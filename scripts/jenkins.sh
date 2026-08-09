#!/usr/bin/env bash
# ==============================================================================
# Standalone Jenkins & Java Installation Script
# ==============================================================================
set -euo pipefail

echo "[INFO] Installing OpenJDK Java..."
if command -v dnf &>/dev/null; then
    sudo dnf install -y java-21-openjdk java-21-openjdk-devel wget
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo dnf install -y jenkins
elif command -v apt-get &>/dev/null; then
    sudo apt-get update -qq && sudo apt-get install -y -qq openjdk-17-jdk wget curl gnupg
    sudo mkdir -p /usr/share/keyrings
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update -qq && sudo apt-get install -y -qq jenkins
fi

sudo systemctl enable --now jenkins || true
echo "Jenkins installed. Admin password location:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
