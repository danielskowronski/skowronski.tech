terraform {
  backend "s3" {
    bucket = "scloud-terraform"
    key    = "skowronski-tech/skowronski-tech.tfstate"
    region = "eu-central-1"
  }
}