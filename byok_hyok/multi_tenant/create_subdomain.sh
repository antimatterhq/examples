#!/bin/bash

# A simple script to create a subdomain for a new tenant

if [ -z "$1" ]; then
    echo "Error: No subdomain nickname provided. Please provide a nickname as an argument."
    exit 1
fi

nickname=$1

id="${PARENT_DOMAIN_ID}"
apiKey="${ANTIMATTER_API_KEY}"
api="https://api.antimatter.io/v1"

if [ -z "$id" ]; then
    echo "Error: missing the $$PARENT_DOMAIN_ID environment variable"
    exit 1
fi

if [ -z "$apiKey" ]; then
    echo "Error: missing the $$ANTIMATTER_API_KEY environment variable"
    exit 1
fi

set -e

# Create an auth token in the parent domain
token_response=$(curl -sS -X 'POST' \
  "${api}/domains/${id}/authenticate" \
  -H 'Content-Type: application/json' \
  -d '{
  "token": "'"$apiKey"'"
}')
token=$(echo $token_response | jq -r .token)

# Generate a peer of the new domain (subdomain) for the new tenant
curl -sS -H "Authorization: Bearer $token" -X 'POST' \
  "${api}/domains/${id}/peer-domain" \
  -H 'Content-Type: application/json' \
  -d '{
  "importAliasForParent": "parent",
  "importAliasForChild": "c_'$nickname'",
  "displayNameForParent": "parent",
  "displayNameForChild": "c_'$nickname'",
  "nicknames": ["'$nickname'"],
  "linkAll": true
}'

