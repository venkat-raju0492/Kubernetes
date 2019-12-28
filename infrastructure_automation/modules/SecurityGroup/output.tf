output "eks_master_securitygroup_id" {
  value = "${aws_security_group.eks_master_securitygroup.id}"
}

output "eks_workernode_securitygroup_id" {
  value = "${aws_security_group.eks_workernode_securitygroup.id}"
}

output "bastion_ec2_eks_sg" {
  value = "${aws_security_group.bastion_ec2_eks_sg.id}"
}


