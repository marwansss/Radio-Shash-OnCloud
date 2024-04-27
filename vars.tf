variable "my_private_subnets" {
 type =  list(object({
    az = string
    cidr = string
 }))
 default = [ {az = "us-east-1a"
              cidr = "10.0.1.0/24"},
              {
                az = "us-east-1b"
                cidr = "10.0.2.0/24"} ]
}

variable "my_public_subnets" {
  type = list(object({
      az = string
      cidr = string
  }))
  default = [ {az = "us-east-1a"
              cidr = "10.0.10.0/24"},
              {
                az = "us-east-1b"
                cidr = "10.0.20.0/24"}]
}

variable "mys3_name" {
  type = string
  default = "maro-s3"
}

variable "elb_account_id" {
  type = number
  default = 127311923021
}

variable "aws_account_id" {
  type = number
  default = 324997758306
}

