resource "aws_iam_role" "eks_master_role" {
  name                  = "${var.project}-${var.cluster_name}-controlplane-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn            = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role                  = "${aws_iam_role.eks_master_role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn            = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role                  = "${aws_iam_role.eks_master_role.name}"
}


resource "aws_iam_role" "eks_workernode_role" {
  name                  = "${var.project}-${var.cluster_name}-workernode-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "ingress_controller_policy" {
  name        = "${var.project}-${var.cluster_name}-workernode-alb-policy"
  description = "policy for alb ingress controller"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "acm:DescribeCertificate",
                "acm:ListCertificates",
                "acm:GetCertificate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcs",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteRule",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:ModifyRule",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:SetIpAddressType",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:SetWebACL"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole",
                "iam:GetServerCertificate",
                "iam:ListServerCertificates"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cognito-idp:DescribeUserPoolClient"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetWebACLForResource",
                "waf-regional:GetWebACL",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "tag:GetResources",
                "tag:TagResources"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "waf:GetWebACL"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name                  = "${var.project}-${var.cluster_name}-workernode-autoscaler-policy"
  description           = "cluster autoscaler"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ec2_cloudwatch_policy" {
  name        = "${var.project}-${var.cluster_name}-cloudwatchaccess-policy"
  description = "EC2 Cloudwatch Access Policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Stmt1561629174188",
        "Action": [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "cloudwatch:PutMetricData"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Sid": "Stmt1561629228242",
        "Action": [
          "ec2:DescribeTags"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn            = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role                  = "${aws_iam_role.eks_workernode_role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn            = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role                  = "${aws_iam_role.eks_workernode_role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn            = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role                  = "${aws_iam_role.eks_workernode_role.name}"
}

resource "aws_iam_role_policy_attachment" "workernode_alb_ingress_controller" {
  role                 = "${aws_iam_role.eks_workernode_role.name}"
  policy_arn           = "${aws_iam_policy.ingress_controller_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "workernode_autoscaler" {
  role                 = "${aws_iam_role.eks_workernode_role.name}"
  policy_arn           = "${aws_iam_policy.cluster_autoscaler_policy.arn}"
}

resource "aws_iam_role" "bastion_ec2_eks_access_role" {
  name               = "${var.project}-${var.cluster_name}-bastion-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },    
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
EOF
}


resource "aws_iam_policy" "bastion_ec2_eks_policy" {
  name        = "${var.project}-${var.cluster_name}-bastion-policy"
  description = "Eks Access Policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "eks:*",
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_policy" "bastion_ec2_s3_policy" {
  name        = "${var.project}-${var.cluster_name}-bastion-s3-policy"
  description = "Eks Access Policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "s3:*",
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
}
EOF
}


resource "aws_iam_policy_attachment" "bastion_ec2_policy_attachment" {
  name             = "${var.project}-${var.cluster_name}-bastion-policyattachment"
  roles            = ["${aws_iam_role.bastion_ec2_eks_access_role.name}"]
  policy_arn       = "${aws_iam_policy.bastion_ec2_eks_policy.arn}"
}

resource "aws_iam_policy_attachment" "bastion_s3_policy_attachment" {
  name             = "${var.project}-}${var.cluster_name}-bastion-s3-policyattachment"
  roles            = ["${aws_iam_role.bastion_ec2_eks_access_role.name}"]
  policy_arn       = "${aws_iam_policy.bastion_ec2_s3_policy.arn}"
}
