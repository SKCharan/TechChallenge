locals {
  resource_group_name="appgrpV1"
  location="CentralIndia"
  virtual_network={
    name="app-network"
    address_space="10.0.0.0/16"
  }

  networksecuritygroup_rules = [
    {
      priority = 400
      destination_port_range = 3389
    },
    {
      priority = 401
      destination_port_range = 80
    },
    {
        priority = 402
        destination_port_range = 22
    }
  ]

}