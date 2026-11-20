# DevOps Environment Setup and Verification

## 1. Environment Overview

This project documents the local DevOps tooling environment configured on Windows Subsystem for Linux 2 (WSL2), using Ubuntu.

The environment is intended for local development, containerization, Kubernetes practice, infrastructure as code, configuration management, and cloud CLI operations.

> Before submission: confirm that Ubuntu is the distribution you used and update any details below that differ from your actual setup.

## 2. Package Manager

**Primary package manager:** APT (Advanced Package Tool), used by Ubuntu.

Typical package-management commands:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install <package-name>
```

Some tools may have been installed using their official vendor repositories, installation scripts, standalone binaries, npm, or other documented methods rather than directly from the Ubuntu APT repositories. Record the actual method used for each tool if your instructor requires a tool-by-tool installation history.

## 3. Tools Configured

| Area | Tools |
|---|---|
| Version control and editor | Git, Visual Studio Code |
| AI-assisted development (optional) | GitHub Copilot, Amazon Q, Gemini CLI, Codex CLI, and/or LocalStack, where installed |
| Containers | Docker, Docker Compose |
| Local Kubernetes | Minikube, kubectl, Helm |
| Cloud and runtime tools | AWS CLI, Azure CLI, Node.js, npm, jq |
| Infrastructure and configuration | Terraform, Ansible |

Only list optional AI tools that are actually installed in your environment.

## 4. Local Kubernetes Cluster

Minikube is used to run a local Kubernetes cluster. The Docker driver is used when Docker is available and configured for WSL2.

Start the cluster:

```bash
minikube start --driver=docker
```

Verify the node:

```bash
kubectl get nodes -o wide
```

Verify Minikube and cluster components:

```bash
minikube status
kubectl get pods -A
kubectl cluster-info
```

A successful node check should show the Minikube node with a `Ready` status.

## 5. Verification Commands

The following commands can be used to verify the main tools:

```bash
git --version
code --version
docker --version
docker compose version
minikube version
kubectl version --client
helm version
aws --version
az version
node --version
npm --version
jq --version
terraform version
ansible --version
```

Additional functional checks:

```bash
docker run hello-world
kubectl get nodes
ansible localhost -m ping -c local
echo '{"status":"ready"}' | jq .
```

Cloud authentication checks require credentials to have been configured:

```bash
aws sts get-caller-identity
az account show
```

Do not include cloud credentials, access tokens, private keys, or other secrets in this document or in screenshots.

## 6. Troubleshooting Notes

Record only the issues that you actually encountered and the actions that resolved them. The following are common checks, not a claim that these problems occurred during this setup.

- **Docker daemon unavailable:** Confirm Docker Desktop is running on Windows and that WSL integration is enabled for the Ubuntu distribution. Then retry `docker info`.
- **Minikube cannot start with the Docker driver:** Confirm Docker is available with `docker info`, then retry `minikube start --driver=docker`.
- **kubectl cannot reach the cluster:** Check `minikube status`. If the cluster is stopped, start it and retry `kubectl get nodes`.
- **Permission denied when accessing Docker:** Check the current user and Docker access configuration. Be aware that membership in the `docker` group grants highly privileged, effectively root-equivalent access.
- **Cloud CLI authentication fails:** Confirm the correct CLI is installed and complete the relevant login/configuration process. Do not paste credentials into shell history or this README.
- **A command is not found:** Check whether the tool is installed and whether its installation directory is included in the shell's `PATH`. Reload the shell configuration or open a new terminal after making changes.

### Actual issues encountered and resolutions

Add your own notes here before submitting:

- Issue encountered: _[Describe the actual issue, or write “None encountered.”]_
- Resolution: _[Describe what you did, or write “Not applicable.”]_

## 7. Evidence to Submit

Include a screenshot named `minikube-cluster-proof.png` showing the terminal output for:

```bash
minikube status
kubectl get nodes -o wide
kubectl get pods -A
```

The screenshot should clearly show the Minikube node in `Ready` status. Capture the actual output from your machine; example output in documentation is not proof of a running cluster.

## 8. Security Considerations

- Use a standard Linux user for routine work rather than operating as root.
- Protect SSH private keys and Kubernetes configuration files with restrictive permissions.
- Keep API keys, passwords, cloud credentials, and tokens out of Git repositories and screenshots.
- Do not commit Terraform state files or secret-bearing variable files to a public repository.
- Grant Docker access only to trusted users.

## 9. Submission Checklist

- [ ] Confirm the environment details and tools listed above match the actual setup.
- [ ] Replace the troubleshooting placeholders with issues actually encountered, or state that none were encountered.
- [ ] Capture the live Minikube/Kubernetes terminal screenshot.
- [ ] Save the screenshot as `minikube-cluster-proof.png`.
- [ ] Submit this README together with the screenshot and the requested shell configuration file.
