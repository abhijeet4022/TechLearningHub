# Kubernetes User Configuration

## Steps

1. **Copy Certificate Files**: Copy the `kubernetes-ca.crt` and `kubernetes-ca.key` files from the Control-Plane to the Management Node.
2. **Create Namespaces**: Create `development` and `production` namespaces.
3. **Generate User Certificates**: Generate keys and certificates for `abhijeet`, `abhi`, and `adminuser`.
4. **Create Kubeconfig Files**: Create and configure kubeconfig files for all users.
5. **Merge Configurations**: Merge all kubeconfig files into one for easier management.
6. **Assign Roles**: Create and assign roles using `role.yaml`, `rolebinding.yaml`, and `cluster_admin_access.yaml`.
7. **Switch Contexts**: Use `kubectx` to switch between user contexts.
8. **Install Portainer**: Deploy Portainer GUI using Helm and configure NodePort in AWS Security Groups.

For detailed steps and configuration files, refer to `config.md`.