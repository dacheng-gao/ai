# Upgrade For Claude Code

```bash
git -C "$HOME/.ai" pull --ff-only
bash "$HOME/.ai/scripts/install.sh" claude
```

The installer replaces current managed files, removes previously recorded files
that no longer exist in the repository, and leaves unrelated user content
intact.
