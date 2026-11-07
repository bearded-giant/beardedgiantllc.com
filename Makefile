SITES = llc bbq ai

.PHONY: dev-llc dev-bbq dev-ai build-llc build-bbq build-ai build-all clean

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

# clean
clean:
	rm -rf sites/llc/dist sites/bbq/dist sites/ai/dist
