SITES = llc bbq ai

.PHONY: dev-llc dev-bbq dev-ai build-llc build-bbq build-ai build-all deploy-llc deploy-bbq deploy-ai deploy-all clean

# dev servers
dev-llc:
	npx vite --config sites/llc/vite.config.js --host

dev-bbq:
	npx vite --config sites/bbq/vite.config.js --host

dev-ai:
	npx vite --config sites/ai/vite.config.js --host

# builds
build-llc:
	npx vite build --config sites/llc/vite.config.js

build-bbq:
	npx vite build --config sites/bbq/vite.config.js

build-ai:
	npx vite build --config sites/ai/vite.config.js

build-all: build-llc build-bbq build-ai

# deploy to gcp buckets
deploy-llc: build-llc
	gsutil -m rsync -r -d sites/llc/dist gs://beardedgiantllc.com

deploy-bbq: build-bbq
	gsutil -m rsync -r -d sites/bbq/dist gs://beardedgiantbbq.com

deploy-ai: build-ai
	gsutil -m rsync -r -d sites/ai/dist gs://beardedgiant.ai

deploy-all: deploy-llc deploy-bbq deploy-ai

# clean
clean:
	rm -rf sites/llc/dist sites/bbq/dist sites/ai/dist
