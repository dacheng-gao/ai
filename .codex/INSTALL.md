# Install For Codex

Prerequisite: install
[superpowers](https://github.com/obra/superpowers) separately.

```bash
if [ -d "$HOME/.ai/.git" ]; then
    git -C "$HOME/.ai" pull --ff-only
else
    git clone https://github.com/dacheng-gao/ai "$HOME/.ai"
fi

bash "$HOME/.ai/scripts/install.sh" codex
```

The installer manages `AGENTS.md` and this repository's rules, skills,
and agents under `~/.codex`. It removes only explicitly listed obsolete
files from earlier versions and preserves other user-created rules, skills, and
agents.
