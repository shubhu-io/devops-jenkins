# 🏗️ devops-jenkins — Jenkins CI/CD Automation Execution Repository

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Learning Hub](https://img.shields.io/badge/DevOps-Learning%20Hub-blue.svg)](https://github.com/shubhu-io/devops-learning)

Production Jenkins CI/CD automation covering installation, Jenkinsfile pipeline templates, Docker build pipelines, and deployment automation for AWS and Kubernetes targets.

---

## ⚡ Quick Start

```bash
git clone https://github.com/shubhu-io/devops-jenkins.git
cd devops-jenkins
chmod +x setup.sh
./setup.sh           # Installs Jenkins + OpenJDK 21 (Ubuntu/RHEL)
```

Access Jenkins at: `http://YOUR_SERVER_IP:8080`

Get the initial admin password:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## 📂 Repository Structure

```
devops-jenkins/
├── setup.sh                             # Jenkins + Java 21 installer
├── uninstall.sh                         # Remove Jenkins & Java
├── scripts/
│   └── jenkins.sh                       # Full automated Jenkins setup script
└── jenkinsfiles/
    ├── Jenkinsfile-basic                 # Basic build pipeline
    ├── Jenkinsfile-docker                # Docker build + push pipeline
    └── Jenkinsfile-deploy                # Deploy to EC2/Kubernetes pipeline
```

---

## 🛠️ Jenkinsfile Templates

| File | Purpose |
|------|---------|
| `Jenkinsfile-basic` | Checkout → Build → Test → Archive artifacts |
| `Jenkinsfile-docker` | Build Docker image → Push to Docker Hub/ECR/ACR |
| `Jenkinsfile-deploy` | Build → Test → Docker push → Deploy to K8s |

### Use a Jenkinsfile in your project:
```groovy
// In your repo's Jenkinsfile — copy from this repo:
pipeline {
    agent any
    stages {
        stage('Build') { steps { sh 'make build' } }
        stage('Test')  { steps { sh 'make test' } }
        stage('Deploy') { steps { sh './deploy.sh' } }
    }
}
```

---

## 🔌 Recommended Plugins

- Pipeline, Blue Ocean, Git, Docker Pipeline
- Kubernetes, AWS Steps, Credentials Binding
- AnsiColor, Slack Notification, JUnit

Install via: `Manage Jenkins → Plugins → Available`

---

## 📚 Learning Hub

For Jenkins architecture, pipeline DSL, shared libraries, and CI/CD theory, visit the [DevOps Learning Hub](https://github.com/shubhu-io/devops-learning).

---

## 📄 License

Licensed under [MIT](LICENSE).
