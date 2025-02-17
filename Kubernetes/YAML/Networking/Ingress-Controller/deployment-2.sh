echo -e "\e[32mCreating the WEB deployment:\e[0m"
kubectl create deploy image --image=httpd -n nginx-ingress --replicas=1
kubectl get pod -o wide -n nginx-ingress | grep -i image
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mExpose the deployment using ServiceIP:\e[0m"
sleep 120
kubectl expose deploy image --name=nginx-ingress-image --port=80 --target-port=80 -n nginx-ingress
kubectl describe service nginx-ingress-image -n nginx-ingress | grep -i Endpoints
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mCreate the Ingress-Controller rule:\e[0m"
kubectl create -f ingress-rule-2.yaml
kubectl get ingress -n nginx-ingress
echo -e "\e[32mDone\e[0m"

#echo "$(kubectl get pod -o wide -n nginx-ingress | awk '/nginx-ingress/{print $6}') www.example.com" >> /etc/hosts


