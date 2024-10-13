##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "dns" {
  description = "DNS configuration for environment"
  type        = any
  default     = {}
}

variable "alarms" {
  description = "Alarms configuration for the environment"
  type        = any
  default     = {}
}

variable "api_gateway" {
  description = "API Gateway configuration for the environment"
  type        = any
  default     = {}
}

variable "namespace" {
  description = "Environment namespace"
  type        = string
}

variable "release" {
  description = "Release configuration"
  type        = any
}

variable "beanstalk" {
  description = "Beanstalk environment configuration"
  type        = any
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "sts_assume_role" {
  description = "STS Assume Role ARN"
  type        = string
  default     = null
}

variable "versions_bucket" {
  description = "S3 bucket for application versions"
  type        = string
}

variable "logs_bucket" {
  description = "S3 bucket for application logs"
  type        = string
}

variable "repository_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "absolute_path" {
  description = "Absolute path to the configuration files"
  type        = string
  default     = ""
}

variable "bucket_path" {
  description = "Path to the S3 bucket"
  type        = string
}