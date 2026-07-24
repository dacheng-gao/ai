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

The installer manages `AGENTS.md` and this repository's rules and skills under
`~/.codex`. Codex custom agents use TOML, so the installer leaves personal and
project custom agents to Codex and preserves them. It records the files it
installs and removes only previously recorded repository-managed files.
