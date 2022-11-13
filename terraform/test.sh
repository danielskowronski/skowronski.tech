#!/bin/bash
echo "=== terraform_plan"
terraform plan

echo "=== purge_cache"
curl -X POST "https://api.cloudflare.com/client/v4/zones/7b7d2e061ace78b28877d4e846714c0a/purge_cache" \
     -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'

echo "=== sleep"
sleep 30

echo "=== check_main"
ip_of_main=`dig skowronski.pro 1.1.1.1 +short | head -n1`
curl -v --resolve skowronski.pro:443:${ip_of_www} https://skowronski.pro/ 2>&1 | grep -i location
curl -L --resolve skowronski.pro:443:${ip_of_main} https://skowronski.pro/robots.txt
echo

echo "=== check_www"
ip_of_www=`dig www.skowronski.pro 1.1.1.1 +short | head -n1`
curl -v --resolve www.skowronski.pro:443:${ip_of_www} https://www.skowronski.pro/ 2>&1 | grep -i location
curl -L --resolve www.skowronski.pro:443:${ip_of_www} https://www.skowronski.pro/robots.txt
echo
