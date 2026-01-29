# Complete Angular + Ionic Project Structure Guide

## The Scope Rule Philosophy

**"Scope determines structure"** - This is the fundamental principle that guides all architectural decisions.

- If code is used by **1 feature** → Keep it **local** in that feature
- If code is used by **2+ features** → Move it to **shared**
- If code is **app-wide singleton** → Place it in **core**

## Full Project Structure

```
src/
├── app/
│   ├── core/                          # Singleton services & app-wide concerns
│   │   ├── services/                  # Core plugins Services
│   │   │   ├── auth.service.ts
│   │   │   ├── api.service.ts
│   │   │   ├── push-notification.service.ts
│   │   │   ├── network.service.ts
│   │   │   ├── storage.service.ts
│   │   ├── interceptors/
│   │   │   ├── app-http.interceptor.ts
│   │   │   └── crashlytics-error-handler.interceptor.ts
│   │   └── guards/
│   │       └── auth.guard.ts          # Global auth guard
│   │       └── unauth.guard.ts        # Global unauth guard
│   │
│   ├── shared/                        # ONLY for 2+ (tabs | menu | feature)/pages usage
│   │   ├── components/
│   │   │   ├── headers/
│   │   │   │   ├── header-back.ts
│   │   │   │   └── header-main.ts
│   │   │   ├── modals/
│   │   │   │   └── confirmation-modal.ts
│   │   │   └── cards/
│   │   │       └── info-card.ts
│   │   ├── services/
│   │   │   └── data-sync.service.ts
│   │   ├── guards/
│   │   │   └── auth.guard.ts          # Shared route guards
│   │   ├── pipes/
│   │   │   └── date-format.pipe.ts
│   │   ├── directives/
│   │   │   └── auto-focus.directive.ts
│   │   ├── signals/
│   │   │   └── user.store.ts
│   │   └── constants/
│   │       ├── database.constants.ts
│   │       └── api.constants.ts
│   │
│   ├── pages/
│   │   ├── start-app/                 # Onboarding & authentication
│   │   │   ├── login/
│   │   │   │   ├── login.page.ts
│   │   │   │   ├── login.page.html
│   │   │   │   └── login.page.scss
│   │   │   ├── register/
│   │   │   │   └── register.page.ts
│   │   │   └── start-app.routes.ts
│   │   │
│   │   ├── in-app/                    # Logged-in experience
│   │   │   ├── tabs/                  # Main tab-based navigation (tabs only usage)
│   │   │   │   ├── home/
│   │   │   │   │   ├── home.page.ts
│   │   │   │   │   └── components/    # Tab-specific components
│   │   │   │   │       └── home-card.component.ts      # Used ONLY by home page
│   │   │   │   ├── profile/
│   │   │   │   │   └── profile.page.ts
│   │   │   │   ├── tabs.routes.ts
│   │   │   │   ├── tabs.page.ts
│   │   │   │   ├── tabs.page.html
│   │   │   │   └── tabs.page.scss
│   │   │   │   
│   │   │   ├── menu/                  # Side menu navigation for pages (menu only usage)
│   │   │   │   ├── dashboard/
│   │   │   │   │   └── dashboard.page.ts
│   │   │   │   ├── settings/
│   │   │   │   │   └── settings.page.ts
│   │   │   │   └── menu.routes.ts
│   │   │   │   
│   │   │   ├── features/               # Pages don't included on menu and tabs 
│   │   │   │   ├── payment/
│   │   │   │   │   ├── payment.page.ts
│   │   │   │   │   └── components/
│   │   │   │   │       └── payment-card.component.ts
│   │   │   │   ├── withdraw/
│   │   │   │   │   └── withdraw.page.ts
│   │   │   │   └── features.routes.ts
│   │   │   └── in-app.routes.ts
│   │   │
│   │   └── out-app/                   # Utility pages
│   │       ├── not-found/
│   │       │   └── not-found.page.ts
│   │       ├── maintenance/
│   │       │    └── maintenance.page.ts
│   │       └── out-app.routes.ts
│   │
│   ├── app.component.ts
│   ├── app.config.ts
│   └── app.routes.ts
│
└── main.ts                        # Bootstrap
```

## Decision Tree for Component Placement

```
┌─────────────────────────────────────┐
│   New Component/Service Created     │
└─────────────────┬───────────────────┘
                  │
                  ▼
         ┌────────────────────┐
         │ How many features  │
         │   will use this?   │
         └────────┬───────────┘
                  │
        ┌─────────┼─────────┐
        │         │         │
        ▼         ▼         ▼
    ┌───────┐ ┌───────┐ ┌──────────┐
    │  ONE  │ │ TWO+  │ │ APP-WIDE │
    │feature│ │features│ │ SINGLETON│
    └───┬───┘ └───┬───┘ └─────┬────┘
        │         │           │
        ▼         ▼           ▼
  ┌──────────┐ ┌────────┐ ┌───────┐
  │  LOCAL   │ │ SHARED │ │ CORE  │
  │in feature│ │  dir   │ │  dir  │
  └──────────┘ └────────┘ └───────┘
```

## Examples by Category

### 1. Pages Structure

```typescript
// pages/in-app/tabs/home/home.ts
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
// shared/components/headers/header-back.ts
// ✅ Used by multiple pages → Goes in shared
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
// core/services/auth.service.ts
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
