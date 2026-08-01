# PAM Native Payments

Stripe PaymentSheet for PAM Native with native payment methods, wallets and SCA/3DS flows. Your server creates the PaymentIntent; the app receives only a publishable key and short-lived client secret. Stripe secret keys are rejected by the PHP API.

```php
PaymentSheet::make($publishableKey, $paymentIntentClientSecret, 'Acme')
    ->returnUrl('acme://stripe-redirect')
    ->onResult(fn (PaymentResult $result, string $message) => /* update the screen */);
```

Always fulfill orders from verified server-side Stripe webhooks, never from the client completion callback.
