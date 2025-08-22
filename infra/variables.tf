variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region for EKS cluster"
  type        = string
  default     = "us-west-2"
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS cluster"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name for the Kubernetes cluster"
  type        = string
  default     = "hello-world-cluster"
}
