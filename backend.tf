/*
  To configure the s3 backend for team use fill in
  bucket and dynamodb_table, if not required delete this
  file.
*/

terraform {
  backend "s3" {
    encrypt = true
    bucket = "com.${var.cluster_name}.terraform-state"
    key = "us-west-2.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform-state-lock-dynamo"
    profile = "${var.aws_profile}"
  }
}