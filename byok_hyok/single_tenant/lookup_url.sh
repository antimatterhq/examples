#!/bin/bash

# A simple script to generate the admin URL for a given domain

id="${DOMAIN_ID}"
apiKey="${ANTIMATTER_API_KEY}"
# This is the name you want your customer to see you as
companyName="CompanyName"
api="https://api.antimatter.io/v1"

if [ -z "$id" ]; then
    echo "Error: missing the $$DOMAIN_ID environment variable"
    exit 1
fi

if [ -z "$apiKey" ]; then
    echo "Error: missing the $$ANTIMATTER_API_KEY environment variable"
    exit 1
fi

set -e

# Create an auth token for the domain
token_response=$(curl -sS  -X 'POST' \
  "${api}/domains/${id}/authenticate" \
  -H 'Content-Type: application/json' \
  -d '{
  "token": "'"$apiKey"'"
}')
echo $token_response

token=$(echo $token_response | jq -r '.token | @uri' )

echo "The customer domain ID is ${id}"
echo "The URL to edit their settings is " \
  "https://app.antimatter.io/settings/${id}/byok?vendor=${companyName}&token=${token}"
