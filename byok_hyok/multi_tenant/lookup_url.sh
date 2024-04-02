#!/bin/bash

# A simple script to generate the admin URL for a given subdomain

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Error: No subdomain nickname provided. Please provide a nickname as an argument."
    exit 1
fi

nickname=$1

id="${PARENT_DOMAIN_ID}"
apiKey="${ANTIMATTER_API_KEY}"
# This is the name you want your customer to see you as
companyName="CompanyName"
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


# Create an auth token for the parent domain (this is scoped to all customers)
token_response=$(curl -sS  -X 'POST' \
  "${api}/domains/${id}/authenticate" \
  -H 'Content-Type: application/json' \
  -d '{
  "token": "'"$apiKey"'"
}')

token=$(echo $token_response | jq -r .token)

# Now get the domain ID of the customer we are interested in from the nickname
subdomain_id=$(curl -sS  -H "Authorization: Bearer $token" -X 'GET' \
  "${api}/domains/${id}/peer-domain?nickname=${nickname}" | jq -r .id)

# Generate a token that is only valid for this customer
subtoken_response=$(curl -sS -X 'POST' \
  "${api}/domains/${subdomain_id}/authenticate?tokenExchange=true" \
  -H 'Content-Type: application/json' \
  -d '{
  "token": "'"${token}"'"
}')
subtoken=$(echo $subtoken_response | jq -r '.token | @uri')

echo "The customer domain ID is ${subdomain_id}"
echo "The URL to edit their settings is " \
  "https://app.antimatter.io/settings/${subdomain_id}/byok?vendor=${companyName}&token=${subtoken}"
