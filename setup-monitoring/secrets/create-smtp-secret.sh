. $(dirname $0)/values
kubectl delete secret smtp-creds -n turbomonitor --ignore-not-found
if [ -z "${smtp-pass}" ] ; then
    kubectl create secret generic smtp-creds -n turbomonitor --from-literal=smtp-host=${smtp_host} --from-literal=smtp-port=${smtp_port} --from-literal=from-email=${from_email} --from-literal=to-email=${to_email}
else
    kubectl create secret generic smtp-creds -n turbomonitor --from-literal=smtp-host=${smtp_host} --from-literal=smtp-port=${smtp_port} --from-literal=from-email=${from_email} --from-literal=to-email=${to_email} --from-literal=smtp-user=${smtp_user} --from-literal=smtp-pass=${smtp_pass}
fi