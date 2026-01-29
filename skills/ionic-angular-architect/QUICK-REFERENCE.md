# Quick Reference Guide

> Fast lookup for Angular 20 + Ionic 8 best practices

## 🚨 The 3 Critical Rules

### Rule 1: Platform Detection
```typescript
// ✅ ALWAYS DO THIS
import { Capacitor } from '@capacitor/core';
if (Capacitor.getPlatform() === 'ios') { }

// ❌ NEVER DO THIS
import { Platform } from '@ionic/angular';
if (this.platform.is('ios')) { }
```

### Rule 2: iOS Status Bar (app.component.ts)
```typescript
if (Capacitor.getPlatform() === 'ios') {
  await StatusBar.setOverlaysWebView({ overlay: true });
  await StatusBar.setStyle({ style: Style.Dark });
  await EdgeToEdge.disable();
}
```

### Rule 3: Push Notifications Service
**Location**: `src/app/core/services/push-notification.service.ts`  
**Template**: See `templates/push-notification.service.ts`

---

## 📁 The Scope Rule Decision Tree

```
How many features use this code?

1 feature  → Place LOCAL in feature folder
2+ features → Place in SHARED directory
App-wide   → Place in CORE directory
```

---

## 🏗️ Project Structure

```
src/app/
├── pages/
│   ├── start-app/     # Auth & onboarding
│   ├── tabs/          # Main app features
│   └── out-app/       # Utility pages
├── shared/            # Used by 2+ features
├── core/              # Singletons
└── app.component.ts   # Root (with iOS config!)
```

---

## 🎯 Component Pattern

```typescript
import { 
  Component, 
  ChangeDetectionStrategy, 
  inject, 
  input, 
  output, 
  signal, 
  computed 
} from '@angular/core';
import { IonicModule } from '@ionic/angular';

@Component({
  selector: 'app-my-component',
  imports: [IonicModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    @if (loading()) {
      <ion-spinner></ion-spinner>
    } @else {
      @for (item of items(); track item.id) {
        <ion-card>{{ item.name }}</ion-card>
      }
    }
  `
})
export class MyComponent {
  // Inputs
  readonly data = input<Type>();
  readonly required = input.required<Type>();
  
  // Outputs
  readonly clicked = output<Type>();
  
  // Services (inject, not constructor)
  private readonly service = inject(MyService);
  
  // State (signals)
  private readonly _loading = signal(false);
  readonly loading = this._loading.asReadonly();
  
  // Derived state (computed)
  readonly items = computed(() => 
    this.data()?.filter(i => i.active) ?? []
  );
  
  // Methods
  handleClick(item: Type) {
    this.clicked.emit(item);
  }
}
```

---

## 🔧 Service Pattern

```typescript
import { Injectable, signal, computed, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class MyService {
  private readonly http = inject(HttpClient);
  
  // Private writable state
  private readonly _state = signal<State>({
    items: [],
    loading: false,
    error: null
  });
  
  // Public readonly accessors
  readonly items = computed(() => this._state().items);
  readonly loading = computed(() => this._state().loading);
  readonly error = computed(() => this._state().error);
  
  // Methods
  async loadItems() {
    this._state.update(s => ({ ...s, loading: true }));
    try {
      const items = await this.http.get<Item[]>('/api/items');
      this._state.update(s => ({ ...s, items, loading: false }));
    } catch (error) {
      this._state.update(s => ({ ...s, error, loading: false }));
    }
  }
}
```

---

## 🔄 Observable → Signal Conversion

```typescript
import { toSignal } from '@angular/core/rxjs-interop';

export class MyComponent {
  private readonly routerService = inject(RouterService);
  
  // Convert Observable to Signal
  readonly currentUrl = toSignal(
    this.routerService.url$, 
    { initialValue: '' }
  );
  
  // Use it in template
  // {{ currentUrl() }}
}
```

---

## 📱 Platform-Specific Code

```typescript
import { Capacitor } from '@capacitor/core';

const platform = Capacitor.getPlatform();

// Check specific platform
if (platform === 'ios') { }
if (platform === 'android') { }
if (platform === 'web') { }

// Check if native
if (Capacitor.isNativePlatform()) {
  // iOS or Android (not web)
}

// Check if plugin available
if (Capacitor.isPluginAvailable('Camera')) {
  // Use camera
}
```

---

## 🎨 Template Syntax

### Control Flow
```html
<!-- If/Else -->
@if (condition()) {
  <p>True</p>
} @else {
  <p>False</p>
}

<!-- For Loop -->
@for (item of items(); track item.id) {
  <ion-card>{{ item.name }}</ion-card>
} @empty {
  <p>No items</p>
}

<!-- Switch -->
@switch (status()) {
  @case ('loading') { <ion-spinner></ion-spinner> }
  @case ('error') { <ion-text color="danger">Error</ion-text> }
  @case ('success') { <ion-text>Success!</ion-text> }
  @default { <p>Unknown</p> }
}
```

### Defer (Lazy Loading)
```html
@defer (on viewport) {
  <app-heavy-component />
} @placeholder {
  <ion-skeleton-text></ion-skeleton-text>
}
```

---

## 🚫 Common Mistakes to Avoid

| ❌ Don't | ✅ Do |
|---------|-------|
| `@Input()` | `input<Type>()` |
| `@Output()` | `output<Type>()` |
| `constructor(private x: X)` | `private readonly x = inject(X)` |
| `ngOnInit()` | `effect()` or `constructor()` |
| `platform.is('ios')` | `Capacitor.getPlatform() === 'ios'` |
| `*ngIf` | `@if` |
| `*ngFor` | `@for` |
| `any` type | Proper types |
| Everything in `shared/` | Only 2+ feature usage |
| Deep imports `../../../` | Path aliases `@pages/` |

---

## 📦 Path Aliases

```json
// tsconfig.json
{
  "compilerOptions": {
    "paths": {
      "@pages/*": ["src/app/pages/*"],
      "@shared/*": ["src/app/shared/*"],
      "@core/*": ["src/app/core/*"]
    }
  }
}
```

```typescript
// Usage
import { AuthService } from '@core/services/auth.service';
import { HeaderComponent } from '@shared/components/header.component';
import { HomePage } from '@pages/tabs/home/home';
```

---

## 🎯 File Naming

```
✅ feature.ts          (not feature.component.ts)
✅ auth.service.ts     (keep .service suffix)
✅ auth.guard.ts       (keep .guard suffix)
✅ format-date.pipe.ts (keep .pipe suffix)
```

---

## ✅ Quality Checklist

Before committing code, verify:

- [ ] Using standalone components (no NgModules)?
- [ ] Using `input()` / `output()` (not decorators)?
- [ ] Using `inject()` (not constructor DI)?
- [ ] Using signals for state?
- [ ] Using `Capacitor.getPlatform()` (not `Platform.is()`)?
- [ ] OnPush change detection?
- [ ] No `any` types?
- [ ] Scope Rule followed (1=local, 2+=shared)?
- [ ] iOS config in app.component?
- [ ] Modern control flow (`@if`, `@for`)?
- [ ] Path aliases used?

---

## 🔗 Quick Links

- **Templates**: `./templates/`
  - `push-notification.service.ts`
  - `app-component-initial.ts`
  - `example-usage.md`

- **References**: `./references/`
  - `capacitor-platform-detection.md`
  - `project-structure.md`

- **Documentation**:
  - `SKILL.md` - Complete skill instructions
  - `README.md` - Skill overview
  - `CHANGELOG.md` - Version history

---

## 💡 Pro Tips

1. **Start with signals** - Only use observables when absolutely necessary
2. **OnPush by default** - Set it on every component
3. **Computed for derived state** - Don't manually update
4. **Effect for side effects** - Not for state derivation
5. **toSignal for observables** - Convert at component boundary
6. **Path aliases everywhere** - Never use `../../`
7. **Type everything** - TypeScript is your friend
8. **Mobile-first** - Always consider native platforms

---

**Remember**: When in doubt, follow the Scope Rule! 🎯
