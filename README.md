# Angular + Ionic AI Agent Skills

Professional AI agent skills for building modern Angular 20+ and Ionic 8+ applications with Cursor, Claude Code, Codex, Copilot, and other AI assistants. Skills enforce standalone components, signals, zoneless, Feature-Driven Slicing, and the Facade pattern so AI assistants produce first-time-correct code.

## Quick path

1. From your Angular project root (`angular.json` must exist), run:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/lyonproducer/agent-skills/main/skills/setup.sh | bash
   ```

2. Restart your AI assistant.
3. Verify: ask the assistant "What Angular skills are available?" — it should list the installed skills.

Supported OS for the curl path: **macOS and Linux**. Windows users see [Alternative methods](#alternative-install-methods) below.

## Available Skills

| Skill | Description |
|-------|-------------|
| **angular-developer** | Official Angular guidelines (vendored from angular/skills): scaffolding, signals, forms, DI, routing, SSR, ARIA, testing, CLI |
| **angular-architecture** | Scope Rule, project structure, file naming |
| **angular-core** | Foundation: standalone components, signals, inject(), control flow, zoneless |
| **angular-forms** | Signal Forms (experimental) and Reactive Forms patterns |
| **angular-performance** | Performance optimization with NgOptimizedImage, @defer, SSR |
| **ionic-angular-architecture** | Project architecture: Scope Rule, Feature-Driven Slicing, Facade pattern, routing |
| **ionic-angular-capacitor** | Capacitor configuration, platform detection, push notifications |
| **ionic-angular-migration-standalone** | Migration guide for Ionic Angular Standalone architecture |
| **capacitor-plugins** | Catalog of Capawesome, Firebase, and community Capacitor plugins (vendored) |

See [skills/AGENTS.md](skills/AGENTS.md) for the full skill tree, triggers, auto-invoke table, and loading priority.

## Alternative install methods

### npx degit (macOS/Linux, lightweight)

Clone only the `skills/` folder without extra docs:

```bash
# One line from main branch
npx degit lyonproducer/agent-skills/skills skills && chmod +x ./skills/setup.sh && ./skills/setup.sh

# Or from dev branch
npx degit lyonproducer/agent-skills/skills#dev skills && chmod +x ./skills/setup.sh && ./skills/setup.sh
```

You get just `skills/` with `setup.sh` and `AGENTS.md` — no README, CHANGES, or LICENSE.

### npx skills (Windows recommended)

```bash
# Install individual skills
npx skills add https://github.com/lyonproducer/agent-skills --skill angular-core
npx skills add https://github.com/lyonproducer/agent-skills --skill ionic-angular-architecture

# Or install all skills
npx skills add https://github.com/lyonproducer/agent-skills
```

### Non-interactive flags

```bash
# Configure all assistants
./skills/setup.sh --all

# Configure specific assistants
./skills/setup.sh --claude --codex --kilocode

# Cursor-only (uses .agents/skills natively)
./skills/setup.sh --cursor

# Check installation status
./skills/setup.sh --status
```

## How it works

| Location | Use Case | Supported By |
|----------|----------|--------------|
| `.agents/skills/` | Central install + native discovery | Cursor, OpenCode, agentskills.io |
| `.opencode/skills/` | OpenCode project-local symlink | OpenCode + symlink |
| `.claude/skills/` | Claude Code assistant | Claude + symlink |
| `.codex/skills/` | Codex (OpenAI) assistant | Codex + symlink |
| `.kilocode/skills/` | Kilocode assistant | Kilocode + symlink |
| `.github/copilot-instructions.md` | GitHub Copilot | Copilot + copy |
| `.agent/skills/` | Antigravity | Antigravity + symlink |

Skills install to `.agents/skills/` (single source of truth, flat layout: `angular-core`, `ionic-angular-capacitor`, etc.). Assistant-specific folders symlink to it. `AGENTS.md` is copied to `CLAUDE.md`, `GEMINI.md`, project root, and `.github/copilot-instructions.md` as needed. Cursor reads `.agents/skills/` natively.

## Verification checklist

After installation, confirm:

- [ ] `.agents/skills/` exists and contains skill folders (e.g., `angular-core/`, `ionic-angular-architecture/`)
- [ ] `SKILL.md` files exist inside each skill folder
- [ ] AI assistant restarted after install
- [ ] Assistant lists the installed skills when asked "What Angular skills are available?"
- [ ] YAML frontmatter in each `SKILL.md` is valid (descriptions act as OpenCode triggers)

## Key concepts at a glance

| Concept | Rule | Source skill |
|---------|------|--------------|
| Scope Rule | 1 page → local; same feature across pages → `features/<feature>/components/`; 2+ features → `shared/ui/` | [ionic-angular-architecture](skills/ionic/angular/architecture/SKILL.md) |
| Feature-Driven Slicing | `features/<feature>/` splits into `models/`, `store/`, `services/`, `utils/`, `components/` | [ionic-angular-architecture](skills/ionic/angular/architecture/SKILL.md) |
| Facade pattern | Pages inject ONLY `*-facade.service.ts` — never `*-http`, `*-storage`, `*-sync` | [ionic-angular-architecture](skills/ionic/angular/architecture/SKILL.md) |
| Modern Angular | Standalone, signals, `inject()`, native control flow, zoneless, NO lifecycle hooks | [angular-core](skills/angular/core/SKILL.md) |
| Capacitor over Ionic Platform | Use `Capacitor.getPlatform()`, never `Platform.is()` | [ionic-angular-capacitor](skills/ionic/angular/capacitor/SKILL.md) |

## Requirements

- **Cursor** (or other supported AI assistant): latest version
- **Angular**: 20+
- **Ionic**: 8+ (for Ionic skills)
- **Capacitor**: 6+ (for Capacitor skills)

## Updating skills

```bash
cd skills
./setup.sh --update
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Skills not loading | Check `.agents/skills/` exists with `SKILL.md` files; restart assistant; verify YAML frontmatter is valid |
| AI not following patterns | Reference the skill explicitly: "Following angular-core skill..."; check triggers in `AGENTS.md`; load `angular-core` first |
| Conflicting patterns | Load order: `angular-core` (foundation) → specific skill (`angular-forms`, `ionic-angular-architecture`, etc.) |

## Skill development

Want to create your own skills? Use the official [skill-creator](https://github.com/anthropics/skills) guide:

```bash
npx skills add https://github.com/anthropics/skills --skill skill-creator
npx skills create my-new-skill
```

## Contributing

1. Clone the repository
2. Create a feature branch
3. Follow the skill template structure (frontmatter, Activation Contract, Hard Rules, Decision Gates, Execution Steps, Output Contract, References)
4. Update `skills/AGENTS.md` with triggers and skill tree
5. Submit a pull request

## License

MIT — See [LICENSE](LICENSE) for details.

## Credits

Created by [Lyon Incode](https://github.com/lyonproducer). Inspired by:
- [Vercel AI SDK Skills](https://github.com/vercel/ai-sdk-skills)
- [Anthropic Skills](https://github.com/anthropics/skills)
- [Gentleman.Dots](https://github.com/gentleman-dots)

## Support

- **Issues**: [GitHub Issues](https://github.com/lyonproducer/agent-skills/issues)
- **Discussions**: [GitHub Discussions](https://github.com/lyonproducer/agent-skills/discussions)
- **Full skill tree & triggers**: [skills/AGENTS.md](skills/AGENTS.md)

## Next step

Read [skills/AGENTS.md](skills/AGENTS.md) for the complete skill tree, auto-invoke table, and loading priority. Then check [CHANGES.md](CHANGES.md) for the latest updates.
