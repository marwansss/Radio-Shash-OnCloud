# Getting ec2 OS image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]  
  }
  filter {
  name   = "virtualization-type"
  values = ["hvm"]  
}
  filter {
  name   = "architecture"
  values = ["x86_64"]  
}
  owners = ["099720109477"]
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------
#creating security groups for web servers
resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow necessary  traffic for webservers "
  vpc_id      = var.vpc-id # getting vpc-id value from the output resource declared in infrastructure module
  tags = {
    Name = "web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = var.DEST_CIDR
  from_port         = var.SSH
  ip_protocol       = "tcp"
  to_port           = var.SSH
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = var.DEST_CIDR
  from_port         = var.HTTP
  ip_protocol       = "tcp"
  to_port           = var.HTTP
}

resource "aws_vpc_security_group_ingress_rule" "allow_JenkinsPort" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = var.DEST_CIDR
  from_port         = var.JenkinsPort
  ip_protocol       = "tcp"
  to_port           = var.JenkinsPort
}

resource "aws_vpc_security_group_ingress_rule" "allow_ping_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = var.DEST_CIDR
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = var.DEST_CIDR
  ip_protocol       = "-1" 
}

#-----------------------------------------------------------------------------------------------

#create sg for K8S Nodes
resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  description = "Allow necessary  traffic for MasterNode "
  vpc_id      = var.vpc-id # getting vpc-id value from the output resource declared in infrastructure module
  tags = {
    Name = "k8s-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = var.DEST_CIDR
  from_port         = var.SSH
  ip_protocol       = "tcp"
  to_port           = var.SSH

}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = var.DEST_CIDR
  from_port         = var.HTTP
  ip_protocol       = "tcp"
  to_port           = var.HTTP
}

resource "aws_vpc_security_group_ingress_rule" "allow_K8s_API" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 6443
  ip_protocol       = "tcp"
  to_port           = 6443
}


resource "aws_vpc_security_group_ingress_rule" "kubelet" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 10250
  ip_protocol       = "tcp"
  to_port           = 10255
}


resource "aws_vpc_security_group_ingress_rule" "allow_K8s_NodePortService" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 30000
  ip_protocol       = "tcp"
  to_port           = 32767
}



resource "aws_vpc_security_group_ingress_rule" "allow_ping" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = var.DEST_CIDR
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = var.DEST_CIDR
  ip_protocol       = "-1" 
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------

# Creating K8s-WorkerNodes in private subnets
resource "aws_instance" "K8s_worker" {
  count = length(var.private_subnets_ids)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.large"
  subnet_id     = var.private_subnets_ids[count.index]
  key_name = "nti-aws"
   user_data              = <<-EOF
    #!/bin/bash
    sudo apt update -y
    hostnamectl set-hostname worker${count.index} 
    echo '123' | sudo passwd --stdin ubuntu

  EOF 
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  tags = {
    Name = "worker${count.index}"
  }
   # Define the root volume size
  root_block_device {
    volume_size = 15
  }
  iam_instance_profile = var.cloudwatch-profile
}



# Creating K8s-MasterNode in private subnets
resource "aws_instance" "K8s_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  subnet_id     = var.private_subnets_ids[0] #attach to the first private-subnet
  key_name = "nti-aws"
   user_data              = <<-EOF
    #!/bin/bash
    sudo apt update -y 
    sudo apt install git -y
    hostnamectl set-hostname master
  EOF 
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  tags = {
    Name = "K8s_MasterNode"
  }
  iam_instance_profile = var.cloudwatch-profile
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------

# Creating proxy-servers
#proxy servers will act as ansible and Jenkins masters
resource "aws_instance" "proxy-servers" {
  count = length(var.public_subnets_ids)
  ami           = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type = "t2.micro"
  subnet_id     = var.public_subnets_ids[count.index]
  key_name = "nti-aws"
   user_data              = <<-EOF
    #!/bin/bash
    sudo apt update -y
    hostnamectl set-hostname jenkins_master
    sudo apt install python3-pip git -y
    sudo pip3 install ansible  
    sudo wget http://nginx.org/keys/nginx_signing.key
    sudo apt-key add nginx_signing.key
    echo "deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu/ focal nginx" > /etc/apt/sources.list.d/nginx.list
    sudo apt update -y 
    sudo apt install nginx -y 
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo echo '''
    upstream backend_servers {
      #Add webservers ip here OR internal LoadBalancer DNS Name
      # egs: server 10.0.0.0:80;
      # egs: server internal-apache-lb-303911939.us-east-1.elb.amazonaws.com;
    } 
    # Server block for handling incoming requests
    server {
      listen 80;
      listen [::]:80;
      #Add our proxy server ip here
      server_name localhost;

      location / {
        # Use proxy_pass to forward requests to the backend_servers upstream group
        proxy_pass http://backend_servers;
      }
    }
    ''' > /etc/nginx/conf.d/proxy.conf
    sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.org
  EOF 
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  tags = {
    Name = "proxy-server${count.index}"
  }
  iam_instance_profile = var.jenkins-profile 
}

 resource "local_file" "jenkins_ip" {
    content = aws_instance.proxy-servers[1].public_ip
    filename = "/home/maro/Desktop/Radio-Shash-OnCloud/Ansible/jenkins_conf/inventory"
 }