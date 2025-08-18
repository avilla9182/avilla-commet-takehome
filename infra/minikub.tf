# This is a dummy resource to validate the Helm chart works with Minikube
resource "null_resource" "minikube_validation" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Verifying Helm chart with Minikube..."
      helm template ./charts/hello-world | kubectl apply --dry-run=server -f -
      echo "Chart is valid for Minikube!"
    EOT
  }
}
