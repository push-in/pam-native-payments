<!-- pam:product-page:start -->
<div align="center">

# PAM Native Payments

**Native checkout surfaces with PCI-conscious application boundaries.**

Present Stripe PaymentSheet and receive typed outcomes without handling raw card data in PHP.

[![Latest version](https://img.shields.io/packagist/v/pushinbr/pam-native-payments?style=flat-square&label=stable)](https://packagist.org/packages/pushinbr/pam-native-payments)
[![CI](https://img.shields.io/github/actions/workflow/status/push-in/pam-native-payments/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/push-in/pam-native-payments/actions)
![PHP](https://img.shields.io/badge/PHP-8.5-777BB4?style=flat-square&logo=php&logoColor=white)
![Android](https://img.shields.io/badge/Android-API%2026%2B-3DDC84?style=flat-square&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-15%2B-000000?style=flat-square&logo=apple&logoColor=white)

**[Documentation](https://push-in.github.io/pam-docs/native/overview/) · [Quick start](#quick-start) · [What you can build](#what-you-can-build) · [PAM ecosystem](https://push-in.github.io/pam-docs/ecosystem/) · [Issues](https://github.com/push-in/pam-native-payments/issues)**

</div>

---

## Why PAM Native Payments

Present Stripe PaymentSheet and receive typed outcomes without handling raw card data in PHP. The public API is strictly typed for PHP 8.5; expensive or frame-sensitive work stays in Rust or the platform SDK instead of crossing the application boundary every frame.

| | |
| --- | --- |
| **Best for** | A focused capability you can add to any PAM Native application |
| **Native path** | Stripe Android SDK · Stripe iOS SDK |
| **Application model** | Composer package + generated native integration |
| **Design rule** | Independent module; no feed, vertical, or application template bundled |

## What you can build

- One-time commerce checkout
- Saved payment-method flows
- Marketplace and service payments

## Quick start

Already have a PAM Native project? Add only this capability:

```bash
pam composer require pushinbr/pam-native-payments
pam doctor --fix
```

New to PAM? Follow the **[five-minute PAM Native setup](https://push-in.github.io/pam-docs/native/overview/)** once, then return here. Your application stays a normal Composer project with a committed lockfile.
<!-- pam:product-page:end -->

## See it in action

Stripe PaymentSheet for PAM Native with native payment methods, wallets and SCA/3DS flows. Your server creates the PaymentIntent; the app receives only a publishable key and short-lived client secret. Stripe secret keys are rejected by the PHP API.

```bash
pam add payments
pam doctor
```

```php
PaymentSheet::make($publishableKey, $paymentIntentClientSecret, 'Acme')
    ->returnUrl('acme://stripe-redirect')
    ->onResult(fn (PaymentResult $result, string $message) => /* update the screen */);
```

Always fulfill orders from verified server-side Stripe webhooks, never from the client completion callback.

## What installation does

`pam add payments` resolves the official compatible package, performs a non-mutating Composer preflight, updates the normal `composer.json` and `composer.lock`, refreshes generated native integration when required, and leaves the project ready for `pam doctor` validation.

Use `pam packages` to inspect availability and `pam remove payments` to uninstall the capability safely. Direct Composer commands are an advanced interoperability path; PAM is the supported application workflow.

## API guide

| API | Responsibility |
| --- | --- |
| `PaymentSheet` | Configure and render Stripe's native PaymentSheet. |
| `PaymentResult` | Handle completed, cancelled, and failed outcomes as typed values. |

All coded states, kinds, and variants are sequential integer-backed enums. Use enum cases in application code; do not depend on raw wire numbers.

## Production checklist

- Create PaymentIntents and ephemeral secrets only on your server.
- Fulfill orders only after verified server-side webhooks.
- Use restricted publishable keys and never embed Stripe secret keys.
- Run `pam doctor`, `pam test`, and a signed release build on every supported platform.
- Exercise denial, cancellation, backgrounding, process restart, and offline behavior before release.

## Troubleshooting

- **The sheet does not open:** verify the publishable key, client secret, and active presentation context.
- **Wallets are missing:** complete the platform merchant configuration.
- **Client reports success but entitlement is absent:** inspect the verified webhook flow.
- **Native integration is stale:** run `pam doctor --fix`, rebuild the native host, and inspect the first reported diagnostic.

## Compatibility and support

This package targets PAM Native `0.8.x`, Android API 26+, and iOS 15+ unless a platform-specific section above states a stricter requirement. Platform SDKs, credentials, entitlements, physical hardware, and store configuration remain application responsibilities.

- [PAM documentation](https://push-in.github.io/pam-docs/introduction/)
- [PAM Native overview](https://push-in.github.io/pam-docs/native/overview/)
- [Plugin and native capability model](https://push-in.github.io/pam-docs/native/plugins/)
- [Report an issue](https://github.com/push-in/pam-native-payments/issues)

Security vulnerabilities should be reported through the repository security policy or GitHub private vulnerability reporting, not a public issue.
