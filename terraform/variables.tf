variable "dns_zone_name" {
  default = "skowronski.tech"
}

variable "cf_zone_id" {
  default = "6443f45f13776c3183e79b68443b4201" 
  # https://dash.cloudflare.com/88589d93cc8f76b46b433d4937d5890e/skowronski.tech
}

variable "cf_worker_path" {
  default = "LLcuOtUmfkzIaOxz" 
  # random string but has to be in sync with ../web/layouts/partials/extend-header.html
}
