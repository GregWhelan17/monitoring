. $(dirname $0)/values
kubectl delete configmap monitor-config -n turbomonitor --ignore-not-found
kubectl create configmap monitor-config -n turbomonitor --from-literal scripts=${scripts} --from-literal noncriticalpods=${noncriticalpods}
