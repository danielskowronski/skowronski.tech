# https://plausible.io/docs/proxy/guides/cloudflare

resource "cloudflare_worker_script" "plausible_proxy_script" {
  name = lower(var.cf_worker_path)
  content = templatefile("worker_plausible.js", {cf_worker_path=var.cf_worker_path})
}
resource "cloudflare_worker_route" "plausible_proxy_route" {
  zone_id = var.cf_zone_id
  pattern = "*${var.dns_zone_name}/${var.cf_worker_path}/*"
  script_name = cloudflare_worker_script.plausible_proxy_script.name
}
