# AGENTS 系统安装指南

## Prerequisites

- Claude Code 已安装
- Git 已安装
- jq 已安装（JSON 处理）

## 安装步骤

```bash
# 1. 进入安装目录
cd ~

# 2. Clone 或更新仓库
if [ -d ".ai" ]; then
    cd .ai && git pull origin main
else
    git clone https://github.com/dacheng-gao/ai ~/.ai
fi

# 3. 创建目录结构
mkdir -p ~/.claude/rules ~/.claude/skills ~/.claude/agents ~/.claude/hooks

# 4. 复制核心文件
cp ~/.ai/AGENTS.md ~/.claude/CLAUDE.md

# 5. 复制规则文件
cp ~/.ai/rules/*.md ~/.claude/rules/

# 6. 复制技能（使用 rsync 保持目录结构）
rsync -av --delete ~/.ai/skills/ ~/.claude/skills/

# 7. 复制 Agent 定义
cp ~/.ai/agents/*.md ~/.claude/agents/

# 8. 复制并设置 Hooks
cp ~/.ai/hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# 9. 设置 settings.json
# 如果已存在自定义 settings，需要手动合并
if [ ! -f ~/.claude/settings.json ]; then
    cp ~/.ai/.claude/settings.template.json ~/.claude/settings.json
    echo "已创建默认 settings.json"
else
    echo "检测到现有 settings.json，请手动合并 permissions 和 hooks 配置"
fi

# 10. 验证安装
echo "验证安装..."
echo "Rules: $(ls ~/.claude/rules/*.md | wc -l) files"
echo "Skills: $(ls ~/.claude/skills/*/SKILL.md | wc -l) skills"
echo "Agents: $(ls ~/.claude/agents/*.md | wc -l) agents"
echo "Hooks: $(ls ~/.claude/hooks/*.sh | wc -l) hooks"
```

## 安装验证

在 Claude Code 中运行以下命令验证：

```
列出所有可用的技能
```

预期输出应包含以下技能：
- answer
- architecture-review
- commit-message
- develop-feature
- fix-bug
- github
- handoff
- loop-until-done
- refactor
- review-code

## 目录结构

```
~/.claude/
├── CLAUDE.md              # 主入口（从 AGENTS.md 复制）
├── settings.json          # 配置文件（permissions + hooks）
├── rules/                # 全局规则
│   ├── code-quality.md
│   ├── fast-path.md
│   ├── git-workflow.md
│   ├── language-rules.md
│   ├── output-style.md
│   └── roles.md

├── skills/               # 技能定义
│   ├── answer/
│   ├── architecture-review/
│   ├── commit-message/
│   ├── develop-feature/
│   ├── fix-bug/
│   ├── github/
│   ├── handoff/
│   ├── loop-until-done/
│   ├── refactor/
│   └── review-code/
├── agents/               # Agent 定义
│   ├── documenter.md
│   ├── implementer.md
│   ├── planner.md
│   ├── prompt-refiner.md
│   ├── researcher.md
│   ├── reviewer.md
│   ├── security-auditor.md
│   ├── tester.md
│   └── verifier.md
└── hooks/                # 生命周期钩子
    ├── post-compact.sh
    ├── pre-compact.sh
    ├── pre-write-check.sh
    └── session-start.sh
```

## 故障排除

### Hook 执行失败

```bash
# 检查 Hook 权限
ls -la ~/.claude/hooks/*.sh
# 应该都是 -rwxr-xr-x

# 重新设置权限
chmod +x ~/.claude/hooks/*.sh
```

### jq 未找到

```bash
# macOS
brew install jq

# Linux
sudo apt-get install jq
```

## 卸载

```bash
# 备份当前配置
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# 删除所有文件
rm -rf ~/.claude

# 或者只删除 AGENTS 相关文件
rm ~/.claude/CLAUDE.md
rm -rf ~/.claude/rules ~/.claude/skills ~/.claude/agents ~/.claude/hooks
```

## 更新

运行 `UPGRADE.md` 中的升级命令。
