# AWS VPC Terraform module

Terraform module which creates VPC resources on AWS.

Note: This module is based on a community [VPC module](https://github.com/terraform-aws-modules/terraform-aws-vpc) maintained by Anton Babenko. It should not be distributed without attribution and license.

These types of resources are supported:

* [VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)
* [Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
* [Route](https://www.terraform.io/docs/providers/aws/r/route.html)
* [Route table](https://www.terraform.io/docs/providers/aws/r/route_table.html)
* [Internet Gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)
* [Transit Gateway](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway.html)
* [Network ACL](https://www.terraform.io/docs/providers/aws/r/network_acl.html)
* [NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html)
* [VPN Gateway](https://www.terraform.io/docs/providers/aws/r/vpn_gateway.html)
* [VPC Flow Log](https://www.terraform.io/docs/providers/aws/r/flow_log.html)
* [VPC Endpoint](https://www.terraform.io/docs/providers/aws/r/vpc_endpoint.html):
  * Gateway: S3, DynamoDB
  * Interface: SQS, SNS, STS, CloudWatch(Monitoring, Logs, Events), CloudTrail, Elastic File System (EFS)

* [Default Network ACL](https://www.terraform.io/docs/providers/aws/r/default_network_acl.html)

## Usage

```hcl
module "vpc" {
  source = "../"

  name = "example"

  cidr = "10.50.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]
  public_subnets  = ["10.50.11.0/24", "10.50.12.0/24", "10.50.13.0/24"]

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
}
```

## External NAT Gateway IPs

By default this module will provision new Elastic IPs for the VPC's NAT Gateways.
This means that when creating a new VPC, new IPs are allocated, and when that VPC is destroyed those IPs are released.
Sometimes it is handy to keep the same IPs even after the VPC is destroyed and re-created.
To that end, it is possible to assign existing IPs to the NAT Gateways.
This prevents the destruction of the VPC from releasing those IPs, while making it possible that a re-created VPC uses the same IPs.

To achieve this, allocate the IPs outside the VPC module declaration.
```hcl
resource "aws_eip" "nat" {
  count = 3

  vpc = true
}
```

Then, pass the allocated IPs as a parameter to this module.
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  # The rest of arguments are omitted for brevity

  enable_nat_gateway  = true
  single_nat_gateway  = false
  reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = "${aws_eip.nat.*.id}"   # <= IPs specified here as input to the module
}
```

Note that in the example we allocate 3 IPs because we will be provisioning 3 NAT Gateways (due to `single_nat_gateway = false` and having 3 subnets).
If, on the other hand, `single_nat_gateway = true`, then `aws_eip.nat` would only need to allocate 1 IP.
Passing the IPs into the module is done by setting two variables `reuse_nat_ips = true` and `external_nat_ip_ids = "${aws_eip.nat.*.id}"`.

## NAT Gateway Scenarios

This module supports three scenarios for creating NAT gateways. Each will be explained in further detail in the corresponding sections.

* One NAT Gateway per subnet (default behavior)
    * `enable_nat_gateway = true`
    * `single_nat_gateway = false`
    * `one_nat_gateway_per_az = false`
* Single NAT Gateway
    * `enable_nat_gateway = true`
    * `single_nat_gateway = true`
    * `one_nat_gateway_per_az = false`
* One NAT Gateway per availability zone
    * `enable_nat_gateway = true`
    * `single_nat_gateway = false`
    * `one_nat_gateway_per_az = true`

If both `single_nat_gateway` and `one_nat_gateway_per_az` are set to `true`, then `single_nat_gateway` takes precedence.

### One NAT Gateway per subnet (default)

By default, the module will determine the number of NAT Gateways to create based on the the length of the private subnet lists.

### Single NAT Gateway

If `single_nat_gateway = true`, then all private subnets will route their Internet traffic through this single NAT gateway. The NAT gateway will be placed in the first public subnet in your `public_subnets` block.

### One NAT Gateway per availability zone

If `one_nat_gateway_per_az = true` and `single_nat_gateway = false`, then the module will place one NAT gateway in each availability zone you specify in `var.azs`. There are some requirements around using this feature flag:

* The variable `var.azs` **must** be specified.
* The number of public subnet CIDR blocks specified in `public_subnets` **must** be greater than or equal to the number of availability zones specified in `var.azs`. This is to ensure that each NAT Gateway has a dedicated public subnet to deploy to.

### Transit Gateway (TGW) integration

When the variable `tgw_id` is specified, settings for NAT gateway creation and routing are overridden. Routes to the TGW are created for private subnets instead of to a NAT gateway. Routes to RFC1918 subnets are also created for all public subnets.

To force NAT gateway routing for private subnets even when the VPC is attached to a transit gateway, set `use_tgw_for_egress = false`.

## VPC Flow Log

VPC Flow Log allows to capture IP traffic for a specific network interface (ENI), subnet, or entire VPC. This module supports enabling or disabling VPC Flow Logs for entire VPC. If you need to have VPC Flow Logs for subnet or ENI, you have to manage it outside of this module with [aws_flow_log resource](https://www.terraform.io/docs/providers/aws/r/flow_log.html).

## Network Access Control Lists (ACL or NACL)

This module can manage network ACL and rules. Once VPC is created, AWS creates the default network ACL, which can be controlled using this module (`manage_default_network_acl = true`).

Also, each type of subnet may have its own network ACL with custom rules per subnet. Eg, set `public_dedicated_network_acl = true` to use dedicated network ACL for the public subnets; set values of `public_inbound_acl_rules` and `public_outbound_acl_rules` to specify all the NACL rules you need to have on public subnets (see `variables.tf` for default values and structures).

By default, all subnets are associated with the default network ACL.

## Examples

* [Simple VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/simple-vpc)
* [Simple VPC with secondary CIDR blocks](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/secondary-cidr-blocks)
* [Complete VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/complete-vpc)
* [VPC with IPv6 enabled](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/ipv6)
* [Network ACL](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/network-acls)
* [VPC Flow Logs](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/vpc-flow-logs)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| amazon\_side\_asn | The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the virtual private gateway is created with the current default Amazon ASN. | `string` | `"64512"` | no |
| assign\_ipv6\_address\_on\_creation | Assign IPv6 address on subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map\_public\_ip\_on\_launch | `bool` | `false` | no |
| azs | A list of availability zones names or ids in the region | `list(string)` | `[]` | no |
| cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `"0.0.0.0/0"` | no |
| cloudtrail\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for CloudTrail endpoint | `bool` | `false` | no |
| cloudtrail\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for CloudTrail endpoint | `list(string)` | `[]` | no |
| cloudtrail\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for CloudTrail endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| create\_flow\_log\_cloudwatch\_iam\_role | Whether to create IAM role for VPC Flow Logs | `bool` | `false` | no |
| create\_flow\_log\_cloudwatch\_log\_group | Whether to create CloudWatch log group for VPC Flow Logs | `bool` | `false` | no |
| customer\_gateway\_tags | Additional tags for the Customer Gateway | `map(string)` | `{}` | no |
| customer\_gateways | Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address) | `map(map(any))` | `{}` | no |
| default\_network\_acl\_egress | List of maps of egress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| default\_network\_acl\_ingress | List of maps of ingress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| default\_network\_acl\_name | Name to be used on the Default Network ACL | `string` | `""` | no |
| default\_network\_acl\_tags | Additional tags for the Default Network ACL | `map(string)` | `{}` | no |
| efs\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for EFS endpoint | `bool` | `false` | no |
| efs\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for EFS endpoint | `list(string)` | `[]` | no |
| efs\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for EFS endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used. | `list(string)` | `[]` | no |
| enable\_cloudtrail\_endpoint | Should be true if you want to provision a CloudTrail endpoint to the VPC | `bool` | `false` | no |
| enable\_dns\_hostnames | Should be true to enable DNS hostnames in the VPC | `bool` | `false` | no |
| enable\_dns\_support | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| enable\_dynamodb\_endpoint | Should be true if you want to provision a DynamoDB endpoint to the VPC | `bool` | `false` | no |
| enable\_efs\_endpoint | Should be true if you want to provision an EFS endpoint to the VPC | `bool` | `false` | no |
| enable\_events\_endpoint | Should be true if you want to provision a CloudWatch Events endpoint to the VPC | `bool` | `false` | no |
| enable\_flow\_log | Whether or not to enable VPC Flow Logs | `bool` | `false` | no |
| enable\_ipv6 | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. | `bool` | `false` | no |
| enable\_logs\_endpoint | Should be true if you want to provision a CloudWatch Logs endpoint to the VPC | `bool` | `false` | no |
| enable\_monitoring\_endpoint | Should be true if you want to provision a CloudWatch Monitoring endpoint to the VPC | `bool` | `false` | no |
| enable\_nat\_gateway | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `false` | no |
| enable\_s3\_endpoint | Should be true if you want to provision an S3 endpoint to the VPC | `bool` | `false` | no |
| enable\_sns\_endpoint | Should be true if you want to provision a SNS endpoint to the VPC | `bool` | `false` | no |
| enable\_sqs\_endpoint | Should be true if you want to provision an SQS endpoint to the VPC | `bool` | `false` | no |
| enable\_storagegateway\_endpoint | Should be true if you want to provision a Storage Gateway endpoint to the VPC | `bool` | `false` | no |
| enable\_sts\_endpoint | Should be true if you want to provision a STS endpoint to the VPC | `bool` | `false` | no |
| enable\_vpn\_gateway | Should be true if you want to create a new VPN Gateway resource and attach it to the VPC | `bool` | `false` | no |
| events\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for CloudWatch Events endpoint | `bool` | `false` | no |
| events\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for CloudWatch Events endpoint | `list(string)` | `[]` | no |
| events\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for CloudWatch Events endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| external\_nat\_ip\_ids | List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse\_nat\_ips) | `list(string)` | `[]` | no |
| flow\_log\_cloudwatch\_iam\_role\_arn | The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow\_log\_destination\_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided. | `string` | `""` | no |
| flow\_log\_cloudwatch\_log\_group\_kms\_key\_id | The ARN of the KMS Key to use when encrypting log data for VPC flow logs. | `string` | `null` | no |
| flow\_log\_cloudwatch\_log\_group\_name\_prefix | Specifies the name prefix of CloudWatch Log Group for VPC flow logs. | `string` | `"/aws/vpc-flow-log/"` | no |
| flow\_log\_cloudwatch\_log\_group\_retention\_in\_days | Specifies the number of days you want to retain log events in the specified log group for VPC flow logs. | `number` | `null` | no |
| flow\_log\_destination\_arn | The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create\_flow\_log\_cloudwatch\_log\_group is set to false this argument must be provided. | `string` | `""` | no |
| flow\_log\_destination\_type | Type of flow log destination. Can be s3 or cloud-watch-logs. | `string` | `"cloud-watch-logs"` | no |
| flow\_log\_log\_format | The fields to include in the flow log record, in the order in which they should appear. | `string` | `null` | no |
| flow\_log\_traffic\_type | The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL. | `string` | `"ALL"` | no |
| igw\_tags | Additional tags for the internet gateway | `map(string)` | `{}` | no |
| instance\_tenancy | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| logs\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for CloudWatch Logs endpoint | `bool` | `false` | no |
| logs\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for CloudWatch Logs endpoint | `list(string)` | `[]` | no |
| logs\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for CloudWatch Logs endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| manage\_default\_network\_acl | Should be true to adopt and manage Default Network ACL | `bool` | `false` | no |
| map\_public\_ip\_on\_launch | Should be false if you do not want to auto-assign public IP on launch | `bool` | `true` | no |
| monitoring\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for CloudWatch Monitoring endpoint | `bool` | `false` | no |
| monitoring\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for CloudWatch Monitoring endpoint | `list(string)` | `[]` | no |
| monitoring\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for CloudWatch Monitoring endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| name | Name to be used on all the resources as identifier | `string` | `""` | no |
| nat\_eip\_tags | Additional tags for the NAT EIP | `map(string)` | `{}` | no |
| nat\_gateway\_tags | Additional tags for the NAT gateways | `map(string)` | `{}` | no |
| one\_nat\_gateway\_per\_az | Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`. | `bool` | `false` | no |
| private\_acl\_tags | Additional tags for the private subnets network ACL | `map(string)` | `{}` | no |
| private\_dedicated\_network\_acl | Whether to use dedicated network ACL (not default) and custom rules for private subnets | `bool` | `false` | no |
| private\_inbound\_acl\_rules | Private subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| private\_outbound\_acl\_rules | Private subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| private\_route\_table\_tags | Additional tags for the private route tables | `map(string)` | `{}` | no |
| private\_subnet\_assign\_ipv6\_address\_on\_creation | Assign IPv6 address on private subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map\_public\_ip\_on\_launch | `bool` | `null` | no |
| private\_subnet\_ipv6\_prefixes | Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list. | `list` | `[]` | no |
| private\_subnet\_suffix | Suffix to append to private subnets name | `string` | `"private"` | no |
| private\_subnet\_tags | Additional tags for the private subnets | `map(string)` | `{}` | no |
| private\_subnets | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| propagate\_private\_route\_tables\_vgw | Should be true if you want route table propagation | `bool` | `false` | no |
| propagate\_public\_route\_tables\_vgw | Should be true if you want route table propagation | `bool` | `false` | no |
| public\_acl\_tags | Additional tags for the public subnets network ACL | `map(string)` | `{}` | no |
| public\_dedicated\_network\_acl | Whether to use dedicated network ACL (not default) and custom rules for public subnets | `bool` | `false` | no |
| public\_inbound\_acl\_rules | Public subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_outbound\_acl\_rules | Public subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_route\_table\_tags | Additional tags for the public route tables | `map(string)` | `{}` | no |
| public\_subnet\_assign\_ipv6\_address\_on\_creation | Assign IPv6 address on public subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map\_public\_ip\_on\_launch | `bool` | `null` | no |
| public\_subnet\_ipv6\_prefixes | Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list | `list` | `[]` | no |
| public\_subnet\_suffix | Suffix to append to public subnets name | `string` | `"public"` | no |
| public\_subnet\_tags | Additional tags for the public subnets | `map(string)` | `{}` | no |
| public\_subnets | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| reuse\_nat\_ips | Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external\_nat\_ip\_ids' variable | `bool` | `false` | no |
| secondary\_cidr\_blocks | List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool | `list(string)` | `[]` | no |
| single\_nat\_gateway | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `false` | no |
| sns\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for SNS endpoint | `bool` | `false` | no |
| sns\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for SNS endpoint | `list(string)` | `[]` | no |
| sns\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for SNS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| sqs\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for SQS endpoint | `bool` | `false` | no |
| sqs\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for SQS endpoint | `list` | `[]` | no |
| sqs\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list` | `[]` | no |
| storagegateway\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for Storage Gateway endpoint | `bool` | `false` | no |
| storagegateway\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for Storage Gateway endpoint | `list(string)` | `[]` | no |
| storagegateway\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for Storage Gateway endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| sts\_endpoint\_private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC for STS endpoint | `bool` | `false` | no |
| sts\_endpoint\_security\_group\_ids | The ID of one or more security groups to associate with the network interface for STS endpoint | `list(string)` | `[]` | no |
| sts\_endpoint\_subnet\_ids | The ID of one or more subnets in which to create a network interface for STS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| tgw\_attach\_default\_route\_table\_association | Whether the VPC Attachment should be associated with the EC2 Transit gateway default route table. | `bool` | `true` | no |
| tgw\_attach\_default\_route\_table\_propagation | Whether the VPC Attachment should propagate routes to the EC2 transit Gateway default route table. | `bool` | `true` | no |
| tgw\_id | TGW ID to attach to the VPC. | `any` | `null` | no |
| use\_tgw\_for\_egress | Set to true only when the transit gateway routing table contains a deafult route to an egress VPC. Set to false when the VPC is being used as an egress point for other VPCs attached to the same transit gateway. | `bool` | `true` | no |
| vpc\_endpoint\_tags | Additional tags for the VPC Endpoints | `map(string)` | `{}` | no |
| vpc\_flow\_log\_tags | Additional tags for the VPC Flow Logs | `map(string)` | `{}` | no |
| vpc\_tags | Additional tags for the VPC | `map(string)` | `{}` | no |
| vpn\_gateway\_az | The Availability Zone for the VPN Gateway | `string` | `null` | no |
| vpn\_gateway\_id | ID of VPN Gateway to attach to the VPC | `string` | `""` | no |
| vpn\_gateway\_tags | Additional tags for the VPN gateway | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| azs | A list of availability zones specified as argument to this module |
| cgw\_ids | List of IDs of Customer Gateway |
| default\_network\_acl\_id | The ID of the default network ACL |
| default\_route\_table\_id | The ID of the default route table |
| default\_security\_group\_id | The ID of the security group created by default on VPC creation |
| egress\_only\_internet\_gateway\_id | The ID of the egress only Internet Gateway |
| igw\_id | The ID of the Internet Gateway |
| name | The name of the VPC specified as argument to this module |
| nat\_ids | List of allocation ID of Elastic IPs created for AWS NAT Gateway |
| nat\_public\_ips | List of public Elastic IPs created for AWS NAT Gateway |
| natgw\_ids | List of NAT Gateway IDs |
| private\_network\_acl\_id | ID of the private network ACL |
| private\_route\_table\_ids | List of IDs of private route tables |
| private\_subnet\_arns | List of ARNs of private subnets |
| private\_subnets | List of IDs of private subnets |
| private\_subnets\_cidr\_blocks | List of cidr\_blocks of private subnets |
| private\_subnets\_ipv6\_cidr\_blocks | List of IPv6 cidr\_blocks of private subnets in an IPv6 enabled VPC |
| public\_network\_acl\_id | ID of the public network ACL |
| public\_route\_table\_ids | List of IDs of public route tables |
| public\_subnet\_arns | List of ARNs of public subnets |
| public\_subnets | List of IDs of public subnets |
| public\_subnets\_cidr\_blocks | List of cidr\_blocks of public subnets |
| public\_subnets\_ipv6\_cidr\_blocks | List of IPv6 cidr\_blocks of public subnets in an IPv6 enabled VPC |
| this\_customer\_gateway | Map of Customer Gateway attributes |
| vgw\_id | The ID of the VPN Gateway |
| vpc\_arn | The ARN of the VPC |
| vpc\_cidr\_block | The CIDR block of the VPC |
| vpc\_enable\_dns\_hostnames | Whether or not the VPC has DNS hostname support |
| vpc\_enable\_dns\_support | Whether or not the VPC has DNS support |
| vpc\_endpoint\_cloudtrail\_dns\_entry | The DNS entries for the VPC Endpoint for CloudTrail. |
| vpc\_endpoint\_cloudtrail\_id | The ID of VPC endpoint for CloudTrail |
| vpc\_endpoint\_cloudtrail\_network\_interface\_ids | One or more network interfaces for the VPC Endpoint for CloudTrail. |
| vpc\_endpoint\_dynamodb\_id | The ID of VPC endpoint for DynamoDB |
| vpc\_endpoint\_dynamodb\_pl\_id | The prefix list for the DynamoDB VPC endpoint. |
| vpc\_endpoint\_efs\_dns\_entry | The DNS entries for the VPC Endpoint for EFS. |
| vpc\_endpoint\_efs\_id | The ID of VPC endpoint for EFS |
| vpc\_endpoint\_efs\_network\_interface\_ids | One or more network interfaces for the VPC Endpoint for EFS. |
| vpc\_endpoint\_events\_dns\_entry | The DNS entries for the VPC Endpoint for CloudWatch Events. |
| vpc\_endpoint\_events\_id | The ID of VPC endpoint for CloudWatch Events |
| vpc\_endpoint\_events\_network\_interface\_ids | One or more network interfaces for the VPC Endpoint for CloudWatch Events. |
| vpc\_endpoint\_logs\_dns\_entry | The DNS entries for the VPC Endpoint for CloudWatch Logs. |
| vpc\_endpoint\_logs\_id | The ID of VPC endpoint for CloudWatch Logs |
| vpc\_endpoint\_logs\_network\_interface\_ids | One or more network interfaces for the VPC Endpoint for CloudWatch Logs. |
| vpc\_endpoint\_monitoring\_dns\_entry | The DNS entries for the VPC Endpoint for CloudWatch Monitoring. |
| vpc\_endpoint\_monitoring\_id | The ID of VPC endpoint for CloudWatch Monitoring |
| vpc\_endpoint\_monitoring\_network\_interface\_ids | One or more network interfaces for the VPC Endpoint for CloudWatch Monitoring. |
| vpc\_endpoint\_s3\_id | The ID of VPC endpoint for S3 |
| vpc\_endpoint\_s3\_pl\_id | The prefix list for the S3 VPC endpoint. |
| vpc\_endpoint\_sns\_dns\_entry | The DNS entries for the VPC Endpoint for SNS. |
| vpc\_endpoint\_sns\_id | The ID of VPC endpoint for SNS |
| vpc\_endpoint\_sns\_network\_interface\_ids | One or more network interfaces for the VPC Endpoint for SNS. |
| vpc\_endpoint\_sqs\_dns\_entry | The DNS entries for the VPC Endpoint for SQS. |
| vpc\_endpoint\_sqs\_id | The ID of VPC endpoint for SQS |
| vpc\_endpoint\_sqs\_network\_interface\_ids | One or more network interfaces for the VPC Endpoint for SQS. |
| vpc\_endpoint\_sts\_dns\_entry | The DNS entries for the VPC Endpoint for STS. |
| vpc\_endpoint\_sts\_id | The ID of VPC endpoint for STS |
| vpc\_endpoint\_sts\_network\_interface\_ids | One or more network interfaces for the VPC Endpoint for STS. |
| vpc\_flow\_log\_cloudwatch\_iam\_role\_arn | The ARN of the IAM role used when pushing logs to Cloudwatch log group |
| vpc\_flow\_log\_destination\_arn | The ARN of the destination for VPC Flow Logs |
| vpc\_flow\_log\_destination\_type | The type of the destination for VPC Flow Logs |
| vpc\_flow\_log\_id | The ID of the Flow Log resource |
| vpc\_id | The ID of the VPC |
| vpc\_instance\_tenancy | Tenancy of instances spin up within VPC |
| vpc\_ipv6\_association\_id | The association ID for the IPv6 CIDR block |
| vpc\_ipv6\_cidr\_block | The IPv6 CIDR block |
| vpc\_main\_route\_table\_id | The ID of the main route table associated with this VPC |
| vpc\_secondary\_cidr\_blocks | List of secondary CIDR blocks of the VPC |


## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-vpc/graphs/contributors).

## License

Apache 2 Licensed. See LICENSE for full details.
