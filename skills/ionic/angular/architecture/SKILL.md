---
name: ionic-angular-architecture
description: >
  Ionic + Angular architecture: Scope Rule, Screaming Architecture, project structure, routing patterns.
  Trigger: When architecting Ionic apps, organizing project structure, or applying Scope Rule to Angular + Ionic projects.
metadata:
  author: Lyon Incode
  version: "2.0"
---

## When to Use

Load this skill when:
- Architecting Angular + Ionic mobile applications
- Organizing project structure with Scope Rule principles
- Setting up Ionic routing (tabs, menu, modal navigation)
- Applying Screaming Architecture to mobile apps
- Deciding component/service placement

## The Scope Rule - Your Unbreakable Law

**"Scope determines structure"**

- Code used by 2+ pages or features → MUST go in `shared/ui/`
- Component used by the same feature across some pages → MUST go in `features/<feature>/components/`
- Code used by 1 tab/page only → MUST stay local in that tab/page folder
- **NO EXCEPTIONS** - This rule is absolute and non-negotiable

## Screaming Architecture for Angular + Ionic

Your structures must IMMEDIATELY communicate what the application does:

- Tab/page names must describe business functionality, not technical implementation
- Directory structure must separate concerns clearly: `core/` (infrastructure), `features/` (business logic), `pages/` (routing/orchestration), `shared/` (cross-cutting UI/utilities)
- Keep routing blocks explicit in `pages/`: `start-app/`, `in-app/`, `out-app/`
- Main tab/page components MUST have the same name as their folder

---

## Ionic + Angular Project Structure

```
src/
├── app/
│   ├── core/                          # Infrastructure (Singletons & Global)
│   │   ├── auth/                      # Session logic, tokens and global guards
│   │   │   ├── guards/
│   │   │   │   ├── auth.guard.ts      # Global auth guard
│   │   │   │   └── public.guard.ts    # Global unauth guard
│   │   │   └── auth.service.ts
│   │   ├── http/                      # Interceptors and base API client
│   │   │   ├── app-http.interceptor.ts
│   │   │   └── crashlytics-error-handler.interceptor.ts
│   │   ├── storage/                   # Capacitor wrappers (Preferences/SQLite)
│   │   │   └── storage.service.ts
│   │   ├── device/                    # Capacitor plugin abstractions
│   │   │   ├── network.service.ts
│   │   │   └── push-notification.service.ts
│   │   └── error-handler/             # Sentry, Crashlytics and Logs
│   │
│   ├── shared/                        # UI Dumb Components (Presentational) & Utilities
│   │   ├── ui/                        # ONLY for components used in 2+ features/pages
│   │   │   ├── headers/
│   │   │   │   ├── header-back.ts
│   │   │   │   └── header-main.ts
│   │   │   ├── modals/
│   │   │   │   └── confirmation-modal.ts
│   │   │   └── cards/
│   │   │       └── info-card.ts
│   │   ├── pipes/
│   │   │   └── date-format.pipe.ts
│   │   ├── directives/
│   │   │   └── auto-focus.directive.ts
│   │   ├── utils/                     # Shared utility services (no business domain)
│   │   │   ├── ui.service.ts          # Centralized Ionic UI controllers (alert, toast, loading)
│   │   │   └── router.service.ts      # Router utilities
│   │   └── constants/
│   │       ├── database.constants.ts
│   │       └── api.constants.ts
│   │
│   ├── features/                      # THE HEART: Business Logic by Domain
│   │   ├── user/
│   │   │   ├── models/                # Interfaces/models and Use Cases
│   │   │   ├── data/                  # Repositories and Mappers (API calls)
│   │   │   └── state/                 # user.store.ts (Signals)
│   │   └── payments/
│   │       ├── models/                # payment.model.ts
│   │       ├── data/                  # Repositories and Mappers
│   │       ├── components/            # Smart components used by payments feature AND related pages
│   │       │   └── payment-form.component.ts
│   │       └── payments.service.ts    # Facade: pages only talk to this service
│   │
│   ├── pages/                         # Orchestrators (Smart Components & Routing)
│   │   ├── start-app/                 # Block: Onboarding & Authentication
│   │   │   ├── login/
│   │   │   │   ├── login.page.ts
│   │   │   │   ├── login.page.html
│   │   │   │   └── login.page.scss
│   │   │   ├── register/
│   │   │   │   └── register.page.ts
│   │   │   └── start-app.routes.ts
│   │   │
│   │   ├── in-app/                    # Block: Logged-in experience
│   │   │   ├── tabs/                  # Main tab-based navigation (tabs only usage)
│   │   │   │   ├── home/
│   │   │   │   │   ├── home.page.ts
│   │   │   │   │   └── components/    # Tab-specific components
│   │   │   │   │       └── home-card.component.ts    # Used ONLY by home page
│   │   │   │   ├── profile/
│   │   │   │   │   └── profile.page.ts
│   │   │   │   ├── tabs.routes.ts
│   │   │   │   ├── tabs.page.ts
│   │   │   │   ├── tabs.page.html
│   │   │   │   └── tabs.page.scss
│   │   │   │
│   │   │   ├── menu/                  # Side menu navigation (menu only usage)
│   │   │   │   ├── dashboard/
│   │   │   │   │   └── dashboard.page.ts
│   │   │   │   ├── settings/
│   │   │   │   │   └── settings.page.ts
│   │   │   │   └── menu.routes.ts
│   │   │   │
│   │   │   ├── features/              # Pages not included in menu or tabs
│   │   │   │   ├── payment/
│   │   │   │   │   └── payment.page.ts    # Uses components from features/payments/components
│   │   │   │   ├── withdraw/
│   │   │   │   │   └── withdraw.page.ts
│   │   │   │   └── features.routes.ts
│   │   │   └── in-app.routes.ts
│   │   │
│   │   └── out-app/                   # Block: Utility/public pages
│   │       ├── not-found/
│   │       │   └── not-found.page.ts
│   │       ├── maintenance/
│   │       │   └── maintenance.page.ts
│   │       └── out-app.routes.ts
│   │
│   ├── app.component.ts               # Plugin initialization (Push, DeepLinks, StatusBar)
│   ├── app.config.ts                  # Global providers (Routes, HttpClient)
│   └── app.routes.ts                  # Root routing (Lazy loading blocks)
│
└── main.ts                        # Bootstrap
```

### Path Aliases Configuration

Always configure these aliases in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "paths": {
      "@pages/*": ["src/app/pages/*"],
      "@shared/*": ["src/app/shared/*"],
      "@core/*": ["src/app/core/*"],
      "@features/*": ["src/app/features/*"]
    }
  }
}
```

---

## Feature State Pattern (Signal Store)

Each feature domain that requires state management uses a signal-based store placed in `features/<domain>/state/`.

```typescript
// features/user/state/user.store.ts
import { Injectable, signal, computed, inject } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class UserStore {
  private readonly http = inject(HttpClient);

  // Private signals for internal state
  private readonly _state = signal<UserState>({
    items: [],
    loading: false,
    error: null,
  });

  // Public readonly computed values (exposed to UI)
  readonly items = computed(() => this._state().items);
  readonly loading = computed(() => this._state().loading);
  readonly error = computed(() => this._state().error);

  loadItems(): void {
    this._state.update((state) => ({ ...state, loading: true }));
    // Implementation
  }
}
```

**Rules:**
- Private `_state` signal holds the full state object
- Public API is always `computed()` — never expose the writable signal
- State is always updated via `.update()` spreading the previous state
- One store per feature domain — do not share stores across unrelated features

---

## Ionic Routing Patterns

### Tab-Based Navigation

```typescript
// app.routes.ts
import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'login',
    pathMatch: 'full',
  },
  {
    path: '',
    loadChildren: () => import('./pages/start-app/start-app.routes').then(m => m.START_APP_ROUTES),
  },
  {
    path: '',
    loadChildren: () => import('./pages/in-app/in-app.routes').then(m => m.IN_APP_ROUTES),
  },
  {
    path: '',
    loadChildren: () => import('./pages/out-app/out-app.routes').then(m => m.OUT_APP_ROUTES),
  },
  {
    path: '**',
    redirectTo: 'not-found',
  },
];
```

### In-App Routing Pattern

```typescript
// pages/in-app/in-app.routes.ts
import { Routes } from '@angular/router';

export const IN_APP_ROUTES: Routes = [
  {
    path: '',
    redirectTo: 'tabs',
    pathMatch: 'full',
  },
  {
    path: 'tabs',
    loadChildren: () => import('./tabs/tabs.routes').then(m => m.tabsRoutes),
  },
  {
    path: 'menu',
    loadChildren: () => import('./menu/menu.routes').then(m => m.menuRoutes),
  },
];
```

### Tab-Based Navigation

```typescript
// pages/in-app/tabs/tabs.routes.ts
import { Routes } from '@angular/router';
import { TabsPage } from './tabs.page';

export const tabsRoutes: Routes = [
  {
    path: '',
    component: TabsPage,
    children: [
      {
        path: 'home',
        loadComponent: () => import('./home/home.page').then(m => m.HomePage),
      },
      {
        path: 'profile',
        loadComponent: () => import('./profile/profile.page').then(m => m.ProfilePage),
      },
      {
        path: '',
        redirectTo: 'home',
        pathMatch: 'full',
      },
    ],
  },
];
```

**tabs.page.ts:**

```typescript
import { Component } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { TABS } from '@shared/constants/settings';

@Component({
  selector: 'app-tabs',
  imports: [IonicModule],
  templateUrl: './tabs.page.html',
})
export class TabsPage {
  readonly tabsItems = TABS;
}
```

**tabs.page.html:**

```html
<ion-tabs>
  <ion-tab-bar slot="bottom">
    @for (item of tabsItems; track $index) {
      <ion-tab-button [tab]="item.tab">
        <ion-icon aria-hidden="true" [name]="item.icon"></ion-icon>
        <ion-label>{{ item.title }}</ion-label>
      </ion-tab-button>
    }
  </ion-tab-bar>
</ion-tabs>
```

**TABS constant in `src/app/shared/constants/settings.ts`:**

```typescript
export interface ITabItem {
  tab: string;
  title: string;
  icon: string;
}

export const TABS: ITabItem[] = [
  {
    tab: 'home',
    title: 'Home',
    icon: 'home-outline',
  },
  {
    tab: 'library',
    title: 'Library',
    icon: 'library-outline',
  },
  {
    tab: 'my-space',
    title: 'Space',
    icon: 'planet-outline',
  },
  {
    tab: 'social',
    title: 'Social',
    icon: 'people-outline',
  },
];
```

### Modal Navigation

```typescript
import { Component, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { MyModalComponent } from '@shared/ui/modals/my-modal';

@Component({
  selector: 'app-page',
  imports: [IonicModule],
  template: `<ion-button (click)="openModal()">Open Modal</ion-button>`,
})
export class MyPage {
  private readonly modalCtrl = inject(ModalController);

  async openModal(): Promise<void> {
    const modal = await this.modalCtrl.create({
      component: MyModalComponent,
    });
    await modal.present();
    const { data, role } = await modal.onWillDismiss();
  }
}
```

---

## Decision Framework

When analyzing component/service placement, you MUST:

1. **Count usage**: Identify exactly how many tabs/pages use the component
2. **Apply the Scope Rule**: 
   - 1 tab/page = local placement in that tab/page folder
   - Component used by 2+ pages/features = `shared/ui/`
   - Component reused inside a single feature across related pages = `features/<feature>/components/`
   - App-wide singleton (auth, guards) = `core/auth/`
   - Capacitor plugin abstraction = `core/device/`
   - Utility service (no business domain) = `shared/utils/`
3. **Document decision**: Explain WHY the placement was chosen

### Placement Examples

| Component/Service Type | Used In | Placement | Reason |
|------------------------|---------|-----------|--------|
| `ProductCard` | Home tab only | `pages/in-app/tabs/home/components/` | Scope Rule: 1 tab |
| `HeaderBack` | Home, Profile, Settings | `shared/ui/headers/` | Scope Rule: 3+ tabs |
| `AuthService` | Entire app | `core/auth/` | Singleton, global auth concern |
| `NetworkService` | Entire app | `core/device/` | Capacitor plugin abstraction |
| `PushNotificationService` | Entire app | `core/device/` | Capacitor plugin abstraction |
| `UiService` | Entire app | `shared/utils/` | Utility service, no business domain |
| `RouterService` | Entire app | `shared/utils/` | Utility service, no business domain |
| `DateFormatPipe` | 2+ tabs | `shared/pipes/` | Scope Rule: 2+ tabs |
| `PaymentForm` | Payments feature + payment page | `features/payments/components/` | Feature-specific smart component |
| `PaymentsService` | Pages consuming payments | `features/payments/` | Domain facade service |
| `PaymentModel` | Payments feature | `features/payments/models/` | Domain model/interface |
| `user.store.ts` | User feature | `features/user/state/` | Feature-specific signal store |

---

## Quality Checklist

Before finalizing any architectural decision:

1. ✅ **Scope verification**: Correctly counted tab/page usage?
2. ✅ **Navigation pattern**: Using tabs, menu, or modal navigation appropriately?
3. ✅ **Naming validation**: Do names match tabs/pages and follow conventions?
4. ✅ **Lazy loading**: All routes using `loadComponent()` or `loadChildren()`?
5. ✅ **Type safety**: No `any` types?
6. ✅ **File naming**: No `.component`, `.service`, `.module` suffixes?

---

## Anti-Patterns

### Don't: Put Business Logic in Pages

```typescript
// ❌ WRONG - API calls and domain logic inside a page
// pages/in-app/features/payment/payment.page.ts
export class PaymentPage {
  async pay() {
    const result = await this.http.post('/api/payments', data); // Direct API call from page
    // mapping, validation, error handling... all here
  }
}

// ✅ CORRECT - Page delegates to a feature facade
// features/payments/payments.service.ts  ← business logic lives here
// pages/in-app/features/payment/payment.page.ts
export class PaymentPage {
  private readonly paymentsService = inject(PaymentsService);
  async pay() {
    await this.paymentsService.processPayment(data); // Page only orchestrates
  }
}
```

### Don't: Confuse `features/` (domain) with `pages/in-app/features/` (routing)

```typescript
// src/app/features/          ← Domain layer: business logic, models, state, repositories
// src/app/pages/in-app/features/  ← Routing layer: pages NOT in tabs or menu

// ❌ WRONG - Putting page-only components in the domain features folder
src/app/features/payments/components/payment-page-header.ts  // Only used by payment.page

// ✅ CORRECT - Page-only components stay local to their page
src/app/pages/in-app/features/payment/components/payment-page-header.ts

// ✅ CORRECT - Smart components reused by feature AND pages go in the feature folder
src/app/features/payments/components/payment-form.component.ts
```

### Don't: Put Capacitor Plugin Wrappers Outside `core/device/`

```typescript
// ❌ WRONG - Capacitor logic scattered in pages or shared services
// pages/in-app/tabs/home/home.page.ts
const net = Network.getStatus(); // Direct plugin call in page

// ✅ CORRECT - Abstract Capacitor plugins in core/device/
// core/device/network.service.ts  ← single abstraction point
// If you change the plugin, you only touch one file
```

### Don't: Violate Scope Rule

```typescript
// ❌ WRONG - Component used in 3 tabs but placed locally
pages/in-app/tabs/home/components/shared-card.ts  // Used in home, profile, settings

// ✅ CORRECT
shared/ui/cards/shared-card.ts
```

### Don't: Mix Navigation Patterns

```typescript
// ❌ WRONG - Don't mix tabs and menu in same route level
{
  path: 'tabs',
  children: [...],
}
{
  path: 'menu',
  children: [...],
}

// ✅ CORRECT - Choose one primary navigation pattern
{
  path: 'tabs',
  children: [...], // All main navigation here
}
```

---

## Resources

- [Ionic Angular Documentation](https://ionicframework.com/docs/angular/overview)
- [Ionic Routing Guide](https://ionicframework.com/docs/angular/navigation)
- [Angular Routing](https://angular.dev/guide/routing)

---

**Remember**: You are the guardian of clean, scalable Angular + Ionic architecture. Every decision must follow the Scope Rule and result in code that immediately communicates what the app does (Screaming Architecture).
