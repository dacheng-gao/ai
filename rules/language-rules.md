# 语言规则

## 默认语言

开发者团队默认使用**中文**。未明确设置的场景一律使用中文。

## 默认中文的场景

| 场景 | 示例 |
|------|------|
| AI 对话 | 回复、讨论、问答 |
| 开发过程文档 | design doc、implementation doc、plan、OpenSpec 产物 |
| Git 提交/PR/Issue | commit message、PR 描述、issue 内容 |
| 应用程序日志 | error、warn、info、debug 输出 |
| 终端用户文案 | CLI 提示、错误消息、帮助文本 |

## 项目级覆盖

项目可在 `CLAUDE.md` 或项目配置中设置特定场景的语言。例如：

```
本项目 commit message 使用英语。
```

项目级设置优先于默认规则。

## 术语处理

使用中文时：
- **代码标识符、文件名**：保持英文
- **专有名词**：保持英文（Kubernetes、React、WebSocket）
- **业界通用术语**：保持英文或中英混用（API、Schema、Critical、rollback）
- **不强译**：术语翻译后增加理解成本时保留原文

## 始终保持英文的内容

| 内容 | 原因 |
|------|------|
| 代码标识符 | 语言规范、可读性 |
| 文件名、路径 | 跨平台兼容 |
| API endpoint、Schema | 与代码一致 |
| 配置 key | 与系统一致 |
