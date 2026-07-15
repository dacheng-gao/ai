# Upgrade For Claude Code

```bash
git -C "$HOME/.ai" pull --ff-only
bash "$HOME/.ai/scripts/install.sh" claude
```

The installer replaces current managed files, removes known obsolete managed
files, and leaves unrelated user content intact.
