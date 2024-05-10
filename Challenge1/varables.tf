variable "number_of_subnets" {
    type = number
    description = "The number of subnets"
    validation {
      condition = var.number_of_subnets <5 
      error_message = "The number of subnets must be less than 5."
    }
  
}

variable "number_of_machines" {
  type = number
  description="The number of VMs"
  validation {
    condition = var.number_of_machines < 5
    error_message = "The number of VMs must be less than 5"
  }
}