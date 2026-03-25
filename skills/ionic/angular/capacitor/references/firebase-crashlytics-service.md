# Firebase Crashlytics Service

## When to Use

Use this service to capture crashes and non-fatal errors and send them to Firebase Crashlytics for monitoring in production.

## Required Packages

```bash
npm install @capacitor-firebase/crashlytics stacktrace-js
npx cap sync
```

## Location

`src/app/core/error-handler/crashlytics.service.ts`

## Implementation

```typescript
import { Injectable } from '@angular/core';
import { FirebaseCrashlytics } from '@capacitor-firebase/crashlytics';
import { Capacitor } from '@capacitor/core';
import * as StackTrace from 'stacktrace-js';

@Injectable({
  providedIn: 'root',
})
export class CrashlyticsService {
  async crash(message: string = 'Test Crash') {
    await FirebaseCrashlytics.crash({ message });
  }

  async setCustomKey(
    key: string,
    value: string | number | boolean,
    type: 'string' | 'long' | 'double' | 'boolean'
  ) {
    await FirebaseCrashlytics.setCustomKey({ key, value, type });
  }

  async setUserId(userId: string) {
    await FirebaseCrashlytics.setUserId({ userId });
  }

  async log(message: string) {
    await FirebaseCrashlytics.log({ message });
  }

  async setEnabled(enabled: boolean) {
    await FirebaseCrashlytics.setEnabled({ enabled });
  }

  async isEnabled(): Promise<boolean> {
    const { enabled } = await FirebaseCrashlytics.isEnabled();
    return enabled;
  }

  async didCrashOnPreviousExecution(): Promise<boolean> {
    const { crashed } = await FirebaseCrashlytics.didCrashOnPreviousExecution();
    return crashed;
  }

  async sendUnsentReports() {
    await FirebaseCrashlytics.sendUnsentReports();
  }

  async deleteUnsentReports() {
    await FirebaseCrashlytics.deleteUnsentReports();
  }

  async recordException(message: string) {
    if (Capacitor.getPlatform() === 'web') return;
    await FirebaseCrashlytics.recordException({ message });
  }

  async recordExceptionWithStacktrace(error: Error, message: string = 'Non-fatal error') {
    if (Capacitor.getPlatform() === 'web') return;
    const stacktrace = await StackTrace.fromError(error);
    await FirebaseCrashlytics.recordException({ message, stacktrace });
  }
}
```

## Rules

- Place in `core/error-handler/` — it is an app-wide infrastructure singleton.
- ALWAYS guard with `Capacitor.getPlatform() === 'web'` before recording exceptions — Crashlytics does not run on web.
- Use `recordExceptionWithStacktrace` for caught `Error` objects to get meaningful stack traces in the Firebase console.
- Call `setUserId` after user authentication so crashes are attributable to specific users.
