# Once the code is complete, follow the below steps.
Create the helloworld.txt file 
```
cat <<EOF >> helloworld.txt
Copied a local file to my EC2 instance via Terraform!
EOF
```

`terraform init`

`terraform apply`

`ssh -o StrictHostKeyChecking=no -i key.pem ubuntu@$(terraform output -json | jq -r .public_ip.value)`

`cat /tmp/helloworld.txt`
