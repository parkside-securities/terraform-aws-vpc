variable "name" {
  description = <<-EOT
    Name to be used on all the resources as identifier
  EOT
  type        = string
  default     = ""
}

variable "cidr" {
  description = <<-EOT
    The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden
  EOT
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_ipv6" {
  description = <<-EOT
    Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block.
  EOT
  type        = bool
  default     = false
}

variable "private_subnet_ipv6_prefixes" {
  description = <<-EOT
    Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list.
  EOT
  type        = list
  default     = []
}

variable "public_subnet_ipv6_prefixes" {
  description = <<-EOT
    Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list
  EOT
  type        = list
  default     = []
}

variable "assign_ipv6_address_on_creation" {
  description = <<-EOT
    Assign IPv6 address on subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  EOT
  type        = bool
  default     = false
}

variable "private_subnet_assign_ipv6_address_on_creation" {
  description = <<-EOT
    Assign IPv6 address on private subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  EOT
  type        = bool
  default     = null
}

variable "public_subnet_assign_ipv6_address_on_creation" {
  description = <<-EOT
    Assign IPv6 address on public subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  EOT
  type        = bool
  default     = null
}

variable "secondary_cidr_blocks" {
  description = <<-EOT
    List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool
  EOT
  type        = list(string)
  default     = []
}

variable "instance_tenancy" {
  description = <<-EOT
    A tenancy option for instances launched into the VPC
  EOT
  type        = string
  default     = "default"
}

variable "public_subnet_suffix" {
  description = <<-EOT
    Suffix to append to public subnets name
  EOT
  type        = string
  default     = "public"
}

variable "private_subnet_suffix" {
  description = <<-EOT
    Suffix to append to private subnets name
  EOT
  type        = string
  default     = "private"
}

variable "public_subnets" {
  description = <<-EOT
    A list of public subnets inside the VPC
  EOT
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = <<-EOT
    A list of private subnets inside the VPC
  EOT
  type        = list(string)
  default     = []
}

variable "azs" {
  description = <<-EOT
    A list of availability zones names or ids in the region
  EOT
  type        = list(string)
  default     = []
}

variable "enable_dns_hostnames" {
  description = <<-EOT
    Should be true to enable DNS hostnames in the VPC
  EOT
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = <<-EOT
    Should be true to enable DNS support in the VPC
  EOT
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = <<-EOT
    Should be true if you want to provision NAT Gateways for each of your private networks
  EOT
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = <<-EOT
    Should be true if you want to provision a single shared NAT Gateway across all of your private networks
  EOT
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = <<-EOT
    Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`.
  EOT
  type        = bool
  default     = false
}

variable "reuse_nat_ips" {
  description = <<-EOT
    Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable
  EOT
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = <<-EOT
    List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)
  EOT
  type        = list(string)
  default     = []
}

variable "enable_dynamodb_endpoint" {
  description = <<-EOT
    Should be true if you want to provision a DynamoDB endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "enable_s3_endpoint" {
  description = <<-EOT
    Should be true if you want to provision an S3 endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "enable_sqs_endpoint" {
  description = <<-EOT
    Should be true if you want to provision an SQS endpoint to the VPC
  EOT
  default     = false
}

variable "sqs_endpoint_security_group_ids" {
  description = <<-EOT
    The ID of one or more security groups to associate with the network interface for SQS endpoint
  EOT
  default     = []
}

variable "sqs_endpoint_subnet_ids" {
  description = <<-EOT
    The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used.
  EOT
  default     = []
}

variable "sqs_endpoint_private_dns_enabled" {
  description = <<-EOT
    Whether or not to associate a private hosted zone with the specified VPC for SQS endpoint
  EOT
  default     = false
}

variable "enable_sns_endpoint" {
  description = <<-EOT
    Should be true if you want to provision a SNS endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "sns_endpoint_security_group_ids" {
  description = <<-EOT
    The ID of one or more security groups to associate with the network interface for SNS endpoint
  EOT
  type        = list(string)
  default     = []
}

variable "sns_endpoint_subnet_ids" {
  description = <<-EOT
    The ID of one or more subnets in which to create a network interface for SNS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used.
  EOT
  type        = list(string)
  default     = []
}

variable "sns_endpoint_private_dns_enabled" {
  description = <<-EOT
    Whether or not to associate a private hosted zone with the specified VPC for SNS endpoint
  EOT
  type        = bool
  default     = false
}

variable "enable_monitoring_endpoint" {
  description = <<-EOT
    Should be true if you want to provision a CloudWatch Monitoring endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "monitoring_endpoint_security_group_ids" {
  description = <<-EOT
    The ID of one or more security groups to associate with the network interface for CloudWatch Monitoring endpoint
  EOT
  type        = list(string)
  default     = []
}

variable "monitoring_endpoint_subnet_ids" {
  description = <<-EOT
    The ID of one or more subnets in which to create a network interface for CloudWatch Monitoring endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used.
  EOT
  type        = list(string)
  default     = []
}

variable "monitoring_endpoint_private_dns_enabled" {
  description = <<-EOT
    Whether or not to associate a private hosted zone with the specified VPC for CloudWatch Monitoring endpoint
  EOT
  type        = bool
  default     = false
}

variable "enable_events_endpoint" {
  description = <<-EOT
    Should be true if you want to provision a CloudWatch Events endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "events_endpoint_security_group_ids" {
  description = <<-EOT
    The ID of one or more security groups to associate with the network interface for CloudWatch Events endpoint
  EOT
  type        = list(string)
  default     = []
}

variable "events_endpoint_subnet_ids" {
  description = <<-EOT
    The ID of one or more subnets in which to create a network interface for CloudWatch Events endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used.
  EOT
  type        = list(string)
  default     = []
}

variable "events_endpoint_private_dns_enabled" {
  description = <<-EOT
    Whether or not to associate a private hosted zone with the specified VPC for CloudWatch Events endpoint
  EOT
  type        = bool
  default     = false
}

variable "enable_logs_endpoint" {
  description = <<-EOT
    Should be true if you want to provision a CloudWatch Logs endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "logs_endpoint_security_group_ids" {
  description = <<-EOT
    The ID of one or more security groups to associate with the network interface for CloudWatch Logs endpoint
  EOT
  type        = list(string)
  default     = []
}

variable "logs_endpoint_subnet_ids" {
  description = <<-EOT
    The ID of one or more subnets in which to create a network interface for CloudWatch Logs endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used.
  EOT
  type        = list(string)
  default     = []
}

variable "logs_endpoint_private_dns_enabled" {
  description = <<-EOT
    Whether or not to associate a private hosted zone with the specified VPC for CloudWatch Logs endpoint
  EOT
  type        = bool
  default     = false
}

variable "enable_cloudtrail_endpoint" {
  description = <<-EOT
    Should be true if you want to provision a CloudTrail endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "cloudtrail_endpoint_security_group_ids" {
  description = <<-EOT
    The ID of one or more security groups to associate with the network interface for CloudTrail endpoint
  EOT
  type        = list(string)
  default     = []
}

variable "cloudtrail_endpoint_subnet_ids" {
  description = <<-EOT
    The ID of one or more subnets in which to create a network interface for CloudTrail endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used.
  EOT
  type        = list(string)
  default     = []
}

variable "cloudtrail_endpoint_private_dns_enabled" {
  description = <<-EOT
    Whether or not to associate a private hosted zone with the specified VPC for CloudTrail endpoint
  EOT
  type        = bool
  default     = false
}

variable "enable_sts_endpoint" {
  description = <<-EOT
    Should be true if you want to provision a STS endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "sts_endpoint_security_group_ids" {
  description = <<-EOT
    The ID of one or more security groups to associate with the network interface for STS endpoint
  EOT
  type        = list(string)
  default     = []
}

variable "sts_endpoint_subnet_ids" {
  description = <<-EOT
    The ID of one or more subnets in which to create a network interface for STS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used.
  EOT
  type        = list(string)
  default     = []
}

variable "sts_endpoint_private_dns_enabled" {
  description = <<-EOT
    Whether or not to associate a private hosted zone with the specified VPC for STS endpoint
  EOT
  type        = bool
  default     = false
}

variable "enable_storagegateway_endpoint" {
  description = <<-EOT
    Should be true if you want to provision a Storage Gateway endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "storagegateway_endpoint_security_group_ids" {
  description = <<-EOT
    The ID of one or more security groups to associate with the network interface for Storage Gateway endpoint
  EOT
  type        = list(string)
  default     = []
}

variable "storagegateway_endpoint_subnet_ids" {
  description = <<-EOT
    The ID of one or more subnets in which to create a network interface for Storage Gateway endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used.
  EOT
  type        = list(string)
  default     = []
}

variable "storagegateway_endpoint_private_dns_enabled" {
  description = <<-EOT
    Whether or not to associate a private hosted zone with the specified VPC for Storage Gateway endpoint
  EOT
  type        = bool
  default     = false
}

variable "enable_efs_endpoint" {
  description = <<-EOT
    Should be true if you want to provision an EFS endpoint to the VPC
  EOT
  type        = bool
  default     = false
}

variable "efs_endpoint_security_group_ids" {
  description = <<-EOT
    The ID of one or more security groups to associate with the network interface for EFS endpoint
  EOT
  type        = list(string)
  default     = []
}

variable "efs_endpoint_subnet_ids" {
  description = <<-EOT
    The ID of one or more subnets in which to create a network interface for EFS endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used.
  EOT
  type        = list(string)
  default     = []
}

variable "efs_endpoint_private_dns_enabled" {
  description = <<-EOT
    Whether or not to associate a private hosted zone with the specified VPC for EFS endpoint
  EOT
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch" {
  description = <<-EOT
    Should be false if you do not want to auto-assign public IP on launch
  EOT
  type        = bool
  default     = true
}

variable "customer_gateways" {
  description = <<-EOT
    Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)
  EOT
  type        = map(map(any))
  default     = {}
}

variable "enable_vpn_gateway" {
  description = <<-EOT
    Should be true if you want to create a new VPN Gateway resource and attach it to the VPC
  EOT
  type        = bool
  default     = false
}

variable "vpn_gateway_id" {
  description = <<-EOT
    ID of VPN Gateway to attach to the VPC
  EOT
  default     = ""
}

variable "amazon_side_asn" {
  description = <<-EOT
    The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the virtual private gateway is created with the current default Amazon ASN.
  EOT
  default     = "64512"
}

variable "vpn_gateway_az" {
  description = <<-EOT
    The Availability Zone for the VPN Gateway
  EOT
  type        = string
  default     = null
}

variable "propagate_private_route_tables_vgw" {
  description = <<-EOT
    Should be true if you want route table propagation
  EOT
  type        = bool
  default     = false
}

variable "propagate_public_route_tables_vgw" {
  description = <<-EOT
    Should be true if you want route table propagation
  EOT
  type        = bool
  default     = false
}

variable "tags" {
  description = <<-EOT
    A map of tags to add to all resources
  EOT
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = <<-EOT
    Additional tags for the VPC
  EOT
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = <<-EOT
    Additional tags for the internet gateway
  EOT
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = <<-EOT
    Additional tags for the public subnets
  EOT
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = <<-EOT
    Additional tags for the private subnets
  EOT
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  description = <<-EOT
    Additional tags for the public route tables
  EOT
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = <<-EOT
    Additional tags for the private route tables
  EOT
  type        = map(string)
  default     = {}
}

variable "public_acl_tags" {
  description = <<-EOT
    Additional tags for the public subnets network ACL
  EOT
  type        = map(string)
  default     = {}
}

variable "private_acl_tags" {
  description = <<-EOT
    Additional tags for the private subnets network ACL
  EOT
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags" {
  description = <<-EOT
    Additional tags for the NAT gateways
  EOT
  type        = map(string)
  default     = {}
}

variable "nat_eip_tags" {
  description = <<-EOT
    Additional tags for the NAT EIP
  EOT
  type        = map(string)
  default     = {}
}

variable "customer_gateway_tags" {
  description = <<-EOT
    Additional tags for the Customer Gateway
  EOT
  type        = map(string)
  default     = {}
}

variable "vpn_gateway_tags" {
  description = <<-EOT
    Additional tags for the VPN gateway
  EOT
  type        = map(string)
  default     = {}
}

variable "vpc_endpoint_tags" {
  description = <<-EOT
    Additional tags for the VPC Endpoints
  EOT
  type        = map(string)
  default     = {}
}

variable "vpc_flow_log_tags" {
  description = <<-EOT
    Additional tags for the VPC Flow Logs
  EOT
  type        = map(string)
  default     = {}
}

variable "manage_default_network_acl" {
  description = <<-EOT
    Should be true to adopt and manage Default Network ACL
  EOT
  type        = bool
  default     = false
}

variable "default_network_acl_name" {
  description = <<-EOT
    Name to be used on the Default Network ACL
  EOT
  type        = string
  default     = ""
}

variable "default_network_acl_tags" {
  description = <<-EOT
    Additional tags for the Default Network ACL
  EOT
  type        = map(string)
  default     = {}
}

variable "public_dedicated_network_acl" {
  description = <<-EOT
    Whether to use dedicated network ACL (not default) and custom rules for public subnets
  EOT
  type        = bool
  default     = false
}

variable "private_dedicated_network_acl" {
  description = <<-EOT
    Whether to use dedicated network ACL (not default) and custom rules for private subnets
  EOT
  type        = bool
  default     = false
}

variable "default_network_acl_ingress" {
  description = <<-EOT
    List of maps of ingress rules to set on the Default Network ACL
  EOT
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "default_network_acl_egress" {
  description = <<-EOT
    List of maps of egress rules to set on the Default Network ACL
  EOT
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "public_inbound_acl_rules" {
  description = <<-EOT
    Public subnets inbound network ACLs
  EOT
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_outbound_acl_rules" {
  description = <<-EOT
    Public subnets outbound network ACLs
  EOT
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_inbound_acl_rules" {
  description = <<-EOT
    Private subnets inbound network ACLs
  EOT
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_outbound_acl_rules" {
  description = <<-EOT
    Private subnets outbound network ACLs
  EOT
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "enable_flow_log" {
  description = <<-EOT
    Whether or not to enable VPC Flow Logs
  EOT
  type        = bool
  default     = false
}

variable "create_flow_log_cloudwatch_log_group" {
  description = <<-EOT
    Whether to create CloudWatch log group for VPC Flow Logs
  EOT
  type        = bool
  default     = false
}

variable "create_flow_log_cloudwatch_iam_role" {
  description = <<-EOT
    Whether to create IAM role for VPC Flow Logs
  EOT
  type        = bool
  default     = false
}

variable "flow_log_traffic_type" {
  description = <<-EOT
    The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL.
  EOT
  type        = string
  default     = "ALL"
}

variable "flow_log_destination_type" {
  description = <<-EOT
    Type of flow log destination. Can be s3 or cloud-watch-logs.
  EOT
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_log_log_format" {
  description = <<-EOT
    The fields to include in the flow log record, in the order in which they should appear.
  EOT
  type        = string
  default     = null
}

variable "flow_log_destination_arn" {
  description = <<-EOT
    The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create_flow_log_cloudwatch_log_group is set to false this argument must be provided.
  EOT
  type        = string
  default     = ""
}

variable "flow_log_cloudwatch_iam_role_arn" {
  description = <<-EOT
    The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow_log_destination_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided.
  EOT
  type        = string
  default     = ""
}

variable "flow_log_cloudwatch_log_group_name_prefix" {
  description = <<-EOT
    Specifies the name prefix of CloudWatch Log Group for VPC flow logs.
  EOT
  type        = string
  default     = "/aws/vpc-flow-log/"
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = <<-EOT
    Specifies the number of days you want to retain log events in the specified log group for VPC flow logs.
  EOT
  type        = number
  default     = null
}

variable "flow_log_cloudwatch_log_group_kms_key_id" {
  description = <<-EOT
    The ARN of the KMS Key to use when encrypting log data for VPC flow logs.
  EOT
  type        = string
  default     = null
}

variable "tgw_id" {
  description = <<-EOT
	  TGW ID to attach to the VPC.
  EOT
  default     = null
}

variable "tgw_attach_default_route_table_association" {
  description = <<-EOT
	  Whether the VPC Attachment should be associated with the EC2 Transit gateway default route table.
	EOT
  default     = true
}

variable "tgw_attach_default_route_table_propagation" {
  description = <<-EOT
	  Whether the VPC Attachment should propagate routes to the EC2 transit Gateway default route table.
	EOT
  default     = true
}

variable "use_tgw_for_egress" {
  description = <<-EOT
	  Set to true only when the transit gateway routing table contains a deafult route to an egress VPC. Set to false when the VPC is being used as an egress point for other VPCs attached to the same transit gateway.
	EOT
  default     = true
}

