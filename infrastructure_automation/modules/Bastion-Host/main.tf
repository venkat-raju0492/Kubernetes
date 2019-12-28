data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"
  vars {
  config = "${var.config}"
  auth   = "${var.auth}"
  }
}



resource "aws_iam_instance_profile" "eks_role" {
  name              = "${var.project}-${var.cluster_name}-bastion-role"
  role              = "${var.bastion_iam_role}"
}

resource "aws_instance" "instance" {
  ami                    = "${var.ami_id}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.bastion_subnet_id}"
  key_name               = "${var.keypair}"
  vpc_security_group_ids = ["${var.bastion_securitygroup}"]
  user_data              = "${data.template_file.user_data.rendered}"
  monitoring             = true
  iam_instance_profile    = "${aws_iam_instance_profile.eks_role.name}"
  root_block_device {
    volume_type           = "standard"
    volume_size           = "8"
    delete_on_termination = "true"
  }
  tags = {
    Name                  = "${var.project}-${var.cluster_name}-bastion-instance"
    project               = "${var.project}"
    created_by            = "Terraform"
  }
}

