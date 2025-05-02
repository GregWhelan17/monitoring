kubectl delete configmap monitor-config -n turbomonitor --ignore-not-found
kubectl create configmap monitor-config -n turbomonitor --from-literal scripts='pods,pipeline,stale,actions,targets' --from-literal noncriticalpods='grafana,timescaledb'
