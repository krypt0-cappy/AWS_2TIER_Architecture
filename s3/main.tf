###---S3/MAIN.TF---###


######################################
# CREATE S3 BUCKET AND ACLS/POLICIES #
######################################

resource "aws_s3_bucket" "main-bucket" {
  bucket = "coalfire-challenge-bucket"
}


resource "aws_s3_bucket_ownership_controls" "bucket-ownership" {
  bucket = aws_s3_bucket.main-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "main-bucket-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket-ownership]
  bucket     = aws_s3_bucket.main-bucket.id
  acl        = "private"
}


resource "aws_s3_object" "Images" {
  bucket = aws_s3_bucket.main-bucket.id
  key    = "Images/"
}


resource "aws_s3_object" "Logs" {
  bucket = aws_s3_bucket.main-bucket.id
  key    = "Logs/"
}


resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_config" {
  rule {
    id     = "move_to_glacier"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    filter {
      prefix = "Images/"
    }
  }

  rule {
    id     = "delete_logs"
    status = "Enabled"

    expiration {
      days = 90
    }

    filter {
      prefix = "Logs/"
    }
  }

  bucket = aws_s3_bucket.main-bucket.id
}