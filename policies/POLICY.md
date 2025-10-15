# POLICY.md

## IAM Policy for Serverless Terraform Website

This project uses a GitHub Actions workflow to deploy AWS resources through Terraform.
For this to work, you must first create an IAM role and attach a policy that grants the workflow enough permissions to manage the required resources.

---

## Wildcards vs Least Privilege

To simplify deployment, the included policy uses **wildcards** (`"Resource": "*"`) or generic service ARNs in some places.  
This is necessary because many ARNs are only created at deployment time (for example, new Lambda functions or CloudFront distributions).  

**Drawback:** Wildcards are overly permissive and grant access beyond the intended scope.

**Recommendation for least privilege:**
1. Deploy the stack once with wildcards.  
2. Collect the actual ARNs of created resources. 
3. Update the policy to replace `"*"` with specific ARNs.  
4. Keep IAM permissions scoped only to what the workflow truly needs.

---

## The Policy
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"sts:GetCallerIdentity"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"cloudfront:CreateOriginAccessControl",
				"cloudfront:ListTagsForResource",
				"cloudfront:TagResource",				
                "cloudfront:CreateInvalidation",
                "cloudfront:GetOriginAccessControl",
				"cloudfront:CreateDistribution",
				"cloudfront:GetDistribution"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"dynamodb:CreateTable",
				"dynamodb:DescribeTable",
				"dynamodb:PutItem",
				"dynamodb:GetItem",
				"DynamoDB:DeleteItem"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"kms:CreateGrant",
				"kms:DescribeKey"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"route53:GetChange",
                "route53:ChangeResourceRecordSets",
				"route53:GetHostedZone",
				"route53:ListResourceRecordSets"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:GetBucketAcl",
				"s3:GetBucketCORS",
				"s3:GetBucketPolicy",            
				"s3:CreateBucket",
				"s3:GetAccelerateConfiguration",
				"s3:GetBucketLogging",
				"s3:GetBucketObjectLockConfiguration",
				"s3:GetBucketPublicAccessBlock",
				"s3:GetBucketRequestPayment",
				"s3:GetBucketTagging",
				"s3:GetBucketVersioning",
				"s3:GetBucketWebsite",
				"s3:GetEncryptionConfiguration",
				"s3:GetLifecycleConfiguration",
				"s3:GetReplicationConfiguration",
				"s3:PutBucketPolicy",
				"s3:PutBucketPublicAccessBlock",
				"s3:PutBucketVersioning",
				"s3:ListBucket",
				"s3:PutObject",
				"s3:GetBucketLocation",
				"s3:GetObject",
				"s3:DeleteObject"
			],
			"Resource": "*"
		}
	]
}
```