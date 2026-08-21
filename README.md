# PAM Native Payments

## Start here

This is a Composer extension for PAM Native. Install the PAM Runtime, create a native project, and then add this package through PAM’s verified Composer toolchain:

```bash
curl --proto '=https' --proto-redir '=https' --tlsv1.2 \
    --connect-timeout 15 --max-time 60 --max-filesize 1048576 -fsSL \
    https://github.com/push-in/pam/releases/latest/download/install.sh | sh

pam init my-app --template native
cd my-app
pam composer require pushinbr/pam-native-payments
pam doctor --fix
```


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

This package targets PAM Native `0.6.x`, Android API 26+, and iOS 15+ unless a platform-specific section above states a stricter requirement. Platform SDKs, credentials, entitlements, physical hardware, and store configuration remain application responsibilities.

- [PAM documentation](https://push-in.github.io/pam-docs/introduction/)
- [PAM Native overview](https://push-in.github.io/pam-docs/native/overview/)
- [Plugin and native capability model](https://push-in.github.io/pam-docs/native/plugins/)
- [Report an issue](https://github.com/push-in/pam-native-payments/issues)

Security vulnerabilities should be reported through the repository security policy or GitHub private vulnerability reporting, not a public issue.
