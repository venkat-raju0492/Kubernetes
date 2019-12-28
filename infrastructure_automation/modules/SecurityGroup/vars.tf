variable "cluster_name" {
  description = "name of the eks cluster"
}
variable "vpc_id" {
  description = "vpc id of that region"
}
variable "cidr_blocks" {
  description = "cidr block"
}
variable "levi_cidr" {
  type = "list"
  description = "levi cidr"
}
variable "jenkins_cidr" {
  type = "list"
  description = "jenkins cidr"
}
variable "project" {
  description = "name of the project"
}
