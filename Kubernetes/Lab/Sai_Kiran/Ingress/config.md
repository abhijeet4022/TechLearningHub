# Make Private Images (Need to do for all images)
- Create one private repository in dockerhub.

- docker pull kiran2361993/testing:latestappresults
- docker tag kiran2361993/testing:latestappresults abhijeet4022/ingress:results
- docker push abhijeet4022/ingress:results

- docker pull kiran2361993/testing:latestappvote
- docker tag kiran2361993/testing:latestappvote abhijeet4022/ingress:vote
- docker push abhijeet4022/ingress:vote

- docker pull kiran2361993/testing:latestappworker
- docker tag kiran2361993/testing:latestappworker abhijeet4022/ingress:worker
- docker push abhijeet4022/ingress:worker

- docker rmi $(docker images -aq) -f
- docker system prune -a

# Run the Deployment and Services.
- Generate one token in docker hub with read, write and delete access and use it in the secret.
- `kubectl create secret docker-registry docker-pwd --docker-server=docker.io --docker-username=abhijeet4022 --docker-password= --docker-email=abhijeet4022@gmail.com`
- `kubectl get secret docker-pwd -o yaml`
- `kubectl apply -f voting.yaml`
- `kubectl get pods`

# Install Snapd in Centos Stream 8 and Generate Certificate in jumphost.
* Step 1: Enable EPEL Repository
`sudo dnf install epel-release`

* Step 2: Install Snapd
`sudo dnf install snapd`

* Step 3: Enable and Start Snapd
`sudo systemctl enable --now snapd.socket`

* Step 4: Enable Classic Snap Support: Create a symbolic link for Snap's classic support:
`sudo ln -s /var/lib/snapd/snap /snap`

* Step 5: Restart the System (Recommended)
`sudo reboot`

* Step 6: Once Snap is installed and running, you can proceed to install Certbot using:
`sudo snap install --classic certbot`
* Generate SSL Certificate and Key.
`certbot certonly --manual --preferred-challenges=dns --key-type rsa --email abhijeet4022@gmail.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.learntechnology.cloud -v`
* Create DNS TXT Record in Route53 for verification. And once record is IN SYNC, press enter to continue.
* Keys Path - `ls /etc/letsencrypt/live/learntechnology.cloud/`


# Store the Certificate and Key in control plane.
- cd /tmp
- echo "<Cert>" > /tmp/tls.crt
- echo "<Key>" > /tmp/tls.key

# Generate the Secret and store the key and cert
- kubectl create secret tls nginx-tls-default --key="tls.key" --cert="tls.crt" -n ingress-nginx
- kubectl describe secret nginx-tls-default -n ingress-nginx


# Configure Ingress Controller - It will create the NetworkLoadBalancer as well in AWS.
- kubectl create -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.1/deploy/static/provider/aws/deploy.yaml
- Create three DNS record in Route53 for the same LoadBalancer DNS name.
- www.learntechnology.cloud, vote.learntechnology.cloud and result.learntechnology.cloud

# Now create the Ingress Resource - Secrets will be used in ingress rule for https.
- kubectl apply -f ingress_rule.yaml -n ingress-nginx