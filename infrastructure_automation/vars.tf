variable "cluster_name" {
  description = "eks cluster name"
}

variable "vpc_id" {
  description = "id for vpc"
}

variable "cidr_blocks" {
  description = "cidr block for VPC"
}

variable "public_subnet_ids" {
  type = "list"
  description = "subnet ids for eks"
}

variable "private_subnet_ids" {
  type = "list"
  description = "subnet ids for eks"
}

variable "keypair" {
  description = "pem key for eks"
}

variable "region" {
  description = "region"
}

variable "instance_type" {
  description = "worked node instance type"
}

variable "workernode_max_count" {
  description = "worker node maximum count in autoscaling group"
}

variable "workernode_min_count" {
  description = "worker node minimum count in autoscaling group"
}

variable "workernode_desired_count" {
  description = "worker node desired count in autoscaling group"
}

variable "ami_id" {
  description = "ami id for bastion host"
}

variable "bastion_subnet_id" {
  description = "subnet id for bastion host"
}

variable "project" {
  description = "name od the project"
}
variable "levi_cidr" {
  type = "list"
  description = "cidr block for levi"
}

variable "jenkins_cidr" {
  type = "list"
  description = "cidr block for jenkins"
}

