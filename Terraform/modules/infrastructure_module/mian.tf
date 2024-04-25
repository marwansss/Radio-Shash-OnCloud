#Create VPC
resource "aws_vpc" "VPC-NTI" {
  cidr_block       = var.VPC_CIDR
  tags = {
    Name = "VPC-NTI"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------
#create 2 public subnets
resource "aws_subnet" "public-subnets" {
  count = length(var.public_subnets)    #intialize the counter by  array size ;
  vpc_id     = aws_vpc.VPC-NTI.id
  cidr_block = var.public_subnets[count.index].cidr
  availability_zone = var.public_subnets[count.index].az
  tags = {
    Name = "Public_subnet${count.index}"
  }
  
}


#create 2 private subnets
resource "aws_subnet" "private-subnets" {
  count = length(var.private_subnets)   #intialize the counter by  array size ;
  vpc_id     = aws_vpc.VPC-NTI.id
  cidr_block = var.private_subnets[count.index].cidr
  availability_zone = var.private_subnets[count.index].az
  tags = {
    Name = "private_subnet${count.index}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Create gateways
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VPC-NTI.id

  tags = {
    Name = "nti-GW"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnets[0].id  #attach nat gateway with the public_subnet1
  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.gw]
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Create Routing Tables

#Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.VPC-NTI.id
   tags = {
    Name = "public-rt"
  }
  }


  resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = var.DEST_CIDR
  gateway_id             = aws_internet_gateway.gw.id
}



resource "aws_route_table_association" "public-subnet-ass" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}



#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Private Route Table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.VPC-NTI.id
   tags = {
    Name = "private-rt"
  }
  }


  resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.private-rt.id
  destination_cidr_block = var.DEST_CIDR
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
}


#private-subnets Association
resource "aws_route_table_association" "Private-Subnet-ass" {
  count = length(var.private_subnets)
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-rt.id
}












