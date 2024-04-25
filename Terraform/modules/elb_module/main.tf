#Create public TargetGroup
resource "aws_lb_target_group" "proxy-tg" {
  name     = "proxy-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  load_balancing_algorithm_type = "round_robin"
  target_type = "instance"
  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  } 

}

#attaching ec2 to proxy-tg target group
resource "aws_lb_target_group_attachment" "proxy_attach" {
  count = length(var.proxy-server-id)
  target_group_arn = aws_lb_target_group.proxy-tg.arn
  target_id        = var.proxy-server-id[count.index]
  port             = 80
}



#Create public Load-Balancer
resource "aws_lb" "proxy-lb" {
  name               = "proxy-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  #specify your subnets to attach them to load-balancer
  subnets            =  var.proxy-lb-subnets
}

#Add LB listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.proxy-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proxy-tg.arn
  }
  
}


#SecurityGroups & Policies for public and private Load-Balancer
resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "Allow http inbound and outbound traffic "
  vpc_id      = var.vpc_id

  tags = {
    Name = "LB_SG"
  }
}
#Allow http ingress rule for public lb from any dest
resource "aws_vpc_security_group_ingress_rule" "lb-allow_http_ipv4" {
  security_group_id = aws_security_group.lb-sg.id
  cidr_ipv4         = var.DEST_CIDR
  from_port         = var.HTTP
  ip_protocol       = "tcp"
  to_port           = var.HTTP
}


#Allow http egress rule for public lb from any dest
resource "aws_vpc_security_group_egress_rule" "lb-allow_http" {
  security_group_id = aws_security_group.lb-sg.id
  cidr_ipv4         = var.DEST_CIDR
  from_port         = var.HTTP
  ip_protocol       = "tcp"
  to_port           = var.HTTP
}

#Allow port 300007 egress rule for private lb from WorkerNode subnets dest
resource "aws_vpc_security_group_egress_rule" "lb-allow_30007_ipv4" {
  security_group_id = aws_security_group.lb-sg.id
  cidr_ipv4         = var.LB_DEST_CIDR
  from_port         = 30007
  ip_protocol       = "tcp"
  to_port           = 30007
}


#--------------------------------------------------------------------------

#Create private TargetGroup for workernode-servers
resource "aws_lb_target_group" "worker-tg" {
  name     = "workernode-tg"
  port     = 30007
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  load_balancing_algorithm_type = "round_robin"
  target_type = "instance"
  health_check {
    path                = "/"
    port                = 30007
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  } 

}

#attaching ec2 to worker-tg target group
resource "aws_lb_target_group_attachment" "k8s_worker_attach" {
  count = length(var.k8s-workers-id)
  target_group_arn = aws_lb_target_group.worker-tg.arn
  target_id        = var.k8s-workers-id[count.index]
  port             = 30007
}



#Create private Load-Balancer
resource "aws_lb" "worker-lb" {
  name               = "worker-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  #specify your subnets to attach them to load-balancer
  subnets            =  var.k8s-worker-lb-subnets
  access_logs {
    bucket  = var.s3-name_bucket
    enabled = true
  }
}

#Add LB listener
resource "aws_lb_listener" "private-http" {
  load_balancer_arn = aws_lb.worker-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.worker-tg.arn
  }
  
}


 resource "local_file" "internal_lb_dns" {
    content = aws_lb.worker-lb.dns_name
    filename = "/home/maro/Desktop/Radio-Shash-OnCloud/Ansible/jenkins_conf/inventory"
 }


