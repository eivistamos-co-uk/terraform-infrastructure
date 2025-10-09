# Serverless Website via Terraform for AWS

## Project Overview 

This is a Terraform rebuild of my ['Serverless Website with CI/CD + IaC on AWS'](https://github.com/eivistamos-co-uk/Serverless-Website-CI-CD-IaC) project. It also uses GitHub Actions for CI/CD. The purpose of this project was for me to gain hands-on experience with Terraform by refactoring my CloudFormation template setup.

## Architecture  

### High-Level Diagram
![Overview Diagram](site/images/terraform-architecture-overview.svg)

This overview shows the core AWS services used, grouped by their role in the solution.

### Detailed Flow Diagram
![Detailed Flow Diagram](site/images/terraform-architecture-detailed.svg)

Covers CI/CD pipeline, Terraform IaC deployed services, and end user path.

## Deployment Instructions  

### Prerequisites

- AWS account with admin access
- Registered domain and hosted zone in Route 53
- ACM Certificate in us-east-1 region
- GitHub Set Up as Identity Provider in AWS

### Steps 

1. In IAM, either create a single policy or separate policies for each service(recommended) to be used in the GitHub Role in the next step:
   - See !WIP! for the policy JSON code to be referenced.
2. In IAM, Create a Role for GitHub:
   - Select entity type as: Web Identity
   - Select Web Identity as: GitHub or githubusercontent.com
   - Select Audience
   - Specify Organisation as your GitHub Account Username e.g. 'eivistamos-co-uk'
   - Add Permission(s) policies created earlier
   - Create Role
3. Clone the Repository and configure the following GitHub Actions Secrets:
   - AWS_ACCOUNT_ID
   - TF_VAR_HOSTED_ZONE_ID
   - TF_VAR_ACM_CERTIFICATE_ARN
4. Review the github\workflows\deploy.yml file and update the ENV variables for your requirements:
   - AWS_REGION
   - IAM_GITHUB_ROLE_NAME
   - TF_VAR_bucket_name
   - TF_VAR_domain_name
   - TF_BACKEND_BUCKET
   - TF_BACKEND_KEY
   - TF_BACKEND_TABLE
5. Update the HTML and CSS files within the site folder to your liking.
6. Add, Commit, and Push code.
7. GitHub Actions will build & deploy the website. 

## Automation Highlights

The project currently uses a single workflow to:
1. Prepare state bucket(S3) and database(dynamoDB). These resources are only created if they don't exist.
2. Run terraform commands. This also initialises terraform so that the backend is AWS cloud based and not local. The CloudFront Distribution ID is also captured so an invalidation could be created in the next step.
3. Sync site content. Also creates an invalidation to force refresh site content.

## Key Learnings / Challenges

- The HCL language used with Terraform. 
- The file structure for Terraform.
- Terraform state files and locking.
- CI/CD process for Terraform

## Next Steps

- Implementing a visitor counter via API Gateway, Lambda, DynamoDB.
- Adding monitoring and alert tools like CloudWatch and SNS to ensure site is healthy.
