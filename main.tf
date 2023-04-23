resource "null_resource" "just" {

  provisioner "local-exec" "just" {
   command = "echo ${var.env}"
  }

}