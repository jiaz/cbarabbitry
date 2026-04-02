# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CBA Rabbitry is a static website for a Netherland Dwarf rabbit breeding and adoption business, built with Hugo and deployed to Cloudflare Pages.

## Commands

```bash
# Local development (hot reload at http://localhost:1313)
hugo server

# Build for production
hugo --minify

# Build without minification (easier debugging)
hugo
```

Deployment happens automatically via GitHub Actions when pushing to `master`. The workflow checks out with submodules (required for Ananke theme), builds with Hugo 0.147.0 extended, and deploys via Cloudflare Wrangler.

## Architecture

**No backend.** This is a purely static site — content in Markdown, rendered by Hugo, forms submitted to external Web3Forms API.

### Content → Template Mapping

| Route | Content | Template |
|-------|---------|----------|
| `/` | `content/_index.md` (front matter params) | `layouts/index.html` |
| `/bunnies-for-adoption/` | `content/bunnies-for-adoption/_index.md` | `layouts/bunnies-for-adoption/list.html` |
| `/bunnies-for-adoption/[name]/` | `content/bunnies-for-adoption/available/*.md` | Ananke default single |
| `/contact/` | `content/contact/_index.md` | `layouts/contact/list.html` |
| `/request-adoption/` | `content/request-adoption/_index.md` | `layouts/request-adoption/list.html` |
| `/join-waiting-list/` | `content/join-waiting-list/_index.md` | `layouts/join-waiting-list/list.html` |
| `/partner-friends/` | `content/partner-friends/_index.md` | `layouts/partner-friends/list.html` |
| `/thank-you/` | `content/thank-you/_index.md` | `layouts/thank-you/list.html` |

### Bunny Records

Each bunny is a Markdown file in `content/bunnies-for-adoption/available/`. Key front matter fields:

```yaml
title: "Bunny Name"
grade: "P"              # A (Adorable), P (Premium), S (Signature), SS (Grand Champion)
price: 299
color: "Color Name"
sex: "Doe"              # or "Buck"
dob: "2025-09-15"
available: true         # false = sold
reserved: false         # true = reserved for specific customer
reserved_by: ""         # customer name if reserved
new_home: ""            # adopter name, shown after adoption
featured_image: "/images/bunnies/name.jpg"
video: ""               # optional TikTok/social link
```

### Forms

All forms POST to `https://api.web3forms.com/submit` with an `access_key` parameter (configured in `hugo.toml` under `[params]`). On success, they redirect to `/thank-you/`. Honeypot spam protection is included in each form.

### Styling

Custom CSS lives entirely in `assets/css/custom.css` (~2,068 lines). The Ananke theme provides Tachyons utility classes. Color palette:
- Brown: `#6b4226`, Accent: `#a0522d`, Dark: `#2c1a0e`, Cream: `#faf4e8`
- Grade badge colors: Green (A), Sienna (P), Purple (S)

Reusable layout components are in `layouts/partials/`: `site-header.html`, `site-footer.html`, `site-navigation.html`, `bunny-card.html`, `bunny-list-item.html`, `contact-form.html`.

### Configuration

`hugo.toml` holds all site-wide parameters: base URL, contact info (email, phone, address), social media URLs (Instagram, TikTok, Facebook, WeChat, Rednote), Web3Forms API key, and navigation menu structure.

### Theme

Ananke is included as a Git submodule at `themes/ananke/`. Always use `--recurse-submodules` when cloning. The `hugo server` command requires the submodule to be initialized.

## Git Workflow

This is a personal website — skip PRs entirely. Push changes directly to `master`:

```bash
git push origin master
```

If in a worktree where `master` is checked out in the main repo, push via:

```bash
git push origin <current-branch>:master
```

Resolve any conflicts before pushing.
