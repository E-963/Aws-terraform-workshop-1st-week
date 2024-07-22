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

# Enable S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "ver_01" {
  bucket = aws_s3_bucket.s3-1.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Get IAM user
resource "aws_iam_user" "Iam-1" {
  name = "test-user" 
}

# Create bucket policy by mentioning the policy below (assuming upload_object_to_logs.json is configured correctly)
resource "aws_s3_bucket_policy" "Policy-s3-1"  {
  bucket = aws_s3_bucket.s3-1.id
  policy = data.aws_iam_policy_document.upload_object_to_logs.json
}

# Create policy document for the IAM user to allow upload only under logs/
data "aws_iam_policy_document" "upload_object_to_logs"{
  statement {
    principals {
      type        = "AWS"
       identifiers = [aws_iam_user.Iam-1.arn]  # Use the actual user ARN
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3-1.arn,
      "${aws_s3_bucket.s3-1.arn}/logs/*",
    ]
  }
}

# Create S3 Object (i.e directories)
resource "aws_s3_object" "dir-1" {
  bucket = aws_s3_bucket.s3-1.id
  key = "logs/"
  content_type = "application/x-directory"
}
