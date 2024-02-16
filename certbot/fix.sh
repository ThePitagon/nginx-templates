#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

# DEFINE VARIABLES & FUNCTIONS

# New IP address for certbot verification
NEW_IP_ADDRESS="LOCAL_IP_ADDRESS"

# Certbot variables
CERTBOT_DIR="/opt/certbot"

# Function to update DNS record
update_dns_record() {
  local api_key="$1"
  local zone_id="$2"
  local record_name="$3"
  local ip_address="$4"
  record_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?name=$record_name&type=A" \
    -H "Authorization: Bearer $api_key" \
    -H "Content-Type: application/json" | jq -r '.result[0].id')
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" \
    -H "Authorization: Bearer $api_key" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip_address\"}"
  sleep 1 # Wait for 1 seconds to prevent blocking by Cloudflare
}

# Function to wait for DNS propagation
wait_for_dns_update() {
  local record_name="$1"
  local expected_ip="$2"
  local resolved_ip=""
  while true; do
    resolved_ip=$(ping -c 1 "$record_name" | grep -oP '(?<=\().*?(?=\))' | head -1)
    if [[ "$resolved_ip" == "$expected_ip" ]]; then
      echo "DNS update confirmed: $record_name resolved to $expected_ip"
      break
    else
      echo "Waiting for DNS update to $expected_ip... ($record_name resolved to $resolved_ip)"
      sleep 10 # Wait for 10 seconds before trying again
    fi
  done
}

# START PROCESSING
cd "$CERTBOT_DIR" || (echo "Cannot access $CERTBOT_DIR" && exit)

echo "Reading pre-defined domains from domains.json..."
declare -A domain_details
# Read JSON and populate array
while IFS="=" read -r domain api_zone; do
  domain_details[$domain]=$api_zone
done < <(jq -r '. as $parent | to_entries[] | .key as $api | .value | to_entries[] | .key as $zone | .value[] | . as $domain | "\($domain)=\($api),\($zone)"' domains.json)
# Example usage: iterate over the array
for domain in "${!domain_details[@]}"; do
  # shellcheck disable=SC2206
  api_key_zone=(${domain_details[$domain]//,/ })
  api_key=${api_key_zone[0]}
  zone_id=${api_key_zone[1]}
  if [[ -n "$api_key" ]] && [[ -n "$zone_id" ]]; then
    # Update DNS record
    echo "Updating record for $domain with API Key: $api_key and Zone ID: $zone_id..."
    update_dns_record "$api_key" "$zone_id" "$domain" "$NEW_IP_ADDRESS"
  else
    echo "API key or Zone ID not found for domain $domain"
  fi
done
for domain in "${domain_details[@]}"; do
  wait_for_dns_update "$domain" "$NEW_IP_ADDRESS"
done
echo "Done"

echo "All services should work normally now."

