#!/usr/bin/env bash

BEDROCK_TAGS_REMOTE="$1"
VERSION="$2"

if [ -z "$VERSION" ]; then
	echo "You must specify a version."
	exit 0
fi

FIRST_CHAR=$(printf '%s' "$VERSION" | cut -c1)
if [ "$FIRST_CHAR" != "v" ]; then
	echo "Tag must start with v."
	exit 0
fi

git tag "umi-bindings/$VERSION"
git tag "umi-service/$VERSION"
git push $BEDROCK_TAGS_REMOTE "umi-bindings/$VERSION"
git push $BEDROCK_TAGS_REMOTE "umi-service/$VERSION"

cd umi-chain-umi
go get github.com/ethereum-optimism/optimism/umi-bindings@$VERSION
go get github.com/ethereum-optimism/optimism/umi-service@$VERSION
go mod tidy

git add .
git commit -am 'chore: Upgrade umi-chain-umi dependencies'

git tag "umi-chain-umi2/$VERSION"
git push $BEDROCK_TAGS_REMOTE "umi-chain-umi2/$VERSION"

cd ../umi-node
go get github.com/ethereum-optimism/optimism/umi-bindings@$VERSION
go get github.com/ethereum-optimism/optimism/umi-service@$VERSION
go get github.com/ethereum-optimism/optimism/umi-chain-umi@$VERSION
go mod tidy

echo Please update the version to ${VERSION} in umi-node/version/version.go
read -p "Press [Enter] key to continue"

git add .
git commit -am 'chore: Upgrade umi-node dependencies'
git push $BEDROCK_TAGS_REMOTE
git tag "umi-node/$VERSION"
git push $BEDROCK_TAGS_REMOTE "umi-node/$VERSION"

cd ../umi-proposer
go get github.com/ethereum-optimism/optimism/umi-bindings@$VERSION
go get github.com/ethereum-optimism/optimism/umi-service@$VERSION
go get github.com/ethereum-optimism/optimism/umi-node@$VERSION
go mod tidy

echo Please update the version to ${VERSION} in umi-proposer/cmd/main.go
read -p "Press [Enter] key to continue"

git add .
git commit -am 'chore: Upgrade umi-proposer dependencies'
git push $BEDROCK_TAGS_REMOTE
git tag "umi-proposer/$VERSION"
git push $BEDROCK_TAGS_REMOTE "umi-proposer/$VERSION"

cd ../umi-batcher
go get github.com/ethereum-optimism/optimism/umi-bindings@$VERSION
go get github.com/ethereum-optimism/optimism/umi-service@$VERSION
go get github.com/ethereum-optimism/optimism/umi-node@$VERSION
go get github.com/ethereum-optimism/optimism/umi-proposer@$VERSION
go mod tidy

echo Please update the version to ${VERSION} in umi-batcher/cmd/main.go
read -p "Press [Enter] key to continue"

git add .
git commit -am 'chore: Upgrade umi-batcher dependencies'
git push $BEDROCK_TAGS_REMOTE
git tag "umi-batcher/$VERSION"
git push $BEDROCK_TAGS_REMOTE "umi-batcher/$VERSION"

cd ../umi-e2e
go get github.com/ethereum-optimism/optimism/umi-bindings@$VERSION
go get github.com/ethereum-optimism/optimism/umi-service@$VERSION
go get github.com/ethereum-optimism/optimism/umi-node@$VERSION
go get github.com/ethereum-optimism/optimism/umi-proposer@$VERSION
go get github.com/ethereum-optimism/optimism/umi-batcher@$VERSION
go mod tidy

git add .
git commit -am 'chore: Upgrade umi-e2e dependencies'
git push $BEDROCK_TAGS_REMOTE
git tag "umi-e2e/$VERSION"
git push $BEDROCK_TAGS_REMOTE "umi-e2e/$VERSION"