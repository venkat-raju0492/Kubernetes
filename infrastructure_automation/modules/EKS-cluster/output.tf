output "certificate_id" {
  value = "${aws_eks_cluster.eks.certificate_authority.0.data}"
}

output "endpoint" {
  value = "${aws_eks_cluster.eks.endpoint}"
}

output "eks_version" {
  value = "${aws_eks_cluster.eks.version}"
}

output "arn" {
  value = "${aws_eks_cluster.eks.arn}"
}
