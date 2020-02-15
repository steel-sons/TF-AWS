#### Oficial latest AMI version for AWS EKS
data "aws_ami" "amazon-eks-linux-2" {
  most_recent = true
  owners      = ["602401143452"] # Amazon repository

  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
