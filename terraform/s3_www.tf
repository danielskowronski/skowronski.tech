resource "aws_s3_bucket" "bucket_www" {
  bucket = "www.${var.dns_zone_name}"
}

resource "aws_s3_bucket_website_configuration" "bucket_website_www" {
  bucket = aws_s3_bucket.bucket_www.bucket 

  redirect_all_requests_to {
    host_name = var.dns_zone_name
    protocol = "https"
  }
}
