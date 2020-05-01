######################
# VPC Endpoint for S3
######################
data "aws_vpc_endpoint_service" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id       = local.vpc_id
  service_name = data.aws_vpc_endpoint_service.s3[0].service_name
  tags         = local.vpce_tags
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = var.enable_s3_endpoint ? local.nat_gateway_count : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count = var.enable_s3_endpoint && length(var.public_subnets) > 0 ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.public[0].id
}

############################
# VPC Endpoint for DynamoDB
############################
data "aws_vpc_endpoint_service" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id       = local.vpc_id
  service_name = data.aws_vpc_endpoint_service.dynamodb[0].service_name
  tags         = local.vpce_tags
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
  count = var.enable_dynamodb_endpoint ? local.nat_gateway_count : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "public_dynamodb" {
  count = var.enable_dynamodb_endpoint && length(var.public_subnets) > 0 ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = aws_route_table.public[0].id
}

#######################
# VPC Endpoint for SQS
#######################
data "aws_vpc_endpoint_service" "sqs" {
  count = var.enable_sqs_endpoint ? 1 : 0

  service = "sqs"
}

resource "aws_vpc_endpoint" "sqs" {
  count = var.enable_sqs_endpoint ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = data.aws_vpc_endpoint_service.sqs[0].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.sqs_endpoint_security_group_ids
  subnet_ids          = coalescelist(var.sqs_endpoint_subnet_ids, aws_subnet.private.*.id)
  private_dns_enabled = var.sqs_endpoint_private_dns_enabled
  tags                = local.vpce_tags
}

#######################
# VPC Endpoint for SNS
#######################
data "aws_vpc_endpoint_service" "sns" {
  count = var.enable_sns_endpoint ? 1 : 0

  service = "sns"
}

resource "aws_vpc_endpoint" "sns" {
  count = var.enable_sns_endpoint ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = data.aws_vpc_endpoint_service.sns[0].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.sns_endpoint_security_group_ids
  subnet_ids          = coalescelist(var.sns_endpoint_subnet_ids, aws_subnet.private.*.id)
  private_dns_enabled = var.sns_endpoint_private_dns_enabled
  tags                = local.vpce_tags
}


#######################
# VPC Endpoint for CloudWatch Monitoring
#######################
data "aws_vpc_endpoint_service" "monitoring" {
  count = var.enable_monitoring_endpoint ? 1 : 0

  service = "monitoring"
}

resource "aws_vpc_endpoint" "monitoring" {
  count = var.enable_monitoring_endpoint ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = data.aws_vpc_endpoint_service.monitoring[0].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.monitoring_endpoint_security_group_ids
  subnet_ids          = coalescelist(var.monitoring_endpoint_subnet_ids, aws_subnet.private.*.id)
  private_dns_enabled = var.monitoring_endpoint_private_dns_enabled
  tags                = local.vpce_tags
}

#######################
# VPC Endpoint for CloudWatch Logs
#######################
data "aws_vpc_endpoint_service" "logs" {
  count = var.enable_logs_endpoint ? 1 : 0

  service = "logs"
}

resource "aws_vpc_endpoint" "logs" {
  count = var.enable_logs_endpoint ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = data.aws_vpc_endpoint_service.logs[0].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.logs_endpoint_security_group_ids
  subnet_ids          = coalescelist(var.logs_endpoint_subnet_ids, aws_subnet.private.*.id)
  private_dns_enabled = var.logs_endpoint_private_dns_enabled
  tags                = local.vpce_tags
}


#######################
# VPC Endpoint for CloudWatch Events
#######################
data "aws_vpc_endpoint_service" "events" {
  count = var.enable_events_endpoint ? 1 : 0

  service = "events"
}

resource "aws_vpc_endpoint" "events" {
  count = var.enable_events_endpoint ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = data.aws_vpc_endpoint_service.events[0].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.events_endpoint_security_group_ids
  subnet_ids          = coalescelist(var.events_endpoint_subnet_ids, aws_subnet.private.*.id)
  private_dns_enabled = var.events_endpoint_private_dns_enabled
  tags                = local.vpce_tags
}

#######################
# VPC Endpoint for CloudTrail
#######################
data "aws_vpc_endpoint_service" "cloudtrail" {
  count = var.enable_cloudtrail_endpoint ? 1 : 0

  service = "cloudtrail"
}

resource "aws_vpc_endpoint" "cloudtrail" {
  count = var.enable_cloudtrail_endpoint ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = data.aws_vpc_endpoint_service.cloudtrail[0].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.cloudtrail_endpoint_security_group_ids
  subnet_ids          = coalescelist(var.cloudtrail_endpoint_subnet_ids, aws_subnet.private.*.id)
  private_dns_enabled = var.cloudtrail_endpoint_private_dns_enabled
  tags                = local.vpce_tags
}

#######################
# VPC Endpoint for STS
#######################
data "aws_vpc_endpoint_service" "sts" {
  count = var.enable_sts_endpoint ? 1 : 0

  service = "sts"
}

resource "aws_vpc_endpoint" "sts" {
  count = var.enable_sts_endpoint ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = data.aws_vpc_endpoint_service.sts[0].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.sts_endpoint_security_group_ids
  subnet_ids          = coalescelist(var.sts_endpoint_subnet_ids, aws_subnet.private.*.id)
  private_dns_enabled = var.sts_endpoint_private_dns_enabled
  tags                = local.vpce_tags
}

#######################
# VPC Endpoint for EFS
#######################
data "aws_vpc_endpoint_service" "efs" {
  count = var.enable_efs_endpoint ? 1 : 0

  service = "elasticfilesystem"
}

resource "aws_vpc_endpoint" "efs" {
  count = var.enable_efs_endpoint ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = data.aws_vpc_endpoint_service.efs[0].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.efs_endpoint_security_group_ids
  subnet_ids          = coalescelist(var.efs_endpoint_subnet_ids, aws_subnet.private.*.id)
  private_dns_enabled = var.efs_endpoint_private_dns_enabled

  tags = local.vpce_tags
}

