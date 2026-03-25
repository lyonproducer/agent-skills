# Network Service

## When to Use

Use this service to monitor connectivity changes and show an online/offline toast to the user. Initialize it once in `app.component.ts`.

## Required Packages

```bash
npm install @capacitor/network
npx cap sync
```

## Location

`src/app/core/device/network.service.ts`

## Implementation

```typescript
import { Injectable, inject, signal } from '@angular/core';
import { ConnectionStatus, Network } from '@capacitor/network';
import { ToastController } from '@ionic/angular';

export enum NetworkStatus {
  offline = 0,
  online = 1,
}

@Injectable({
  providedIn: 'root',
})
export class NetworkService {
  private readonly toastController = inject(ToastController);
  readonly status = signal<NetworkStatus>(NetworkStatus.offline);

  async initializeNetworkEvents() {
    const current = await this.logCurrentNetworkStatus();
    this.setNetwork(current);

    Network.addListener('networkStatusChange', (networkStatus: ConnectionStatus) => {
      this.setNetwork(networkStatus);
    });
  }

  setNetwork(networkStatus: ConnectionStatus) {
    const status = networkStatus.connected ? NetworkStatus.online : NetworkStatus.offline;
    this.status.set(status);
  }

  logCurrentNetworkStatus() {
    return Network.getStatus();
  }

  async updateNetworkStatus(status: NetworkStatus) {
    const connection = status === NetworkStatus.offline ? 'offline' : 'online';
    try {
      const toast = await this.toastController.create({
        color: status === NetworkStatus.offline ? 'danger' : 'success',
        message: `Currently ${connection}`,
        duration: 3000,
        position: 'top',
      });
      toast.present();
    } catch (error) {
      console.error('Error showing network toast', error);
    }
  }
}
```

## Usage in `app.component.ts`

```typescript
// Inside platform.ready():
this.networkService.initializeNetworkEvents();
```

## Consuming in Components

```typescript
private readonly networkService = inject(NetworkService);
readonly isOffline = computed(() => this.networkService.status() === NetworkStatus.offline);
```

## Rules

- Place in `core/device/` — it is a Capacitor plugin abstraction singleton.
- Call `initializeNetworkEvents()` once in `app.component.ts` after `platform.ready()`.
- Expose `status` as a `signal` so components can react with `computed()` without additional subscriptions.
