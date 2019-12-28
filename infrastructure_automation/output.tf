output "config" {
  value = "${module.Configs.kubeconfig}"
}

output "aws-auth" {
  value = "${module.Configs.aws-auth}"
}
