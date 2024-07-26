resource "aws_s3_bucket" "buc-1" {
  bucket = "main-buc-1"

  force_destroy       = true   # force destroy even if the bucket not empty
  object_lock_enabled = false

  tags = {
    Name        = "bucket"
    Environment = "terraformChamps"
    Owner       = "Sama"
  }
}
# Create outgoing directory
resource "aws_s3_object" "directory_object_buc-1_outgoing" {
  bucket = aws_s3_bucket.buc-1.id
  key = "outgoing/"
  content_type = "application/x-directory"
}

# Create incoming directory
resource "aws_s3_object" "directory_object_buc-1_incoming" {
  bucket = aws_s3_bucket.buc-1.id
  key = "incoming/"
  content_type = "application/x-directory"
}

# Create logs directory
resource "aws_s3_object" "directory_object_buc-1_logs" {
  bucket = aws_s3_bucket.buc-1.id
  key = "logs/"
  content_type = "application/x-directory"
}
resource "aws_s3_bucket_lifecycle_configuration" "bucket-lifecycle-config" {
  bucket = aws_s3_bucket.buc-1.id

 # logs directory rule
  rule {
    id = "log-directory"

    filter {  # filter the bucket based on the path prefix 
        prefix = "logs/"
    }

    transition {  # move the files to infrequent access tier 30 days after creation time
      days = 30
      storage_class = "STANDARD_IA"
    }

    status = "Enabled"

        transition {
     days = 90
      storage_class = "GLACIER"
    }
    
     transition {  # move the files to the deep archive tier 180 days after creation time.
      days = 180
      storage_class = "DEEP_ARCHIVE"
    }

    expiration { # Delete objects a year after creation time.
      days = 365
    }
  }
  

  # outgoing directory rule
  rule {
    id = "outgoing"
       filter {
      tag {          # filter objects based on objects tag & under outgoing directory object
        key = "Name"
        value = "notDeepArchvie"
      }
      and {
        prefix = "outgoing/"
      }
    }
    transition {     # Move to Infrequent access tier 30 days after creation time
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {  # Move to Archive access tier 90 days after creation time
      days = 90
      storage_class = "GLACIER"
    }
    expiration {  # Delete objects a year after creation time.
      days = 365
    }

    # Enable the rule
    status = "Enabled"
  }


 # incoming directory rule 
  rule {
    id = "incoming-directory"

    filter {
        prefix = "incoming/"

        # Filter files it's size is between 1MB to 1G
        object_size_greater_than = 1000000 # in Bytes
        object_size_less_than = 100000000  # in Bytes
    }

    transition {          # Move to Infrequent access tier 30 days after creation time
      days = 30
      storage_class = "STANDARD_IA"
    }
  
    transition {          # Move to Archive access tier 90 days after creation time
      days = 90
      storage_class = "GLACIER"
    }

    # Enable the rule
    status = "Enabled"
  }
}
