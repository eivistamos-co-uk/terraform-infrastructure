output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}

output "domain_name" {
  value = var.domain_name
}