#!/bin/bash

export VERSION_LABEL=`git rev-parse --short HEAD`
export LAST_TAG=`git rev-list --tags="$CIRCLE_BRANCH*" --max-count=1`


echo "Git Config"
git config --global user.email "harshit.shah@surfdome.com"
git config --global user.name "hsdeploy"

echo "Add git tags"
git tag "$CIRCLE_BRANCH-$VERSION_LABEL"

echo "Git push tags"
git push --tags

echo "Create Git binary"
export GIT_BINARY=`git log --pretty=format:'%h - %s' --abbrev-commit --no-merges --date=relative "$LAST_TAG".."$VERSION_LABEL"`

echo "Create the release"
github-release release --user surfdome --repo purchasing -d "$GIT_BINARY" --tag "$CIRCLE_BRANCH-$VERSION_LABEL" --name "$CIRCLE_BRANCH-$VERSION_LABEL"

echo "Upload the binary"
github-release upload --user surfdome --repo purchasing --tag "$CIRCLE_BRANCH-$VERSION_LABEL" --name "$CIRCLE_BRANCH-$VERSION_LABEL" -f deploy.sh

echo "Remove old Bundle"
rm -rf ./vendor/bundle

echo "Run docker pull"
docker pull 213273172953.dkr.ecr.us-east-1.amazonaws.com/cfn-demo1:latest
echo "Run docker build"
docker build -f Dockerfile-deploy -t 213273172953.dkr.ecr.us-east-1.amazonaws.com/cfn-demo1:latest .
echo "Run docker push"
docker push 213273172953.dkr.ecr.us-east-1.amazonaws.com/cfn-demo1:latest
echo "Run docker tag"
docker tag 213273172953.dkr.ecr.us-east-1.amazonaws.com/cfn-demo1:latest 213273172953.dkr.ecr.us-east-1.amazonaws.com/purchasing:$CIRCLE_BRANCH-$VERSION_LABEL
echo "Run docker push with the new tag"
docker push 213273172953.dkr.ecr.us-east-1.amazonaws.com/purchasing:$CIRCLE_BRANCH-$VERSION_LABEL
sed -i -e "s/__TAG__/$CIRCLE_BRANCH-$VERSION_LABEL/g" ../eb-purchasing.json
