#--------------------------------------------------------------
# for skaffold 
#--------------------------------------------------------------
AWS_REGION=ap-northeast-1

.PHONY: push-ecr
push-ecr:
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
	skaffold build --default-repo ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

.PHONY: create-base
create-base:
	skaffold run -p namespace
	skaffold run -p local-infra
	skaffold run -p dev-app

delete-base:
	skaffold delete -p dev-app
	skaffold delete -p local-infra
	skaffold delete -p namespace
