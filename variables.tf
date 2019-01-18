variable "cluster_name" {
  description = "The name for the K8s cluster."
}

variable "availability_zones" {
  default     = ["us-west-2a","us-west-2b"]
  description = "The availability zones to run the cluster in."
}

variable "aws_profile_region" {
  default = "us-west-2"
  description = "The AWS region"
}

variable "aws_shared_credentials_file" {
  default = "~/.aws/credentials"
  description = "The path to the AWS configuration file."
}

variable "aws_profile" {
  description = "The AWS profile to be used from the ~/.aws/credentials configuration file."
}

variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  description = "The CIDR of the VPC created for this cluster"
}

variable "k8s_version" {
  default = "1.10"
  description = "The version of Kubernetes to use."
}

# The name of our SSH keypair you've created and downloaded
# from the AWS console.
#
# https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:
#
variable "key_name" {
  description = "The name of the AWS EC2 SSH keypair you've created and downloaded from the AWS console."
}