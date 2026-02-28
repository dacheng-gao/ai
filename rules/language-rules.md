# 语言规则

## 默认语言

开发过程默认使用中文。

## 默认中文场景

| 场景 | 示例 |
|------|------|
| AI 对话 | 回复、讨论、问答 |
| 开发过程文档 | design doc、plan、OpenSpec 产物 |
| PR 描述、Issue 内容 | PR body、issue 内容 |
| 应用程序日志 | error、warn、info、debug 输出 |
| 终端用户文案 | CLI 提示、错误消息、帮助文本 |

## 始终英文内容

| 内容 | 原因 |
|------|------|
| 代码标识符、文件名、路径 | 语言规范与跨平台兼容 |
| Git commit message | 遵循 Conventional Commits |
| API endpoint、Schema、配置 key | 与代码保持一致 |

## 术语处理

中文语境下，以下内容保持英文：
- 专有名词（Kubernetes、React、WebSocket）
- 业界术语（API、Schema、rollback）
- 翻译后会增加理解成本的术语

## 项目级覆盖

项目可在 `CLAUDE.md` 指定特定场景语言，且项目级设置优先。
