# Upgrade For Codex

```bash
git -C "$HOME/.ai" pull --ff-only
bash "$HOME/.ai/scripts/install.sh" codex
```

The installer replaces current managed files, removes previously recorded files
that are no longer supported for Codex, including older repository-managed
Markdown agent copies, and leaves unrelated TOML agents and user content intact.
