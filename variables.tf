variable "aws_region" {
  description = "The region you would like to use for this deployment."
  type = string
  default = "eu-west-2"
}

variable "bucket_name" {
  description = "Name of your bucket to contain site files."
  type = string
}

variable "domain_name" {
  description = "Your website domain."
  type = string
}

variable "acm_certificate_arn" {
  description = "The ARN of your valid ACM certificate."
  type = string
}

variable "hosted_zone_id" {
  description = "The ID of your hosted zone."
  type = string
}