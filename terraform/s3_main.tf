resource "aws_s3_bucket" "bucket_main" {
  bucket = var.dns_zone_name
}

resource "aws_s3_bucket_website_configuration" "bucket_website_main" {
  bucket = aws_s3_bucket.bucket_main.bucket 

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy_main" {
  bucket = aws_s3_bucket.bucket_main.id

  policy = data.aws_iam_policy_document.iam_policy_bucket_main.json
}

data "aws_iam_policy_document" "iam_policy_bucket_main" {  
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket_main.arn}/*",
    ]
  }
}
