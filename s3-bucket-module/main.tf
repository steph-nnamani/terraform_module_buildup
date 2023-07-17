module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket"
  #acl    = "private"
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  # Allow deletion of non-empty bucket
  force_destroy = true

  versioning = {
    enabled = true
  }
}