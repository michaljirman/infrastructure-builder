# Infrastructure As Code - Proof of Concept
## Building infrastructure on AWS using terraform

### Install the awscli and kubectl

For example (macosx):
```bash
$ pip install awscli
$ brew install kubernetes-cli
```

### Setup AWS credentials in the ~/.aws/credentials file
```text
[dev-account]
aws_access_key_id = 
aws_secret_access_key = 
[staging-account]
aws_access_key_id = 
aws_secret_access_key = 
```

### Issues => needs to be created manually or using cli firstly, before terraform init/apply
S3 bucket and AWS DynamoDB Table needs to be created first
```bash
aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${BUCKET_REGION}" \
          --create-bucket-configuration LocationConstraint="${BUCKET_REGION}"
```

### Create an AWS image (IAM) for the k8s nodes
AWS_PROFILE=${AWS_PROFILE} packer build node.json

### Configure terraform build in `variables.tf` or set the ENV variables
```yaml
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
  description = "The name of our SSH keypair you've created and downloaded from the AWS console."
}
```

### Validate, plan and apply infrastructure
```bash
$ terraform validate
$ terraform plan -out initial_infrastructure.plan
$ terraform apply "initial_infrastructure.plan" \
            -var 'cluster_name=my-company-dev-cluster' \
            -var 'aws_profile=my-company-dev-profile' \
            -var 'key_name=my-company-dev-keypair'
```

### Test k8s cluster and accessibility of the pods
```bash
$ kubectl --kubeconfig=${YOUR_KUBECONFIG} get pods --all-namespaces
$ kubectl --kubeconfig=${YOUR_KUBECONFIG} get deployments --all-namespacess 
...
```

### Test if metrics-server was successfully deployed
```bash
$ kubectl --kubeconfig=${YOUR_KUBECONFIG} top nodes
```

### Optional 1 (Helm installation)
[Helm Server (Tiller) installation in kubernetes cluster](02_Helm_installation_and_deployment.md)



