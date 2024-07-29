resource "aws_s3_bucket" "Sample-S3-Bucket" {
  bucket = "sample-bucket-${var.account_number}"
}

resource "aws_s3_object" "sample_s3_object" {
  depends_on = [aws_s3_bucket.Sample-S3-Bucket]

  bucket = "sample-bucket-${var.account_number}"
  key    = "MickeyMouse.jpg"
  source = "../files/MickeyMouse.jpg"
}

resource "aws_s3_bucket_ownership_controls" "Sample-S3-Bucket-Ownership-Control" {
  bucket = aws_s3_bucket.Sample-S3-Bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "Sample-S3-Bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.Sample-S3-Bucket-Ownership-Control]

  bucket = aws_s3_bucket.Sample-S3-Bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.Sample-S3-Bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}