terraform {
  backend "s3" {
    bucket = "terraform-state-eivistamos"
    key    = "static-site/terraform.tfstate"
    region = "eu-west-2"
    # optional
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
