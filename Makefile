COMPOSEFLAGS=-d
ITESTS_L2_HOST=http://localhost:9545
BEDROCK_TAGS_REMOTE?=origin

build: build-go build-ts
.PHONY: build

build-go: submodules umi-node umi-proposer umi-batcher
.PHONY: build-go

build-ts: submodules
	if [ -n "$$NVM_DIR" ]; then \
		. $$NVM_DIR/nvm.sh && nvm use; \
	fi
	yarn install
	yarn build
.PHONY: build-ts

submodules:
	# CI will checkout submodules on its own (and fails on these commands)
	if [ -z "$$GITHUB_ENV" ]; then \
		git submodule init; \
		git submodule update; \
	fi
.PHONY: submodules

umi-bindings:
	make -C ./umi-bindings
.PHONY: umi-bindings

umi-node:
	make -C ./umi-node umi-node
.PHONY: umi-node

umi-batcher:
	make -C ./umi-batcher umi-batcher
.PHONY: umi-batcher

umi-proposer:
	make -C ./umi-proposer umi-proposer
.PHONY: umi-proposer

umi-challenger:
	make -C ./umi-challenger umi-challenger
.PHONY: umi-challenger

umi-program:
	make -C ./umi-program umi-program
.PHONY: umi-program

mod-tidy:
	# Below GOPRIVATE line allows mod-tidy to be run immediately after
	# releasing new versions. This bypasses the Go modules proxy, which
	# can take a while to index new versions.
	#
	# See https://proxy.golang.org/ for more info.
	export GOPRIVATE="github.com/ethereum-optimism" && go mod tidy
.PHONY: mod-tidy

clean:
	rm -rf ./bin
.PHONY: clean

nuke: clean devnet-clean
	git clean -Xdf
.PHONY: nuke

devnet-up:
	@bash ./umi2-bedrock/devnet-up.sh
.PHONY: devnet-up

devnet-up-deploy:
	PYTHONPATH=./bedrock-devnet python3 ./bedrock-devnet/main.py --monorepo-dir=.
.PHONY: devnet-up-deploy

devnet-down:
	@(cd ./umi2-bedrock && GENESIS_TIMESTAMP=$(shell date +%s) docker-compose stop)
.PHONY: devnet-down

devnet-clean:
	rm -rf ./packages/contracts-bedrock/deployments/devnetL1
	rm -rf ./.devnet
	cd ./umi2-bedrock && docker-compose down
	docker image ls 'umi2-bedrock*' --format='{{.Repository}}' | xargs -r docker rmi
	docker volume ls --filter name=umi2-bedrock --format='{{.Name}}' | xargs -r docker volume rm
.PHONY: devnet-clean

devnet-logs:
	@(cd ./umi2-bedrock && docker-compose logs -f)
	.PHONY: devnet-logs

test-unit:
	make -C ./umi-node test
	make -C ./umi-proposer test
	make -C ./umi-batcher test
	make -C ./umi-e2e test
	yarn test
.PHONY: test-unit

test-integration:
	bash ./umi2-bedrock/test-integration.sh \
		./packages/contracts-bedrock/deployments/devnetL1
.PHONY: test-integration

# Remove the baseline-commit to generate a base reading & show all issues
semgrep:
	$(eval DEV_REF := $(shell git rev-parse develop))
	SEMGREP_REPO_NAME=ethereum-optimism/optimism semgrep ci --baseline-commit=$(DEV_REF)
.PHONY: semgrep

clean-node-modules:
	rm -rf node_modules
	rm -rf packages/**/node_modules


tag-bedrock-go-modules:
	./umi2/scripts/tag-bedrock-go-modules.sh $(BEDROCK_TAGS_REMOTE) $(VERSION)
.PHONY: tag-bedrock-go-modules

update-umi-geth:
	./umi2/scripts/update-umi-geth.py
.PHONY: update-umi-geth

bedrock-markdown-links:
	docker run --init -it -v `pwd`:/input lycheeverse/lychee --verbose --no-progress --exclude-loopback --exclude twitter.com --exclude explorer.optimism.io --exclude-mail /input/README.md "/input/specs/**/*.md"
