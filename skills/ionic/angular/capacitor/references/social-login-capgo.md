# Social Login (Capgo)

## When to Use

Use `@capgo/capacitor-social-login` when you need Google (or other social provider) sign-in on iOS and Android. This is the actively maintained recommended alternative to deprecated community plugins.

## Required Packages

```bash
npm install @capgo/capacitor-social-login
npx cap sync
```

## Location

`src/app/core/auth/social-login.service.ts`

## Implementation

```typescript
import { Injectable } from '@angular/core';
import { Capacitor } from '@capacitor/core';
import { SocialLogin, LoginProvider } from '@capgo/capacitor-social-login';

@Injectable({
  providedIn: 'root',
})
export class SocialLoginService {
  async signInWithGoogle() {
    if (Capacitor.getPlatform() === 'web') {
      return null;
    }
    return await SocialLogin.login({
      provider: LoginProvider.GOOGLE,
    });
  }

  async signOut() {
    if (Capacitor.getPlatform() === 'web') {
      return;
    }
    await SocialLogin.logout();
  }
}
```

## Rules

- Place in `core/auth/` — social login is an authentication infrastructure concern.
- ALWAYS check `Capacitor.getPlatform() === 'web'` — the plugin only works natively.
- Do not use `@capacitor-community/facebook-login` or other older social plugins — they are unmaintained; prefer `@capgo/capacitor-social-login` for all providers.
