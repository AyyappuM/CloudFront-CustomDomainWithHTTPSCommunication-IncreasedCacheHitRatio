locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
	enabled = true
	default_root_object = "index.html"

	origin {
		domain_name = aws_s3_bucket.example.bucket_regional_domain_name
		origin_access_control_id = aws_cloudfront_origin_access_control.default.id
		origin_id = local.s3_origin_id
	}

	viewer_certificate {
    	cloudfront_default_certificate = true
  	}

  restrictions {
    geo_restriction {
      	restriction_type = "whitelist"
      	locations = ["IN"]
    }
  }

  default_cache_behavior {
  	allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
  	viewer_protocol_policy = "https-only"

  	forwarded_values {
    	query_string = false

    	cookies {
      	forward = "none"
    	}
  	}
  }  
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "example"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
