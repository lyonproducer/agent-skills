# Angular + Ionic AI Agent Skills

> **Single Source of Truth** - This file is the master reference for all AI assistants working with Angular 20+ and Ionic 8+ projects.

This repository provides AI agent skills for Cursor, OpenCode, Claude Code, and other AI assistants. Skills provide on-demand context and patterns for modern Angular + Ionic development.

## Quick Start

When working on Angular + Ionic projects, AI assistants automatically load relevant skills based on context. For manual loading, read the SKILL.md file directly.

## Available Skills

> **Note on overlap**: `angular-developer` (official, vendored from `angular/skills`) is a comprehensive reference covering many Angular topics in depth. The local `angular-core` and `angular-forms` skills are **opinionated, Ionic 8+ / zoneless-specific rule sets** (`REQUIRED`/`NEVER`/`ALWAYS`). Both coexist by design:
> - Use `angular-core` / `angular-forms` as the **first-load foundation** for concise, strict patterns tailored to this repo's stack.
> - Use `angular-developer` as the **deep reference** for topics not covered by the local skills (routing, ARIA, animations, testing, CLI, migrations, `linkedSignal`, `resource`, SSR, Tailwind), or when you need fuller official documentation on a topic.

### Angular Core Skills

| Skill | Description | File |
|-------|-------------|------|
| `angular-developer` | **Official deep reference** (vendored from angular/skills): project scaffolding, components, signals, forms, DI, routing, SSR, ARIA, animations, styling, testing, CLI. Use for in-depth/official guidance and topics not covered by the local skills. | [SKILL.md](.agents/skills/angular-developer/SKILL.md) |
| `angular-core` | **Opinionated foundation for this repo** (load FIRST): standalone components, signals, inject(), control flow, NO lifecycle hooks, zoneless, RxJS-vs-signals rules | [SKILL.md](.agents/skills/angular-core/SKILL.md) |
| `angular-forms` | **Opinionated forms rules for this repo**: Signal Forms (experimental) and Reactive Forms concise patterns with validation | [SKILL.md](.agents/skills/angular-forms/SKILL.md) |
| `angular-performance` | Angular performance optimization: NgOptimizedImage, @defer, lazy loading, SSR | [SKILL.md](.agents/skills/angular-performance/SKILL.md) |

### Ionic + Capacitor Skills

| Skill | Description | File |
|-------|-------------|------|
| `ionic-angular-architecture` | Ionic + Angular architecture: Scope Rule, Screaming Architecture, Feature-Driven Slicing (models/store/services/utils/components), Facade pattern, routing | [SKILL.md](.agents/skills/ionic-angular-architecture/SKILL.md) |
| `ionic-angular-capacitor` | Capacitor mobile plugins: platform detection, status bar, push notifications, storage configuration | [SKILL.md](.agents/skills/ionic-angular-capacitor/SKILL.md) |
| `ionic-angular-migration-standalone` | Migration guide for converting Ionic Angular apps to Standalone architecture | [SKILL.md](.agents/skills/ionic-angular-migration-standalone/SKILL.md) |
| `capacitor-plugins` | Catalog of Capacitor community and Capawesome plugins with usage references (vendored from capawesome-team/skills) | [SKILL.md](.agents/skills/ionic-capacitor-capacitor-plugins/SKILL.md) |

## Skill Tree & Dependencies

```
Angular + Ionic Project
│
├── angular-core (FOUNDATION - Load FIRST; opinionated rules for this repo)
│   ├── Standalone components
│   ├── Signals & computed()
│   ├── inject() over constructor
│   ├── Native control flow (@if, @for)
│   └── Zoneless configuration
│
├── angular-developer (Official DEEP REFERENCE - vendored from angular/skills)
│   ├── Creating new projects (ng new)
│   ├── Components, inputs, outputs, host elements
│   ├── Reactivity (signals, linkedSignal, resource, effects)
│   ├── Forms (signal forms, reactive, template-driven)
│   ├── Dependency injection & providers
│   ├── Routing, resolvers, guards, outlets
│   ├── SSR, hydration, rendering & loading strategies
│   ├── Accessibility (ARIA), animations, styling (Tailwind CSS)
│   ├── Testing fundamentals & e2e
│   └── CLI tooling & migrations
│
├── angular-forms (When working with forms; opinionated concise rules)
│   ├── Signal Forms (experimental)
│   ├── Reactive Forms
│   └── Form validation
│
├── angular-performance (When optimizing)
│   ├── NgOptimizedImage
│   ├── @defer lazy loading
│   ├── Route lazy loading
│   └── SSR & hydration
│
├── ionic-angular-architecture (When architecting Ionic apps)
│   ├── Scope Rule enforcement
│   ├── Screaming Architecture
│   ├── Project structure (tabs/menu/pages)
│   ├── Feature-Driven Slicing (models/store/services/utils/components)
│   ├── Facade pattern (pages → facade only; facade → store/sync/storage/http)
│   ├── Routing patterns
│   └── Component placement decisions
│
├── ionic-angular-capacitor (When configuring mobile features)
│   ├── Platform detection (Capacitor.getPlatform())
│   ├── iOS status bar configuration
│   ├── Push notifications service
│   ├── Ionic Storage setup
│   └── Capacitor plugin integration
│
└── capacitor-plugins (When choosing or installing a third-party/community plugin)
    ├── Plugin catalog with usage references
    ├── Capawesome plugins
    ├── Firebase plugins
    └── Community plugins
```

## Auto-Invoke Skills

When performing these actions, **ALWAYS** invoke the corresponding skill FIRST:

| Action | Invoke First | Why |
|--------|--------------|-----|
| Creating a new Angular project | `angular-developer` | Official `ng new` execution rules (npx vs local install) |
| Scaffolding components/services/pipes | `angular-developer` | Angular CLI conventions and style guide |
| Using signals, linkedSignal, resource, effects | `angular-developer` | Official reactivity reference docs |
| Setting up routing, resolvers, guards | `angular-developer` | Official routing reference docs |
| Configuring SSR, hydration, loading strategies | `angular-developer` | Official rendering strategy docs |
| Adding accessibility (ARIA) | `angular-developer` | Official ARIA reference docs |
| Adding animations or Tailwind CSS styling | `angular-developer` | Official animations & styling references |
| Writing Angular tests (unit/e2e) | `angular-developer` | Official testing fundamentals & e2e docs |
| Running Angular CLI commands or migrations | `angular-developer` | Official CLI & migrations references |
| Creating Angular components | `angular-core` | Standalone, signals, inject(), control flow |
| Using lifecycle hooks | `angular-core` | NO lifecycle hooks - use signals instead |
| Working with forms | `angular-forms` | Signal Forms vs Reactive Forms patterns |
| Optimizing images | `angular-performance` | NgOptimizedImage requirements |
| Lazy loading components | `angular-performance` | @defer patterns and triggers |
| Structuring Ionic project | `ionic-angular-architecture` | Scope Rule, tabs/menu structure |
| Deciding component placement | `ionic-angular-architecture` | Scope Rule: local for 1 page, same-feature reuse in `features/<feature>/components/`, cross-feature/page reuse in `shared/ui/` |
| Setting up navigation | `ionic-angular-architecture` | Tab-based vs menu-based patterns |
| Building/refactoring a feature domain | `ionic-angular-architecture` | Feature-Driven Slicing: models, store, services (facade/http/storage/sync), utils (mappers), components |
| Creating feature services (facade, http, storage, sync) | `ionic-angular-architecture` | Naming conventions, dependency inversion, pages inject Facade only |
| Wiring feature state to pages | `ionic-angular-architecture` | Store coordinated by Facade; expose readonly signals via Facade |
| Detecting iOS/Android | `ionic-angular-capacitor` | Capacitor.getPlatform() - NEVER Ionic Platform |
| Configuring status bar | `ionic-angular-capacitor` | iOS status bar setup in app.component |
| Setting up push notifications | `ionic-angular-capacitor` | Push notification service structure |
| Configuring storage | `ionic-angular-capacitor` | Ionic Storage setup in main.ts |
| Choosing a third-party/community plugin | `capacitor-plugins` | Full plugin catalog with references |
| Installing a Capawesome or Firebase plugin | `capacitor-plugins` | Usage guide and API reference per plugin |

## Trigger Patterns

### angular-developer
**Triggers when (deep reference / topics NOT fully covered by `angular-core`/`angular-forms`):**
- Creating a new Angular project (`ng new`)
- Scaffolding components, services, directives, pipes, or routes with the CLI
- Using `linkedSignal`, `resource`, or advanced `effect()` patterns (NOT basic signals — use `angular-core`)
- Template-driven forms (NOT signal/reactive forms basics — use `angular-forms`)
- Configuring dependency injection providers, `InjectionToken`, hierarchical injectors, injection context
- Defining routes, resolvers, guards, outlets, or router lifecycle
- Setting up SSR, hydration, rendering or loading strategies
- Adding accessibility (ARIA), animations, or component styling (Tailwind CSS)
- Writing Angular unit or e2e tests
- Running CLI commands or migrations
- Needing deeper official docs on a topic already covered by `angular-core`/`angular-forms`
- User mentions: "ng new", "angular cli", "scaffold", "linkedSignal", "resource", "resolver", "guard", "SSR", "hydration", "ARIA", "animations", "tailwind", "e2e", "migrations", "template-driven"

> **Priority**: For basic components/signals/inject/control flow/zoneless, `angular-core` loads first. For signal forms / reactive forms basics, `angular-forms` loads first. Load `angular-developer` alongside them when you need deeper API detail or for the topics above.

### angular-core
**Triggers when:**
- Creating Angular components
- Using signals, computed(), or effect()
- Setting up dependency injection
- Using control flow in templates
- Configuring zoneless Angular
- User mentions: "component", "signal", "inject", "standalone"

### angular-forms
**Triggers when:**
- Working with forms
- Implementing validation
- Handling form state
- User mentions: "form", "validation", "input", "FormBuilder"

### angular-performance
**Triggers when:**
- Optimizing performance
- Working with images
- Implementing lazy loading
- Setting up SSR
- User mentions: "performance", "image", "lazy", "defer", "SSR"

### ionic-angular-architecture
**Triggers when:**
- Architecting Ionic applications
- Organizing project structure
- Making component placement decisions
- Setting up routing (tabs/menu)
- Building or refactoring a feature under `features/<feature-name>/`
- Creating feature services: facade, http, storage, sync
- Creating pure mappers in `features/<feature>/utils/`
- Wiring signal stores to pages via a Facade
- User mentions: "architecture", "structure", "tabs", "menu", "scope rule", "placement", "facade", "feature slicing", "store", "mapper", "sync service"

### ionic-angular-capacitor
**Triggers when:**
- Configuring Capacitor plugins
- Detecting platform (iOS/Android/web)
- Setting up push notifications
- Configuring mobile storage
- Setting up iOS status bar
- User mentions: "Capacitor", "iOS", "Android", "platform", "push notification", "storage", "status bar"

### ionic-angular-migration-standalone
**Triggers when:**
- Migrating Ionic app to Standalone
- Removing IonicModule
- Converting NgModule pages to Standalone
- Updating to provideIonicAngular
- Registering ionicons
- User mentions: "migration", "standalone", "NgModule", "IonicModule", "migrate to standalone"

### capacitor-plugins
**Triggers when:**
- Asking which plugin to use for a specific feature
- Installing or configuring Capawesome, Firebase, or community Capacitor plugins
- Looking up API usage for a specific plugin
- User mentions: "capawesome", "firebase plugin", "community plugin", "which plugin", "barcode", "biometrics", "live update", "in-app review"

## How Skills Work

1. **Auto-detection**: AI assistants read AGENTS.md which contains skill triggers
2. **Context matching**: When creating components, `angular-core` loads
3. **Pattern application**: AI follows exact patterns from the skill
4. **First-time-correct**: No trial and error - skills provide exact conventions

## Skill Loading Priority

1. **ALWAYS load first**: `angular-core` - Opinionated foundation for all Angular code in this repo (standalone, signals, inject, zoneless, NO lifecycle hooks)
2. **Load for forms**: `angular-forms` - Concise opinionated forms rules
3. **Load as deep reference**: `angular-developer` - When you need fuller official documentation on a topic, or for topics NOT covered by `angular-core`/`angular-forms` (routing, ARIA, animations, testing, CLI, migrations, `linkedSignal`, `resource`, SSR, Tailwind, template-driven forms)
4. **Load when needed**: Other skills based on context (`angular-performance`, Ionic skills)
5. **Multiple skills**: Can be loaded simultaneously (e.g., `angular-core` + `angular-developer` + `ionic-angular-architecture`)

> **Overlap rule**: When `angular-core`/`angular-forms` and `angular-developer` cover the same topic (signals, inputs/outputs, `inject()`, forms), the **local opinionated skills win for style/strictness decisions** in this repo. Use `angular-developer` for deeper API details, edge cases, and reference docs the local skills don't cover.

## Core Principles Across All Skills

### 1. Standalone Components (REQUIRED)
- ALL components are standalone by default
- NO `standalone: true` needed
- NO NgModules

### 2. Signals Over RxJS (REQUIRED)
- Use `signal()`, `computed()`, `effect()` for state
- NO lifecycle hooks (`ngOnInit`, `ngOnChanges`, `ngOnDestroy`)
- RxJS only for complex async operations

### 3. Modern Syntax (REQUIRED)
- Use `input()` and `output()` functions, NOT decorators
- Use `inject()`, NOT constructor injection
- Use native control flow (`@if`, `@for`), NOT directives

### 4. Scope Rule (REQUIRED for Ionic)
- 1 tab/page = local placement
- Same feature across some pages = `features/<feature>/components/`
- 2+ tabs/pages/features = `shared/ui/`
- App-wide infrastructure = `core/` (for example `core/auth/`, `core/device/`)
- NO EXCEPTIONS

### 5. Mobile-First (REQUIRED for Capacitor)
- Use `Capacitor.getPlatform()`, NEVER Ionic Platform
- Configure iOS status bar in app.component
- Use Ionic Storage for persistence

### 6. Feature Facade (REQUIRED for `features/`)
- Pages and UI components inject ONLY `*-facade.service.ts` — never `*-http`, `*-storage`, or `*-sync`
- Facade coordinates Store, Sync, and Storage; Sync uses HTTP; HTTP uses pure Mapper functions
- Mappers live in `features/<feature>/utils/*.mapper.ts` as pure functions — NO `@Injectable()`
- All feature services use `inject()`, never constructor injection

## Skill Structure

```
skills/
├── angular/
│   ├── developer/                  # vendored from angular/skills (official)
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── *.md
│   ├── architecture/
│   │   └── SKILL.md
│   ├── core/
│   │   └── SKILL.md
│   ├── forms/
│   │   └── SKILL.md
│   └── performance/
│       └── SKILL.md
└── ionic/
    ├── angular/
    │   ├── architecture/
    │   │   ├── SKILL.md
    │   │   ├── references/
    │   │   │   ├── capacitor-platform-detection.md
    │   │   │   ├── project-structure.md
    │   │   │   └── ui-interaction-pattern.md
    │   │   └── templates/
    │   │       ├── app-component-initial.ts
    │   │       ├── example-usage.md
    │   │       └── ui.service.ts
    │   ├── capacitor/
    │   │   ├── SKILL.md
    │   │   ├── templates/
    │   │   │   └── push-notification.service.ts
    │   │   └── references/
    │   │       ├── push-notifications-angular.md
    │   │       ├── status-bar-ios.md
    │   │       ├── ionic-storage.md
    │   │       ├── capacitor-config.md
    │   │       ├── plugin-workflow-camera.md
    │   │       ├── network-service.md
    │   │       ├── geolocation-service.md
    │   │       ├── keyboard-service.md
    │   │       ├── android-edge-to-edge.md
    │   │       ├── social-login-capgo.md
    │   │       ├── firebase-crashlytics-service.md
    │   │       └── firebase-analytics-service.md
    │   └── migration-standalone/
    │       └── SKILL.md
    └── capacitor/
        └── capacitor-plugins/        # vendored from capawesome-team/skills
            ├── SKILL.md
            └── references/
                └── *.md
```

## Installation

See [README.md](README.md) for installation instructions.

## Contributing

When adding new skills:
1. Follow the skill template structure
2. Update this AGENTS.md file with triggers
3. Add to the skill tree diagram
4. Include in auto-invoke table if applicable

## Version Compatibility

| Skill | Angular Version | Ionic Version | Capacitor Version |
|-------|----------------|---------------|-------------------|
| angular-developer | latest stable | N/A | N/A |
| angular-core | 20+ | 8+ | N/A |
| angular-forms | 20+ (21+ for Signal Forms) | 8+ | N/A |
| angular-performance | 20+ | 8+ | N/A |
| ionic-angular-architecture| 20+ | 8+ | 6+ |
| ionic-angular-capacitor| 20+ | 8+ | 6+ |
| ionic-angular-migration-standalone | 12+ | 8+ | N/A |
| capacitor-plugins | N/A | N/A | 6+ |

## Support

- [Angular Documentation](https://angular.dev)
- [Ionic Documentation](https://ionicframework.com/docs)
- [Capacitor Documentation](https://capacitorjs.com/docs)
- [Capacitor Cap Awesome Plugins Documentation](https://capawesome.io/plugins/)

---

**Remember**: These skills enforce modern Angular 20+ and Ionic 8+ best practices. Always start with `angular-core` and `ionic-angular-architecture` and build up from there.
