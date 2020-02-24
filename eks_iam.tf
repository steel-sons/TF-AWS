#### Setup for IAM role for EKS cluster
resource "aws_iam_role" "eks_role" {
  name = "EKS-cluster-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          Action : "sts:AssumeRole",
          Effect : "Allow",
          Principal : {
            "Service" : "eks.amazonaws.com"
          }
        }
      ]
    }
  )
  tags = {
    Name = "EKS-IAM-cluster"
  }
  depends_on = [
    aws_route_table_association.public-RT-AS,
    aws_route_table_association.private-RT-AS
  ]
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
  depends_on = [
    aws_iam_role.eks_role
  ]
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
  depends_on = [
    aws_iam_role.eks_role
  ]
}

#########################################################################
#### IAM role for EKS Worker nodes
resource "aws_iam_role" "eks-node" {
  name = "eks-node-group"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
  tags = {
    tag-key = "EKS-IAM-node-group"
  }
  depends_on = [
    aws_route_table_association.public-RT-AS,
    aws_route_table_association.private-RT-AS
  ]
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node.name
  depends_on = [
    aws_iam_role.eks-node
  ]
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node.name
  depends_on = [
    aws_iam_role.eks-node
  ]
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node.name
  depends_on = [
    aws_iam_role.eks-node
  ]
}

resource "aws_iam_instance_profile" "eks-node" {
  name = "IAM-profile-for-EKS-node"
  role = aws_iam_role.eks-node.name
}
