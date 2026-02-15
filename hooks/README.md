# Hooks 配置说明

本目录包含 Claude Code 生命周期钩子脚本。

## 已配置的 Hooks

| Hook | 事件 | 用途 |
|------|------|------|
| `session-start.sh` | SessionStart(startup) | 检测 HANDOFF.md，提示恢复会话 |
| `pre-compact.sh` | PreCompact | 上下文压缩前保存关键信息 |
| `post-compact.sh` | SessionStart(compact) | 压缩后注入框架提醒 |
| `pre-write-check.sh` | PreToolUse(Write/Edit) | 阻止敏感文件修改，警告未提交变更 |

## 设计原则

1. **最小化**：只保留必要的生命周期管理
2. **信任 Claude**：不使用脚本进行 prompt 分类或复杂检测
3. **信息注入**：hooks 主要用于在适当时机注入提醒信息

## 调试

启用 debug 模式查看 hook 执行详情：

```bash
claude --debug
```
