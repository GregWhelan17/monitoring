#!/bin/sh

cd $(dirname $0)
echo 'Setting kubernets config'
mkdir -p ~/.kube
cp /kubeconfig/config ~/.kube/config

echo 'getting configs and secrets'
for f in /config/*/* ; do
    case $(basename ${f}) in
        noncriticalpods)
            noncriticalpods=$(cat ${f})
            ;;
        scripts)
            scripts=$(cat ${f})
            ;;
        turbohost)
            turbohost=$(cat ${f})
            ;;
        turbopass)
            turbopass=$(cat ${f})
            ;;
        turbouser)
            turbouser=$(cat ${f})
            ;;
        *)
            echo 'unexpected secret or configmap entry found'
            ;;
    esac
done


echo 'Running monitors'
result=$(./monitor.sh -t ${turbohost} -u ${turbouser} -p ${turbopass} -s ${scripts} -n ${noncriticalpods})
echo "RETURNCODE: $?"
echo "RESULT: $result"
