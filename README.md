# Bearded Giant Sites

Monorepo for the three Bearded Giant web properties. Each site is a static single-page build served from a GCP bucket behind a global HTTPS load balancer with CDN.

| Site | Domain | Vibe |
|------|--------|------|
| LLC | beardedgiantllc.com | Terminal aesthetic -- tech consulting landing page |
| AI | beardedgiant.ai | Modern dark -- agentic AI & consulting services |
| BBQ | beardedgiantbbq.com | Moody minimal -- stealth Texas-style BBQ |

## Structure

```
sites/
  llc/          # beardedgiantllc.com
  bbq/          # beardedgiantbbq.com
  ai/           # beardedgiant.ai
terraform/      # GCP infra (buckets, LB, SSL, CDN)
Makefile        # build + deploy commands
```

Each site has: `index.html`, `src/` (CSS + JS), `public/` (images, favicons), `vite.config.js`, and builds to its own `dist/`.

## Prerequisites

```
node >= 18
npm
gcloud CLI (authenticated to personal config)
terraform >= 1.5
```

## Local Dev

```bash
npm install
make dev-llc    # http://localhost:5173
make dev-bbq
make dev-ai
```

## Build

```bash
make build-llc          # builds sites/llc/dist/
make build-bbq
make build-ai
make build-all          # all three
```

## Deploy

```bash
make deploy-llc         # build + gsutil rsync to GCP bucket
make deploy-bbq
make deploy-ai
make deploy-all         # ship everything
```

## Infrastructure

Terraform in `terraform/` manages:

1. Three GCS buckets (one per domain) with static website config
2. Public read IAM on each bucket
3. Google-managed SSL certificates
4. Global HTTPS load balancers with backend buckets + CDN
5. HTTP -> HTTPS redirect

```bash
cd terraform
terraform init
terraform apply
```

### DNS

Each domain has an A record pointing to a GCP global static IP. After `terraform apply`, the output shows the IPs. Set A records in GoDaddy (or wherever DNS is managed):

```
beardedgiantllc.com  -> A -> (see terraform output)
beardedgiantbbq.com  -> A -> (see terraform output)
beardedgiant.ai      -> A -> (see terraform output)
```

SSL certs auto-provision once DNS propagates.

### GCP

1. Project: `calcium-aria-492423-h7`
2. APIs enabled via terraform: `compute.googleapis.com`, `storage.googleapis.com`
3. Org policy `iam.allowedPolicyMemberDomains` was cleared to allow `allUsers` bucket access

### GCP Auth

This is a personal GCP project. If you also use GCP for work, use named configs to avoid auth conflicts:

```bash
gcloud config configurations create personal
gcloud config configurations activate personal
gcloud config set project calcium-aria-492423-h7
gcloud auth login
gcloud auth application-default login
```

Switch with `gcloud config configurations activate personal` / `default`.

## Clean

```bash
make clean              # rm all dist/ dirs
```
