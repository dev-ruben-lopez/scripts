# Instructions to Run the Script Install Docker and K3S on Kali Linux

Save the script to a file named install_docker_k3s.sh.
Make the script executable:

```shell
chmod +x install_docker_k3s.sh
```

Run the script:

```shell
./install_docker_k3s.sh
```


This script includes error handling to exit if any command fails, checks for existing installations, 
and provides necessary user feedback. After running the script, you should log out and back in to apply changes to the Docker group membership.


# Instructions to Run the Script k3s-permissions.sh in Kali Linux

Save the script to a file.
Make the script executable:

```shell
chmod +x configure_k3s.sh
```

Run the script:
```shell
./configure_k3s.sh
```


This script will ensure that K3s is running, set the appropriate permissions, configure the KUBECONFIG environment variable, and verify the configuration.
