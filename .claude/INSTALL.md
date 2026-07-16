# Install For Claude Code

Prerequisite: install
[superpowers](https://github.com/obra/superpowers) separately.

```bash
if [ -d "$HOME/.ai/.git" ]; then
    git -C "$HOME/.ai" pull --ff-only
else
    git clone https://github.com/dacheng-gao/ai "$HOME/.ai"
fi

bash "$HOME/.ai/scripts/install.sh" claude
```

The installer manages `AGENTS.md`, `CLAUDE.md`, and this repository's rules,
skills, and agents under `~/.claude`. It records the files it installs, removes
previously recorded files when they disappear from the repository, and
preserves other user-created rules, skills, and agents.
