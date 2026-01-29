# Cline 安装指南

本指南帮助您将 AI Agent Rules 和 Skills 集成到 Cline 中。

## 前置条件

- 已安装 Cline

## 规则文件加载顺序

Cline 按以下优先级加载规则：

1. `.clinerules/` 文件夹（包含所有 `.md` 文件）
2. 单个 `.clinerules` 文件
3. `AGENTS.md` 文件

**注意**：工作区规则会覆盖同名的全局规则。

## 支持的规则文件

Cline 支持多种规则文件格式，实现跨工具兼容：

| 文件/文件夹 | 来源 | 说明 |
|------------|------|------|
| `.clinerules/` | Cline | 包含 `.md` 文件的文件夹（推荐）|
| `.cursor/rules/` | Cursor | 包含 `.mdc` 文件的文件夹 |
| `.windsurf/rules` | Windsurf | 包含多个 `md` 文件的文件夹 |
| `AGENTS.md` | Universal | 遵循 agents.md 标准，递归搜索子目录 |

Cline 优先使用 `.clinerules`（当存在时）。其他格式仅在没有 `.clinerules` 时加载（`AGENTS.md` 除外，它始终搜索子目录）。所有规则都会出现在 Rules popover 中，您可以在那里切换它们。

## 安装步骤

### 1. 克隆本仓库

```sh
git clone https://github.com/dacheng-gao/ai ~/.ai
cd ~/.ai
```

### 2. 创建工作区规则目录

```sh
mkdir -p .clinerules
```

### 3. 复制规则文件

将规则文件复制到项目根目录的 `.clinerules/` 文件夹：

```sh
cp rules/* .clinerules/
```

如果使用多个规则文件，建议使用数字前缀控制加载顺序（如 `01-coding.md`, `02-docs.md`）。

### 4. 复制技能文件（可选）

将技能文件复制到项目根目录：

```sh
cp -r skills/* .cline-skills/
```

## 规则存储位置

### 工作区规则
- **位置**: 项目根目录下的 `.clinerules/` 文件夹
- **优先级**: 高于全局规则

### 全局规则
全局规则存储位置取决于操作系统：

| 操作系统 | 默认位置 |
|---------|----------|
| Windows | `Documents\Cline\Rules` |
| macOS | `~/Documents/Cline/Rules` |
| Linux/WSL | `~/Documents/Cline/Rules` 或 `~/Cline/Rules` |

**注意**：Linux/WSL 用户，如果在 `~/Documents/Cline/Rules` 中找不到全局规则，请检查两个位置。

## 规则管理

### 创建规则

- **方法 1**: 在 Cline 的 Rules 标签页中点击 `+` 按钮，这会在编辑器中打开一个文件供您编写规则
- **方法 2**: 使用 `/newrule` 斜杠命令，让 Cline 根据您的描述生成规则

保存文件后，规则存储位置：
- **工作区规则**: 项目根目录下的 `.clinerules/`
- **全局规则**: 操作系统特定的位置（见上表）

### 管理规则

Rules popover（聊天输入框下方）显示活跃规则并让您切换它们的开/关状态。

popover 显示：
- **全局规则**: 来自用户级 Rules 目录
- **工作区规则**: 来自项目中 `.clinerules/` 文件夹

切换任何规则以启用或禁用它。禁用的规则即使匹配条件也不会加载。

## 条件规则（可选）

使用 YAML frontmatter 根据文件模式激活规则，将 React 指导排除在 Python 代码之外，或将后端规则与前端工作分开：

```markdown
---
paths:
  - "src/components/**"
  - "src/hooks/**"
---

# React Guidelines

使用函数式组件和 Hooks。将可复用逻辑提取为自定义 Hooks。
```

此规则仅在处理匹配路径的文件时激活。更多示例和模式语法，请阅读 [条件规则文档](https://docs.cline.bot/features/cline-rules/conditional-rules)。

## 验证安装

1. 检查 `.clinerules/` 目录结构：
   ```sh
   ls -la .clinerules/
   ```

2. 检查全局规则目录（根据您的操作系统）：
   ```sh
   # macOS/Linux 示例
   ls -la ~/Documents/Cline/Rules/
   # Windows 示例
   dir Documents\Cline\Rules
   ```

3. 启动 Cline，在 Rules popover 中查看已加载的规则

## 常见问题

### 规则未识别

- 确保 `.clinerules/` 位于项目根目录
- 检查文件扩展名是否为 `.md`
- 如果使用全局规则，确认位置是否正确

### 全局规则未加载

- Linux/WSL 用户：检查两个可能的位置（`~/Documents/Cline/Rules` 和 `~/Cline/Rules`）
- 确认文件存在于全局规则目录中

### 技能未识别

- 确保技能目录结构正确
- 每个技能应包含 `SKILL.md` 文件

### 规则优先级

- 工作区规则（`.clinerules/`）会覆盖同名的全局规则
- `.clinerules/` 文件夹优先级高于单个 `.clinerules` 文件
- `AGENTS.md` 始终被搜索，不受 `.clinerules` 存在影响

## 下一步

- 查看 [Cline Rules 官方文档](https://docs.cline.bot/features/cline-rules/overview) 了解更多功能
- 阅读 [条件规则文档](https://docs.cline.bot/features/cline-rules/conditional-rules) 实现基于文件的规则激活
- 探索项目 `skills/` 目录下的各个 `SKILL.md` 文件了解具体技能用法