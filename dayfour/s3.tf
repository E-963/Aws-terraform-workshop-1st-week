resource "aws_s3_bucket" "s3-1" {
  bucket = "main-s3-1"

  force_destroy       = true    # force destroy even if the bucket not empty
  object_lock_enabled = false


  tags = {
    Name           = "erakiterrafromstatefiles"
    key            = "terraform.tfstate" 
    Environment    = "terraformChamps"
  }
}