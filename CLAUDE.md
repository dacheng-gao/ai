# CLAUDE.md

## 强制技能调用

**每次响应用户之前，必须先调用 `superpowers:using-superpowers` 技能。**

```
用户消息 → Skill('superpowers:using-superpowers') → 检查适用技能 → 执行任务
```

这是硬性要求，不可跳过。该技能定义了如何识别和使用其他技能。
若调用失败或技能不可用，告知用户并停止当前任务。

> **与快速路径的关系**：`using-superpowers` 是路由前的元操作（识别应使用哪些技能），始终执行。
> 快速路径跳过的是技能专属 Superpowers（brainstorming、tdd 等），不是此元操作。

---

## 这是 **AI Agent 框架的源仓库**。

`~/.claude/` 中的 `CLAUDE.md`、`rules/`、`skills/`、`agents/` **是从本项目安装的副本**。两者内容相同是预期行为，不是重复。

**工作流**：
1. 在本项目中修改源文件
2. 运行 `.claude/INSTALL.md` 或 `UPGRADE.md` 安装到 `~/.claude/`

---

@AGENTS.md