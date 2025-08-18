variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "Name for the Kubernetes cluster"
  type        = string
  default     = "hello-world-cluster"
}
