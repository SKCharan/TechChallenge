resource "azurerm_virtual_network" "appnetwork" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]  
  
   depends_on = [
     azurerm_resource_group.appgrp
   ]
  }


  resource "azurerm_subnet" "subnets" {
  count = var.number_of_subnets
  name                 = "subnet${count.index}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
  depends_on = [
    azurerm_virtual_network.appnetwork,
    azurerm_resource_group.appgrp
  ]
}


resource "azurerm_network_interface" "appinterface" {
  count = var.number_of_subnets
  name                = "appinterface${count.index}"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pubip[count.index].id
  }
  depends_on = [
    azurerm_subnet.subnets,
    azurerm_public_ip.pubip
  ]
}


resource "azurerm_public_ip" "pubip" {
  count = var.number_of_machines
  name = "pubip${count.index}"
  location = local.location
  resource_group_name = local.resource_group_name
  allocation_method = "Static"
  sku = "Standard"
  zones = ["${count.index+1}"]

  depends_on = [
    azurerm_resource_group.appgrp
  ]
}


resource "azurerm_network_security_group" "nsg" {
  name = "nsg"
  location = local.location
  resource_group_name = local.resource_group_name


  dynamic security_rule {
    for_each = local.networksecuritygroup_rules
    content {
      name = "Allow-${security_rule.value.destination_port_range}"
      priority = security_rule.value.priority
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = security_rule.value.destination_port_range
      source_address_prefix = "*"
      destination_address_prefix = "*"
    }
  }
  depends_on = [
    azurerm_resource_group.appgrp
  ]

}

resource "azurerm_network_interface_security_group_association" "linknsg" {
  count = var.number_of_subnets
  network_interface_id = azurerm_network_interface.appinterface[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [
    azurerm_resource_group.appgrp
  ]
}