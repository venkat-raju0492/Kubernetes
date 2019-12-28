variable "cluster_name" {
  description = "name of the eks cluster"
}
variable "eks_master_role_arn" {
  description = "role arn of eks master role"
}
variable "eks_master_securitygroup_id" {
  description = "security group id for eks master"
}
variable "subnet_ids" {
  type        = "list"
  description = "subnet IDs"
}
variable "project" {
  description = "name of the project"
}
