#Creating the S3 bucket
resource "aws_s3_bucket" "S3logs_storage" {
  bucket = var.storage_name
  force_destroy = true


  tags = {
    Name        = var.storage_name
  }
}

#adding s3 policy to store lb access logs
resource "aws_s3_bucket_policy" "lb_logs_policy" {
  bucket = aws_s3_bucket.S3logs_storage.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.elb_account_id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.S3logs_storage.bucket}/AWSLogs/${var.aws_account_id}/*"
    }
  ]
}
POLICY
}