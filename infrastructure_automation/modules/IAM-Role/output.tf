output "eks_master_role_arn" {
  value = "${aws_iam_role.eks_master_role.arn}"
}
output "eks_workernode_role_name" {
  value = "${aws_iam_role.eks_workernode_role.name}"
}
output "eks_workernode_role_arn" {
  value = "${aws_iam_role.eks_workernode_role.arn}"
}

output "bastion_iam_role" {
  value = "${aws_iam_role.bastion_ec2_eks_access_role.name}"
}

output "bastion_iam_role_arn" {
  value = "${aws_iam_role.bastion_ec2_eks_access_role.arn}"
}

