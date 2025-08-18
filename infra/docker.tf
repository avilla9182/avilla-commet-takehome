resource "null_resource" "docker_desktop_check" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Verifying Docker Desktop Kubernetes is running..."
      kubectl cluster-info
      echo "Helm chart can be installed with: helm install hello-world ./charts/hello-world"
    EOT
  }
}
