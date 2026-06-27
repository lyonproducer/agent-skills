# Facade Pattern Example

Complete code example for the Feature-Driven Slicing & State Management Facade pattern. Read this when implementing a feature under `features/<feature-name>/`.

## Mapper (pure functions, NO @Injectable)

```typescript
// features/payments/utils/payments.mapper.ts
import { PaymentDto } from '../models/payment.dto';
import { PaymentModel } from '../models/payment.model';

export function mapPaymentDtoToModel(dto: PaymentDto): PaymentModel {
  return {
    id: dto.id,
    amount: dto.amount,
    status: dto.status,
  };
}
```

## HTTP Service

```typescript
// features/payments/services/payments-http.service.ts
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';
import { PAYMENTS_API } from '@shared/constants/api.constants';
import { mapPaymentDtoToModel } from '../utils/payments.mapper';
import { PaymentModel } from '../models/payment.model';

@Injectable({ providedIn: 'root' })
export class PaymentsHttpService {
  private readonly http = inject(HttpClient);

  async fetchPayments(): Promise<PaymentModel[]> {
    const dtos = await firstValueFrom(this.http.get(PAYMENTS_API.LIST));
    return dtos.map(mapPaymentDtoToModel);
  }
}
```

## Store (Signals, coordinated by Facade)

```typescript
// features/payments/store/payments.store.ts
import { Injectable, signal, computed } from '@angular/core';
import { PaymentModel } from '../models/payment.model';

@Injectable({ providedIn: 'root' })
export class PaymentsStore {
  private readonly _items = signal<PaymentModel[]>([]);
  private readonly _loading = signal(false);

  readonly items = computed(() => this._items());
  readonly loading = computed(() => this._loading());

  setItems(items: PaymentModel[]): void {
    this._items.set(items);
  }

  setLoading(loading: boolean): void {
    this._loading.set(loading);
  }
}
```

## Facade (single contact point for pages)

```typescript
// features/payments/services/payments-facade.service.ts
import { Injectable, inject } from '@angular/core';
import { PaymentsStore } from '../store/payments.store';
import { PaymentsHttpService } from './payments-http.service';
import { PaymentsStorageService } from './payments-storage.service';

@Injectable({ providedIn: 'root' })
export class PaymentsFacade {
  private readonly store = inject(PaymentsStore);
  private readonly http = inject(PaymentsHttpService);
  private readonly storage = inject(PaymentsStorageService);

  // Expose consolidated state as readonly signals
  readonly items = this.store.items;
  readonly loading = this.store.loading;

  async loadPayments(): Promise<void> {
    this.store.setLoading(true);
    try {
      const cached = await this.storage.load();
      if (cached.length) {
        this.store.setItems(cached);
      }
      const items = await this.http.fetchPayments();
      this.store.setItems(items);
      await this.storage.save(items);
    } finally {
      this.store.setLoading(false);
    }
  }
}
```

## Page (injects ONLY the Facade)

```typescript
// pages/in-app/features/payment/payment.page.ts
import { Component, inject } from '@angular/core';
import { PaymentsFacade } from '@features/payments/services/payments-facade.service';

@Component({
  selector: 'app-payment',
  template: `
    @if (facade.loading()) {
      <ion-spinner />
    } @else {
      @for (item of facade.items(); track item.id) {
        <payment-form [payment]="item" />
      }
    }
  `,
})
export class PaymentPage {
  readonly facade = inject(PaymentsFacade);

  constructor() {
    this.facade.loadPayments();
  }
}
```

## User Domain Example (state object pattern)

```typescript
// features/user/models/user-state.model.ts
export interface UserState {
  items: UserModel[];
  loading: boolean;
  error: string | null;
}

// features/user/store/user.store.ts
import { Injectable, signal, computed } from '@angular/core';
import { UserModel } from '../models/user.model';
import { UserState } from '../models/user-state.model';

@Injectable({ providedIn: 'root' })
export class UserStore {
  private readonly _state = signal<UserState>({
    items: [],
    loading: false,
    error: null,
  });

  readonly items = computed(() => this._state().items);
  readonly loading = computed(() => this._state().loading);
  readonly error = computed(() => this._state().error);

  setItems(items: UserModel[]): void {
    this._state.update((state) => ({ ...state, items }));
  }

  setLoading(loading: boolean): void {
    this._state.update((state) => ({ ...state, loading }));
  }
}
```

```typescript
// features/user/services/user-facade.service.ts
import { Injectable, inject } from '@angular/core';
import { UserStore } from '../store/user.store';
import { UserHttpService } from './user-http.service';

@Injectable({ providedIn: 'root' })
export class UserFacade {
  private readonly store = inject(UserStore);
  private readonly http = inject(UserHttpService);

  readonly items = this.store.items;
  readonly loading = this.store.loading;
  readonly error = this.store.error;

  async loadItems(): Promise<void> {
    this.store.setLoading(true);
    try {
      const items = await this.http.fetchUsers();
      this.store.setItems(items);
    } finally {
      this.store.setLoading(false);
    }
  }
}
```
