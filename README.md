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
├── README.md          ← Installation guide (full repo)
├── CHANGES.md         ← Change log
├── LICENSE            ← License file
├── .gitignore         ← Git exclusions
│
└── skills/            ← Clone this folder only! 📦
    ├── AGENTS.md      ← Skill tree & triggers
    ├── setup.sh       ← Installation script
    │
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
            ├── architecture/              [335 lines]
            │   ├── SKILL.md
            │   ├── references/
            │   │   ├── capacitor-platform-detection.md
            │   │   └── project-structure.md
            │   └── templates/
            │       ├── app-component-initial.ts
            │       ├── example-usage.md
            │       └── push-notification.service.ts
            │
            ├── capacitor/                 [398 lines]
            │   └── SKILL.md
            │
            └── migration-standalone/      [285 lines] ⭐ NEW
                └── SKILL.md
```

**💡 Pro Tip**: Clone only `skills/` folder for a lightweight setup without docs!

## Quick Start

### Option 0: Clone Only Skills Folder (Lightweight)

Clone only the `skills/` folder without extra documentation files:

```bash
# Method 1: Using sparse checkout (Git 2.25+)
npx degit lyonproducer/agent-skills/skills skills && cd skills && ./setup.sh 

# Run setup
./setup.sh
```

**What you get:**
- ✅ Just `skills/` folder with all skills
- ✅ `setup.sh` script included
- ✅ `AGENTS.md` for AI assistants
- ❌ No extra docs (README, CHANGES, LICENSE, etc.)

### Option 1: Use setup.sh (Full Repository - Interactive & Multi-Assistant)

The `setup.sh` script supports both multi-assistant configuration (Claude, Gemini, Codex, Copilot, Kilocode) and Cursor-specific installations.

**Interactive Mode (Recommended):**
```bash
# Clone full repository
git clone https://github.com/lyonproducer/agent-skills.git
cd agent-skills/skills

# Run without arguments for interactive selection
./setup.sh

# You'll be prompted to:
# 1. Select which AI assistants to configure
# 2. Select which skills to install
```

**Command-Line Mode:**
```bash
# From skills/ directory
cd skills

# Configure all assistants with all skills
./setup.sh --all

# Configure specific assistants
./setup.sh --claude --codex --kilocode

# Cursor-only install (current project)
./setup.sh --cursor                  # All skills to .cursor/skills

# Check installation status
./setup.sh --status
```

**What it does:**
- Creates symlinks from `.claude/skills`, `.gemini/skills`, `.codex/skills`, `.kilocode/skills` → `skills/`
- Copies `AGENTS.md` to `CLAUDE.md`, `GEMINI.md`, `AGENTS.md (Kilocode... etc)`
- Copies `AGENTS.md` to `.github/copilot-instructions.md` for Copilot
- Installs selected skills to Cursor (project-specific in `.cursor/skills/`)

### Option 2: Using npx skills - AGENTS.MD

```bash
# Install individual skills
npx skills add https://github.com/lyonproducer/agent-skills --skill angular-core
npx skills add https://github.com/lyonproducer/agent-skills --skill ionic-angular-architecture
npx skills add https://github.com/lyonproducer/agent-skills --skill ionic-angular-capacitor

# Or install all Angular + Ionic skills
npx skills add https://github.com/lyonproducer/agent-skills
```

## Cursor Skill Locations

| Location | Use Case | Supported By |
|----------|----------|--------------|
| `<project>/.cursor/skills/` | Project-specific team standards | `.cursor` directory |
| `.claude/skills/` | Claude Code assistant | Claude + symlink |
| `.gemini/skills/` | Gemini CLI assistant | Gemini + symlink |
| `.codex/skills/` | Codex (OpenAI) assistant | Codex + symlink |
| `.kilocode/skills/` | Kilocode assistant | Kilocode + symlink |
| `.github/copilot-instructions.md` | GitHub Copilot | Copilot + copy |

**Note**: Skills are now project-specific only for better team collaboration and version control.

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
cp -r skills/* .cursor/skills/
```

## Skill Development

Want to create your own skills? See the [skill-creator](https://github.com/anthropics/skills) guide.

```markdown
### Creating a New Skill

#### Option 1: Using Official Skill-Creator (Recommended)
Install and use the official Anthropic skill-creator:

```bash
# Install skill-creator tool
npx skills add https://github.com/anthropics/skills --skill skill-creator

# Create your new skill (interactive)
npx skills create my-new-skill

# Follow the generated structure and guidelines
```

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
