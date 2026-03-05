#!/usr/bin/env bash
set -euo pipefail

# AMC Knowledge Base for Claude Code - Installer
# Usage: ./install.sh [target_directory]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "=== AMC Knowledge Base for Claude Code ==="
echo "Source:  $SCRIPT_DIR"
echo "Target:  $TARGET_DIR"
echo ""

# 1. Copy knowledge_base/
if [ -d "$TARGET_DIR/knowledge_base" ]; then
  echo "[!] knowledge_base/ already exists in target. Overwriting..."
fi
cp -r "$SCRIPT_DIR/knowledge_base" "$TARGET_DIR/knowledge_base"
echo "[+] Copied knowledge_base/ directory"

# 2. Copy /amc slash command
mkdir -p "$TARGET_DIR/.claude/commands"
cp "$SCRIPT_DIR/commands/amc.md" "$TARGET_DIR/.claude/commands/amc.md"
echo "[+] Installed /amc slash command to .claude/commands/amc.md"

# 3. Append CLAUDE.md.template to CLAUDE.md
if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
  # Check if already installed
  if grep -q "AMC SQL Knowledge Base" "$TARGET_DIR/CLAUDE.md" 2>/dev/null; then
    echo "[=] CLAUDE.md already contains AMC rules. Skipping."
  else
    echo "" >> "$TARGET_DIR/CLAUDE.md"
    cat "$SCRIPT_DIR/CLAUDE.md.template" >> "$TARGET_DIR/CLAUDE.md"
    echo "[+] Appended AMC rules to existing CLAUDE.md"
  fi
else
  cp "$SCRIPT_DIR/CLAUDE.md.template" "$TARGET_DIR/CLAUDE.md"
  echo "[+] Created CLAUDE.md with AMC rules"
fi

echo ""
echo "=== Installation complete! ==="
echo ""
echo "Usage:"
echo "  1. Use '/amc' command in Claude Code to enter AMC SQL assistant mode"
echo "  2. Or just ask Claude about AMC — it will automatically reference the knowledge base"
echo ""
echo "Tables installed: $(find "$TARGET_DIR/knowledge_base" -name '*.md' ! -name 'README.md' | wc -l | tr -d ' ')"
