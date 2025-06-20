<!-- 
  ** DO NOT EDIT THIS FILE
  ** 
  ** This file was automatically generated. 
  ** 1) Make all changes to `README.yaml` 
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file. 
  -->
[![README Header][readme_header_img]][readme_header_link]

[![cloudopsworks][logo]](https://cloudops.works/)

# Terraform Elastic Beanstalk Application Deployment Module




Deployment module for Elastic Beanstalk applications through the [Base Application Module](https://github.com/cloudopsworks/base-app-template.git). This module provides comprehensive configuration options for AWS Elastic Beanstalk deployments including load balancer setup, instance configurations, networking, DNS management, monitoring and alarms integration.


---

This project is part of our comprehensive approach towards DevOps Acceleration. 
[<img align="right" title="Share via Email" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/ios-mail.svg"/>][share_email]
[<img align="right" title="Share on Google+" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-googleplus.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-facebook.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-reddit.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-linkedin.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-twitter.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudops.works/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We have [*lots of terraform modules*][terraform_modules] that are Open Source and we are trying to get them well-maintained!. Check them out!






## Introduction

This Terraform module simplifies AWS Elastic Beanstalk application deployments by providing:

- Multiple platform support (Java 8/11/17, Node.js 12/14/16/18, Go, Docker)
- Flexible load balancer configuration with shared LB support
- DNS management with Route53 integration
- CloudWatch alarms integration
- API Gateway VPC Link support
- Spot instance support for cost optimization
- Custom health checks and SSL configuration
- Comprehensive tag management

## Usage


**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=vX.Y.Z`) of one of our [latest releases](https://github.com/terraform-module-aws-elasticbeanstalk-deploy/releases).


File Format recommended for inputs:
```yaml
environment: "dev|uat|prod|demo"
runner_set: "RUNNER-ENV"
versions_bucket: "VERSIONS_BUCKET"
#logs_bucket: "LOGS_BUCKET"
#node_extra_env:
dns:
  enabled: true
  private_zone: false
  domain_name: DOMAIN_NAME
  alias_prefix: ALIAS_PREFIX
alarms:
  enabled: false
  threshold: 15
  period: 120
  evaluation_periods: 2
  destination_topic: DESTINATION_SNS
api_gateway:
  enabled: false
  vpc_link:
    #link_name: VPC_LINK_NAME # Optional: only valid when existing link is NOT used
    use_existing: false
    #lb_name: LOAD_BALANCER_NAME
    #listener_port: 8443
    #to_port: 443
    #health: # Enable this and below to change the type of healthcheck
    #  enabled: true
    #  protocol: HTTPS
    #  http_status: "200-401"
    #  path: "/"
beanstalk:
  # Solution stack is one of:
  #   java      = "^64bit Amazon Linux 2 (.*) Corretto 8(.*)$"
  #   java11    = "^64bit Amazon Linux 2 (.*) Corretto 11(.*)$"
  #   java17    = "^64bit Amazon Linux 2 (.*) Corretto 17(.*)$"
  #   node      = "^64bit Amazon Linux 2 (.*) Node.js 12(.*)$"
  #   node14    = "^64bit Amazon Linux 2 (.*) Node.js 14(.*)$"
  #   node16    = "^64bit Amazon Linux 2 (.*) Node.js 16 AL2 (.*)$"
  #   node18    = "^64bit Amazon Linux 2 (.*) Node.js 18 AL2 (.*)$"
  #   go        = "^64bit Amazon Linux 2 (.*) Go (.*)$"
  #   docker    = "^64bit Amazon Linux 2 (.*) Docker (.*)$"
  #   docker-m  = "^64bit Amazon Linux 2 (.*) Multi-container Docker (.*)$"
  #   java-amz1 = "^64bit Amazon Linux (.*)$ running Java 8(.*)$"
  #   node-amz1 = "^64bit Amazon Linux (.*)$ running Node.js(.*)$"
  # Can specify complete name for certain environments to Stick the stack to a specific version.
  solution_stack: SOLUTION_STACK
  application: APPLICATION
  iam:
    instance_profile: INSTANCE_PROFILE
    service_role: SERVICE_ROLE
  load_balancer:
    # Shared Load Balancer configuration subset
    #shared:
    #  dns:
    #    enabled: false
    #  enabled: false
    #  name: SHARED_LB_NAME
    #  weight: 100
    public: true
    ssl_certificate_id: SSL_CERTIFICATE_ID
    ssl_policy: ELBSecurityPolicy-2016-08
    alias: LOAD_BALANCER_ALIAS
  instance:
    instance_port: 8080
    enable_spot: true
    default_retention: 90
    volume_size: 20
    volume_type: gp2
    ec2_key: EC2_KEY
    ami_id: AMI_ID
    server_types:
      - SERVER TYPE1
      - SERVER TYPE2
    #pool: # Instance Pool elasticity minimum & maximum number of instances
    #  min: 1
    #  max: 1
  networking:
    private_subnets: []
    #      - SUBNET_ID
    #      - SUBNET_ID2
    public_subnets: []
    #      - SUBNET_ID3
    #      - SUBNET_ID4
    vpc_id: VPC_ID
  ##
  # Optional variable for mapping ports to backend ports:
  port_mappings: []
  #    - name: default
  #      from_port: 80
  #      to_port: 8081
  #      protocol: HTTP
  #    - name: port443
  #      from_port: 443
  #      to_port: 8443
  #      protocol: HTTPS
  #      backend_protocol: HTTPS
  #      health_check: # for custom target group
  #        enabled: true
  #        protocol: HTTPS
  #        port: 8443 | traffic-port
  #        matcher: "200-302"
  #        path: "/"
  #        unhealthy_threshold: 2
  #        healthy_threshold: 2
  #        timeout: 5
  #        interval: 30
  #      # Rules are required if custom_shared_rules=false or not set
  #      rules:
  #        - RULENAME

  ##
  # Optional variable for adding extra tags to the environment
  extra_tags: {}
  #    key: value
  #    key2: value2
  extra_settings: []
  #    - name: SETTING_NAME
  #      namespace: aws:NAMESPACE
  #      resource: ""
  #      value: "<VALUE>"
  #    - name: SETTING_NAME_2
  #      namespace: aws:NAMESPACE_2
  #      resource: ""
  #      value: "<VALUE>"
  ##
  # Enable custom shared Rules where below rule mappings mandate over elastic beanstalk configuration.
  #custom_shared_rules: true
  ##
  # Optional Variable for mapping rules for shared Load Balancer
  rule_mappings: []
#    - name: RULENAME
#      process: port_mapping_process
#      host: host.address.com,host.address2.com
#      path: /path
#      priority: 100
#      path_patterns:
#        - /path
#      query_strings:
#        - query1=value1
#        - query2=value2
#      http_headers:
#        - name: HEADERNAME
#          values: ["value1", "valuepattern*"]
#      source_ips:
#        - IP1
#        - IP2
tags: {}
# TAG1: value1
# TAG2: value2
```

## Quick Start

1. Create a new Terragrunt configuration file (terragrunt.hcl)
2. Configure the module source and version:
   ```hcl
   terraform {
     source = "git::https://github.com/cloudopsworks/terraform-module-aws-elasticbeanstalk-deploy.git?ref=v1.0.0"
   }
   ```
3. Set required variables:
   - environment
   - runner_set
   - versions_bucket
   - beanstalk configuration (solution_stack, application, networking)
4. Initialize Terragrunt:
   ```bash
   terragrunt init
   ```
5. Review the plan:
   ```bash
   terragrunt plan
   ```
6. Apply the configuration:
   ```bash
   terragrunt apply
   ```


## Examples

## Basic Terragrunt Configuration
```hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/cloudopsworks/terraform-module-aws-elasticbeanstalk-deploy.git?ref=v1.0.0"
}

inputs = {
  environment = "dev"
  runner_set = "dev-runner"
  versions_bucket = "my-versions-bucket"

  dns = {
    enabled = true
    private_zone = false
    domain_name = "example.com"
    alias_prefix = "myapp"
  }

  beanstalk = {
    solution_stack = "^64bit Amazon Linux 2 (.*) Node.js 18 AL2 (.*)$"
    application = "myapp"

    load_balancer = {
      public = true
      ssl_certificate_id = "arn:aws:acm:region:account:certificate/certificate-id"
    }

    instance = {
      instance_port = 8080
      enable_spot = true
      server_types = ["t3.micro", "t3.small"]
    }

    networking = {
      vpc_id = "vpc-12345"
      private_subnets = ["subnet-1", "subnet-2"]
    }
  }
}
```



## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform/opentofu code
  tag                                 Tag the current version

```
## Requirements

| Name                                                                      | Version |
|---------------------------------------------------------------------------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app"></a> [app](#module\_app) | cloudopsworks/beanstalk-deploy/aws | 1.1.2 |
| <a name="module_app_dns_shared"></a> [app\_dns\_shared](#module\_app\_dns\_shared) | cloudopsworks/beanstalk-dns/aws | 1.0.5 |
| <a name="module_dns"></a> [dns](#module\_dns) | cloudopsworks/beanstalk-dns/aws | 1.0.5 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |
| <a name="module_version"></a> [version](#module\_version) | cloudopsworks/beanstalk-version/aws | 1.5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_vpc_link.apigw_rest_link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_vpc_link) | resource |
| [aws_cloudwatch_metric_alarm.metric_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_lb.apigw_rest_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.apigw_rest_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.apigw_rest_lb_listener_link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.apigw_rest_lb_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.apigw_rest_lb_tg_link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.apigw_rest_lb_tg_att](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.apigw_rest_lb_tg_att_link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_lb.apigw_rest_lb_link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.shared_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_sns_topic.topic_destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_absolute_path"></a> [absolute\_path](#input\_absolute\_path) | Absolute path to the configuration files | `string` | `""` | no |
| <a name="input_alarms"></a> [alarms](#input\_alarms) | Alarms configuration for the environment | `any` | `{}` | no |
| <a name="input_api_gateway"></a> [api\_gateway](#input\_api\_gateway) | API Gateway configuration for the environment | `any` | `{}` | no |
| <a name="input_beanstalk"></a> [beanstalk](#input\_beanstalk) | Beanstalk environment configuration | `any` | n/a | yes |
| <a name="input_bucket_path"></a> [bucket\_path](#input\_bucket\_path) | Path to the S3 bucket | `string` | `""` | no |
| <a name="input_dns"></a> [dns](#input\_dns) | DNS configuration for environment | `any` | `{}` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Establish this is a HUB or spoke configuration | `bool` | `false` | no |
| <a name="input_logs_bucket"></a> [logs\_bucket](#input\_logs\_bucket) | S3 bucket for application logs | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Environment namespace | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | n/a | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_release"></a> [release](#input\_release) | Release configuration | `any` | n/a | yes |
| <a name="input_repository_owner"></a> [repository\_owner](#input\_repository\_owner) | GitHub repository owner | `string` | n/a | yes |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | n/a | `string` | `"001"` | no |
| <a name="input_sts_assume_role"></a> [sts\_assume\_role](#input\_sts\_assume\_role) | STS Assume Role ARN | `string` | `null` | no |
| <a name="input_versions_bucket"></a> [versions\_bucket](#input\_versions\_bucket) | S3 bucket for application versions | `string` | n/a | yes |

## Outputs

No outputs.



## Help

**Got a question?** We got answers. 

File a GitHub [issue](https://github.com/terraform-module-aws-elasticbeanstalk-deploy/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Tools

## Slack Community


## Newsletter

## Office Hours

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/terraform-module-aws-elasticbeanstalk-deploy/issues) to report any bugs or file feature requests.

### Developing




## Copyrights

Copyright © 2024-2025 [Cloud Ops Works LLC](https://cloudops.works)





## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained by [Cloud Ops Works LLC][website]. 


### Contributors

|  [![Cristian Beraha][berahac_avatar]][berahac_homepage]<br/>[Cristian Beraha][berahac_homepage] |
|---|

  [berahac_homepage]: https://github.com/berahac
  [berahac_avatar]: https://github.com/berahac.png?size=50

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudops.works/logo-300x69.svg
  [docs]: https://cowk.io/docs?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=docs
  [website]: https://cowk.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=website
  [github]: https://cowk.io/github?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=github
  [jobs]: https://cowk.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=jobs
  [hire]: https://cowk.io/hire?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=hire
  [slack]: https://cowk.io/slack?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=slack
  [linkedin]: https://cowk.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=linkedin
  [twitter]: https://cowk.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=twitter
  [testimonial]: https://cowk.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=testimonial
  [office_hours]: https://cloudops.works/office-hours?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=office_hours
  [newsletter]: https://cowk.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=newsletter
  [email]: https://cowk.io/email?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=email
  [commercial_support]: https://cowk.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=commercial_support
  [we_love_open_source]: https://cowk.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=we_love_open_source
  [terraform_modules]: https://cowk.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=terraform_modules
  [readme_header_img]: https://cloudops.works/readme/header/img
  [readme_header_link]: https://cloudops.works/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=readme_header_link
  [readme_footer_img]: https://cloudops.works/readme/footer/img
  [readme_footer_link]: https://cloudops.works/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudops.works/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudops.works/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=terraform-module-aws-elasticbeanstalk-deploy&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=Terraform+Elastic+Beanstalk+Application+Deployment+Module&url=https://github.com/terraform-module-aws-elasticbeanstalk-deploy
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=Terraform+Elastic+Beanstalk+Application+Deployment+Module&url=https://github.com/terraform-module-aws-elasticbeanstalk-deploy
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/terraform-module-aws-elasticbeanstalk-deploy
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/terraform-module-aws-elasticbeanstalk-deploy
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/terraform-module-aws-elasticbeanstalk-deploy
  [share_email]: mailto:?subject=Terraform+Elastic+Beanstalk+Application+Deployment+Module&body=https://github.com/terraform-module-aws-elasticbeanstalk-deploy
  [beacon]: https://ga-beacon.cloudops.works/G-7XWMFVFXZT/terraform-module-aws-elasticbeanstalk-deploy?pixel&cs=github&cm=readme&an=terraform-module-aws-elasticbeanstalk-deploy
