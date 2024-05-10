resource "null_resource" "addingfiles" {
    count = var.number_of_subnets
    provisioner "file" {
        source = "Default.html"
        destination = "/var/www/html/Default.html"
    }

    connection {
      type = "ssh"
      user = "adminuser"
      private_key = file("${local_file.linuxpemkey.filename}")
      host = "${azurerm_public_ip.pubip[count.index].ip_address}"
    }

    depends_on = [
    local_file.linuxpemkey,
    azurerm_linux_virtual_machine.linuxvm
]
}

