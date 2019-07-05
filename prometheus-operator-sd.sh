#!/bin/sh -e

ENDPOINT=$1
OUTPUT=${2:-/dev/stdout}

while true; do
	echo --- > "$OUTPUT"
	curl --noproxy "$ENDPOINT" -s -m 60 -H "Authorization: Bearer ${AUTH_TOKEN}" "https://$ENDPOINT/apis/monitoring.coreos.com/v1/prometheuses" | jq -r '.items[].metadata|.name,.namespace' | while read -r prometheus; read -r namespace; do
		if test "$namespace" != "openshift-monitoring"; then
		cat <<EOF>>"$OUTPUT"
- targets:
    - $ENDPOINT
  labels:
    service: $prometheus
    namespace: $namespace
EOF
		fi
	done
	sleep 10
done
