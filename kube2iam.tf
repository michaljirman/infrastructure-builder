resource "null_resource" "kube2iam" {
  triggers = {
    manifest_sha1 = "${sha1(file("${path.module}/kube2iam.yaml"))}"
  }
  depends_on = ["local_file.kubeconfig"]

  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${local_file.kubeconfig.filename} apply -f ${path.module}/kube2iam.yaml"
  }
}