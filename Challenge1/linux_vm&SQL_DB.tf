resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location  
}

resource "tls_private_key" "linuxkey" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "linuxpemkey" {
    filename = "linuxkey.pem"
    content = tls_private_key.linuxkey.private_key_pem
    depends_on = [
      tls_private_key.linuxkey
    ]
}

data "template_file" "cloudinit" {
    template = file("script.sh")
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  count = var.number_of_machines
  name                = "linuxvm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_E2s_v3"
  admin_username      = "adminuser"
  custom_data = base64encode(data.template_file.cloudinit.rendered)
  network_interface_ids = [azurerm_network_interface.appinterface[count.index].id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.linuxkey.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = "sqlserver876"
  resource_group_name          = local.resource_group_name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "admin"
  administrator_login_password = "Ytrewq654321@"
}

resource "azurerm_storage_account" "sa1" {
  name                     = "sa1"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "sqldb" {
  name                = "sqldb876"
  resource_group_name = local.resource_group_name
  location            = local.location
  server_name         = azurerm_sql_server.sqlserver.sqlserver876

}