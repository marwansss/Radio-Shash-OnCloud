variable "vpc-id" {
  type = string
}

variable "private_subnets_ids" {
  type = list
}
variable "public_subnets_ids" {
  type = list
}

variable "DEST_CIDR" {
  type = string
  default = "0.0.0.0/0"
}
variable "HTTP" {
  type = number
  default = "80"
}
variable "SSH" {
  type = number
  default = "22"
}


variable "JenkinsPort" {
  type = number
  default = "8080"
}

variable "cloudwatch-profile" {
  type = string
}

variable "jenkins-profile" {
  type = string
}