#!/bin/bash
cluster=$1; shift
kubectl --kubeconfig=./$cluster/auth/kubeconfig $*
