
#!/bin/bash

echo "================================================"
echo "       DEVOPS ENVIRONMENT VERIFICATION"
echo "================================================"

# Function to check installed commands
check_tool() {
    TOOL=$1
    LABEL=$2

    if command -v "$TOOL" >/dev/null 2>&1; then
        echo "[PASS] $LABEL is installed"
    else
        echo "[FAIL] $LABEL is NOT installed"
    fi
}

echo ""
echo "1. SYSTEM REQUIREMENTS"
echo "------------------------------------------------"

echo "Operating System:"
grep PRETTY_NAME /etc/os-release

echo ""
echo "Memory:"
free -h

echo ""
echo "Disk Space:"
df -h /

echo ""
echo "Current User:"
whoami

echo ""
echo "2. VERSION CONTROL AND EDITOR"
echo "------------------------------------------------"

check_tool git "Git"
check_tool code "Visual Studio Code CLI"

if command -v git >/dev/null 2>&1; then
    git --version
    echo "Git user: $(git config --global user.name || echo 'Not configured')"
    echo "Git email: $(git config --global user.email || echo 'Not configured')"
fi

echo ""
echo "3. AI DEVELOPMENT TOOLS"
echo "------------------------------------------------"

check_tool gh "GitHub CLI"
check_tool q "Amazon Q CLI"
check_tool gemini "Gemini CLI"
check_tool codex "Codex CLI"
check_tool localstack "LocalStack CLI"

echo ""
echo "4. CONTAINERIZATION"
echo "------------------------------------------------"

check_tool docker "Docker"
check_tool docker-compose "Docker Compose standalone"

if command -v docker >/dev/null 2>&1; then
    docker --version

    if docker compose version >/dev/null 2>&1; then
        echo "[PASS] Docker Compose plugin is working"
        docker compose version
    else
        echo "[FAIL] Docker Compose plugin is unavailable"
    fi

    if docker info >/dev/null 2>&1; then
        echo "[PASS] Docker daemon is accessible"
    else
        echo "[WARN] Docker daemon is not accessible"
    fi
fi

echo ""
echo "5. KUBERNETES TOOLING"
echo "------------------------------------------------"

check_tool minikube "Minikube"
check_tool kubectl "kubectl"
check_tool helm "Helm"

if command -v minikube >/dev/null 2>&1; then
    minikube version
    minikube status
fi

if command -v kubectl >/dev/null 2>&1; then
    kubectl version --client
fi

if command -v helm >/dev/null 2>&1; then
    helm version --short
fi

echo ""
echo "6. CLOUD AND LANGUAGE RUNTIMES"
echo "------------------------------------------------"

check_tool aws "AWS CLI"
check_tool az "Azure CLI"
check_tool node "Node.js"
check_tool npm "NPM"
check_tool jq "JQ"

if command -v aws >/dev/null 2>&1; then
    aws --version
fi

if command -v az >/dev/null 2>&1; then
    az version --output table
fi

if command -v node >/dev/null 2>&1; then
    node --version
    npm --version
fi

if command -v jq >/dev/null 2>&1; then
    jq --version
fi

echo ""
echo "7. INFRASTRUCTURE AND CONFIGURATION"
echo "------------------------------------------------"

check_tool terraform "Terraform"
check_tool ansible "Ansible"

if command -v terraform >/dev/null 2>&1; then
    terraform version
fi

if command -v ansible >/dev/null 2>&1; then
    ansible --version
fi

echo ""
echo "8. SECURITY AND PERMISSIONS"
echo "------------------------------------------------"

echo "Current user and groups:"
id

echo ""
echo "Sudo access:"
if sudo -n true 2>/dev/null; then
    echo "[PASS] Sudo access available without password"
elif sudo -v 2>/dev/null; then
    echo "[PASS] Sudo access available"
else
    echo "[FAIL] Sudo access unavailable"
fi

echo ""
echo "Docker group membership:"
if id -nG | grep -qw docker; then
    echo "[WARN] User belongs to Docker group (root-equivalent access)"
else
    echo "[INFO] User is not in Docker group"
fi

echo ""
echo "SSH directory permissions:"
if [ -d "$HOME/.ssh" ]; then
    stat -c '%a %n' "$HOME/.ssh"
    find "$HOME/.ssh" -maxdepth 1 -type f \
        -name 'id_*' ! -name '*.pub' \
        -exec stat -c '%a %n' {} \;
else
    echo "[INFO] SSH directory not created"
fi

echo ""
echo "Kubernetes configuration permissions:"
if [ -f "$HOME/.kube/config" ]; then
    stat -c '%a %n' "$HOME/.kube/config"
else
    echo "[INFO] Kubernetes config not created"
fi

echo ""
echo "Terraform configuration permissions:"
if [ -d "$HOME" ]; then
    find "$HOME" -maxdepth 2 -type f \
        -name 'terraform.tfstate*' \
        -exec stat -c '%a %n' {} \;
fi

echo ""
echo "================================================"
echo "       VERIFICATION COMPLETED"
echo "================================================"

