variable "region" {
  description = "region to create the infrastructure"
}

variable "cluster_name" {
  description = "name of the eks cluster"
}

variable "project" {
  description = "project name"
}

variable "keypair" {
  description = "SSH key name to be used"
}

variable "ami_id" {
  description = "ami id"
}

variable "bastion_subnet_id" {
  description = "subnet ids"
}

variable "bastion_securitygroup" {
  description = "security group for bastion host"
}

variable "bastion_iam_role" {
  description = "iam role for bastion"
}

variable "config" {
  description = "config file for eks cluster"
}

variable "auth" {
  description = "aws auth file to join worker nodes"
}
