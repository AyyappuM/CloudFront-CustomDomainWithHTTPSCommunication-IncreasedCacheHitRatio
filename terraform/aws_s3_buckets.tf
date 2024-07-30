resource "aws_s3_bucket" "example" {
  bucket = "sample-bucket-${var.account_number}"
}

resource "aws_s3_object" "sample_s3_object" {
  depends_on = [aws_s3_bucket.example]

  bucket = "sample-bucket-${var.account_number}"
  key    = "MickeyMouse.jpg"
  source = "../files/MickeyMouse.jpg"
  content_type = "image/jpeg" # The metadata will have content-type = application/octet-stream otherwise. The image/jpeg content-type is required to view the image in browser
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true  
  ignore_public_acls      = true
  block_public_policy     = false # Bucket policy can't be added without this
  restrict_public_buckets = false # Object can't be publicly accessed, as defined by the bucket policy below, without this
}

resource "aws_s3_bucket_policy" "example" {
    bucket = aws_s3_bucket.example.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::sample-bucket-${var.account_number}",
          "arn:aws:s3:::sample-bucket-${var.account_number}/MickeyMouse.jpg"
        ]
      },
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.example]
}