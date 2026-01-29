# Angular Ionic Architect Skill

> Elite Angular 20 + Ionic 8 architectural guidance with mobile-first principles

## 📋 Overview

This skill provides comprehensive architectural guidance for building modern Angular + Ionic applications following the **Scope Rule** pattern, Angular 20 best practices, and mobile-first development with Capacitor.

## 🎯 What This Skill Does

- ✅ Enforces **Scope Rule** architecture (1 feature = local, 2+ features = shared)
- ✅ Promotes **Angular 20** modern patterns (standalone components, signals, `inject()`)
- ✅ Ensures **mobile-first** development with proper Capacitor integration
- ✅ Guides **project structure** following Screaming Architecture principles
- ✅ Provides **code templates** for common patterns
- ✅ Validates **architectural decisions** with clear reasoning

## 🚨 Critical Rules Enforced

### 1. Platform Detection
**Always use Capacitor, never Ionic's Platform.is()**

```typescript
// ✅ CORRECT
import { Capacitor } from '@capacitor/core';
if (Capacitor.getPlatform() === 'ios') { }

// ❌ WRONG
import { Platform } from '@ionic/angular';
if (this.platform.is('ios')) { }
```

### 2. iOS Status Bar Configuration
**Must be included in app.component.ts**

```typescript
if (Capacitor.getPlatform() === 'ios') {
  await StatusBar.setOverlaysWebView({ overlay: true });
  await StatusBar.setStyle({ style: Style.Dark });
  await EdgeToEdge.disable();
}
```

### 3. Push Notifications Service
**Required structure for mobile apps**

Location: `src/app/core/services/push-notification.service.ts`

See `templates/push-notification.service.ts` for complete implementation.

## 📁 Skill Structure

```
angular-ionic-architect/
├── SKILL.md                              # Main skill instructions
├── README.md                             # This file
├── templates/
│   ├── push-notification.service.ts     # Complete push notification service
│   └── app-component-initial.ts         # App component with iOS config
└── references/
    ├── capacitor-platform-detection.md  # Platform detection guide
    └── project-structure.md             # Complete project structure guide
```

## 🚀 Usage

### When to Activate This Skill

This skill should be used when:

- 🏗️ Starting a new Angular + Ionic project
- 📦 Making architectural decisions about component placement
- 🔄 Refactoring existing code to modern patterns
- 📱 Implementing mobile-specific features with Capacitor
- ✅ Reviewing code for architectural compliance

### Example Invocations

**Starting a new project:**
```
"I need to create a new e-commerce app with Angular 20 and Ionic 8"
```

**Component placement:**
```
"I have a header component used in 3 pages. Where should it go?"
```

**Mobile integration:**
```
"How do I properly configure push notifications in my Ionic app?"
```

**Code review:**
```
"Review my component structure and ensure it follows best practices"
```

## 📚 Key Concepts

### The Scope Rule

**"Scope determines structure"**

- Code used by **1 feature** → Keep it **local** in that feature's folder
- Code used by **2+ features** → Move it to **shared/** directory
- **App-wide singletons** → Place in **core/** directory

### Angular 20 Modern Patterns

- ✅ **Standalone components** (no NgModules)
- ✅ **`input()` and `output()`** functions (not decorators)
- ✅ **`inject()`** for DI (avoid constructor)
- ✅ **Signals** for state management
- ✅ **`toSignal()`** for converting observables
- ✅ **Modern control flow** (`@if`, `@for`, `@switch`)

### Project Structure

```
src/app/
├── pages/
│   ├── start-app/      # Auth & onboarding
│   ├── tabs/           # Main app tabs
│   └── out-app/        # Utility pages
├── shared/             # Used by 2+ features
├── core/               # Singletons & app-wide
└── app.component.ts    # Root with iOS config
```

## 🎓 Learning Resources

### Templates

1. **push-notification.service.ts** - Complete implementation with all listeners
2. **app-component-initial.ts** - Proper iOS configuration and initialization

### References

1. **capacitor-platform-detection.md** - Why and how to use Capacitor platform detection
2. **project-structure.md** - Complete guide to project organization

## ⚡ Quick Reference

### Component Template

```typescript
import { Component, ChangeDetectionStrategy, inject, input, output, signal, computed } from '@angular/core';
import { IonicModule } from '@ionic/angular';

@Component({
  selector: 'app-feature',
  imports: [IonicModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    @if (isLoading()) {
      <ion-spinner></ion-spinner>
    } @else {
      @for (item of items(); track item.id) {
        <ion-card>{{ item.name }}</ion-card>
      }
    }
  `
})
export class FeatureComponent {
  readonly data = input<DataType>();
  readonly itemSelected = output<ItemType>();
  
  private readonly service = inject(FeatureService);
  private readonly loading = signal(false);
  
  readonly isLoading = this.loading.asReadonly();
  readonly items = computed(() => this.data()?.filter(i => i.active) ?? []);
}
```

### Service Template

```typescript
import { Injectable, signal, computed, inject } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class FeatureService {
  private readonly http = inject(HttpClient);
  private readonly _state = signal<State>({ items: [], loading: false });
  
  readonly items = computed(() => this._state().items);
  readonly loading = computed(() => this._state().loading);
}
```

## 🔍 Decision Framework

When making architectural decisions:

1. **Count usage** - How many features use this code?
2. **Apply Scope Rule** - 1 feature = local, 2+ = shared, app-wide = core
3. **Validate mobile requirements** - Is Capacitor needed?
4. **Check patterns** - Using modern Angular 20 APIs?
5. **Verify naming** - Following conventions?
6. **Document decision** - Explain the reasoning

## ✅ Quality Checks

Before finalizing any code:

- [ ] Scope Rule applied correctly?
- [ ] Using standalone components?
- [ ] Using `input()`, `output()`, `inject()`?
- [ ] Using signals instead of observables (where appropriate)?
- [ ] Using `Capacitor.getPlatform()` not `Platform.is()`?
- [ ] iOS status bar configured in app.component?
- [ ] Push notifications service exists (if mobile)?
- [ ] OnPush change detection?
- [ ] No `any` types?
- [ ] Path aliases used (`@pages`, `@shared`, `@core`)?

## 🤝 Contributing

To improve this skill:

1. Add new templates for common patterns
2. Expand reference documentation
3. Add more real-world examples
4. Update for new Angular/Ionic versions

## 📝 Version History

- **1.0.0** - Initial skill creation
  - Scope Rule enforcement
  - Angular 20 modern patterns
  - Capacitor platform detection
  - iOS configuration requirements
  - Push notification service template

## 📄 License

Created by Lyon Incode.

---

**Remember**: Every architectural decision should make the codebase more understandable, maintainable, and scalable. When in doubt, follow the Scope Rule!
