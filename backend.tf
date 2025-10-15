terraform {
  backend "s3" {
    bucket = "terraform-state-eivistamos" #bucket name
    key    = "static-site/terraform.tfstate" #key to state file
    region = "eu-west-2"
    dynamodb_table = "terraform-locks" #table name
    encrypt        = true
  }
}
