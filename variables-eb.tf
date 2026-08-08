##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# dns: # (Optional) DNS configuration for the environment. Default: {}
#   enabled: true              # (Optional) Enable Route53 record management. Default: false
#   private_zone: false        # (Optional) Look up the hosted zone as private. Default: false
#   domain_name: "example.com" # (Required when enabled) Route53 hosted zone name.
#   alias_prefix: "myapp"      # (Required when enabled) Record prefix prepended to domain_name.
variable "dns" {
  description = "DNS configuration for environment - (Optional) default: {}"
  type        = any
  default     = {}
}

# alarms: # (Optional) CloudWatch alarm configuration for the environment. Default: {}
#   enabled: false                    # (Optional) Create the EnvironmentHealth metric alarm. Default: false
#   threshold: 15                     # (Required when enabled) EnvironmentHealth value that triggers the alarm.
#   period: 120                       # (Required when enabled) Evaluation period in seconds.
#   evaluation_periods: 2             # (Required when enabled) Number of periods before alarming.
#   destination_topic: "ops-alerts"   # (Required when enabled) Name of an existing SNS topic to notify.
variable "alarms" {
  description = "Alarms configuration for the environment - (Optional) default: {}"
  type        = any
  default     = {}
}

# api_gateway: # (Optional) API Gateway VPC Link configuration. Default: {}
#   enabled: false      # (Optional) Enable the API Gateway VPC Link integration. Default: false
#   vpc_link:           # (Required when enabled) VPC Link settings.
#     use_existing: false          # (Optional) Attach to an existing NLB instead of creating one. Default: false
#     link_name: "my-vpc-link"     # (Optional) VPC Link name, only valid when use_existing = false. Default: "api-gw-nlb-<release>-<namespace>-nlb-link"
#     lb_name: "my-shared-nlb"     # (Required when use_existing = true) Name of the existing NLB.
#     listener_port: 8443          # (Required when use_existing = true) Listener port created on the existing NLB.
#     to_port: 443                 # (Optional) Target group port. Default: listener_port
#     health:                      # (Optional) Target group health check overrides.
#       enabled: true              # (Optional) Enable the health check. Default: false
#       protocol: "HTTPS"          # (Optional) Possible values: TCP, HTTP, HTTPS. Default: "TCP"
#       http_status: "200-401"     # (Optional) Success status matcher. Default: ""
#       path: "/"                  # (Optional) Health check path. Default: ""
variable "api_gateway" {
  description = "API Gateway configuration for the environment - (Optional) default: {}"
  type        = any
  default     = {}
}

# namespace: "dev" # (Required) Environment namespace, appended to the release name to build the environment name.
variable "namespace" {
  description = "Environment namespace - (Required)"
  type        = string
}

# release: # (Required) Release definition, normally supplied by the base application pipeline.
#   name: "myapp"          # (Required) Release name, used as the Beanstalk environment prefix.
#   qualifier: "blue"      # (Optional) Blue/green qualifier. Possible values: "blue", "green" or empty. Default: ""
#   source:                # (Required) Source artifact reference.
#     name: "myapp"        # (Required) Artifact name.
#     version: "1.0.0"     # (Required) Artifact version, used to build the version label.
variable "release" {
  description = "Release configuration - (Required)"
  type        = any
}

# beanstalk: # (Required) Elastic Beanstalk environment configuration.
#   # solution_stack is a regular expression matched against the available AWS solution stacks,
#   # or a complete stack name to stick the environment to a specific version. Common patterns:
#   #   java      = "^64bit Amazon Linux 2 (.*) Corretto 8(.*)$"
#   #   java11    = "^64bit Amazon Linux 2 (.*) Corretto 11(.*)$"
#   #   java17    = "^64bit Amazon Linux 2 (.*) Corretto 17(.*)$"
#   #   node      = "^64bit Amazon Linux 2 (.*) Node.js 12(.*)$"
#   #   node14    = "^64bit Amazon Linux 2 (.*) Node.js 14(.*)$"
#   #   node16    = "^64bit Amazon Linux 2 (.*) Node.js 16 AL2 (.*)$"
#   #   node18    = "^64bit Amazon Linux 2 (.*) Node.js 18 AL2 (.*)$"
#   #   go        = "^64bit Amazon Linux 2 (.*) Go (.*)$"
#   #   docker    = "^64bit Amazon Linux 2 (.*) Docker (.*)$"
#   #   docker-m  = "^64bit Amazon Linux 2 (.*) Multi-container Docker (.*)$"
#   solution_stack: "^64bit Amazon Linux 2 (.*) Corretto 17(.*)$" # (Required) Solution stack name or regex.
#   application: "myapp"                    # (Required) Existing Elastic Beanstalk application name.
#   wait_for_ready_timeout: "20m"           # (Optional) Timeout waiting for the environment to become ready. Default: "20m"
#   custom_shared_rules: false              # (Optional) When true, rule_mappings override the Beanstalk shared LB configuration. Default: false
#   iam:                                    # (Optional) IAM overrides, AWS defaults are used when omitted.
#     instance_profile: "aws-elasticbeanstalk-ec2-role" # (Optional) EC2 instance profile name. Default: null
#     service_role: "aws-elasticbeanstalk-service-role" # (Optional) Beanstalk service role name. Default: null
#   load_balancer:                          # (Required) Load balancer configuration.
#     public: true                          # (Required) Place the load balancer on the public subnets.
#     ssl_certificate_id: "arn:aws:acm:..." # (Required) ACM certificate ARN for the HTTPS listener.
#     ssl_policy: "ELBSecurityPolicy-2016-08" # (Optional) Listener SSL policy. Default: null (AWS default)
#     alias: "myapp-lb"                     # (Optional) Load balancer alias name. Default: null
#     shared:                               # (Optional) Attach the environment to a shared load balancer.
#       enabled: false                      # (Optional) Enable shared load balancer mode. Default: false
#       name: "shared-alb"                  # (Required when enabled) Name of the existing shared ALB.
#       weight: 100                         # (Optional) Traffic weight for the environment. Default: 100
#       dns:                                # (Optional) DNS record pointing to the shared load balancer.
#         enabled: false                    # (Optional) Create the alias record on the shared LB. Default: false
#   instance:                               # (Required) EC2 instance configuration.
#     instance_port: 8080                   # (Required) Port the application listens on.
#     enable_spot: true                     # (Required) Enable spot instances for cost optimization.
#     default_retention: 90                 # (Required) CloudWatch log retention in days.
#     volume_size: 20                       # (Required) Root volume size in GB.
#     volume_type: "gp2"                    # (Required) Root volume type. Possible values: gp2, gp3, io1, standard.
#     server_types:                         # (Required) Ordered list of instance types offered to the ASG.
#       - "t3.micro"
#       - "t3.small"
#     ec2_key: "my-keypair"                 # (Optional) EC2 key pair name. Default: null
#     ami_id: "ami-0123456789abcdef0"       # (Optional) Custom AMI id. Default: null (platform AMI)
#     pool:                                 # (Optional) Auto scaling group elasticity.
#       min: 1                              # (Optional) Minimum number of instances. Default: 1
#       max: 1                              # (Optional) Maximum number of instances. Default: 1
#   networking:                             # (Required) Network placement.
#     vpc_id: "vpc-0123456789abcdef0"       # (Required) VPC id hosting the environment.
#     private_subnets: []                   # (Required) Subnet ids for the instances - may be empty when public.
#     public_subnets: []                    # (Required) Subnet ids for the public load balancer - may be empty when private.
#   port_mappings: []                       # (Optional) Listener to backend port mappings. Default: []
#     # - name: "default"                   # (Required) Mapping/process name.
#     #   from_port: 80                     # (Required) Listener port.
#     #   to_port: 8081                     # (Required) Backend port.
#     #   protocol: "HTTP"                  # (Required) Listener protocol. Possible values: HTTP, HTTPS.
#     #   backend_protocol: "HTTPS"         # (Optional) Backend protocol. Possible values: HTTP, HTTPS. Default: protocol
#     #   health_check:                     # (Optional) Custom target group health check.
#     #     enabled: true                   # (Optional) Enable the health check. Default: false
#     #     protocol: "HTTPS"               # (Optional) Possible values: HTTP, HTTPS. Default: backend_protocol
#     #     port: 8443                      # (Optional) Possible values: a port number or "traffic-port". Default: "traffic-port"
#     #     matcher: "200-302"              # (Optional) Success status matcher. Default: "200"
#     #     path: "/"                       # (Optional) Health check path. Default: "/"
#     #     unhealthy_threshold: 2          # (Optional) Failed checks before unhealthy. Default: 2
#     #     healthy_threshold: 2            # (Optional) Successful checks before healthy. Default: 2
#     #     timeout: 5                      # (Optional) Check timeout in seconds. Default: 5
#     #     interval: 30                    # (Optional) Check interval in seconds. Default: 30
#     #   rules: []                         # (Required when custom_shared_rules is not set) Names of the rule_mappings applied to this process.
#   rule_mappings: []                       # (Optional) Listener rules for the shared load balancer. Default: []
#     # - name: "myapp-rule"                # (Required) Rule name, referenced from port_mappings.rules.
#     #   process: "default"                # (Required) Target port mapping name.
#     #   host: "host.address.com"          # (Optional) Comma separated host headers to match.
#     #   path: "/path"                     # (Optional) Single path to match.
#     #   priority: 100                     # (Optional) Listener rule priority. Default: assigned by the module
#     #   path_patterns: []                 # (Optional) List of path patterns to match.
#     #   query_strings: []                 # (Optional) List of "key=value" query strings to match.
#     #   http_headers: []                  # (Optional) List of { name, values } header matchers.
#     #   source_ips: []                    # (Optional) List of CIDR blocks to match.
#   extra_settings: []                      # (Optional) Raw Beanstalk option settings. Default: []
#     # - name: "SETTING_NAME"              # (Required) Option name.
#     #   namespace: "aws:NAMESPACE"        # (Required) Option namespace.
#     #   resource: ""                      # (Optional) Option resource. Default: ""
#     #   value: "VALUE"                    # (Required) Option value.
#   extra_tags: {}                          # (Optional) Extra tags applied to the Beanstalk environment only. Default: {}
variable "beanstalk" {
  description = "Beanstalk environment configuration - (Required)"
  type        = any
}

# region: "us-east-1" # (Optional) AWS region where the environment is deployed. Default: "us-east-1"
variable "region" {
  description = "AWS region - (Optional) default: us-east-1"
  type        = string
  default     = "us-east-1"
}

# sts_assume_role: "arn:aws:iam::123456789012:role/deployer" # (Optional) Role assumed by the deployment modules. Default: null
variable "sts_assume_role" {
  description = "STS Assume Role ARN - (Optional) default: null"
  type        = string
  default     = null
}

# versions_bucket: "my-versions-bucket" # (Required) S3 bucket holding the application version bundles.
variable "versions_bucket" {
  description = "S3 bucket for application versions - (Required)"
  type        = string
}

# logs_bucket: "my-logs-bucket" # (Required) S3 bucket receiving the load balancer access logs.
variable "logs_bucket" {
  description = "S3 bucket for application logs - (Required)"
  type        = string
}

# repository_owner: "cloudopsworks" # (Required) GitHub organization owning the application repository.
variable "repository_owner" {
  description = "GitHub repository owner - (Required)"
  type        = string
}

# absolute_path: "/deploy/myapp" # (Optional) Absolute path where the .values_hash file is located. Default: "" (current directory)
variable "absolute_path" {
  description = "Absolute path to the configuration files - (Optional) default: \"\""
  type        = string
  default     = ""
}

# bucket_path: "myapp/1.0.0/myapp-1.0.0-ABCDEF.zip" # (Optional) Key of the version bundle inside versions_bucket. Default: "" (computed from the release)
variable "bucket_path" {
  description = "Path to the S3 bucket - (Optional) default: \"\" (computed from the release)"
  type        = string
  default     = ""
}
