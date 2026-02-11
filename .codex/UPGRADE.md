# Codex Upgrade

## Steps

```sh
# 1. Pull latest
cd ~/.ai && git pull origin main

# 2. Sync entry file with Superpowers bootstrap
cp ~/.ai/AGENTS.md ~/.codex/AGENTS.md
cat >> ~/.codex/AGENTS.md <<'EOF'

---

## Superpowers System

<EXTREMELY_IMPORTANT>
You have superpowers. Superpowers teach you new skills and capabilities. RIGHT NOW run: `~/.codex/superpowers/.codex/superpowers-codex bootstrap` and follow the instructions it returns.
</EXTREMELY_IMPORTANT>
EOF

# 3. Sync rules and skills
cp ~/.ai/rules/* ~/.codex/rules/
rsync -av --delete ~/.ai/skills/ ~/.codex/skills/
```

## Verify

```sh
codex "列出所有可用的技能"
```
