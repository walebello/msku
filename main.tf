locals {
  required_tags = {
    Owner       = var.owner,
    Environment = var.environment,
    Costcenter  = var.costcenter,
    Terraform   = "True"
  }
  region_map = {
    "us-east-1" = "ue1",
    "us-east-2" = "ue2",
    "us-west-1" = "uw1",
    "us-west-2" = "uw2"
  }
  region           = local.region_map[var.region]
  project_name     = "aws${var.environment}${var.app_name}-${local.region}"
  msk_cluster_name = upper("${local.project_name}-msk")
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.environment}-architecture-logs"
  acl    = var.s3_bucket_acl
}

resource "aws_cloudwatch_log_group" "cwlg" {
  name = var.cloudwatch_log_group_name
}

resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = upper("${local.project_name}-msk")
  tags                   = merge({ Name = "${local.project_name}-msk" }, local.required_tags, var.additional_tags)
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring

  encryption_info {
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn
    encryption_in_transit {
      client_broker = var.encryption_in_transit_client_broker
      in_cluster    = var.encryption_in_transit_in_cluster
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.SGDEFAULTMSK.arn
    revision = aws_msk_configuration.SGDEFAULTMSK.latest_revision
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloudwatch_logs_enable
        log_group = aws_cloudwatch_log_group.cwlg.name
      }
      s3 {
        enabled = var.s3_logs_enable
        bucket  = aws_s3_bucket.bucket.id
        prefix  = var.s3_logs_prefix
      }
    }
  }

  broker_node_group_info {
    instance_type   = var.msk_instance_type
    ebs_volume_size = var.msk_ebs_volume_size
    client_subnets  = var.msk_subnet_ids
    security_groups = var.msk_security_group_ids
  }

}

resource "aws_msk_configuration" "SGDEFAULTMSK" {
  kafka_versions = var.msk_config_kafka_versions
  name           = var.msk_config_name

  server_properties = var.server_properties

}
