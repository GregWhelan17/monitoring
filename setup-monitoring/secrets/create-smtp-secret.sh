. $(dirname $0)/values
kubectl delete secret smtp-creds -n turbomonitor --ignore-not-found
if [ -z "${smtp-pass}" ] ; then
    kubectl create secret generic smtp-creds -n turbomonitor --from-literal=smtp-host=${smtp-host} --from-literal=smtp-port=${smtp-port} --from-literal=from-email=${from-email} --from-literal=to-email=${to-email}
else
    kubectl create secret generic smtp-creds -n turbomonitor --from-literal=smtp-host=${smtp-host} --from-literal=smtp-port=${smtp-port} --from-literal=from-email=${from-email} --from-literal=to-email=${to-email} --from-literal=smtp-user=${smtp-user} --from-literal=smtp-pass=${smtp-pass}
fi