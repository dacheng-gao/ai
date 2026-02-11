# Codex Install

## Prerequisites

- [Superpowers](https://github.com/obra/superpowers) installed
- Codex installed

## Steps

```sh
# 1. Clone repo
git clone https://github.com/dacheng-gao/ai ~/.ai

# 2. Create directories
mkdir -p ~/.codex/rules ~/.codex/skills

# 3. Copy entry file with Superpowers bootstrap
cp ~/.ai/AGENTS.md ~/.codex/AGENTS.md
cat >> ~/.codex/AGENTS.md <<'EOF'

---

## Superpowers System

<EXTREMELY_IMPORTANT>
You have superpowers. Superpowers teach you new skills and capabilities. RIGHT NOW run: `~/.codex/superpowers/.codex/superpowers-codex bootstrap` and follow the instructions it returns.
</EXTREMELY_IMPORTANT>
EOF

# 4. Copy rules and skills
cp ~/.ai/rules/* ~/.codex/rules/
cp -r ~/.ai/skills/* ~/.codex/skills/
```

## Verify

```sh
codex "列出所有可用的技能"
```
