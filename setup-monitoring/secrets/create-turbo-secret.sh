. $(dirname $0)/values
kubectl delete secret turbo-creds -n turbomonitor --ignore-not-found
kubectl create secret generic turbo-creds -n turbomonitor --from-literal=turbohost=${turbohost} --from-literal=turbouser=${turbouser}  --from-literal=turbopass=${turbopass}
