# moved this part into a separate file
# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encode this
# information and write it into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
#locals {
#  tf-eks-node-userdata = <<USERDATA
#!/bin/bash
#set -o xtrace
#/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks_cluster.certificate_authority.0.data}' '${var.cluster_name}'
#USERDATA
#}
######################################
#### AutoScaling launch configuration
######################################
#### Public subnet
resource "aws_launch_configuration" "tf_eks" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.eks-node.name
  image_id                    = data.aws_ami.amazon-eks-linux-2.id # we getting the AMI from data source
  instance_type               = var.instance_type
  name_prefix                 = "terraform-eks-public"
  security_groups             = [aws_security_group.eks_cluster_security_group.id, aws_security_group.eks-node.id]
  user_data_base64            = base64encode(local.tf-eks-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_security_group.eks-node, aws_security_group.eks_cluster_security_group]
}

resource "aws_autoscaling_group" "tf_eks_asg" {
  count                     = length(var.availability_zones)
  name                      = "asg-out${count.index + 1}"
  default_cooldown          = 1
  wait_for_capacity_timeout = 0
  launch_configuration      = aws_launch_configuration.tf_eks.id
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [element(aws_subnet.subnet-public.*.id, count.index)]

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
  tag {
    key                 = "role"
    value               = "eks-worker-public"
    propagate_at_launch = true
  }
}
###############################
#### Private subnet
resource "aws_launch_configuration" "tf-eks-asg-private" {
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.eks-node.name
  image_id                    = data.aws_ami.amazon-eks-linux-2.id # we getting the AMI from data source
  instance_type               = var.instance_type
  name_prefix                 = "terraform-eks-private"
  security_groups             = [aws_security_group.eks_cluster_security_group.id, aws_security_group.eks-node.id]
  user_data_base64            = base64encode(local.tf-eks-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_security_group.eks-node, aws_security_group.eks_cluster_security_group]
}

resource "aws_autoscaling_group" "eks-asg-private" {
  count                     = length(var.availability_zones)
  name                      = "asg-in${count.index + 1}"
  default_cooldown          = 1
  wait_for_capacity_timeout = 0
  launch_configuration      = aws_launch_configuration.tf-eks-asg-private.id
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier       = [element(aws_subnet.subnet-private.*.id, count.index)]

  tags = concat(
    [
      {
        key                 = "Name",
        value               = "eks-workers-nodes"
        propagate_at_launch = true
      },
      {
        key                 = "kubernetes.io/cluster/${var.cluster_name}"
        value               = "owned"
        propagate_at_launch = true
      },
      {
        key                 = "role"
        value               = "eks-worker-private"
        propagate_at_launch = true
      }
    ]
  )
}
