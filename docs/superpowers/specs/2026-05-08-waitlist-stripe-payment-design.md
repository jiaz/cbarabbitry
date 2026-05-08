# Waitlist Stripe Payment Design

## Context

CBA Rabbitry is a static Hugo site. The current waitlist page uses a Web3Forms preference form and says the $49 waitlist fee will be paid later through a payment link. The desired change is to make paid waitlist signup the primary path, reduce low-conversion outreach, and associate customer preferences with the reservation payment.

Jiaji has not created a Stripe account or Payment Link yet. Stripe URLs in the site should therefore be configurable placeholders until the live link exists.

## Goals

- Encourage interested customers to pay the $49 waitlist reservation fee before reaching out.
- Keep the site static; avoid adding a backend for the first version.
- Use Stripe as the source of truth for paid waitlist entries.
- Collect compact preference information in Stripe Checkout so it stays associated with the payment.
- Add FAQ content that answers common questions before customers contact CBA Rabbitry.

## Non-Goals

- Do not build a custom payment backend in this version.
- Do not store waitlist submissions in the Hugo site.
- Do not preserve the full existing Web3Forms waitlist questionnaire unless Stripe custom fields prove insufficient later.
- Do not implement Stripe webhooks until there is a clear operational need.

## Recommended Approach

Use a Stripe Payment Link for the $49 waitlist reservation fee. The waitlist page links directly to Stripe Checkout. Stripe collects customer name, email, payment status, and three custom fields:

1. Color preference
2. Grade preference
3. Anything else we should know

This matches the static-site architecture and keeps customer intake attached to the successful payment without introducing server-side Stripe secret handling.

## Page Flow

1. Customer opens `/join-waiting-list/`.
2. The top section explains that joining the waitlist starts by paying the $49 reservation fee.
3. Customer reviews the short policy summary, expected timeline, and FAQ.
4. Customer clicks `Pay $49 Reservation Fee`.
5. Stripe Checkout collects payment, contact details, and the three custom fields.
6. After successful payment, Stripe redirects to `/thank-you/` or a future dedicated waitlist thank-you page.

## Content Structure

The waitlist page should be rewritten around a payment-first structure:

- Hero/payment section with headline, short value explanation, primary Stripe CTA, and note that the $49 fee applies toward the adoption price.
- Checkout summary explaining what Stripe will collect.
- Waitlist policy summary explaining that the fee confirms serious interest and supports responsible breeding plans.
- Existing breeding timeline, adjusted so payment is the first step.
- FAQ before contact.
- Contact link only after the FAQ, framed for specific policy or fit questions not already answered.

## FAQ Topics

The FAQ should cover:

- Is the waitlist fee refundable?
- Does paying reserve a specific bunny?
- How long is the typical wait?
- What happens if my preferred color or grade is not available?
- What price range should I expect?
- Can I ask questions before paying?

The tone should be clear but polite: customers should review the FAQ and sales policy before contacting CBA Rabbitry, and contact is best for questions not already answered.

## Configuration

Add a site parameter in `hugo.toml`:

```toml
stripe_waitlist_payment_url = ""
```

The template should not hard-code the Stripe URL. While the value is empty, the page should make it obvious that online payment is being prepared rather than sending users to a broken link. Once Jiaji creates the Stripe account and Payment Link, the live URL can be placed in this parameter.

## Stripe Setup Requirements

When the Stripe account is ready, create a Payment Link or Checkout-backed product with:

- Product/name: CBA Rabbitry Waitlist Reservation Fee
- Amount: $49
- Custom fields:
  - Color preference
  - Grade preference
  - Anything else we should know
- Success redirect: `https://cbarabbitry.com/thank-you/` unless a dedicated waitlist thank-you page is created later

Stripe should collect name and email through Checkout.

## Implementation Scope

Expected files:

- `hugo.toml`: add `stripe_waitlist_payment_url`.
- `content/join-waiting-list/_index.md`: rewrite payment-first policy and FAQ copy.
- `layouts/join-waiting-list/list.html`: replace the Web3Forms waitlist form with the Stripe CTA and checkout summary.
- `assets/css/custom.css`: add narrowly scoped styles only if existing waitlist/form/timeline styles are insufficient.

Generated brainstorming companion files under `.superpowers/` are not part of the feature and should not be committed.

## Error And Placeholder Behavior

If `stripe_waitlist_payment_url` is empty:

- Do not render a broken external link.
- Show the payment CTA as unavailable or point customers to a short message that online payment setup is in progress.
- Keep the rest of the FAQ and policy visible so the page remains useful.

When the URL is configured:

- Render the primary CTA as a normal external link to Stripe.
- Use link text that makes payment expectation explicit, such as `Pay $49 Reservation Fee`.

## Testing

- Run `hugo` to verify the static build succeeds.
- Run `hugo server` for local review.
- Check desktop and mobile layouts for the waitlist page.
- Verify the empty placeholder URL state does not produce a broken link.
- After Stripe is configured, click through to confirm the Payment Link opens and shows the expected custom fields.

