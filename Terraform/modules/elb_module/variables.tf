variable "vpc_id" {
  type = string
}

variable "DEST_CIDR" {
  type = string
  default = "0.0.0.0/0"
}

variable "LB_DEST_CIDR" {
  type = string
  default = "10.0.0.0/16"
}


variable "HTTP" {
  type = number
  default = "80"
}
variable "SSH" {
  type = number
  default = "22"
}

variable "proxy-server-id" {
  type = list
}

variable "k8s-workers-id" {
  type = list
}


variable "proxy-lb-subnets" {
  type = list
}

variable "k8s-worker-lb-subnets" {
  type = list
}

variable "s3-name_bucket" {
  type = string
}