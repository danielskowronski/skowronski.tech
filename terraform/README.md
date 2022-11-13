# skowronski.pro - terraform

## ENV
- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN` -> https://dash.cloudflare.com/profile/api-tokens
  - All zones - Workers Routes:Edit, Cache Purge:Purge, DNS:Edit
  - Entire account -  Workers Scripts:Edit, Workers Scripts:Read
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## testing

run:
```bash
bash test.sh
```

expected output:
```
=== terraform_plan
...

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
=== purge_cache
{
  "result": {
    "id": "..."
  },
  "success": true,
  "errors": [],
  "messages": []
}
=== sleep
=== check_main
User-agent: *
=== check_www
< location: https://skowronski.pro/
User-agent: *
```
