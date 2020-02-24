#### Oficial latest AMI version for AWS EKS
data "aws_ami" "amazon-eks-linux-2" {
  most_recent = true
  owners      = ["602401143452"] # Amazon repository

  filter {
    name   = "name"
    values = ["amazon-eks-node-1.14*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# amazon-eks-node-1.11-v20191213 (ami-0ab75073588fdfe5d)
# if deployed using Autoscaling group rules
# with aws_eks_node_group diffirent image is deployed
# amazon-eks-node-1.14-v20190927 (ami-0392bafc801b7520f)
