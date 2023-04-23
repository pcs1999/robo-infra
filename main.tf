resource "null_resource" "just" {

  provisioner "local-exec" {
   command = "echo ${var.env}"
  }

}