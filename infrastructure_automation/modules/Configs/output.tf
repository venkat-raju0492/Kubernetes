output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "aws-auth" {
  value = "${local.config-map-aws-auth}"
}


