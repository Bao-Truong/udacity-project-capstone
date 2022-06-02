################################## BUILD ################################## 

################################## CREATE INFRA ################################## 

create-ecr:
	aws cloudformation deploy \
              --template-file deployment/cfn/ecr.yml \
              --tags project=capstone \
              --region us-east-2 \
              --stack-name "capstone-ecr"
create-network:
	aws cloudformation deploy \
              --template-file deployment/cfn/networking.yml \
              --tags project=capstone \
              --region us-east-2 \
              --stack-name "capstone-networking"
create-eks-cluster:
	aws cloudformation deploy \
              --template-file deployment/cfn/eks.yml \
              --tags project=capstone \
              --region us-east-2 \
              --stack-name "capstone-eks-cluster"
create-eks-addon:
	aws cloudformation deploy \
              --template-file deployment/cfn/eks-addon.yml \
              --tags project=capstone \
              --region us-east-2 \
              --stack-name "capstone-eks-addon"
create-eks-nodegroup:
	aws cloudformation deploy \
              --template-file deployment/cfn/eks-nodegroup.yml \
              --tags project=capstone \
              --region us-east-2 \
              --stack-name "capstone-eks-nodegroup"

create-eks: create-eks-cluster create-eks-addon create-eks-nodegroup

create-infra: create-ecr create-network create-eks

connect-eks:
	aws eks --region us-east-2 update-kubeconfig --name capstone-cluster
	
################################## DEPLOY################################## 	