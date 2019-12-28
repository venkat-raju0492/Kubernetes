resource "aws_security_group" "eks_master_securitygroup" {
  name        = "${var.project}-${var.cluster_name}-controlplane-securitygroup"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.project}-${var.cluster_name}-controlplane-sg"
    created_by = "terraform"
    project    = "${var.project}"
  }
}

resource "aws_security_group_rule" "master_securitygroup_rule" {
  cidr_blocks       = ["${var.cidr_blocks}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks_master_securitygroup.id}"
  to_port           = 443
  type              = "ingress"
}



resource "aws_security_group" "eks_workernode_securitygroup" {
  name        = "${var.project}-${var.cluster_name}-workernode-securitygroup"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "${var.project}-${var.cluster_name}-workernode-sg",
     "kubernetes.io/cluster/${var.cluster_name}", "owned",
     "created_by", "terraform",
    )
  }"
}

resource "aws_security_group_rule" "workernode_ingress" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks_workernode_securitygroup.id}"
  source_security_group_id = "${aws_security_group.eks_workernode_securitygroup.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workernode_ingress_pods" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_workernode_securitygroup.id}"
  source_security_group_id = "${aws_security_group.eks_master_securitygroup.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workernode_ingress_API" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_master_securitygroup.id}"
  source_security_group_id = "${aws_security_group.eks_workernode_securitygroup.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "workernode_SSH" {
  description              = "Allow pods to SSH"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_master_securitygroup.id}"
  source_security_group_id = "${aws_security_group.eks_workernode_securitygroup.id}"
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group" "bastion_ec2_eks_sg" {
  name             = "${var.project}-${var.cluster_name}-bastion-securitygroup"
  description      = "Security group for bastion host"
  vpc_id           = "${var.vpc_id}"

  ingress {
    from_port      = 22
    to_port        = 22
    protocol       = "tcp"
    cidr_blocks    = "${var.levi_cidr}"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = "${var.jenkins_cidr}"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = "${var.levi_cidr}"
}

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = "${var.levi_cidr}"
  }

  ingress {
    from_port       = 8001
    to_port         = 8001
    protocol        = "tcp"
    cidr_blocks     = "${var.levi_cidr}"
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name            = "${var.project}-${var.cluster_name}-bastion-securitygroup"
    Created_By      = "Terraform"
    Project         = "${var.project}"
  }
}

