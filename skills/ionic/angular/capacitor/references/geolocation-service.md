# Geolocation Service

## When to Use

Use this service to request GPS location, check/request permissions, and watch position changes on iOS and Android.

## Required Packages

```bash
npm install @capacitor/geolocation
npx cap sync
```

**iOS** — add to `Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show nearby results.</string>
```

**Android** — add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## Location

`src/app/core/device/geolocation.service.ts`

## Implementation

```typescript
import { Injectable, inject, signal } from '@angular/core';
import { Geolocation, Position, PositionOptions } from '@capacitor/geolocation';
import { AlertController } from '@ionic/angular';

@Injectable({
  providedIn: 'root',
})
export class GeolocationService {
  private readonly alertController = inject(AlertController);
  readonly position = signal<Position | null>(null);

  async getCurrentPosition() {
    try {
      const coordinates = await Geolocation.getCurrentPosition();
      this.position.set(coordinates);
    } catch (error) {
      console.error('Error getting location:', error);
    }
  }

  async initGeolocation(): Promise<void> {
    try {
      const result = await Geolocation.checkPermissions();
      if (result.location === 'denied') {
        await this.showAlertPermissions();
        return;
      }

      const permission = await this.requestGeolocationPermission();
      if (permission === 'granted') {
        this.getCurrentPosition();
        this.watchPosition();
      }
    } catch (error) {
      console.error('Error checking geolocation permissions:', error);
    }
  }

  async requestGeolocationPermission() {
    try {
      const result = await Geolocation.requestPermissions();
      return result.location;
    } catch (error) {
      console.error('Error requesting geolocation permissions:', error);
      return 'denied';
    }
  }

  watchPosition() {
    const options: PositionOptions = {
      enableHighAccuracy: true,
      minimumUpdateInterval: 5000,
      maximumAge: 0,
    };

    Geolocation.watchPosition(options, (position?: Position | null) => {
      if (position) {
        this.position.set(position);
      }
    });
  }

  private async showAlertPermissions(): Promise<void> {
    const alert = await this.alertController.create({
      header: 'Location permissions denied',
      message: 'To use this feature, enable location permissions in your device settings.',
      buttons: ['OK'],
    });
    await alert.present();
  }
}
```

## Rules

- Place in `core/device/` — it is a Capacitor plugin abstraction singleton.
- ALWAYS call `checkPermissions` before `requestPermissions` — avoid prompting if already granted.
- Use `signal<Position | null>` to expose the current position reactively; consume with `computed()` in components.
- Expose `watchPosition` only when live tracking is needed — it drains battery.
