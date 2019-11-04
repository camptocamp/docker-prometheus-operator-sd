#!/bin/sh -e

OUTPUT=${OUTPUT:-/dev/stdout}

while true; do
	echo --- > "$OUTPUT"
	curl --noproxy "$ENDPOINT" -s -m 60 -H "Authorization: Bearer ${AUTH_TOKEN}" "https://$ENDPOINT/apis/monitoring.coreos.com/v1/prometheuses" | jq -r '.items[]|(.metadata|.name,.namespace),.spec.externalUrl' | while read -r prometheus; read -r namespace; read -r externalurl; do
		target=${externalurl#https://}
		target=${target%/}
		cat <<EOF>>"$OUTPUT"
- targets:
    - $ENDPOINT
  labels:
    service: $prometheus
    namespace: $namespace
EOF
	done
	sleep 10
done
