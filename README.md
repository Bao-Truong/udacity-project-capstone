[![CircleCI](https://circleci.com/gh/Bao-Truong/udacity-project-capstone/tree/main.svg?style=svg)](https://circleci.com/gh/Bao-Truong/udacity-project-capstone/tree/main)
## Give your Application Auto-Deploy Superpowers

In this project, you will prove your mastery of the following learning objectives:

- Explain the fundamentals and benefits of CI/CD to achieve, build, and deploy automation for cloud-based software products.
- Utilize Deployment Strategies to design and build CI/CD pipelines that support Continuous Delivery processes.
- Utilize a configuration management tool to accomplish deployment to cloud-based servers.
- Surface critical server errors for diagnosis using centralized structured logging.

![Diagram of CI/CD Pipeline we will be building.](udapeople.png)

### Instructions

* [Getting Started](instructions/1-getting-started.md)
* [Deploying Working, Trustworthy Software](instructions/2-deploying-trustworthy-code.md)
* [Configuration Management](instructions/3-configuration-management.md)



### Built With

- [Circle CI](www.circleci.com) - Cloud-based CI/CD service
- [Amazon AWS](https://aws.amazon.com/) - Cloud services
- [AWS CLI](https://aws.amazon.com/cli/) - Command-line tool for AWS
- [CloudFormation](https://aws.amazon.com/cloudformation/) - Infrastrcuture as code
- [Kubernetes](https://kubernetes.io/) - Container Orchestation

## Setup CircleCI 
**[Important]** Go to AWS Console, Create a Free tier Postgresql RDS(latest version) running on T3.micro, Recommend to run on public access for testing, change to private connect after you sure it is working correctly.

Required Evironment Variables:
```bash
- AWS_ACCESS_KEY_ID="Your IAM Access Key"
- AWS_SECRET_ACCESS_KEY="Your IAM Secret Access Key"
- AWS_DEFAULT_REGION="us-east-2"
- TYPEORM_CONNECTION="postgres"
- TYPEORM_ENTITIES="./src/modules/domain/**/*.entity.ts"
- TYPEORM_HOST="PostgresSQL Endpoint you manually created"
- TYPEORM_PORT="5432"
- TYPEORM_USERNAME="postgres"(default)
- TYPEORM_PASSWORD="mypassword"
- TYPEORM_DATABASE="postgres" (default)
- TYPEORM_MIGRATIONS="./src/migrations/*.ts"
- TYPEORM_MIGRATIONS_DIR="./src/migrations"
```

## Install
Manually change these setting below:
1. deployment/k8s/deployment.yml: change the image URI for frontend and backend in line 25, 55. For example:

```yml
- image: <AWS AcccountID>.dkr.ecr.us-east-2.amazonaws.com/capstone-ecr-frontend:FRONTEND_IMAGE_VERSION
- image: <AWS AcccountID>.dkr.ecr.us-east-2.amazonaws.com/capstone-ecr-backend:BACKEND_IMAGE_VERSION
```
2. deployment/cfn/ecr/yml: change the AWSAccountID Parameters
3. deployment/cfn/eks-nodegroup.yml: change the NodeRole ARN, Create if not existed
4. deployment/cfn/eks.yml: Config the EKS cluster version (default 1.21) and change the RoleArn ARN, Create if not existed


Create ECR:
> `make create-ecr` 

Create Networking:
>`make create-network`

Create EKS Cluster: (take sometime to create, resource include: 1 EKS Cluster, 1 NodeGroup, 2 Addon)
>`make create-eks`

Connect to EKS cluster:
>`make connect-eks`

Run Circleci Pipeline:
> When ever you commit code it will trigger the circleci pipeline, the pipeline will run the ci/cd process includes: installing dependencies, testing, linting, build sourcecode, building and uploading the docker images into ECR registry and apply the deployment.yml and service.yml onto the EKS cluster.

## Get K8s Service endpoint:

Connect to the EKS if not already:
>`make connect-eks` 

or

>`aws eks --region <your region> update-kubeconfig --name <EKS cluster name>`

Get service info, you will see a lot of service created in the EKS cluster, pay attention to the **capstone-frontend** and **capstone-backend** service, look fot the **External-IP** of the capstone-frontend, paste it on the brower, Command: 
>`kubectl get service`

## Cleanup
Remove the service and delopment on EKS cluster:
```bash
make connect-eks
kubectl delete -f deployment/k8s/deployment.yml
kubectl delete -f deployment/k8s/service.yml
```
Remove ALB and Target Group:
> Login to AWS Console and deleted the related resources (have 'capstone' in its name)

Remove the Cloudformation Stacks:
```bash
aws cloudformation delete-stack --region us-east-2 --stack-name capstone-eks-nodegroup 
aws cloudformation delete-stack --region us-east-2 --stack-name capstone-eks-addon
aws cloudformation delete-stack --region us-east-2 --stack-name capstone-eks-cluster
aws cloudformation delete-stack --region us-east-2 --stack-name capstone-ecr-backend
aws cloudformation delete-stack --region us-east-2 --stack-name capstone-ecr-frontend
aws cloudformation delete-stack --region us-east-2 --stack-name capstone-networking
```

## Code Structure
Folders:
```
├── backend:      backend sourcecode
├── deployment:   store deployment stage required files (k8s, cfn)
├── dockerfiles:  store dockerfile to build docker images
├── frontend:     frontend sourcecode
└── instructions: instructions for better understanding
```

### License

[License](LICENSE.md)
