module "infrastructure_module" {
  source = "./modules/infrastructure_module"
  private_subnets = var.my_private_subnets
  public_subnets = var.my_public_subnets
}

module "ec2_module" {
  source = "./modules/ec2_module"
  #you can customize any attribute value below
  vpc-id = module.infrastructure_module.vpc_id
  public_subnets_ids = module.infrastructure_module.public-subnets-id
  private_subnets_ids = module.infrastructure_module.private-subnets-id
  cloudwatch-profile = module.iamrole_module.ec2-profile
  jenkins-profile = module.iamrole_module.jenkins-profile
}
module "s3_module" {
  source = "./modules/s3_module"
  storage_name = var.mys3_name
  elb_account_id = var.elb_account_id
  aws_account_id = var.aws_account_id
}

module "iamrole_module" {
  source = "./modules/iamrole_module"
}

module "rds_module" {
  source = "./modules/rds_module"
}

module "cloudwatch_module" {
  source = "./modules/cloudwatch_module"
  master_id = module.ec2_module.k8s-master-id
  workers_id = module.ec2_module.k8s-worker-id
}

module "backup_module" {
  source = "./modules/backup_module"
  jenkins_arn = module.ec2_module.jenkins_arn
}

module "elb_module" {
  source = "./modules/elb_module"
  # proxy-server-id = module.ec2_module.proxy-id
  k8s-workers-id =  module.ec2_module.k8s-worker-id
  proxy-lb-subnets = module.infrastructure_module.public-subnets-id
  vpc_id = module.infrastructure_module.vpc_id
  k8s-worker-lb-subnets =  module.infrastructure_module.public-subnets-id
  s3-name_bucket = module.s3_module.s3_storage
}
module "ecr_module" {
  source = "./modules/ecr_module"
}

# output "internet-loadbalancer" {
#   value = module.elb_module.internet-lb
# }

output "internal-loadbalancer" {
  value = module.elb_module.internal-lb
}

output "jenkins_ip" {
  value = module.ec2_module.jenkins_ip
}

output "ecr_url" {
  value = module.ecr_module.ecr_url
}

output "k8s-worker-ip" {
  value = module.ec2_module.k8s-worker-ip
}

output "k8s-master-ip" {
  value = module.ec2_module.k8s-master-ip
}

