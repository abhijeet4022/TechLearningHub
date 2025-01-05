# Install Snapd in Centos Stream 8.
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
* Generate SSL Certificate.
`certbot certonly --manual --preferred-challenges=dns --key-type rsa --email abhijeet4022@gmail.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.learntechnology.cloud -v`



# Configure Ingress Controller
- https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.1/deploy/static/provider/aws/deploy.yaml

# Store the Certificate and Key in file
- cd /tmp
- echo "<Cert>" > /tmp/tls.crt
- echo "<Key>" > /tmp/tls.key

# Generate the Secret and store the key and cert
- kubectl create secret tls nginx-tls-default --key="tls.key" --cert="tls.crt"
- kubectl describe secret nginx-tls-default

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

- docker rmi $(docker ps -aq) -f
- docker system prune -a 


