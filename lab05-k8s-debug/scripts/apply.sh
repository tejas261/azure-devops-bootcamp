#!/usr/bin/env bash
# usage: ./apply.sh s1 [ACR_LOGIN_SERVER]   (ACR only needed for s2: terraform output acr_login_server)
set -euo pipefail
s="${1:?scenario like s1}"; acr="${2:-}"
f="$(dirname "$0")/../scenarios/$s/app.yaml"
if grep -q __ACR__ "$f"; then [ -n "$acr" ] || { echo "s2 needs ACR login server"; exit 1; }; sed "s#__ACR__#$acr#" "$f" | kubectl apply -f -; else kubectl apply -f "$f"; fi
echo "Applied $s. Symptom is in README. Go debug: kubectl -n $s get all"
