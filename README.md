# CloudFront-CustomDomainWithHTTPSCommunication-IncreasedCacheHitRatio
## v1

```
terraform apply --auto-approve -var="account_number=..."
```

Running the command above will do the following:

An S3 bucket will be created and objects (an index.html and an image) are added into it. The objects can't be accessed directly from S3. If you load the Object URL of the image in a browser, you would get an `Access denied` error. A CloudFront distribution will be created with the S3 bucket as origin. Content from the S3 bucket will be loaded only through CloudFront. You can access the content by loading the CloudFront URL `https://randomString.cloudfront.net`.

We can change the `viewer_control_policy` setting for the cache behaviors to require HTTPS communication. As we're using the domain name assigned by CloudFront i.e., `randomString.cloudfront.net`, the SSL/TLS certificate will be provided by the CloudFront.

```
default_cache_behavior {
	allowed_methods  = ["GET", "HEAD", "OPTIONS"]
	cached_methods   = ["GET", "HEAD"]
	target_origin_id = local.s3_origin_id
	viewer_protocol_policy = "https-only" --> This will make cache behaviour require HTTPS

	forwarded_values {
		query_string = false

		cookies {
			forward = "none"
		}
	}
}
```
