#creating backup baults where daily backup snapshot will be stored
resource "aws_backup_vault" "Jenkins_vaults" {
  name        = "Jenkins_vault"
}

#create backup plan to schedule backups daily 
resource "aws_backup_plan" "jenkins_backup_plan" {
  name = "JenkinsBackupPlan"

  rule {
    rule_name         = "JenkinsBackupRole"
    target_vault_name = aws_backup_vault.Jenkins_vaults.name
    schedule          = "cron(0 0 * * ? *)" #Daily at 00:00 UTC 
    lifecycle {
      delete_after = 7
    }
  }
}

#The below example creates an IAM role with the default managed IAM Policy for allowing AWS Backup to create backups.
#data resource to get the data of the default iam role that allow ec2 instance to be backup
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "default_IAMRole" {
  name               = "Default_Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AttachPolicyToRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.default_IAMRole.name
}

resource "aws_backup_selection" "JenkinsBackupSelection" {
  iam_role_arn = aws_iam_role.default_IAMRole.arn
  name         = "JenkinsbackupSelection"
  plan_id      = aws_backup_plan.jenkins_backup_plan.id

  resources = [
    var.jenkins_arn
  ]
}