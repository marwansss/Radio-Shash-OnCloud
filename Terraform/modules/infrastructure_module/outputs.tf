#output file used to retrive data from module to another...

output "vpc_id" {
    value = aws_vpc.VPC-NTI.id
}


output "private-subnets-id" {
  value = aws_subnet.private-subnets[*].id
}

output "public-subnets-id" {
 value = aws_subnet.public-subnets[*].id
}

