
# Setting up S3 Bucket

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "bucket_public_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Setting up OAC for S3 Bucket

resource "aws_cloudfront_origin_access_control" "bucket_oac" {
  name                              = "${aws_s3_bucket.website_bucket.id}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Setting up and attaching Bucket Policy for OAC

resource "aws_s3_bucket_policy" "bucket_policy_oac" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = ["s3:GetObject"]
        Resource = [
          aws_s3_bucket.website_bucket.arn,
          "${aws_s3_bucket.website_bucket.arn}/*",
        ]
      }
    ]
  })
}

# Setting up CloudFront Distribution with OAC for S3 Bucket

resource "aws_cloudfront_distribution" "distribution" {

  origin {
    origin_id                = "s3origin"
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.bucket_oac.id
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = ["${aws_s3_bucket.website_bucket.id}"]

  default_cache_behavior {
    target_origin_id       = "s3origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    compress               = true
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  http_version = "http2"

}

# Creating Records in Route 53 for Routing

resource "aws_route53_record" "a_record" {

  zone_id = var.hosted_zone_id      #<--------------Variable
  name    = var.domain_name
  type    = "A"

  alias {
    zone_id                = "Z2FDTNDATAQYW2"
    name                   = aws_cloudfront_distribution.distribution.domain_name
    evaluate_target_health = false

  }

}