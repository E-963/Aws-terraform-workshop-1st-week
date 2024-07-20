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

# Create policy document for the IAM user (assuming you need it)
# Adjust the principals, actions, and resources as needed

resource "aws_s3_bucket_policy" "s3-1-policy" {
  bucket = aws_s3_bucket.s3-1.id
  policy = <<EOF
  {
   "Version":"2012-10-17",
   "Statement":[
     {
       "Sid":"PolicyForAllowUploadWithACL",
       "Effect":"Allow",
       "Principal":{"AWS":"111122223333"},
       "Action":"s3:PutObject",
       "Resource":"arn:aws:s3:::DOC-s3-1-BUCKET/*",
       "Condition": {
         "StringEquals": {"s3:x-amz-acl":"bucket-owner-full-control"}
       }
     }
   ]
}
  EOF
}

# Create S3 objects (i.e directories)
resource "aws_s3_object" "directory_object_s3_1_sama" {
  bucket       = aws_s3_bucket.s3-1.id
  key          = "sama/"
  content_type = "application/x-directoy"
}