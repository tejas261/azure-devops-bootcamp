#!/usr/bin/env bash
# Deletes scenario namespaces (clean teardown of everything in lab05 on the cluster)
for n in s1 s2 s3 s4 s5 s6 s7 s8; do kubectl delete ns "$n" --ignore-not-found --wait=false; done
