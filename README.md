# Angular + Ionic AI Agent Skills

Professional AI agent skills for building modern Angular 20+ and Ionic 8+ applications with Cursor, Claude Code, and other AI assistants.

## Overview

This repository provides curated skills that teach AI assistants how to work with Angular and Ionic following modern best practices:

- ✅ **Angular 20+**: Standalone components, signals, zoneless
- ✅ **Ionic 8+**: Tab & menu navigation, mobile-first architecture
- ✅ **Capacitor 6+**: Platform detection, push notifications, native plugins
- ✅ **Architecture**: Scope Rule, Screaming Architecture principles
- ✅ **Performance**: NgOptimizedImage, @defer, lazy loading

## Available Skills

| Skill | Description |
|-------|-------------|
| **angular-architecture** | Scope Rule, project structure, file naming |
| **angular-core** | Foundation: standalone components, signals, inject(), control flow |
| **angular-forms** | Signal Forms (experimental) and Reactive Forms patterns |
| **angular-performance** | Performance optimization with NgOptimizedImage, @defer, SSR |
| **ionic-angular-architecture** | Project architecture with Scope Rule and routing patterns |
| **ionic-angular-capacitor** | Capacitor configuration, platform detection, push notifications |

See [AGENTS.md](AGENTS.md) for detailed skill tree, triggers, and usage patterns.

## 🏗️ Skills Architecture

```
Root
├── AGENTS.md          ← Skill tree & triggers
├── README.md          ← Installation guide
├── CHANGES.md         ← Change log
├── SUMMARY.md         ← Visual summary
├── STATUS.md          ← This file
├── setup.sh           ← Installation script
├── .gitignore         ← Git exclusions
│
└── skills/
    ├── angular/
    │   ├── core/                          [207 lines]
    │   │   └── SKILL.md
    │   ├── forms/                         [125 lines]
    │   │   └── SKILL.md
    │   └── performance/                   [134 lines]
    │       └── SKILL.md
    │
    └── ionic/
        └── angular/
            ├── architect/                 [335 lines]
            │   ├── SKILL.md
            │   ├── references/
            │   │   ├── capacitor-platform-detection.md
            │   │   └── project-structure.md
            │   └── templates/
            │       ├── app-component-initial.ts
            │       ├── example-usage.md
            │       └── push-notification.service.ts
            │
            └── capacitor/                 [398 lines] ⭐ NEW
                └── SKILL.md
```

## Quick Start

### Option 1: Install All Skills (Recommended)

```bash
# Clone the repository
git clone https://github.com/lyonproducer/agent-skills.git

# Copy skills to your Cursor configuration
cp -r agent-skills/skills ~/.cursor/skills/
```

### Option 2: Install Specific Skills

```bash
# Copy only the skills you need
cp -r agent-skills/skills/angular/core ~/.cursor/skills/angular-core
cp -r agent-skills/skills/ionic/angular/architect ~/.cursor/skills/ionic-angular-architect
```

### Option 3: Project-Specific Installation

For team-wide usage, install skills in your project:

```bash
# Inside your Angular + Ionic project
mkdir -p .cursor/skills
cp -r /path/to/agent-skills/skills/* .cursor/skills/
```

Then commit the `.cursor/skills/` directory to your repository.

### Option 4: Using npx skills

```bash
# Install individual skills
npx skills add https://github.com/lyonproducer/agent-skills --skill angular-core
npx skills add https://github.com/lyonproducer/agent-skills --skill ionic-angular-architect

# Or install all Angular + Ionic skills
npx skills add https://github.com/lyonproducer/agent-skills
```

## Cursor Skill Locations

| Location | Scope | Use Case |
|----------|-------|----------|
| `~/.cursor/skills/` | Personal (all projects) | Your personal preferences |
| `<project>/.cursor/skills/` | Project-specific | Team-wide standards |

## Verification

After installation, verify skills are detected:

1. Open Cursor
2. Start a new chat
3. Type: "What Angular skills are available?"
4. AI should list the installed skills

## Usage Examples

### Example 1: Creating a Component

```typescript
// AI will automatically use angular-core skill
// Prompt: "Create a user profile component"

// Result: Standalone component with signals, inject(), OnPush
import { Component, signal, inject } from '@angular/core';

@Component({
  selector: 'app-user-profile',
  imports: [IonicModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    @if (user()) {
      <ion-card>{{ user()?.name }}</ion-card>
    }
  `
})
export class UserProfile {
  private readonly userService = inject(UserService);
  readonly user = signal<User | null>(null);
}
```

### Example 2: Deciding Component Placement

```typescript
// AI will use ionic-angular-architectureskill
// Prompt: "Where should I place a HeaderBack component used in 3 tabs?"

// AI Response: "Following the Scope Rule:
// - Used in 3 tabs = 2+ usage
// - Placement: src/app/shared/components/headers/header-back.ts
// - Reason: Scope Rule requires shared placement for 2+ tabs"
```

### Example 3: Platform Detection

```typescript
// AI will use ionic-angular-capacitorskill
// Prompt: "How do I detect if app is running on iOS?"

// Result: Capacitor platform detection
import { Capacitor } from '@capacitor/core';

if (Capacitor.getPlatform() === 'ios') {
  // iOS-specific code
}
```

## Skill Architecture

```
Angular Core Foundation
    ↓
├─→ Forms (when needed)
├─→ Performance (when optimizing)
└─→ Ionic Architecture
      ↓
    └─→ Capacitor (for mobile features)
```

**Key Principle**: Always load `angular-core` first, then other skills as needed.

## Key Concepts

### 1. The Scope Rule (Ionic Architecture)

**"Scope determines structure"**

- Used in 1 tab/page → Local placement
- Used in 2+ tabs/pages → `shared/` directory
- Used app-wide → `core/services/` (singletons)

### 2. Modern Angular Patterns

```typescript
// ✅ DO: Signals, inject(), native control flow
readonly count = signal(0);
private readonly http = inject(HttpClient);

@if (loading()) {
  <ion-spinner />
}

// ❌ DON'T: Lifecycle hooks, constructor injection, structural directives
ngOnInit() { }
constructor(private http: HttpClient) { }
*ngIf="loading"
```

### 3. Capacitor Over Ionic Platform

```typescript
// ✅ DO: Use Capacitor
import { Capacitor } from '@capacitor/core';
if (Capacitor.getPlatform() === 'ios') { }

// ❌ DON'T: Use Ionic Platform
import { Platform } from '@ionic/angular';
if (this.platform.is('ios')) { }
```

## Requirements

- **Cursor**: Latest version
- **Angular**: 20+
- **Ionic**: 8+ (for Ionic skills)
- **Capacitor**: 6+ (for Capacitor skills)

## Updating Skills

To update to the latest version:

```bash
cd agent-skills
git pull origin main

# Update your installation
cp -r skills/* ~/.cursor/skills/
```

## Skill Development

Want to create your own skills? See the [skill-creator](https://github.com/anthropics/skills) guide.

### Creating a New Skill

1. Use the skill template from `.agents/skills/skill-creator/`
2. Follow YAML frontmatter requirements
3. Keep SKILL.md under 500 lines
4. Add to AGENTS.md trigger table

## Troubleshooting

### Skills Not Loading

1. Check installation path: `~/.cursor/skills/` or `<project>/.cursor/skills/`
2. Verify SKILL.md files exist
3. Restart Cursor
4. Check YAML frontmatter is valid

### AI Not Following Patterns

1. Ensure you're referencing the skill explicitly: "Following angular-core skill..."
2. Check skill triggers in AGENTS.md
3. Load `angular-core` first for foundation

### Conflicting Patterns

Skills are designed to work together. Load order:
1. `angular-core` (foundation)
2. Specific skill (`angular-forms`, `ionic-angular-architecture`, etc.)

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Follow skill template structure
4. Add tests/examples
5. Update AGENTS.md
6. Submit a pull request

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.

## Credits

Created by [Lyon Incode](https://github.com/lyonproducer)

Inspired by:
- [Vercel AI SDK Skills](https://github.com/vercel/ai-sdk-skills)
- [Anthropic Skills](https://github.com/anthropics/skills)
- [Gentleman.Dots](https://github.com/gentleman-dots)

## Support

- **Issues**: [GitHub Issues](https://github.com/lyonproducer/agent-skills/issues)
- **Discussions**: [GitHub Discussions](https://github.com/lyonproducer/agent-skills/discussions)
- **Documentation**: [AGENTS.md](AGENTS.md)

## Resources

- [Angular Documentation](https://angular.dev)
- [Ionic Documentation](https://ionicframework.com/docs)
- [Capacitor Documentation](https://capacitorjs.com/docs)
- [Cursor Documentation](https://cursor.sh/docs)

---

**Built with ❤️ for the Ionic + Angular community**
