resource "aws_iam_instance_profile" "instance_profile" {
  name        = "${var.project}-${var.cluster_name}-workernode-instance"
  role        = "${var.eks_workernode_role_name}"
}

data "aws_ami" "eks_worker" {
  filter {
    name      = "name"
    values    = ["amazon-eks-node-${var.eks_version}-v*"]
  }
  most_recent = true
  owners      = ["602401143452"]
}


data "aws_region" "current" {}

locals {
  userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.eks_endpoint}' --b64-cluster-ca '${var.certificate_id}' '${var.cluster_name}'
USERDATA
}

resource "aws_launch_configuration" "launchconfig" {
  name_prefix                 = "${var.cluster_name}-eks-autoscaling-group"
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.instance_profile.name}"
  image_id                    = "${data.aws_ami.eks_worker.id}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${var.eks_workernode_securitygroup_id}"]
  user_data_base64            = "${base64encode(local.userdata)}"
  key_name                    = "${var.keypair}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscalingroup" {
  name                 = "${var.project}-${var.cluster_name}-autoscaling"
  desired_capacity     = "${var.workernode_desired_count}"
  launch_configuration = "${aws_launch_configuration.launchconfig.id}"
  max_size             = "${var.workernode_max_count}"
  min_size             = "${var.workernode_min_count}"
  vpc_zone_identifier  = "${var.subnet_ids}"

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-eks-workernodes"
    propagate_at_launch = true
  }
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
