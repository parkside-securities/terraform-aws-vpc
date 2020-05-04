output "vpc_id" {
  description = <<-EOT
    The ID of the VPC
  EOT
  value       = concat(aws_vpc.this.*.id, [""])[0]
}

output "vpc_arn" {
  description = <<-EOT
    The ARN of the VPC
  EOT
  value       = concat(aws_vpc.this.*.arn, [""])[0]
}

output "vpc_cidr_block" {
  description = <<-EOT
    The CIDR block of the VPC
  EOT
  value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
}

output "default_security_group_id" {
  description = <<-EOT
    The ID of the security group created by default on VPC creation
  EOT
  value       = concat(aws_vpc.this.*.default_security_group_id, [""])[0]
}

output "default_network_acl_id" {
  description = <<-EOT
    The ID of the default network ACL
  EOT
  value       = concat(aws_vpc.this.*.default_network_acl_id, [""])[0]
}

output "default_route_table_id" {
  description = <<-EOT
    The ID of the default route table
  EOT
  value       = concat(aws_vpc.this.*.default_route_table_id, [""])[0]
}

output "vpc_instance_tenancy" {
  description = <<-EOT
    Tenancy of instances spin up within VPC
  EOT
  value       = concat(aws_vpc.this.*.instance_tenancy, [""])[0]
}

output "vpc_enable_dns_support" {
  description = <<-EOT
    Whether or not the VPC has DNS support
  EOT
  value       = concat(aws_vpc.this.*.enable_dns_support, [""])[0]
}

output "vpc_enable_dns_hostnames" {
  description = <<-EOT
    Whether or not the VPC has DNS hostname support
  EOT
  value       = concat(aws_vpc.this.*.enable_dns_hostnames, [""])[0]
}

output "vpc_main_route_table_id" {
  description = <<-EOT
    The ID of the main route table associated with this VPC
  EOT
  value       = concat(aws_vpc.this.*.main_route_table_id, [""])[0]
}

output "vpc_ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = concat(aws_vpc.this.*.ipv6_association_id, [""])[0]
}

output "vpc_ipv6_cidr_block" {
  description = <<-EOT
    The IPv6 CIDR block
  EOT
  value       = concat(aws_vpc.this.*.ipv6_cidr_block, [""])[0]
}

output "vpc_secondary_cidr_blocks" {
  description = <<-EOT
    List of secondary CIDR blocks of the VPC
  EOT
  value       = aws_vpc_ipv4_cidr_block_association.this.*.cidr_block
}

output "private_subnets" {
  description = <<-EOT
    List of IDs of private subnets
  EOT
  value       = aws_subnet.private.*.id
}

output "private_subnet_arns" {
  description = <<-EOT
    List of ARNs of private subnets
  EOT
  value       = aws_subnet.private.*.arn
}

output "private_subnets_cidr_blocks" {
  description = <<-EOT
    List of cidr_blocks of private subnets
  EOT
  value       = aws_subnet.private.*.cidr_block
}

output "private_subnets_ipv6_cidr_blocks" {
  description = <<-EOT
    List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC
  EOT
  value       = aws_subnet.private.*.ipv6_cidr_block
}

output "public_subnets" {
  description = <<-EOT
    List of IDs of public subnets
  EOT
  value       = aws_subnet.public.*.id
}

output "public_subnet_arns" {
  description = <<-EOT
    List of ARNs of public subnets
  EOT
  value       = aws_subnet.public.*.arn
}

output "public_subnets_cidr_blocks" {
  description = <<-EOT
    List of cidr_blocks of public subnets
  EOT
  value       = aws_subnet.public.*.cidr_block
}

output "public_subnets_ipv6_cidr_blocks" {
  description = <<-EOT
    List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC
  EOT
  value       = aws_subnet.public.*.ipv6_cidr_block
}

output "public_route_table_ids" {
  description = <<-EOT
    List of IDs of public route tables
  EOT
  value       = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  description = <<-EOT
    List of IDs of private route tables
  EOT
  value       = aws_route_table.private.*.id
}

output "nat_ids" {
  description = <<-EOT
    List of allocation ID of Elastic IPs created for AWS NAT Gateway
  EOT
  value       = aws_eip.nat.*.id
}

output "nat_public_ips" {
  description = <<-EOT
    List of public Elastic IPs created for AWS NAT Gateway
  EOT
  value       = aws_eip.nat.*.public_ip
}

output "natgw_ids" {
  description = <<-EOT
    List of NAT Gateway IDs
  EOT
  value       = aws_nat_gateway.this.*.id
}

output "igw_id" {
  description = <<-EOT
    The ID of the Internet Gateway
  EOT
  value       = concat(aws_internet_gateway.this.*.id, [""])[0]
}

output "egress_only_internet_gateway_id" {
  description = <<-EOT
    The ID of the egress only Internet Gateway
  EOT
  value       = concat(aws_egress_only_internet_gateway.this.*.id, [""])[0]
}

output "cgw_ids" {
  description = <<-EOT
    List of IDs of Customer Gateway
  EOT
  value       = [for k, v in aws_customer_gateway.this : v.id]
}

output "this_customer_gateway" {
  description = <<-EOT
    Map of Customer Gateway attributes
  EOT
  value       = aws_customer_gateway.this
}

output "vgw_id" {
  description = <<-EOT
    The ID of the VPN Gateway
  EOT
  value = concat(
    aws_vpn_gateway.this.*.id,
    aws_vpn_gateway_attachment.this.*.vpn_gateway_id,
    [""],
  )[0]
}

output "public_network_acl_id" {
  description = <<-EOT
    ID of the public network ACL
  EOT
  value       = concat(aws_network_acl.public.*.id, [""])[0]
}

output "private_network_acl_id" {
  description = <<-EOT
    ID of the private network ACL
  EOT
  value       = concat(aws_network_acl.private.*.id, [""])[0]
}

# VPC Endpoints
output "vpc_endpoint_s3_id" {
  description = <<-EOT
    The ID of VPC endpoint for S3
  EOT
  value       = concat(aws_vpc_endpoint.s3.*.id, [""])[0]
}

output "vpc_endpoint_s3_pl_id" {
  description = <<-EOT
    The prefix list for the S3 VPC endpoint.
  EOT
  value       = concat(aws_vpc_endpoint.s3.*.prefix_list_id, [""])[0]
}

output "vpc_endpoint_dynamodb_id" {
  description = <<-EOT
    The ID of VPC endpoint for DynamoDB
  EOT
  value       = concat(aws_vpc_endpoint.dynamodb.*.id, [""])[0]
}

output "vpc_endpoint_dynamodb_pl_id" {
  description = <<-EOT
    The prefix list for the DynamoDB VPC endpoint.
  EOT
  value       = concat(aws_vpc_endpoint.dynamodb.*.prefix_list_id, [""])[0]
}

output "vpc_endpoint_sqs_id" {
  description = <<-EOT
    The ID of VPC endpoint for SQS
  EOT
  value       = concat(aws_vpc_endpoint.sqs.*.id, [""])[0]
}

output "vpc_endpoint_sqs_network_interface_ids" {
  description = <<-EOT
    One or more network interfaces for the VPC Endpoint for SQS.
  EOT
  value       = flatten(aws_vpc_endpoint.sqs.*.network_interface_ids)
}

output "vpc_endpoint_sqs_dns_entry" {
  description = <<-EOT
    The DNS entries for the VPC Endpoint for SQS.
  EOT
  value       = flatten(aws_vpc_endpoint.sqs.*.dns_entry)
}

output "vpc_endpoint_sns_id" {
  description = <<-EOT
    The ID of VPC endpoint for SNS
  EOT
  value       = concat(aws_vpc_endpoint.sns.*.id, [""])[0]
}

output "vpc_endpoint_sns_network_interface_ids" {
  description = <<-EOT
    One or more network interfaces for the VPC Endpoint for SNS.
  EOT
  value       = flatten(aws_vpc_endpoint.sns.*.network_interface_ids)
}

output "vpc_endpoint_sns_dns_entry" {
  description = <<-EOT
    The DNS entries for the VPC Endpoint for SNS.
  EOT
  value       = flatten(aws_vpc_endpoint.sns.*.dns_entry)
}

output "vpc_endpoint_monitoring_id" {
  description = <<-EOT
    The ID of VPC endpoint for CloudWatch Monitoring
  EOT
  value       = concat(aws_vpc_endpoint.monitoring.*.id, [""])[0]
}

output "vpc_endpoint_monitoring_network_interface_ids" {
  description = <<-EOT
    One or more network interfaces for the VPC Endpoint for CloudWatch Monitoring.
  EOT
  value       = flatten(aws_vpc_endpoint.monitoring.*.network_interface_ids)
}

output "vpc_endpoint_monitoring_dns_entry" {
  description = <<-EOT
    The DNS entries for the VPC Endpoint for CloudWatch Monitoring.
  EOT
  value       = flatten(aws_vpc_endpoint.monitoring.*.dns_entry)
}

output "vpc_endpoint_logs_id" {
  description = <<-EOT
    The ID of VPC endpoint for CloudWatch Logs
  EOT
  value       = concat(aws_vpc_endpoint.logs.*.id, [""])[0]
}

output "vpc_endpoint_logs_network_interface_ids" {
  description = <<-EOT
    One or more network interfaces for the VPC Endpoint for CloudWatch Logs.
  EOT
  value       = flatten(aws_vpc_endpoint.logs.*.network_interface_ids)
}

output "vpc_endpoint_logs_dns_entry" {
  description = <<-EOT
    The DNS entries for the VPC Endpoint for CloudWatch Logs.
  EOT
  value       = flatten(aws_vpc_endpoint.logs.*.dns_entry)
}

output "vpc_endpoint_events_id" {
  description = <<-EOT
    The ID of VPC endpoint for CloudWatch Events
  EOT
  value       = concat(aws_vpc_endpoint.events.*.id, [""])[0]
}

output "vpc_endpoint_events_network_interface_ids" {
  description = <<-EOT
    One or more network interfaces for the VPC Endpoint for CloudWatch Events.
  EOT
  value       = flatten(aws_vpc_endpoint.events.*.network_interface_ids)
}

output "vpc_endpoint_events_dns_entry" {
  description = <<-EOT
    The DNS entries for the VPC Endpoint for CloudWatch Events.
  EOT
  value       = flatten(aws_vpc_endpoint.events.*.dns_entry)
}

output "vpc_endpoint_cloudtrail_id" {
  description = <<-EOT
    The ID of VPC endpoint for CloudTrail
  EOT
  value       = concat(aws_vpc_endpoint.cloudtrail.*.id, [""])[0]
}

output "vpc_endpoint_cloudtrail_network_interface_ids" {
  description = <<-EOT
    One or more network interfaces for the VPC Endpoint for CloudTrail.
  EOT
  value       = flatten(aws_vpc_endpoint.cloudtrail.*.network_interface_ids)
}

output "vpc_endpoint_cloudtrail_dns_entry" {
  description = <<-EOT
    The DNS entries for the VPC Endpoint for CloudTrail.
  EOT
  value       = flatten(aws_vpc_endpoint.cloudtrail.*.dns_entry)
}

output "vpc_endpoint_sts_id" {
  description = <<-EOT
    The ID of VPC endpoint for STS
  EOT
  value       = concat(aws_vpc_endpoint.sts.*.id, [""])[0]
}

output "vpc_endpoint_sts_network_interface_ids" {
  description = <<-EOT
    One or more network interfaces for the VPC Endpoint for STS.
  EOT
  value       = flatten(aws_vpc_endpoint.sts.*.network_interface_ids)
}

output "vpc_endpoint_sts_dns_entry" {
  description = <<-EOT
    The DNS entries for the VPC Endpoint for STS.
  EOT
  value       = flatten(aws_vpc_endpoint.sts.*.dns_entry)
}

output "vpc_endpoint_efs_id" {
  description = <<-EOT
    The ID of VPC endpoint for EFS
  EOT
  value       = concat(aws_vpc_endpoint.efs.*.id, [""])[0]
}

output "vpc_endpoint_efs_network_interface_ids" {
  description = <<-EOT
    One or more network interfaces for the VPC Endpoint for EFS.
  EOT
  value       = flatten(aws_vpc_endpoint.efs.*.network_interface_ids)
}

output "vpc_endpoint_efs_dns_entry" {
  description = <<-EOT
    The DNS entries for the VPC Endpoint for EFS.
  EOT
  value       = flatten(aws_vpc_endpoint.efs.*.dns_entry)
}

# VPC flow log
output "vpc_flow_log_id" {
  description = <<-EOT
    The ID of the Flow Log resource
  EOT
  value       = concat(aws_flow_log.this.*.id, [""])[0]
}

output "vpc_flow_log_destination_arn" {
  description = <<-EOT
    The ARN of the destination for VPC Flow Logs
  EOT
  value       = local.flow_log_destination_arn
}

output "vpc_flow_log_destination_type" {
  description = <<-EOT
    The type of the destination for VPC Flow Logs
  EOT
  value       = var.flow_log_destination_type
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  description = <<-EOT
    The ARN of the IAM role used when pushing logs to Cloudwatch log group
  EOT
  value       = local.flow_log_iam_role_arn
}

# Static values (arguments)
output "azs" {
  description = <<-EOT
    A list of availability zones specified as argument to this module
  EOT
  value       = var.azs
}

output "name" {
  description = <<-EOT
    The name of the VPC specified as argument to this module
  EOT
  value       = var.name
}

