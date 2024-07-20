variable "iam_user" {
  default = "Sama"
}


# Create S3 Bucket
resource "aws_s3_bucket" "s3-1" {
  bucket = "main-s3-1"

  force_destroy       = true # force destroy even if the bucket not empty
  object_lock_enabled = false

  tags = {
    Name        = "erakiterrafromstatefiles"
    Environment = "terraformChamps"
    Owner       = "Sama"
  }
}

# Enable S3 Bucket Versioning.
resource "aws_s3_bucket_versioning" "version-1" {
  bucket = aws_s3_bucket.s3-1.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create a directory in the S3 bucket
resource "aws_s3_object" "directory" {
  bucket = aws_s3_bucket.s3-1.bucket
  key    = "logs/"
}

# Get IAM user
resource "aws_iam_user" "user" {
  name = "test-user" 
}

# Create policy document for the IAM user to allow upload only under logs/
data "aws_iam_policy_document" "upload_object_user" {
  statement {
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.s3-1.arn}/logs/*"]
    principals {
      type        = "AWS"
      identifiers = ["data.aws_iam_user.user.arn"]
    }
  }
}
