#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

# DEFINE VARIABLES & FUNCTIONS

# Nginx application directories
INC_DIRS=("app1" "app2")
# New IP address for certbot verification
NEW_IP_ADDRESS="LOCAL_IP_ADDRESS"

# Certbot variables
CERTBOT_DIR="/opt/certbot"
CERTBOT_EXPIRING_DOMAIN_OUTPUT="$CERTBOT_DIR/tmp_expiring_domains.txt"

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
  echo "===Domain: $domain | API Key: $api_key | Zone ID: $zone_id"
done
echo "Done"

echo "Getting the list of expiring domains..."
expiring_domains=()
readarray -t expiring_domains < "$CERTBOT_EXPIRING_DOMAIN_OUTPUT"
echo "${expiring_domains[@]}"
echo "Done"

echo "Start changing IP address of expiring domains to old IP address..."
for domain in "${expiring_domains[@]}"; do
  if [[ -n "${domain_details[$domain]}" ]]; then
    # Domain exists in domain_details
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
  else
    # Domain does not exist in domain_details
    echo "Domain $domain not found in domains.json"
  fi
done
for domain in "${expiring_domains[@]}"; do
  if [[ -n "${domain_details[$domain]}" ]]; then
    # Domain exists in domain_details
    wait_for_dns_update "$domain" "$NEW_IP_ADDRESS"
  fi
done
echo "Done"

truncate -s 0 "$CERTBOT_EXPIRING_DOMAIN_OUTPUT"

echo "Bring temporary nginx domain configurations back to live..."
# shellcheck disable=SC2068
for INC_DIR in ${INC_DIRS[@]}; do
  sudo mv "/etc/nginx/${INC_DIR}_tmp" "/etc/nginx/${INC_DIR}"
done
sudo systemctl restart nginx
echo "Done"
echo "All services should work normally now."

