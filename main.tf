##
# (c) 2021-2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  tags = merge(var.extra_tags, {
    Environment = format("%s-%s", var.release.name, var.namespace)
    Namespace   = var.namespace
    Release     = var.release.name
  })
  qualifier         = try(var.release.qualifier, "")
  shared_lb_weight  = try(var.beanstalk.load_balancer.shared.weight, 100)
  config_hash_file  = var.absolute_path == "" ? format("%s_%s", ".values_hash", var.release.name) : format("%s/%s_%s", var.absolute_path, ".values_hash", var.release.name)
  config_file_sha   = upper(substr(split(" ", file(local.config_hash_file))[0], 0, 10))
  version_label     = local.qualifier != "" ? format("%s-%s-%s-%s", var.release.name, var.release.source.version, local.config_file_sha, local.qualifier) : format("%s-%s-%s", var.release.name, var.release.source.version, local.config_file_sha)
  version_file_path = format("%s/%s/%s.zip", var.release.name, var.release.source.version, local.version_label)
}
##
# This module to manage DNS association.
#   - This can be commented out to disable DNS management (not recommended)
#
module "dns" {
  count                    = try(var.beanstalk.load_balancer.shared.enabled, false) == false && try(var.dns.enabled, false) ? 1 : 0
  source                   = "cloudopsworks/beanstalk-dns/aws"
  version                  = "1.0.5"
  region                   = var.region
  sts_assume_role          = var.sts_assume_role
  release_name             = var.release.name
  namespace                = local.qualifier != "" ? format("%s-%s", var.namespace, local.qualifier) : var.namespace
  private_domain           = try(var.dns.private_zone, false)
  domain_name              = var.dns.domain_name
  domain_name_alias_prefix = var.dns.alias_prefix
  domain_name_weight       = local.qualifier != "" ? (local.qualifier == "green" ? 100 : 1) : -1
  domain_alias             = true
  alias_cname              = module.app.environment_cname
  alias_zone_id            = module.app.environment_zone_id
}

module "version" {
  source  = "cloudopsworks/beanstalk-version/aws"
  version = "1.5.0"
  # source = "github.com/cloudopsworks/terraform-aws-beanstalk-version.git//?ref=release-v5"

  region          = var.region
  sts_assume_role = var.sts_assume_role

  release_name                = var.release.name
  source_name                 = var.release.source.name
  source_version              = var.release.source.version
  namespace                   = local.qualifier != "" ? format("%s-%s", var.namespace, local.qualifier) : var.namespace
  application_versions_bucket = var.versions_bucket
  bucket_path                 = var.bucket_path != "" ? var.bucket_path : local.version_file_path
  beanstalk_application       = var.beanstalk.application
  config_file_sha             = local.config_file_sha
  version_label               = local.version_label
}

module "app" {
  # source                         = "github.com/cloudopsworks/terraform-aws-beanstalk-deploy.git//?ref=develop"
  source                         = "cloudopsworks/beanstalk-deploy/aws"
  version                        = "1.1.1"
  region                         = var.region
  sts_assume_role                = var.sts_assume_role
  release_name                   = var.release.name
  namespace                      = local.qualifier != "" ? format("%s-%s", var.namespace, local.qualifier) : var.namespace
  solution_stack                 = var.beanstalk.solution_stack
  application_version_label      = module.version.application_version_label
  private_subnets                = var.beanstalk.networking.private_subnets
  public_subnets                 = var.beanstalk.networking.public_subnets
  vpc_id                         = var.beanstalk.networking.vpc_id
  server_types                   = var.beanstalk.instance.server_types
  beanstalk_application          = var.beanstalk.application
  beanstalk_ec2_key              = can(var.beanstalk.instance.ec2_key) ? var.beanstalk.instance.ec2_key : null
  beanstalk_ami_id               = can(var.beanstalk.instance.ami_id) ? var.beanstalk.instance.ami_id : null
  beanstalk_instance_port        = var.beanstalk.instance.instance_port
  beanstalk_enable_spot          = var.beanstalk.instance.enable_spot
  beanstalk_default_retention    = var.beanstalk.instance.default_retention
  beanstalk_instance_volume_size = var.beanstalk.instance.volume_size
  beanstalk_instance_volume_type = var.beanstalk.instance.volume_type
  beanstalk_instance_profile     = can(var.beanstalk.iam.instance_profile) ? var.beanstalk.iam.instance_profile : null
  beanstalk_service_role         = can(var.beanstalk.iam.service_role) ? var.beanstalk.iam.service_role : null
  beanstalk_min_instances        = try(var.beanstalk.instance.pool.min, 1)
  beanstalk_max_instances        = try(var.beanstalk.instance.pool.max, 1)

  load_balancer_shared             = try(var.beanstalk.load_balancer.shared.enabled, false)
  load_balancer_shared_name        = try(var.beanstalk.load_balancer.shared.name, "")
  load_balancer_shared_weight      = local.qualifier != "" ? (local.qualifier == "green" ? local.shared_lb_weight - 1 : local.shared_lb_weight) : local.shared_lb_weight
  load_balancer_public             = var.beanstalk.load_balancer.public
  load_balancer_log_bucket         = var.logs_bucket
  load_balancer_log_prefix         = var.release.name
  load_balancer_ssl_certificate_id = var.beanstalk.load_balancer.ssl_certificate_id
  load_balancer_ssl_policy         = can(var.beanstalk.load_balancer.ssl_policy) ? var.beanstalk.load_balancer.ssl_policy : null
  load_balancer_alias              = can(var.beanstalk.load_balancer.alias) ? var.beanstalk.load_balancer.alias : null
  custom_shared_rules              = try(var.beanstalk.custom_shared_rules, false)
  port_mappings                    = var.beanstalk.port_mappings
  rule_mappings                    = try(var.beanstalk.rule_mappings, [])
  extra_tags                       = merge(try(var.beanstalk.extra_tags, {}), local.all_tags)
  extra_settings                   = var.beanstalk.extra_settings
  wait_for_ready_timeout           = try(var.beanstalk.wait_for_ready_timeout, "20m")
}
