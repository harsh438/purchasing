#!/bin/bash

export VERSION_LABEL=`git rev-parse --short HEAD`
export LAST_TAG=`git rev-list --tags="$CIRCLE_BRANCH*" --max-count=1`


echo "Git Config"
git config --global user.email "admin@surfdome.io"
git config --global user.name "sddeploy"

echo "Add git tags"
git tag "$CIRCLE_BRANCH-$VERSION_LABEL"

echo "Git push tags"
git push --tags

echo "Create Git binary"
export GIT_BINARY=`git log --pretty=format:'%h - %s' --abbrev-commit --no-merges --date=relative "$LAST_TAG".."$VERSION_LABEL"`

echo "Create the release"
github-release release --user surfdome --repo surfdome_store -d "$GIT_BINARY" --tag "$CIRCLE_BRANCH-$VERSION_LABEL" --name "$CIRCLE_BRANCH-$VERSION_LABEL"

echo "Upload the binary"
github-release upload --user surfdome --repo surfdome_store --tag "$CIRCLE_BRANCH-$VERSION_LABEL" --name "$CIRCLE_BRANCH-$VERSION_LABEL" -f deploy.sh


echo "Run docker pull"
docker pull 213273172953.dkr.ecr.eu-west-1.amazonaws.com/purchasing:latest
echo "Run docker build"
docker build -f Dockerfile -t 213273172953.dkr.ecr.eu-west-1.amazonaws.com/purchasing:latest .
echo "Run docker push"
docker push 213273172953.dkr.ecr.eu-west-1.amazonaws.com/purchasing:latest
echo "Run docker tag"
docker tag 213273172953.dkr.ecr.eu-west-1.amazonaws.com/purchasing:latest 213273172953.dkr.ecr.eu-west-1.amazonaws.com/purchasing:$VERSION_LABEL
echo "Run docker push with the new tag"
docker push 213273172953.dkr.ecr.eu-west-1.amazonaws.com/purchasing:$VERSION_LABEL
sed -i -e "s/__TAG__/$VERSION_LABEL/g" ../eb-purchasing.json

# ElasticBeanstalk Delete Application Version for each Region
echo "ElasticBeanstalk Delete Application Version"
aws elasticbeanstalk delete-application-version --application-name "$EB_APP_NAME" --version-label `git rev-parse --short HEAD` --delete-source-bundle

# Copy the eb-purchasing.json to the S3 Deployment Bucket for each Region
echo "Copy the eb-purchasing.json to the S3 Deployment Bucket"
aws s3 cp ../eb-purchasing.json "s3://$S3_DEPLOYMENT_BUCKET/$CIRCLE_PROJECT_REPONAME/$CIRCLE_PROJECT_REPONAME-$CIRCLE_SHA1.json"

# ElasticBeanstalk Create Application Version
echo "ElasticBeanstalk Create Application Version"
aws elasticbeanstalk create-application-version --application-name "$EB_APP_NAME" --version-label `git rev-parse --short HEAD` --description "`git log -1 --pretty=%B`" --source-bundle S3Bucket="$S3_DEPLOYMENT_BUCKET",S3Key="$CIRCLE_PROJECT_REPONAME/$CIRCLE_PROJECT_REPONAME-$CIRCLE_SHA1.json"


echo -n "Waiting for $EB_APP_NAME-$CIRCLE_BRANCH to be Ready "
STATUS=`aws elasticbeanstalk describe-environment-health --environment-name "$EB_ENV_NAME-euw1-$CIRCLE_BRANCH" --attribute-names All | sed  -n '/"Status":/p'`
while [[ !($STATUS =~ 'Status": "Ready",') ]]; do
  sleep 10
  STATUS=`aws elasticbeanstalk describe-environment-health --environment-name "$EB_ENV_NAME-euw1-$CIRCLE_BRANCH" --attribute-names All | sed  -n '/"Status":/p'`
  echo -n '.'
done
echo '[ OK ]'

echo "ElasticBeanstalk Update Enviroment"
aws elasticbeanstalk update-environment --region=eu-west-1 --environment-name "$EB_ENV_NAME-euw1-$CIRCLE_BRANCH" --version-label `git rev-parse --short HEAD`
