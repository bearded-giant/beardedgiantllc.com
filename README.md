# Bearded Giant Sites

Monorepo for the three Bearded Giant web properties. Each site is a static single-page Vite build hosted on Vercel, one Vercel project per site.

| Site | Domain | Vercel project | Vibe |
|------|--------|----------------|------|
| LLC | beardedgiantllc.com | `beardedgiantllc` | Terminal aesthetic -- tech consulting landing page |
| AI | beardedgiant.ai | `beardedgiant-ai` | Modern dark -- agentic AI & consulting services |
| BBQ | beardedgiantbbq.com | `beardedgiantbbq` | Moody minimal -- stealth Texas-style BBQ |

## Structure

```
sites/
  llc/          # beardedgiantllc.com
  bbq/          # beardedgiantbbq.com
  ai/           # beardedgiant.ai
Makefile        # dev + build commands
```

Each site has: `index.html`, `src/` (CSS + JS), `public/` (images, favicons), `vite.config.js`, and builds to its own `dist/`.

## Prerequisites

```
node >= 18
npm
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

Push to `main` and you're done. Vercel's GitHub integration builds all three projects from the repo root, and each project's build settings pick its site:

| Project | Build command | Output directory |
|---------|---------------|------------------|
| `beardedgiantllc` | `npm run build:llc` | `sites/llc/dist` |
| `beardedgiantbbq` | `npm run build:bbq` | `sites/bbq/dist` |
| `beardedgiant-ai` | `npm run build:ai` | `sites/ai/dist` |

Root directory and install command stay at Vercel's defaults (repo root, `npm install`). Pull requests get a preview deployment per project.

## DNS

DNS lives at GoDaddy. Each apex domain has A records pointing at Vercel (the exact values are on each domain's page in the Vercel project settings), and each `www` host is a CNAME to its apex. Vercel redirects `www` to the apex domain.

Mail runs through ProtonMail, so leave the MX records and the SPF and verification TXT records alone when you touch DNS.

## Clean

```bash
make clean              # rm all dist/ dirs
```
