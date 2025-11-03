#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Verifying TOOL-REGISTRY.md..."

# Check file exists
test -f TOOL-REGISTRY.md || { echo "❌ TOOL-REGISTRY.md not found"; exit 1; }

# Check Last Updated is recent (within 30 days)
last_updated=$(grep "Last Updated:" TOOL-REGISTRY.md | head -1 | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
days_old=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "$last_updated" +%s)) / 86400 ))
if [ "$days_old" -gt 30 ]; then
  echo "⚠️  Last Updated is $days_old days old. Consider reviewing."
else
  echo "✅ Last Updated is current ($days_old days old)"
fi

# Verify local scripts exist
echo ""
echo "📝 Checking local scripts..."
grep -oE "scripts/[a-z-]+\.sh" TOOL-REGISTRY.md | sort -u | while read -r script; do
  if [ -f "$script" ]; then
    echo "  ✅ $script"
  else
    echo "  ❌ $script (referenced but missing)"
  fi
done

# Verify agent files exist
echo ""
echo "🤖 Checking Claude Code agents..."
grep -oE "\.claude/agents/[a-z-]+\.md" TOOL-REGISTRY.md | sort -u | while read -r agent; do
  global_agent="/Users/$(whoami)/$agent"
  if [ -f "$agent" ] || [ -f "$global_agent" ]; then
    echo "  ✅ $(basename "$agent")"
  else
    echo "  ❌ $(basename "$agent") (referenced but missing)"
  fi
done

# Verify skill directories exist
echo ""
echo "📚 Checking Claude Code skills..."
grep -oE "\.claude/skills/[a-z-]+" TOOL-REGISTRY.md | sort -u | while read -r skill; do
  global_skill="/Users/$(whoami)/$skill"
  if [ -d "$skill" ] || [ -d "$global_skill" ]; then
    echo "  ✅ $(basename "$skill")"
  else
    echo "  ❌ $(basename "$skill") (referenced but missing)"
  fi
done

# Check for broken internal links
echo ""
echo "🔗 Checking internal documentation links..."
grep -oE "docs/[^)]*\.md" TOOL-REGISTRY.md | sort -u | while read -r doc; do
  if [ -f "$doc" ]; then
    echo "  ✅ $doc"
  else
    echo "  ⚠️  $doc (referenced but missing)"
  fi
done

# Check key sections exist
echo ""
echo "📖 Checking key sections..."
required_sections=(
  "Local Scripts"
  "Documentation & Specs"
  "MCP Servers"
  "CLI Tools"
  "APIs"
  "Claude Code Subagents"
  "Claude Code Skills"
  "Development Tools"
  "Quick Reference"
  "Maintenance Process"
)

for section in "${required_sections[@]}"; do
  if grep -q "## $section" TOOL-REGISTRY.md; then
    echo "  ✅ $section section found"
  else
    echo "  ❌ $section section missing"
  fi
done

echo ""
echo "✅ Verification complete! Review any ❌ or ⚠️  items above."
