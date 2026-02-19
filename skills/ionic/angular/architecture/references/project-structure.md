# Complete Angular + Ionic Project Structure Guide

## The Scope Rule Philosophy

**"Scope determines structure"** - This is the fundamental principle that guides all architectural decisions.

- If code is used by **1 page only** → Keep it **local** in that page
- If a component is reused by **some pages inside the same feature** → place it in `features/<feature>/components/`
- If a component is used by **2+ pages or features** → move it to `shared/ui/`
- If code is **app-wide infrastructure singleton** (auth, guards, device plugins) → place it in `core/`

## Full Project Structure

```
src/
├── app/
│   ├── core/                          # Infrastructure (Singletons & Global)
│   │   ├── auth/
│   │   │   ├── guards/
│   │   │   │   ├── auth.guard.ts
│   │   │   │   └── public.guard.ts
│   │   │   └── auth.service.ts
│   │   ├── http/
│   │   │   ├── app-http.interceptor.ts
│   │   │   └── crashlytics-error-handler.interceptor.ts
│   │   ├── storage/
│   │   │   └── storage.service.ts
│   │   └── device/
│   │       ├── network.service.ts
│   │       └── push-notification.service.ts
│   │
│   ├── shared/                        # Cross-feature UI + utilities
│   │   ├── ui/                        # Components used by 2+ pages/features
│   │   │   ├── headers/
│   │   │   │   ├── header-back.ts
│   │   │   │   └── header-main.ts
│   │   │   ├── modals/
│   │   │   │   └── confirmation-modal.ts
│   │   │   └── cards/
│   │   │       └── info-card.ts
│   │   ├── utils/
│   │   │   ├── ui.service.ts
│   │   │   └── router.service.ts
│   │   ├── pipes/
│   │   │   └── date-format.pipe.ts
│   │   ├── directives/
│   │   │   └── auto-focus.directive.ts
│   │   └── constants/
│   │       ├── database.constants.ts
│   │       └── api.constants.ts
│   │
│   ├── features/                      # Business logic by domain
│   │   ├── user/
│   │   │   ├── models/
│   │   │   ├── data/
│   │   │   └── state/
│   │   └── payments/
│   │       ├── models/
│   │       ├── data/
│   │       ├── components/            # Reused in payments feature pages
│   │       │   └── payment-form.ts
│   │       └── payments.service.ts
│   │
│   ├── pages/
│   │   ├── start-app/
│   │   │   ├── login/
│   │   │   ├── register/
│   │   │   └── start-app.routes.ts
│   │   ├── in-app/
│   │   │   ├── tabs/
│   │   │   ├── menu/
│   │   │   ├── features/
│   │   │   └── in-app.routes.ts
│   │   └── out-app/
│   │       ├── not-found/
│   │       ├── maintenance/
│   │       └── out-app.routes.ts
│   │
│   ├── app.component.ts
│   ├── app.config.ts
│   └── app.routes.ts
│
└── main.ts
```

## Decision Tree for Component Placement

```
┌─────────────────────────────────────┐
│   New Component/Service Created     │
└─────────────────┬───────────────────┘
                  │
                  ▼
         ┌────────────────────┐
        │ How many pages or  │
        │ features use this? │
         └────────┬───────────┘
                  │
        ┌─────────┼─────────┐
        │         │         │
        ▼         ▼         ▼
    ┌───────┐ ┌───────┐ ┌──────────┐
    │  ONE  │ │ TWO+  │ │ APP-WIDE │
    │ page  │ │pages/ │ │ SINGLETON│
    │       │ │feature│ │          │
    └───┬───┘ └───┬───┘ └─────┬────┘
        │         │           │
        ▼         ▼           ▼
  ┌──────────┐ ┌──────────┐ ┌───────┐
  │  LOCAL   │ │SHARED/UI │ │ CORE  │
  │in page   │ │or FEATURE│ │  dir  │
  └──────────┘ └──────────┘ └───────┘
```

## Examples by Category

### 1. Pages Structure

```typescript
// pages/in-app/tabs/home/home.page.ts
@Component({
  selector: 'app-home',
  imports: [IonicModule, HeaderMainComponent],
  template: `
    <app-header-main [title]="'Home'" />
    <ion-content>
      <!-- Home content -->
    </ion-content>
  `
})
export class HomePage { }
```

### 2. Local Feature Components

```typescript
// pages/in-app/tabs/home/components/featured-card.ts
// ✅ Used ONLY in home page → Stays local
@Component({
  selector: 'app-featured-card',
  imports: [IonicModule],
  template: `<ion-card>...</ion-card>`
})
export class FeaturedCardComponent { }
```

### 3. Shared Components

```typescript
// shared/ui/headers/header-back.ts
// ✅ Used by multiple pages/features → Goes in shared/ui
@Component({
  selector: 'app-header-back',
  imports: [IonicModule],
  template: `
    <ion-header>
      <ion-toolbar>
        <ion-button (click)="goBack()">
          <ion-icon name="chevron-back"></ion-icon>
        </ion-button>
        <ion-title>{{ title() }}</ion-title>
      </ion-toolbar>
    </ion-header>
  `
})
export class HeaderBackComponent {
  readonly title = input<string>('');
  private readonly navController = inject(NavController);
  
  goBack() {
    this.navController.back();
  }
}
```

### 4. Core Services

```typescript
// core/auth/auth.service.ts
// ✅ Singleton used throughout app → Goes in core
@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly http = inject(HttpClient);
  private readonly _user = signal<User | null>(null);
  
  readonly user = this._user.asReadonly();
  readonly isAuthenticated = computed(() => !!this._user());
  
  async login(credentials: LoginDto) {
    const response = await this.http.post('/auth/login', credentials);
    this._user.set(response.user);
  }
}
```

## Naming Conventions

### Files

- **Components**: `feature-name.ts` (no `.component` suffix)
- **Feature components**: `features/<feature>/components/feature-name.ts` (when reused in same feature pages)
- **Shared UI components**: `shared/ui/<category>/feature-name.ts` (when reused in 2+ pages/features)
- **Services**: `feature-name.service.ts`
- **Guards**: `feature-name.guard.ts`
- **Pipes**: `pipe-name.pipe.ts`
- **Models**: `model-name.model.ts`

### Selectors

- **Pages**: `app-page-name`
- **Components**: `app-component-name`
- Prefix all selectors with `app-` for consistency

### Classes

- **Components**: `FeatureNameComponent`
- **Services**: `FeatureNameService`
- **Guards**: `FeatureNameGuard`
- **Pipes**: `PipeNamePipe`

## Routing Structure

```typescript
// app.routes.ts
import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'start-app',
    pathMatch: 'full',
  },
  {
    path: 'start-app',
    loadChildren: () => import('./pages/start-app/start-app.routes').then(m => m.START_APP_ROUTES),
  },
  {
    path: 'in-app',
    loadChildren: () => import('./pages/in-app/in-app.routes').then(m => m.IN_APP_ROUTES),
  },
  {
    path: 'out-app',
    loadChildren: () => import('./pages/out-app/out-app.routes').then(m => m.OUT_APP_ROUTES),
  },
  {
    path: '**',
    redirectTo: 'out-app/not-found',
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

## Path Aliases Setup

```json
// tsconfig.json
{
  "compilerOptions": {
    "baseUrl": "./",
    "paths": {
      "@pages/*": ["src/app/pages/*"],
      "@shared/*": ["src/app/shared/*"],
      "@core/*": ["src/app/core/*"]
    }
  }
}
```

## Common Mistakes to Avoid

❌ **Putting everything in shared** - Only use shared for 2+ features
❌ **Using NgModules** - Angular 20 uses standalone components only
❌ **Deep nesting** - Use path aliases to avoid `../../../../`
❌ **Mixing concerns** - Keep business logic in services, not components
❌ **Using `any` type** - Always use proper TypeScript types
❌ **Constructor injection** - Use `inject()` function instead

## Summary Checklist

When creating a new component/service, ask:

1. ✅ How many features use this?
   - 1 feature → Local placement
   - 2+ features → Shared
   - App-wide → Core

2. ✅ Is it standalone? (It must be!)

3. ✅ Using modern patterns?
   - `input()` not `@Input()`
   - `output()` not `@Output()`
   - `inject()` not `constructor()`
   - Signals not observables (where appropriate)

4. ✅ Proper naming?
   - No unnecessary suffixes
   - Descriptive of business function

5. ✅ Using path aliases?
   - `@pages`, `@shared`, `@core`

Follow this structure religiously and your codebase will be clean, scalable, and immediately understandable!
