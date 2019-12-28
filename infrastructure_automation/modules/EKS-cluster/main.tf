data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "AmazonEKSServicePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_eks_cluster" "eks" {
  name                      = "${var.cluster_name}"
  role_arn                  = "${var.eks_master_role_arn}"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]  

  vpc_config {
    security_group_ids      = ["${var.eks_master_securitygroup_id}"]
    subnet_ids              = "${var.subnet_ids}"
  }
  tags = {
    Name                  = "${var.project}-${var.cluster_name}-controlplane"
    project               = "${var.project}"
    created_by            = "Terraform"
  }
  depends_on = [
    "data.aws_iam_policy.AmazonEKSClusterPolicy",
    "data.aws_iam_policy.AmazonEKSServicePolicy",
    "aws_cloudwatch_log_group.eks-logging"
  ]
}


resource "aws_cloudwatch_log_group" "eks-logging" {
  name                      = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days         = 7
}


