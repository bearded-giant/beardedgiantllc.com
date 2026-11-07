# CLAUDE.md

mr_base_branch: main

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Monorepo for three Bearded Giant static sites, each its own Vercel project in the beardedgiant team. All sites are single-page, no frameworks -- just HTML/CSS/JS built with Vite.

| Site | Domain | Dir | Vercel project | Theme |
|------|--------|-----|----------------|-------|
| LLC | beardedgiantllc.com | `sites/llc/` | `beardedgiantllc` | Terminal aesthetic, monospace only |
| BBQ | beardedgiantbbq.com | `sites/bbq/` | `beardedgiantbbq` | Moody minimal, Playfair Display + Source Sans |
| AI | beardedgiant.ai | `sites/ai/` | `beardedgiant-ai` | Modern dark, Inter + JetBrains Mono |

## Commands

```bash
npm install                 # one-time setup
make dev-llc                # local dev server (llc, bbq, or ai)
make build-llc              # build to sites/llc/dist/
make build-all              # all three sites
make clean                  # rm all dist/ dirs
```

## Deploy

Merging to `main` deploys. `.github/workflows/deploy.yml` runs `vercel deploy --prod` once per project using the `VERCEL_TOKEN` repo secret (team-scoped). `vercel.json` turns off Vercel's own git deploys for `main`, so each merge deploys once; pull requests still get Vercel previews. Every project builds from the repo root with build command `npm run build:<site>` and output directory `sites/<site>/dist`.

## DNS

DNS is at GoDaddy. Apex A records point at Vercel, each `www` is a CNAME to its apex, and Vercel 308-redirects `www` to the apex. Mail runs through ProtonMail: never touch the MX, DKIM, SPF, or verification TXT records.

## Architecture

Each site under `sites/{name}/` follows the same structure: `index.html` at root, `src/style.css` + `src/main.js` for source, `public/` for static assets (favicons, images, logos), and `vite.config.js`. Each vite config is identical -- sets root to the site dir, publicDir to `public/`, and builds to `dist/`.

## Design Constraints

- No build frameworks, no React/Vue/etc. Plain HTML + vanilla JS + CSS.
- LLC site uses terminal-style reveal animations via `data-delay` attributes on `.line` and `.output` elements.
- Each site has its own font stack and color palette -- they are intentionally distinct, not sharing styles.
- Sites are ~10-20KB total (HTML + CSS + JS before images). Keep them minimal.
