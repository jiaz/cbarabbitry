# Waitlist Stripe Payment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the waitlist form with a payment-first Stripe Payment Link flow that works safely while the live Stripe URL is not yet configured.

**Architecture:** The site remains static Hugo. `hugo.toml` owns the configurable Stripe URL, `content/join-waiting-list/_index.md` owns the policy and FAQ copy, and `layouts/join-waiting-list/list.html` renders the payment CTA, placeholder state, and existing timeline. CSS changes stay scoped to the waitlist payment page.

**Tech Stack:** Hugo templates, Markdown content, Ananke/Tachyons, custom CSS, Stripe Payment Link.

---

### Task 1: Add Stripe Waitlist Configuration

**Files:**
- Modify: `hugo.toml`

- [x] **Step 1: Add a placeholder Stripe parameter**

Add this under `[params]`, near the Web3Forms settings:

```toml
  # Stripe
  stripe_waitlist_payment_url = ""
```

- [x] **Step 2: Verify the config parses**

Run: `hugo --printI18nWarnings`

Expected: Hugo exits successfully without TOML parse errors.

### Task 2: Rewrite Waitlist Content

**Files:**
- Modify: `content/join-waiting-list/_index.md`

- [x] **Step 1: Replace the existing body with payment-first copy**

Use Markdown sections for:

```markdown
## Reserve Your Waitlist Spot

The $49 waitlist reservation fee confirms that you are seriously interested in a future CBA Rabbitry Netherland Dwarf bunny. It helps us plan responsible litters around committed homes instead of breeding without confirmed demand.

The fee is applied toward your bunny adoption price after adoption.

## What Stripe Will Collect

When online payment is ready, Stripe Checkout will collect your name, email, payment, and three waitlist preferences:

- Color preference
- Grade preference
- Anything else we should know

## What The Waitlist Means

Joining the waitlist gives you priority for future litters based on your preferences. It does not reserve a specific bunny. Once babies are available, we will share photos and videos so paid waitlist families can choose and reserve a bunny.

## Typical Timeline

We typically start planning breeding within 1-2 weeks after waitlist demand is confirmed. Babies are usually available for selection in 1-2 months, then go home after they are safely weaned.

## FAQ

### Is the waitlist fee refundable?

The waitlist fee is a reservation fee for planning future litters and is applied toward your bunny adoption price after adoption. Please make sure you are ready to join before paying.

### Does paying reserve a specific bunny?

No. The waitlist fee reserves your priority for future litters. A specific bunny is reserved later, after babies are available and you choose from photos and videos.

### What if my preferred color or grade is not available?

We use your preferences to plan and recommend good matches, but exact color, sex, and grade cannot be guaranteed. We will discuss available options with paid waitlist families when babies are ready.

### What price range should I expect?

Our grades typically range from A - Adorable to S - Signature. Current grade ranges are shown in the Stripe checkout field and on the adoption pages.

### Can I ask questions before paying?

Please review this page and our [sales policy](/sales-policy/) first. If you still have a specific policy or fit question that is not answered, you are welcome to [contact us](/contact/).
```

- [x] **Step 2: Keep front matter unchanged**

Expected front matter stays:

```yaml
---
title: "Join Our Waiting List"
description: "Reserve your future Netherland Dwarf bunny by joining the CBA Rabbitry waiting list."
---
```

### Task 3: Render Stripe CTA And Placeholder State

**Files:**
- Modify: `layouts/join-waiting-list/list.html`

- [x] **Step 1: Define the Stripe URL variable**

At the top of the template inside `{{ define "main" }}`, set:

```go-html-template
{{ $stripeURL := site.Params.stripe_waitlist_payment_url }}
```

- [x] **Step 2: Replace the form column**

Replace the current `cba-form-split-form` block and Web3Forms partial with a payment card:

```go-html-template
<div class="cba-waitlist-payment-card">
  <p class="cba-payment-eyebrow">Reservation Fee</p>
  <h2 class="cba-form-split-form-title">$49 Waitlist Reservation</h2>
  <p class="cba-payment-card-copy">Paying the reservation fee is the first step to join the CBA Rabbitry waitlist. Stripe will collect your payment and compact preferences in one secure checkout.</p>

  <div class="cba-payment-includes">
    <h3>Stripe checkout collects</h3>
    <ul>
      <li>Your name and email</li>
      <li>Color preference</li>
      <li>Grade preference</li>
      <li>Anything else we should know</li>
    </ul>
  </div>

  {{ if $stripeURL }}
    <a class="cba-btn-primary cba-payment-button" href="{{ $stripeURL }}" target="_blank" rel="noopener">Pay $49 Reservation Fee</a>
  {{ else }}
    <button class="cba-btn-primary cba-payment-button cba-payment-button--disabled" type="button" disabled>Online Payment Coming Soon</button>
    <p class="cba-payment-placeholder">We are preparing online reservation payment. Please review the waitlist details and check back soon.</p>
  {{ end }}

  <p class="cba-payment-footnote">The $49 fee applies toward your bunny adoption price after adoption.</p>
</div>
```

- [x] **Step 3: Keep the timeline**

Keep the existing timeline section, but ensure the first step says:

```html
<p class="cba-timeline-label">You Pay Fee &amp; Join</p>
<p class="cba-timeline-desc">Pay the $49 waitlist fee and share your compact preferences through Stripe Checkout.</p>
```

### Task 4: Add Scoped Styles

**Files:**
- Modify: `assets/css/custom.css`

- [x] **Step 1: Add payment-card styles near existing waitlist styles**

Add rules for:

```css
.cba-waitlist-payment-card { ... }
.cba-payment-eyebrow { ... }
.cba-payment-card-copy { ... }
.cba-payment-includes { ... }
.cba-payment-includes h3 { ... }
.cba-payment-includes ul { ... }
.cba-payment-includes li { ... }
.cba-payment-button { ... }
.cba-payment-button--disabled { ... }
.cba-payment-placeholder { ... }
.cba-payment-footnote { ... }
```

The styles should match the existing brown/accent/cream palette and should not affect other forms.

- [x] **Step 2: Check responsive behavior**

Use existing split-page responsive styles where possible. Add only targeted mobile rules if the payment card does not fit.

### Task 5: Verify Build And Placeholder Behavior

**Files:**
- Verify generated output only.

- [x] **Step 1: Run Hugo build**

Run: `hugo`

Expected: Build succeeds.

- [x] **Step 2: Confirm no broken Stripe href in rendered HTML**

Run: `rg -n "Pay \\$49 Reservation Fee|Online Payment Coming Soon|href=\\\"\\\"" public/join-waiting-list/index.html`

Expected: `Online Payment Coming Soon` appears and no empty `href=""` appears.

- [x] **Step 3: Check git status**

Run: `git status --short`

Expected: Only intentional files are modified, plus pre-existing untracked scratch files if still present.
