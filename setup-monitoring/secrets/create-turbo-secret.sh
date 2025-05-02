kubectl delete secret turbo-creds -n turbomonitor --ignore-not-found
kubectl create secret generic turbo-creds -n turbomonitor --from-literal=turbohost=10.188.161.53 --from-literal=turbouser=administrator  --from-literal=turbopass='t1v0l1A1'
