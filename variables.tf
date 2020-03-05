# TF Variables

variable "AWS_region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "AmiLinux" {
  type = map(string)
  default = {
    us-east-1 = "ami-09d069a04349dc3cb"
  }
  description = "Amazon Linux image in us-east-1 region"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Default Amazon Instance type"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "List of available regions"
}

variable "cluster_name" {
  type        = string
  default     = "EKS-cluster"
  description = "EKS cluster name"
}
