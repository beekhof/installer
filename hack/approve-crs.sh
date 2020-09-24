#!/bin/bash
OC="oc --kubeconfig=./$1/auth/kubeconfig"
COUNT=$($OC get csr -o name | wc -l)
if [ $COUNT = 0 ]; then
    exit 0
fi		 
$OC get csr -o name | xargs $OC adm certificate approve
