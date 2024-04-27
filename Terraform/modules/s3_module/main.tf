#Creating the S3 bucket
resource "aws_s3_bucket" "S3logs_storage" {
  bucket = var.storage_name
  force_destroy = true


  tags = {
    Name        = var.storage_name
  }
}

#push the AI model to the s3 to be retrieve when building docker image
resource "aws_s3_object" "Store_AI_Model" {
  key                    = "model_2 (3).h5"
  bucket                 = aws_s3_bucket.S3logs_storage.id
  source                 = "model_2 (3).h5"
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