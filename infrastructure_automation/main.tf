terraform {
  backend "s3" {}
}

provider "aws" {
  region                          = "${var.region}"
}

data "terraform_remote_state" "levis_infra_state" {
  backend = "s3"
  config {
    bucket = "terraform-states-${var.region}"
    key = "eks.tfstate"
    region = "${var.region}"
  }
}


module "IAM-Role" {
  source                          = "./modules/IAM-Role"
  cluster_name                    = "${var.cluster_name}"
  project                         = "${var.project}"
}

module "SecurityGroup" {
  source                          = "./modules/SecurityGroup"
  cluster_name                    = "${var.cluster_name}"
  vpc_id                          = "${var.vpc_id}"
  cidr_blocks                     = "${var.cidr_blocks}"
  project                         = "${var.project}"
  levi_cidr                       = "${var.levi_cidr}"
  jenkins_cidr                    = "${var.jenkins_cidr}"
  project                         = "${var.project}"
}

module "EKS-cluster" {
  source                          = "./modules/EKS-cluster"
  cluster_name                    = "${var.cluster_name}"
  eks_master_role_arn             = "${module.IAM-Role.eks_master_role_arn}"
  eks_master_securitygroup_id     = "${module.SecurityGroup.eks_master_securitygroup_id}"
  subnet_ids                      = "${var.public_subnet_ids}"
  project                         = "${var.project}"
}

module "Worker-Nodes" {
  source                          = "./modules/Worker-Nodes"
  cluster_name                    = "${var.cluster_name}"
  eks_workernode_role_name        = "${module.IAM-Role.eks_workernode_role_name}"
  eks_workernode_securitygroup_id = "${module.SecurityGroup.eks_workernode_securitygroup_id}"
  keypair                         = "${var.keypair}"
  instance_type                   = "${var.instance_type}"
  subnet_ids                      = "${var.private_subnet_ids}"
  eks_endpoint                    = "${module.EKS-cluster.endpoint}"
  certificate_id                  = "${module.EKS-cluster.certificate_id}"
  eks_version                     = "${module.EKS-cluster.eks_version}"
  workernode_max_count            = "${var.workernode_max_count}"
  workernode_min_count            = "${var.workernode_min_count}"
  workernode_desired_count        = "${var.workernode_desired_count}"
  project                         = "${var.project}"
}

module "Bastion-Host" {
  source                          = "./modules/Bastion-Host"
  cluster_name                    = "${var.cluster_name}"
  keypair                         = "${var.keypair}"
  region                          = "${var.region}"
  bastion_subnet_id               = "${var.bastion_subnet_id}"
  ami_id                          = "${var.ami_id}"
  bastion_securitygroup           = "${module.SecurityGroup.bastion_ec2_eks_sg}"
  bastion_iam_role                = "${module.IAM-Role.bastion_iam_role}"
  project                         = "${var.project}"
  config                          = "${module.Configs.kubeconfig}"
  auth                            = "${module.Configs.aws-auth}"
}

module "Configs" {
  source                          = "./modules/Configs"
  eks_cluster_endpoint            = "${module.EKS-cluster.endpoint}"
  eks_cluster_certificate_id      = "${module.EKS-cluster.certificate_id}"
  eks_cluster_arn                 = "${module.EKS-cluster.arn}" 
  cluster_name                    = "${var.cluster_name}"
  iam_role_workernode_arn         = "${module.IAM-Role.eks_workernode_role_arn}"
  iam_role_bastion_arn            = "${module.IAM-Role.bastion_iam_role_arn}"  
  iam_role_bastion_role           = "${module.IAM-Role.bastion_iam_role}"  
}

