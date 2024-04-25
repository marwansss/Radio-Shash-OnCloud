output "ec2-profile" {
    value = aws_iam_instance_profile.ec2-cloudagent-profile.name
}

output "jenkins-profile" {
  value = aws_iam_instance_profile.jenkins-profile.name
}

