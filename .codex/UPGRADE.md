# Upgrade For Codex

```bash
git -C "$HOME/.ai" pull --ff-only
bash "$HOME/.ai/scripts/install.sh" codex
```

The installer replaces current managed files, removes known obsolete managed
files, and leaves unrelated user content intact.
