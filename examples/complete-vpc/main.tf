provider "aws" {
  region = "eu-west-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "../../"

  name = "complete-example"

  cidr = "20.10.0.0/16" # 10.0.0.0/8 is reserved for EC2-Classic

  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets      = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
  public_subnets       = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  customer_gateways = {
    IP1 = {
      bgp_asn    = 65112
      ip_address = "1.2.3.4"
    },
    IP2 = {
      bgp_asn    = 65112
      ip_address = "5.6.7.8"
    }
  }

  enable_vpn_gateway = true

  # VPC endpoint for S3
  enable_s3_endpoint = true

  # VPC endpoint for DynamoDB
  enable_dynamodb_endpoint = true

  # VPC endpoint for SQS
  enable_sqs_endpoint              = true
  sqs_endpoint_private_dns_enabled = true
  sqs_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  tags = {
    Owner       = "user"
    Environment = "staging"
    Name        = "complete"
  }

  vpc_endpoint_tags = {
    Project  = "Secret"
    Endpoint = "true"
  }
}

