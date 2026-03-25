# Firebase Analytics Service

## When to Use

Use this service to log user events and set user properties in Firebase Analytics.

## Required Packages

```bash
npm install @capacitor-firebase/analytics
npx cap sync
```

## Location

`src/app/core/error-handler/analytics.service.ts`

## Implementation

```typescript
import { Injectable } from '@angular/core';
import { FirebaseAnalytics } from '@capacitor-firebase/analytics';
import { Capacitor } from '@capacitor/core';

@Injectable({
  providedIn: 'root',
})
export class AnalyticsService {
  async logEvent(name: string, params?: Record<string, string | number>) {
    if (Capacitor.getPlatform() === 'web') return;
    await FirebaseAnalytics.logEvent({ name, params });
  }

  async setUserId(userId: string) {
    if (Capacitor.getPlatform() === 'web') return;
    await FirebaseAnalytics.setUserId({ userId });
  }
}
```

## Rules

- Place in `core/error-handler/` alongside `CrashlyticsService` — both are Firebase observability singletons.
- ALWAYS guard with `Capacitor.getPlatform() === 'web'` — the native Firebase SDK is not available on web.
- Call `setUserId` right after successful authentication.
- Keep `logEvent` calls in services or page components, never inside dumb UI components.
