# Angular + Ionic AI Agent Skills

> **Single Source of Truth** - This file is the master reference for all AI assistants working with Angular 20+ and Ionic 8+ projects.

This repository provides AI agent skills for Cursor, Claude Code, and other AI assistants. Skills provide on-demand context and patterns for modern Angular + Ionic development.

## Quick Start

When working on Angular + Ionic projects, AI assistants automatically load relevant skills based on context. For manual loading, read the SKILL.md file directly.

## Available Skills

### Angular Core Skills

| Skill | Description | File |
|-------|-------------|------|
| `angular-core` | Angular 20+ core patterns: standalone components, signals, inject(), control flow, zoneless | [SKILL.md](skills/angular/core/SKILL.md) |
| `angular-forms` | Angular forms: Signal Forms (experimental) and Reactive Forms with validation | [SKILL.md](skills/angular/forms/SKILL.md) |
| `angular-performance` | Angular performance optimization: NgOptimizedImage, @defer, lazy loading, SSR | [SKILL.md](skills/angular/performance/SKILL.md) |

### Ionic + Capacitor Skills

| Skill | Description | File |
|-------|-------------|------|
| `ionic-angular-architecture` | Ionic + Angular architecture: Scope Rule, Screaming Architecture, project structure, routing patterns | [SKILL.md](skills/ionic/angular/architecture/SKILL.md) |
| `ionic-angular-capacitor` | Capacitor mobile plugins: platform detection, status bar, push notifications, storage configuration | [SKILL.md](skills/ionic/angular/capacitor/SKILL.md) |
| `ionic-angular-migration-standalone` | Migration guide for converting Ionic Angular apps to Standalone architecture | [SKILL.md](skills/ionic/angular/migration-standalone/SKILL.md) |

## Skill Tree & Dependencies

```
Angular + Ionic Project
│
├── angular-core (FOUNDATION - Load first)
│   ├── Standalone components
│   ├── Signals & computed()
│   ├── inject() over constructor
│   ├── Native control flow (@if, @for)
│   └── Zoneless configuration
│
├── angular-forms (When working with forms)
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
│   ├── Routing patterns
│   └── Component placement decisions
│
└── ionic-angular-capacitor (When configuring mobile features)
    ├── Platform detection (Capacitor.getPlatform())
    ├── iOS status bar configuration
    ├── Push notifications service
    ├── Ionic Storage setup
    └── Capacitor plugin integration
```

## Auto-Invoke Skills

When performing these actions, **ALWAYS** invoke the corresponding skill FIRST:

| Action | Invoke First | Why |
|--------|--------------|-----|
| Creating Angular components | `angular-core` | Standalone, signals, inject(), control flow |
| Using lifecycle hooks | `angular-core` | NO lifecycle hooks - use signals instead |
| Working with forms | `angular-forms` | Signal Forms vs Reactive Forms patterns |
| Optimizing images | `angular-performance` | NgOptimizedImage requirements |
| Lazy loading components | `angular-performance` | @defer patterns and triggers |
| Structuring Ionic project | `ionic-angular-architecture` | Scope Rule, tabs/menu structure |
| Deciding component placement | `ionic-angular-architecture` | Scope Rule: 1 tab = local, 2+ tabs = shared |
| Setting up navigation | `ionic-angular-architecture` | Tab-based vs menu-based patterns |
| Detecting iOS/Android | `ionic-angular-capacitor` | Capacitor.getPlatform() - NEVER Ionic Platform |
| Configuring status bar | `ionic-angular-capacitor` | iOS status bar setup in app.component |
| Setting up push notifications | `ionic-angular-capacitor` | Push notification service structure |
| Configuring storage | `ionic-angular-capacitor` | Ionic Storage setup in main.ts |

## Trigger Patterns

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

### ionic-angular-architect
**Triggers when:**
- Architecting Ionic applications
- Organizing project structure
- Making component placement decisions
- Setting up routing (tabs/menu)
- User mentions: "architecture", "structure", "tabs", "menu", "scope rule", "placement"

### ionic-angular-capacitor-plugins
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

## How Skills Work

1. **Auto-detection**: AI assistants read AGENTS.md which contains skill triggers
2. **Context matching**: When creating components, `angular-core` loads
3. **Pattern application**: AI follows exact patterns from the skill
4. **First-time-correct**: No trial and error - skills provide exact conventions

## Skill Loading Priority

1. **ALWAYS load first**: `angular-core` - Foundation for all Angular code
2. **Load when needed**: Other skills based on context
3. **Multiple skills**: Can be loaded simultaneously (e.g., `angular-core` + `ionic-angular-architecture`)

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
- 2+ tabs/pages = `shared/` directories
- App-wide = `core/services/`
- NO EXCEPTIONS

### 5. Mobile-First (REQUIRED for Capacitor)
- Use `Capacitor.getPlatform()`, NEVER Ionic Platform
- Configure iOS status bar in app.component
- Use Ionic Storage for persistence

## Skill Structure

```
skills/
├── angular/
│   ├── core/
│   │   └── SKILL.md
│   ├── forms/
│   │   └── SKILL.md
│   └── performance/
│       └── SKILL.md
└── ionic/
    └── angular/
        ├── architect/
        │   ├── SKILL.md
        │   ├── references/
        │   │   ├── capacitor-platform-detection.md
        │   │   ├── project-structure.md
        │   │   └── ui-interaction-pattern.md
        │   └── templates/
        │       ├── app-component-initial.ts
        │       ├── example-usage.md
        │       ├── push-notification.service.ts
        │       └── ui.service.ts
        ├── capacitor/
        │   └── SKILL.md
        └── migration-standalone/
            └── SKILL.md
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
| angular-core | 20+ | 8+ | N/A |
| angular-forms | 20+ (21+ for Signal Forms) | 8+ | N/A |
| angular-performance | 20+ | 8+ | N/A |
| ionic-angular-architecture| 20+ | 8+ | 6+ |
| ionic-angular-capacitor| 20+ | 8+ | 6+ |

## Support

- [Angular Documentation](https://angular.dev)
- [Ionic Documentation](https://ionicframework.com/docs)
- [Capacitor Documentation](https://capacitorjs.com/docs)

---

**Remember**: These skills enforce modern Angular 20+ and Ionic 8+ best practices. Always start with `angular-core` and build up from there.
