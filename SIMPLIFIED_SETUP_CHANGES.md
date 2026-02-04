# 🎯 Setup Simplification - February 4, 2026

## Changes Made

### Removed Options
- ❌ `--cursor-global` - No longer available
- ❌ `--cursor-skill PATH` - No longer available

### New Simplified Option
- ✅ `--cursor` - Install skills to current project only

## Rationale

**Why simplify?**
1. **Single responsibility**: Each project should have its own skills
2. **Version control**: Skills can be committed to the project repository
3. **Team consistency**: All team members use the same skill versions
4. **No global state**: Avoids conflicts between projects
5. **Simpler to understand**: One clear option for Cursor users

## Migration Guide

### If you were using `--cursor-global`:

**Before**:
```bash
./setup.sh --cursor-global
# Installed to ~/.cursor/skills/ (global)
```

**After**:
```bash
cd /path/to/your/project
./setup.sh --cursor
# Installs to .cursor/skills/ (project-specific)
```

### If you were using `--cursor-skill`:

**Before**:
```bash
./setup.sh --cursor-skill angular/core
# Installed single skill globally
```

**After**:
```bash
cd /path/to/your/project
./setup.sh --cursor
# Then select skills in interactive mode
# Or manually copy specific skills
```

## Updated Commands

### Interactive Mode (Recommended)
```bash
./setup.sh
# 1. Select assistants (Claude, Gemini, Codex, Copilot, Kilocode)
# 2. Select skills to install
```

### Command-Line Mode
```bash
# Multi-assistant setup
./setup.sh --all                    # All assistants
./setup.sh --claude --kilocode      # Specific assistants

# Cursor-only (project installation)
./setup.sh --cursor                 # Install to .cursor/skills/
```

### List Skills
```bash
./setup.sh --list
```

## Benefits

✅ **Simpler**: One clear option instead of three  
✅ **Safer**: No risk of global conflicts  
✅ **Team-friendly**: Committed to repository  
✅ **Consistent**: All developers use same versions  
✅ **Clear**: Less confusion about where skills are installed  

## Documentation Updated

- ✅ `setup.sh --help` menu
- ✅ `README.md` installation options
- ✅ Removed references to global installation
- ✅ Updated all examples

## Testing

```bash
# Test 1: Help menu
./setup.sh --help
# ✓ Shows only --cursor option

# Test 2: List skills
./setup.sh --list
# ✓ Shows all 6 skills

# Test 3: Interactive mode
./setup.sh
# ✓ Works as expected

# Test 4: Direct cursor installation
./setup.sh --cursor
# ✓ Requires angular.json in current directory
# ✓ Installs to .cursor/skills/
```

## Summary

The setup script is now **simpler, clearer, and more focused**:

- **5 assistants**: Claude, Gemini, Codex, Copilot, Kilocode (with symlinks)
- **1 Cursor option**: `--cursor` (project-specific installation)
- **6 skills**: All installable via interactive selection

**Result**: Less complexity, better user experience, clearer mental model.

---

**Status**: ✅ Complete  
**Date**: February 4, 2026  
**Impact**: Breaking change for `--cursor-global` and `--cursor-skill` users
