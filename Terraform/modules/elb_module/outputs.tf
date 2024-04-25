output "internet-lb" {
  value = aws_lb.proxy-lb.dns_name
}

output "internal-lb" {
  value = aws_lb.worker-lb.dns_name
}