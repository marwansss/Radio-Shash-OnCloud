#create iam role to allow ec2 instance to consume this role
resource "aws_iam_role" "ec2-cloudagent-role" {
  name = "cloudagent_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})

  tags = {
    tag-key = "ec2-cloudagentrole"
  }
}

#attaching cloudagent policy to allow ec2 instances to commuinicate with cloud-watch service
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment" {
  role       = aws_iam_role.ec2-cloudagent-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_public_full_access_attachment" {
  role       = aws_iam_role.ec2-cloudagent-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess"
}




#make iam role profile to allow roles to be attached to the ec2 instances
resource "aws_iam_instance_profile" "ec2-cloudagent-profile" {
  name = "ec2-iamroles"
  role = aws_iam_role.ec2-cloudagent-role.name
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#create iam role to allow jenkins instance to have full access on ecr registry and can communicate with cloudwatch service
resource "aws_iam_role" "jenkins-role" {
  name = "jenkins-roles"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})

  tags = {
    tag-key = "jenkins-roles"
  }
}


#attaching cloudagent policy to allow ec2 instances to commuinicate with cloud-watch service
resource "aws_iam_role_policy_attachment" "jenkins_cloudwatch_agent_policy_attachment" {
  role       = aws_iam_role.jenkins-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


#attaching ecr full access to allow ec2 instance to push and pull to ecr
resource "aws_iam_role_policy_attachment" "jenkins_ecr_public_full_access_attachment" {
  role       = aws_iam_role.jenkins-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess"
}
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.jenkins-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#make iam profile to be used by jenkins instance
resource "aws_iam_instance_profile" "jenkins-profile" {
  name = "jenkins-iamroles"
  role = aws_iam_role.jenkins-role.name
}
