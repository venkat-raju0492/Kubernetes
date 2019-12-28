variable "cluster_name" {
  description = "eks cluster name"
}

variable "keypair" {
  description = "name of the pem file"
}

variable "subnet_ids" {
  type = "list"
  description = "subnet ids for eks"
}


variable "eks_workernode_securitygroup_id" {
  description = "security group ID for eks worker node"
}

variable "eks_endpoint" {
  description = "eks endpoint"
}

variable "certificate_id" {
  description = "eks certificate authority"
}

variable "eks_version" {
  description = "eks version"
}

variable "instance_type" {
  description = "worked node instance type"
}

variable "eks_workernode_role_name" {
  description = "role arn for worker node"
}

variable "workernode_max_count" {
  description = "worker node maximum cluster size"
}

variable "workernode_min_count" {
  description = "worker node minimum cluster size"
}

variable "workernode_desired_count" {
  description = "worker node desired cluster size"
}

variable "project" {
  description = "name of the project"
}
