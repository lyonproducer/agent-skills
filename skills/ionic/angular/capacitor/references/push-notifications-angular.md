# Push Notifications — Angular Integration Guide

## When to Use

Use this guide when setting up push notifications (FCM / APNs) in an Ionic + Angular app. Covers the full flow: service setup, initialization on app start, and permission registration after user opt-in.

## Required Packages

```bash
npm install @capacitor/push-notifications
npx cap sync
```

**iOS** — add to `Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>remote-notification</string>
</array>
```

**Android** — add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

---

## Step 1: Copy the Service Template

Copy `templates/push-notification.service.ts` to:

`src/app/core/device/push-notification.service.ts`

The service exposes four methods:

| Method | When to call |
|--------|-------------|
| `addListeners()` | In `app.component.ts` after `platform.ready()` — always, on every app start |
| `registerNotifications()` | After user grants permission (login, onboarding opt-in) |
| `getDeliveredNotifications()` | When showing notification history |
| `removeAllDeliveredNotifications()` | When clearing the notification center |

---

## Step 2: Initialize Listeners in `app.component.ts`

```typescript
import { Component, inject } from '@angular/core';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Platform, IonicModule } from '@ionic/angular';
import { EdgeToEdge } from '@capawesome/capacitor-android-edge-to-edge-support';
import { PushNotificationService } from '@core/device/push-notification.service';

@Component({
  selector: 'app-root',
  imports: [IonicModule],
  templateUrl: 'app.component.html',
})
export class AppComponent {
  private readonly platform = inject(Platform);
  private readonly pushService = inject(PushNotificationService);

  constructor() {
    this.platform.ready().then(async () => {
      if (Capacitor.getPlatform() === 'ios') {
        await StatusBar.setOverlaysWebView({ overlay: true });
        await StatusBar.setStyle({ style: Style.Dark });
        await EdgeToEdge.disable();
      }

      // Register listeners on every native app start
      if (Capacitor.isNativePlatform()) {
        await this.pushService.addListeners();
        // Do NOT call registerNotifications() here —
        // request permission at the right UX moment (see Step 3)
      }
    });
  }
}
```

---

## Step 3: Register After User Opt-in

Request permission and register the device token at a meaningful UX moment — typically right after a successful login or during an onboarding opt-in screen:

```typescript
// In your auth service or login page
async onLoginSuccess() {
  if (Capacitor.isNativePlatform()) {
    try {
      await this.pushService.registerNotifications();
      console.log('Push notifications enabled');
    } catch {
      // User declined — do not block the flow
      console.log('User declined push notifications');
    }
  }
}
```

---

## Step 4: Handle Notification Events

Open `push-notification.service.ts` and fill in the TODO comments inside `addListeners()`:

```typescript
// 1. On successful registration: save token to backend
PushNotifications.addListener('registration', token => {
  this.saveTokenToBackend(token.value); // implement this
});

// 2. On registration error: log to Crashlytics
PushNotifications.addListener('registrationError', err => {
  console.error('Push registration error:', err.error);
});

// 3. Notification received while app is open: show in-app UI
PushNotifications.addListener('pushNotificationReceived', notification => {
  console.log('Received:', notification);
  // e.g. show an ion-toast or trigger a signal update
});

// 4. User tapped a notification: navigate to relevant screen
PushNotifications.addListener('pushNotificationActionPerformed', notification => {
  console.log('Tapped:', notification);
  // e.g. this.router.navigateByUrl(notification.notification.data.route);
});
```

---

## Rules

- `addListeners()` MUST be called on every app start (before the user interacts with the app), but only on native platforms.
- `registerNotifications()` MUST NOT be called on app start — call it at a user-triggered opt-in moment to avoid Android 13+ permission dialog appearing too early.
- The service MUST live in `core/device/` — it is a singleton Capacitor plugin abstraction.
- ALWAYS wrap native calls with `Capacitor.isNativePlatform()` — push notifications are not available on web.
