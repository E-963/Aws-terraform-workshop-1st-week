Use S3 to store Terraform statefile using "erakiterrafromstatefiles" bucket

* Create S3 Bucket.
* Enable S3 Bucker Versioning.
* Disable ACL and ensure object ownership have "BucketOwnerEnforced"
* Create a directory under the S3 Bucket called "logs"
* Provide Bucket policy permission for your IAM user to upload object only under logs.
* Force destroy Bucket even if the bucket is not empty.

Requirement Specifications:

* Resources must be created at us-east-1 region otherwise will fail.
* Resources must have tags as below otherwise will fail
* Key: "Environment" Value: "terraformChamps"
* Key: "Owner" Value: "<type_your_name_here>"
* Prefer to use variables.
