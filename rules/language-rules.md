# 语言规则

## 默认语言

开发者团队默认使用**中文**。

## 默认中文的场景

| 场景 | 示例 |
|------|------|
| AI 对话 | 回复、讨论、问答 |
| 开发过程文档 | design doc、plan、OpenSpec 产物 |
| PR 描述、Issue 内容 | PR body、issue 内容 |
| 应用程序日志 | error、warn、info、debug 输出 |
| 终端用户文案 | CLI 提示、错误消息、帮助文本 |

## 始终保持英文的内容

| 内容 | 原因 |
|------|------|
| 代码标识符、文件名、路径 | 语言规范、跨平台兼容 |
| Git commit message | 遵循 Conventional Commits 规范 |
| API endpoint、Schema、配置 key | 与代码一致 |

## 术语处理

使用中文时保持以下内容英文：
- 专有名词（Kubernetes、React、WebSocket）
- 业界术语（API、Schema、rollback）
- 翻译后增加理解成本的术语

## 项目级覆盖

项目可在 `CLAUDE.md` 中设置特定场景的语言，项目级设置优先。
