# CBA Rabbitry — Website Cheat Sheet

Your website lives in this folder. It's built with **Hugo** and auto-deploys to Cloudflare Pages whenever you push to GitHub.

---

## How to Add a New Bunny

1. Copy an existing bunny file from `content/bunnies-for-adoption/available/`
2. Rename it (e.g., `snowflake.md`)
3. Edit the top section (called "front matter"):

```markdown
---
title: "Snowflake"
grade: "P"           # A = pet ($99+), P = premium ($299+), S = show ($599+)
price: 299
color: "Blue Tort"
sex: "Doe"           # Doe = female, Buck = male
dob: "2025-09-15"
available: true
featured_image: "/images/bunnies/snowflake.jpg"
---

Write a description of the bunny here.
```

4. Add the bunny's photo to `static/images/bunnies/` (name it `snowflake.jpg`)
5. Push to GitHub → site updates automatically in ~1 minute

---

## How to Mark a Bunny as Sold

1. Open the bunny's file in `content/bunnies-for-adoption/available/`
2. Change `available: true` to `available: false`
3. Push to GitHub

---

## How to Update Contact Info / Prices

- **Contact info and site-wide settings:** Edit `hugo.toml`
- **Page text:** Edit the `.md` file in `content/` for that page
- **Sales policy:** Edit `content/sales-policy/_index.md`

---

## How to Add a Partner

Edit `content/partner-friends/_index.md` and add a new section following the existing format.

---

## Updating Your API Keys

After setting up Web3Forms and Cloudflare Turnstile, update `hugo.toml`:

```toml
[params]
  web3forms_key = "your-actual-key-here"
  turnstile_site_key = "your-actual-key-here"
```

---

## Deploying (Push to GitHub)

```bash
git add .
git commit -m "Add new bunny Snowflake"
git push
```

Cloudflare Pages picks it up and publishes within ~60 seconds.

---

## Running Locally (Preview Before Publishing)

### Quick start

```bash
bash dev.sh
```

This starts Hugo and opens a Cloudflare Tunnel so the site is live at **https://dev.cbarabbitry.com** — useful for testing on mobile or sharing a preview link. Press Ctrl+C to stop.

> If you just want a local-only preview without the tunnel, run `hugo server` and open `http://localhost:1313`.

---

### New machine setup

Do this once on any new machine before running `dev.sh`.

**1. Install prerequisites**

| Tool | Install |
|------|---------|
| [Hugo](https://gohugo.io/installation/) (extended) | `winget install Hugo.Hugo.Extended` |
| [Git](https://git-scm.com/) | `winget install Git.Git` |
| [cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/) | `winget install Cloudflare.cloudflared` |

**2. Clone the repo and initialise the theme**

```bash
git clone https://github.com/jiaz/cbarabbitry.git
cd cbarabbitry
git submodule update --init --recursive
```

**3. Add the Cloudflare Tunnel credentials**

The tunnel config in `.cloudflared/config.yml` references a credentials file that is **not stored in git** (it contains a secret key). You need to copy it from an existing machine or re-authenticate:

- **Copy from existing machine:** grab `~/.cloudflared/ddb9ef18-b4dd-4fe2-a413-491dad1c3e27.json` and place it at the same path on the new machine.
- **Or re-authenticate:** run `cloudflared tunnel login` then `cloudflared tunnel token ddb9ef18-b4dd-4fe2-a413-491dad1c3e27` and follow the prompts.

**4. Run**

```bash
bash dev.sh
```

---

## File Structure Quick Reference

```
content/                    ← All your text/pages
  bunnies-for-adoption/
    available/              ← One file per bunny (add/edit here)
  sales-policy/_index.md   ← Your sales policy
  contact/_index.md        ← Contact page text
  ...

static/
  images/
    bunnies/               ← Bunny photos go here
    partners/              ← Partner org photos
  css/custom.css           ← Colors and styling

hugo.toml                  ← Site title, contact info, API keys
```

---

## Need Help?

Contact your web developer or refer to the [Hugo documentation](https://gohugo.io/documentation/).
