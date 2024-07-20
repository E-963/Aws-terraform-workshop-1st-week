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

# Enable ACL as private
resource "aws_s3_bucket_acl" "acl-s3-1" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership_s3-1]

  bucket = aws_s3_bucket.s3-1.id
  acl    = "private"


}
# Enable S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "version-1" {
  bucket = aws_s3_bucket.s3-1.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create a directory in the S3 bucket
resource "aws_s3_directory_bucket" "example" {
  bucket = "main-s3-1--use1-az4--x-s3"

  location {
    name = "use1-az4"
  }
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
# Create S3 Object (i.e directories)
resource "aws_s3_object" "directory_object_s3-1_public" {
  bucket = aws_s3_bucket.s3-1.id
  key = "Public/"
  content_type = "application/x-directory"
}