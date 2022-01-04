# serverless-webapp
This is a terraform and python repo that contains the AWS resources and the backend for the web app.
![image](https://user-images.githubusercontent.com/65294673/147787618-aedd3448-cde0-4425-acd4-0dc5fb9d1325.png)

### AWS Services used

* ACM
* API Gateway
* CloudFront
* Cognito
* Lambda
* Route53
* S3
* WAF
* XRay

## Implementation 
 
**Backend**: For the backend implementation, I have created 4 POST and 5 GET API endpoints. Each API endpoint was routed to its own lambda. The lambda was implemented using Python. The shared python code was published using Lambda layers. 

**Data**: The data was persisted on an existing RDS. Mysql tables and views were created. 

**Identity and RBAC**: system was implemented using Cognito, DynamoDB and Lambda Authorizer. Roles and Permissions were stored in the DynamoDB tables. SSO was added using Cognito Federated IdP.

**Frontend**: The frontend was hosted using AWS S3 with CloudFront infront of S3. The frontend was implemented by a colleague. It was written in React.JS.

**Testing**: I have implemented an API testing module using pytests that tests all endpoints with sample data. 

**Security**: The security was handled using WAF for CloudFront and Lambda Authorizer for API GW.

**CICD**: This solution was deployed to three environments (dev, stage and prod) in their own AWS accounts. The pipelines were created using Github Actions. The CI pipeline would deploy the feature branch to dev env. On merge to master branch in git, the CD pipeline will deploy the solution to stage first, and then prod.

#### Tools used 
- Terraform (IaC)
- Github Actions (CICD)
- Python (Backend implementation)
- Pytest (API testing)

## Deployment

Run `make deploy`
