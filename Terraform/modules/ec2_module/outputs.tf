output "proxy-id" {
  value = aws_instance.proxy-servers[*].id
}

output "k8s-worker-id" {
  value = aws_instance.K8s_worker[*].private_ip
}

output "k8s-worker-ip" {
  value = aws_instance.K8s_worker[*].private_ip
}


output "k8s-master-ip" {
  value = aws_instance.K8s_master.private_ip
}

output "jenkins_ip" {
  value = aws_instance.proxy-servers[1].public_ip
}


output "jenkins_arn" {
   value = aws_instance.proxy-servers[1].arn
}