# CloudFront-CustomDomainWithHTTPSCommunication-IncreasedCacheHitRatio
CloudFront-CustomDomainWithHTTPSCommunication-IncreasedCacheHitRatio

```
terraform apply --auto-approve -var="account_number=..."
```

Running the command above will do the following:

An S3 bucket will be created and objects (an index.html and an image) are added into it. The objects can't be accessed directly from S3. If you load the Object URL of the image in a browser, you would get an `Access denied` error. A CloudFront distribution will be created with the S3 bucket as origin. Content from the S3 bucket will be loaded only through CloudFront. You can access the content by loading the CloudFront URL `https://randonStringHere.cloudfront.net`.