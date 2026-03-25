# Capacitor Config Reference

## When to Use

Use this template as the starting point for `capacitor.config.ts` in any Ionic + Angular + Capacitor project.

## Full Example

```typescript
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.example.app',
  appName: 'MyApp',
  webDir: 'www',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    PushNotifications: {
      presentationOptions: ['badge', 'sound', 'alert']
    },
    StatusBar: {
      style: 'dark',
      backgroundColor: '#000000'
    },
    Keyboard: {
      resizeOnFullScreen: false
    },
    EdgeToEdge: {
      backgroundColor: '#000000',
    },
  }
};

export default config;
```

## Key Fields

| Field | Purpose |
|-------|---------|
| `appId` | Unique bundle identifier (reverse-DNS). Must match iOS/Android project. |
| `appName` | Human-readable app name. |
| `webDir` | Output folder from Angular build (`www` for Ionic). |
| `server.androidScheme` | Use `https` to avoid mixed-content warnings on Android. |
| `plugins.PushNotifications.presentationOptions` | Controls how push notifications are shown when app is in foreground. |
| `plugins.Keyboard.resizeOnFullScreen` | Prevents layout jumps when the keyboard opens. |

## Rules

- Run `npx cap sync` after changing this file to propagate settings to native projects.
- `appId` must not change after the app is published — it is the unique store identifier.
