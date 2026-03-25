# Ionic Storage Configuration

## When to Use

Use Ionic Storage (`@ionic/storage-angular`) as the persistent key-value store for user preferences, tokens, and local app data across iOS, Android, and web.

## Required Packages

```bash
npm install @ionic/storage-angular
```

## Configuration in `main.ts`

```typescript
import { provideIonicAngular } from '@ionic/angular/standalone';
import { IonicStorageModule } from '@ionic/storage-angular';
import { importProvidersFrom } from '@angular/core';
import { DB_INDEX_NAME, DB_STORE_NAME } from '@shared/constants/database.constants';

bootstrapApplication(AppComponent, {
  providers: [
    provideIonicAngular({
      innerHTMLTemplatesEnabled: true,
      sanitizerEnabled: true,
    }),
    importProvidersFrom(
      IonicStorageModule.forRoot({
        name: DB_INDEX_NAME,
        storeName: DB_STORE_NAME,
      })
    ),
  ],
});
```

## Database Constants

Create in `src/app/shared/constants/database.constants.ts`:

```typescript
export const DB_INDEX_NAME = '__myapp_db';
export const DB_STORE_NAME = '__myapp_store';
export const DB_TOKEN_NAME = '__myapp_token';
```

## Storage Service

Place at `src/app/core/storage/storage.service.ts`:

```typescript
import { Storage } from '@ionic/storage-angular';
import { inject, Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class StorageService {
  private readonly storage = inject(Storage);
  private initialized = false;

  async init(): Promise<void> {
    if (!this.initialized) {
      await this.storage.create();
      this.initialized = true;
    }
  }

  async set(key: string, value: any): Promise<void> {
    await this.init();
    await this.storage.set(key, value);
  }

  async get<T>(key: string): Promise<T | null> {
    await this.init();
    return await this.storage.get(key);
  }

  async remove(key: string): Promise<void> {
    await this.init();
    await this.storage.remove(key);
  }

  async clear(): Promise<void> {
    await this.init();
    await this.storage.clear();
  }
}
```

## Why These Settings

- `innerHTMLTemplatesEnabled: true` — allows modifying innerHTML CSS in Ionic components.
- `sanitizerEnabled: true` — keeps security enabled while allowing CSS modifications.

## Rules

- ALWAYS call `await this.init()` before any `get`/`set` — Storage must be created first.
- NEVER call `storage.get()` in a constructor — storage is not initialized synchronously.
- Place `StorageService` in `core/storage/` — it is a singleton infrastructure service.
