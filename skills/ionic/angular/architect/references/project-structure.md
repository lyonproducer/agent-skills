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
│   ├── pages/                          # All page components
│   │   │
│   │   ├── start-app/                 # 🔐 Onboarding & Authentication
│   │   │   ├── login/
│   │   │   │   ├── login.ts
│   │   │   │   ├── login.html
│   │   │   │   └── login.scss
│   │   │   ├── register/
│   │   │   │   ├── register.ts
│   │   │   │   ├── register.html
│   │   │   │   └── register.scss
│   │   │   ├── verify-account/
│   │   │   ├── forgot-password-email/
│   │   │   ├── forgot-password-code/
│   │   │   └── forgot-password-confirm/
│   │   │
│   │   ├── tabs/                      # 📱 Main App Tabs
│   │   │   ├── home/
│   │   │   │   ├── home.ts
│   │   │   │   ├── home.html
│   │   │   │   ├── home.scss
│   │   │   │   └── components/        # Home-specific components
│   │   │   │       ├── featured-card.ts
│   │   │   │       └── quick-actions.ts
│   │   │   │
│   │   │   ├── search/
│   │   │   │   ├── search.ts
│   │   │   │   └── components/
│   │   │   │       └── search-filters.ts
│   │   │   │
│   │   │   ├── notifications/
│   │   │   │   └── notifications.ts
│   │   │   │
│   │   │   └── profile/
│   │   │       ├── profile.ts
│   │   │       └── components/
│   │   │           ├── edit-information/
│   │   │           ├── edit-email/
│   │   │           ├── edit-password/
│   │   │           └── delete-account/
│   │   │
│   │   └── out-app/                   # 🔧 Utility Pages
│   │       ├── not-found/
│   │       │   └── not-found.ts
│   │       ├── faq/
│   │       │   └── faq.ts
│   │       ├── favorites/
│   │       │   └── favorites.ts
│   │       ├── privacy-policy/
│   │       └── terms-of-service/
│   │
│   ├── shared/                        # 🔄 Shared Across 2+ Features
│   │   ├── components/
│   │   │   ├── headers/
│   │   │   │   ├── header-back.ts     # Used by multiple pages
│   │   │   │   └── header-main.ts
│   │   │   ├── modals/
│   │   │   │   ├── success-heading.ts
│   │   │   │   └── confirmation-dialog.ts
│   │   │   ├── cards/
│   │   │   └── inputs/
│   │   │
│   │   ├── services/
│   │   │   └── [shared-business-logic].service.ts
│   │   │
│   │   ├── guards/
│   │   │   └── feature.guard.ts
│   │   │
│   │   ├── pipes/
│   │   │   ├── format-date.pipe.ts
│   │   │   └── currency-format.pipe.ts
│   │   │
│   │   ├── directives/
│   │   │   └── auto-focus.directive.ts
│   │   │
│   │   └── signals/
│   │       └── shared-state.signal.ts
│   │
│   ├── core/                          # 🏗️ App-Wide Singletons
│   │   ├── services/
│   │   │   ├── auth.service.ts       # Authentication
│   │   │   ├── api.service.ts        # HTTP wrapper
│   │   │   ├── storage.service.ts    # Local storage
│   │   │   ├── network.service.ts    # Network monitoring
│   │   │   ├── router.service.ts     # Router helper
│   │   │   ├── utils.service.ts      # Utilities
│   │   │   ├── screensize.service.ts # Screen size detection
│   │   │   └── push-notification.service.ts  # 🚨 Required for mobile
│   │   │
│   │   ├── interceptors/
│   │   │   ├── app-http.interceptor.ts
│   │   │   └── error.interceptor.ts
│   │   │
│   │   ├── guards/
│   │   │   ├── auth.guard.ts
│   │   │   └── role.guard.ts
│   │   │
│   │   └── models/
│   │       ├── user.model.ts
│   │       └── api-response.model.ts
│   │
│   ├── app.component.ts               # 🚨 Must include iOS config
│   ├── app.component.html
│   ├── app.component.scss
│   ├── app.config.ts                  # App configuration
│   └── app.routes.ts                  # Route definitions
│
├── assets/                            # Static assets
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── environments/                      # Environment configs
│   ├── environment.ts
│   └── environment.prod.ts
│
├── theme/                             # Ionic theming
│   └── variables.scss
│
├── global.scss                        # Global styles
├── index.html
├── main.ts                            # App bootstrap
└── polyfills.ts

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
// pages/tabs/home/home.ts
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
// pages/tabs/home/components/featured-card.ts
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
export const routes: Routes = [
  {
    path: '',
    redirectTo: 'start-app',
    pathMatch: 'full'
  },
  {
    path: 'start-app',
    children: [
      {
        path: 'login',
        loadComponent: () => import('@pages/start-app/login/login').then(m => m.LoginPage)
      },
      {
        path: 'register',
        loadComponent: () => import('@pages/start-app/register/register').then(m => m.RegisterPage)
      }
    ]
  },
  {
    path: 'tabs',
    loadComponent: () => import('@pages/tabs/tabs').then(m => m.TabsPage),
    children: [
      {
        path: 'home',
        loadComponent: () => import('@pages/tabs/home/home').then(m => m.HomePage)
      },
      {
        path: 'profile',
        loadComponent: () => import('@pages/tabs/profile/profile').then(m => m.ProfilePage)
      }
    ]
  }
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
