resource "null_resource" "metrics-server" {
  triggers = {
    manifest_sha1 = "${sha1(dirname("${path.module}/metrics-server/deploy/1.8+/"))}"
  }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${local_file.kubeconfig.filename} apply -f ${path.module}/metrics-server/deploy/1.8+/"
  }
}