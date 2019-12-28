#Kubeconfig File
locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: "${var.eks_cluster_endpoint}"
    certificate-authority-data: "${var.eks_cluster_certificate_id}"
  name: "${var.eks_cluster_arn}" 
contexts:
- context:
    cluster: "${var.eks_cluster_arn}"
    user: "${var.eks_cluster_arn}"
  name: "${var.eks_cluster_arn}"
current-context: "${var.eks_cluster_arn}"
kind: Config
preferences: {}
users:
- name: "${var.eks_cluster_arn}"
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
KUBECONFIG
}

#Aws-Auth FIle
locals {
  config-map-aws-auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: "${var.iam_role_workernode_arn}"
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: "${var.iam_role_bastion_arn}"
      username: "${var.iam_role_bastion_role}"
      groups:
        - system:masters
CONFIGMAPAWSAUTH
}
