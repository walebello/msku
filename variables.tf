variable "additional_tags" {
  description = "A mapping of additional tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "Application name abbreviation. Cannot be more than 5 characters long and no less than 2 and must also be lower case."
  type        = string
  default     = "app"

  validation {
    condition     = length(var.app_name) >= 2 && length(var.app_name) <= 5 && var.app_name == lower(var.app_name)
    error_message = "Valid name must be at least 2 characters and no more than 5. Name must be lower case."
  }
}

variable "cloudwatch_log_group_name" {
  description = "Name of the Cloudwatch Log Group to deliver logs to."
  type        = string
  default     = "msk_broker_logs"
}

variable "cloudwatch_logs_enable" {
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs."
  type        = bool
  default     = true
}

variable "costcenter" {
  description = "Costcenter associated with these resoures."
  type        = string
  default     = "cc"
}

variable "encryption_at_rest_kms_key_arn" {
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest."
  type        = string
  default     = ""
}

variable "encryption_in_transit_client_broker" {
  description = "Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT. Default value is TLS_PLAINTEXT."
  type        = string
  default     = "TLS"
}

variable "encryption_in_transit_in_cluster" {
  description = "Whether data communication among broker nodes is encrypted. Default value: true."
  type        = bool
  default     = true
}

variable "enhanced_monitoring" {
  description = "Specify the desired enhanced MSK CloudWatch monitoring level to one of three monitoring levels: DEFAULT, PER_BROKER, PER_TOPIC_PER_BROKER or PER_TOPIC_PER_PARTITION. See [Monitoring Amazon MSK with Amazon CloudWatch](https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html)."
  type        = string
  default     = "PER_BROKER"
}

variable "environment" {
  description = "Environment the resources are being provisioned for. Valid options are 'prod', 'uat', 'dev', 'qa' 'sandbox'."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["prod", "uat", "qa", "dev", "sandbox"], var.environment)
    error_message = "Must be a valid and environment. Acceptable types are prod, uat, qa, dev and sandbox."
  }
}

variable "kafka_version" {
  description = "Specify the desired Kafka software version."
  type        = string
  default     = "2.6.1"
}

variable "msk_config_kafka_versions" {
  description = "List of Apache Kafka versions which can use this configuration."
  type        = list(string)
  default     = ["2.6.1"]
}

variable "msk_config_name" {
  description = "Name of the configuration."
  type        = string
  default     = "SG"
}

variable "msk_ebs_volume_size" {
  description = "The size in GiB of the EBS volume for the data drive on each broker node."
  type        = number
  default     = 100
}

variable "msk_instance_type" {
  description = "Specify the instance type to use for the kafka brokers."
  type        = string
  default     = "kafka.m5.large"
}

variable "msk_security_group_ids" {
  description = "A list of security group IDs to assign to the MSK cluster."
  type        = list(string)
}

variable "msk_subnet_ids" {
  description = "List of subnet IDs to use for MSK private subnets."
  type        = list(string)
}

variable "number_of_broker_nodes" {
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets."
  type        = number
  default     = 2
}

variable "owner" {
  description = "Resource owners Active Directory user id."
  type        = string
  default     = "owner"
}

variable "region" {
  description = "Region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "server_properties" {
  description = " Contents of the server.properties file."
  type        = string
  default     = <<PROPERTIES
     auto.create.topics.enable=true
     default.replication.factor=2
     min.insync.replicas=2
     num.io.threads=8
     num.network.threads=5
     num.partitions=2
     num.replica.fetchers=2
     replica.lag.time.max.ms=30000
     socket.receive.buffer.bytes=102400
     socket.request.max.bytes=104857600
     socket.send.buffer.bytes=102400
     unclean.leader.election.enable=true
     zookeeper.session.timeout.ms=18000
   PROPERTIES
}

variable "s3_bucket_acl" {
  description = "The canned ACL to apply."
  type        = string
  default     = "private"
}

variable "s3_logs_enable" {
  description = "Indicates whether you want to enable or disable streaming broker logs to S3."
  type        = bool
  default     = true
}

variable "s3_logs_prefix" {
  description = "Prefix to append to the folder name."
  type        = string
  default     = "msk/2021"
}

variable "vpc_id" {
  description = "ID of the VPC in which MSK will be attached."
  type        = string
}
