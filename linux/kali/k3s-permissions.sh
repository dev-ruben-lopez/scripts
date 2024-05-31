#!/bin/bash

# Ensure K3s is running
sudo systemctl start k3s

# Check the status of K3s
sudo systemctl status k3s

# Change ownership and permissions of the k3s.yaml file
sudo chown $USER:$USER /etc/rancher/k3s/k3s.yaml
chmod 600 /etc/rancher/k3s/k3s.yaml

# Add KUBECONFIG to shell profile
if ! grep -q 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' ~/.bashrc; then
    echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc
    source ~/.bashrc
fi

# Export KUBECONFIG for the current session
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Verify configuration
kubectl get nodes
