resource "aws_iam_role" "cluster_role" {
  name = "${var.cluster_name}-role"

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

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_security_group" "cluster_sg" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for EKS Cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}

resource "aws_security_group_rule" "self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.cluster_sg.id
}

resource "aws_security_group_rule" "node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = var.node_sg
  security_group_id = aws_security_group.cluster_sg.id
}

resource "aws_eks_cluster" "fred_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.cluster_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids           = var.private_subnet_ids
    # public_access_cidrs  = var.cluster_enpoint_cidr
    security_group_ids   = var.cluster_sg_ids
    endpoint_private_access = false
    endpoint_public_access    = true
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy]
}

### Added
data "tls_certificate" "eks" {
  url = aws_eks_cluster.fred_eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.fred_eks_cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "csi" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_ebs_csi_driver" {
  name               = var.csi-role-name 
  assume_role_policy = data.aws_iam_policy_document.csi.json
  
}

resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


resource "aws_eks_addon" "ebs-csi-driver" {
  cluster_name                = var.cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.25.0-eksbuild.1" 
  service_account_role_arn    = aws_iam_role.eks_ebs_csi_driver.arn
  resolve_conflicts_on_update = "PRESERVE"
}

### This policy will be used to encrypt ebs volume. If needed, create a key and add details to kms-iam-policy.json file
/* resource "aws_iam_policy" "eks_ebs_csi_driver_kms" {
  name = "KMS_Key_For_Encryption_On_EBS"
  policy = "${file("kms-iam-policy.json")}"
}

 resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver_kms" {
   role       = aws_iam_role.eks_ebs_csi_driver.name
   policy_arn = aws_iam_policy.eks_ebs_csi_driver_kms.arn
} */