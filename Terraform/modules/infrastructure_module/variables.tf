variable "VPC_CIDR" {
  type = string
  default = "10.0.0.0/16"
}

variable "DEST_CIDR" {
  type = string
  default = "0.0.0.0/0"
}

#----------------------------------------------------------------------------------------------------------------
# Variables for the Public subnets
#------------------------------------

variable "public_subnets" {
  type = list(object({
    az = string
    cidr = string
  }))
}


#----------------------------------------------------------------------------------------------------------------
# Variables for the Private subnets
#------------------------------------

variable "private_subnets" {
  type = list(object({
    az = string
    cidr = string
  }))
}