resource "aws_s3_bucket" "example" {
  bucket = "sample-bucket-${var.account_number}"
}

resource "aws_s3_object" "indexPage" {
  depends_on = [aws_s3_bucket.example]

  bucket = "sample-bucket-${var.account_number}"
  key    = "index.html"
  source = "../files/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "image" {
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
  block_public_policy     = true # Bucket policy can't be added if this is true
  restrict_public_buckets = true # Object can't be publicly accessed, as defined by the bucket policy below, if this is true
}

resource "aws_s3_bucket_policy" "example" {
    bucket = aws_s3_bucket.example.id
    policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        "Sid": "AllowCloudFrontServicePrincipal",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::sample-bucket-767398097783/*",
        "Condition": {
            "StringEquals": {
            "AWS:SourceArn": aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      },
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.example]
}