variable "eks_cluster_endpoint" {
  description = "endpoint for EKS cluster"
}

variable "eks_cluster_arn" {
  description = "arn for EKS cluster"
}

variable "eks_cluster_certificate_id" {
  description = "certificate id for EKS cluster"
}

variable "cluster_name" {
  description = "name of the EKS cluster"
}

variable "iam_role_workernode_arn" {
  description = "role arn for worker node"
}

variable "iam_role_bastion_arn" {
  description = "roler arn for Bastion Host" 
}

variable "iam_role_bastion_role" {
  description = "role name for Bastion Host"
}
