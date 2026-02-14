# Skills × Agents 协作接口规范

定义 Skills 如何调度和编排 Agents，确保工作流平滑、可验证、可迭代。

## 核心概念

```
Skill = 任务路由器 + 流程编排器
Agent = 独立执行单元（隔离上下文）
Superpower = 流程方法论（通过 Skill 调用）
```

## 一、Agent 接口规范

### 1.1 标准输入

每个 Agent 接收结构化的任务描述：

```typescript
interface AgentInput {
  // 任务类型
  task: string;                    // "explore-architecture" | "implement-feature" | ...

  // 上下文
  context: {
    // 必需
    target?: string;               // 目标文件/模块/功能
    specification?: string;        // 详细规格或计划

    // 可选
    constraints?: string[];        // 约束条件
    references?: string[];         // 参考文件路径
    previousFindings?: string;     // 前序 agent 的发现
  };

  // 输出要求
  outputFormat?: string;           // 期望的输出格式
}
```

### 1.2 标准输出

每个 Agent 返回结构化结果：

```typescript
interface AgentOutput {
  // 执行状态
  status: "success" | "partial" | "failed" | "blocked";

  // 核心产出
  result: string;                  // 主要结论或产出

  // 结构化数据（可选）
  data?: {
    files?: FileInfo[];            // 涉及的文件
    findings?: Finding[];          // 发现项
    issues?: Issue[];              // 问题列表
  };

  // 后续建议
  nextSteps?: string[];            // 建议的下一步

  // 阻塞信息
  blockedReason?: string;          // 被阻塞的原因
  blockedBy?: string;              // 需要什么才能继续
}
```

### 1.3 Agent 能力声明

每个 Agent 在其 .md 文件中声明能力：

```yaml
---
name: implementer
description: 代码实现执行器
model: sonnet
tools: Read, Write, Edit, Bash
capabilities:
  - code-generation
  - code-modification
  - code-deletion
constraints:
  - requires-specification        # 需要明确的规格
  - max-files: 10                 # 单次最多修改文件数
  - no-git-commit                 # 不执行 git commit
---
```

---

## 二、Skill 调度模式

### 2.1 串行执行（有依赖）

```
Step 1 → Step 2 → Step 3
   ↓         ↓         ↓
Agent A   Agent B   Agent C
```

**触发条件**：后一步依赖前一步的输出

```markdown
## 串行执行示例

1. 调用 `researcher` 探索代码库
2. 等待结果，获取 `previousFindings`
3. 调用 `implementer`，传入 `previousFindings` 作为上下文
4. 等待实现完成
5. 调用 `verifier` 验证
```

### 2.2 并行执行（无依赖）

```
        ┌→ Agent A →┐
Start →─┼→ Agent B →┼→ Merge → End
        └→ Agent C →┘
```

**触发条件**：多个独立任务可同时执行

```markdown
## 并行执行示例

同时发起 3 个 Task 调用：
- `researcher` (prompt: "探索认证模块架构")
- `researcher` (prompt: "探索数据库 schema")
- `researcher` (prompt: "探索 API 接口定义")

合并结果后进入下一步
```

### 2.3 条件执行

```
         ┌→ Agent A (if condition) →┐
Input →─┤                           ├→ End
         └→ Agent B (else)     →┘
```

**触发条件**：根据前序结果决定分支

```markdown
## 条件执行示例

IF `verifier` 返回 status="failed":
    调用 `researcher` 分析失败原因
    调用 `implementer` 修复
    重新调用 `verifier`
ELSE:
    进入下一阶段
```

---

## 三、Skill-Agent 协作模板

### 3.1 develop-feature 模板

```markdown
## develop-feature 执行流程

### Phase 1: 需求澄清
CALL `superpowers:brainstorming`
  - IF 用户请求足够明确 → 跳过
  - ELSE → 执行苏格拉底式对话

### Phase 2: 代码探索（并行）
PARALLEL {
  CALL `researcher` WITH {
    task: "explore-architecture",
    context: { target: "相关模块" }
  }
  CALL `researcher` WITH {
    task: "explore-interfaces",
    context: { target: "相关 API" }
  }
}
MERGE findings

### Phase 3: 计划生成
IF 复杂任务 (≥3 模块 / schema 变更 / API 变更):
  CALL `EnterPlanMode` OR `superpowers:writing-plans`
ELSE:
  INLINE plan (3-5 steps)

### Phase 4: 实现（TDD）
CALL `superpowers:test-driven-development`
LOOP until done:
  CALL `implementer` WITH {
    task: "implement",
    context: {
      specification: plan.currentStep,
      references: findings
    }
  }

  CALL `tester` WITH {
    task: "write-test",
    context: {
      target: changedFiles,
      specification: plan.currentStep.behavior
    }
  }

  CALL `verifier` WITH {
    task: "verify",
    context: { target: changedFiles }
  }

  IF status != "success":
    CALL `implementer` WITH { task: "fix", context: { previousFindings: verifier.output } }

### Phase 5: 安全检查（条件）
IF 涉及鉴权/外部输入/敏感数据:
  CALL `security-auditor` WITH {
    task: "audit",
    context: { target: changedFiles }
  }

### Phase 6: 收尾
CALL `superpowers:verification-before-completion`
```

### 3.2 fix-bug 模板

```markdown
## fix-bug 执行流程

### Phase 1: 问题定位（并行）
PARALLEL {
  CALL `researcher` WITH {
    task: "analyze-logs",
    context: { target: "错误日志/堆栈" }
  }
  CALL `researcher` WITH {
    task: "trace-code-path",
    context: { target: "相关代码路径" }
  }
}
MERGE findings → rootCauseHypothesis

### Phase 2: 系统调试
CALL `superpowers:systematic-debugging` WITH {
  hypothesis: rootCauseHypothesis
}

### Phase 3: 修复（TDD）
CALL `superpowers:test-driven-development`
  1. CALL `tester` WITH { task: "write-reproduction-test" }
  2. VERIFY test FAILS
  3. CALL `implementer` WITH { task: "fix", context: { specification: rootCause } }
  4. VERIFY test PASSES

### Phase 4: 验证
CALL `verifier` WITH {
  task: "full-verify",
  context: { target: "all-changed-files" }
}

IF status != "success":
  ROLLBACK fix
  GOTO Phase 2

### Phase 5: 收尾
CALL `superpowers:verification-before-completion`
```

---

## 四、Agent 调用约定

### 4.1 调用语法

在 Skill 中使用 Task 工具调用 Agent：

```markdown
<!-- 正确的调用方式 -->
调用 `researcher` agent：

Task(
  subagent_type: "researcher",
  prompt: """
  任务：探索认证模块的架构

  目标：理解以下内容
  - 认证流程的数据流
  - 关键函数和它们的职责
  - 与其他模块的接口

  输出格式：按标准 AgentOutput 格式返回
  """,
  description: "探索认证架构"
)
```

### 4.2 并行调用语法

```markdown
<!-- 在同一消息中发起多个 Task 调用 -->
PARALLEL {
  Task(subagent_type: "researcher", prompt: "...架构探索..."),
  Task(subagent_type: "researcher", prompt: "...接口探索...")
}
```

### 4.3 后台执行语法

```markdown
<!-- 长时间任务使用后台执行 -->
Task(
  subagent_type: "verifier",
  prompt: "执行全量测试验证",
  run_in_background: true
)

<!-- 之后检查输出 -->
TaskOutput(task_id: "xxx", block: true)
```

---

## 五、错误处理规范

### 5.1 Agent 级别错误

| 状态 | 含义 | Skill 应对 |
|------|------|-----------|
| `success` | 完全成功 | 继续下一步 |
| `partial` | 部分完成 | 评估是否可继续，或补充调用 |
| `failed` | 执行失败 | 分析原因，重试或报告用户 |
| `blocked` | 被阻塞 | 获取 `blockedBy`，解除阻塞后重试 |

### 5.2 重试策略

```markdown
## 重试规则

MAX_RETRIES = 3

FOR each retry:
  IF error is transient (timeout, rate limit):
    WAIT exponential_backoff
    RETRY
  ELSE IF error is fixable:
    ADJUST input based on error message
    RETRY
  ELSE:
    ESCALATE to user with:
      - Error details
      - What was attempted
      - Suggested next steps
```

### 5.3 回滚策略

```markdown
## 回滚触发条件

- `verifier` 报告 regression
- `security-auditor` 报告 critical issue
- 用户明确要求停止

## 回滚动作

1. `git restore .` (未提交的变更)
2. 或 `git revert HEAD` (已提交的变更)
3. 记录回滚原因
4. 报告用户下一步建议
```

---

## 六、上下文传递规范

### 6.1 Agent 间上下文传递

```markdown
## 上下文链

researcher 输出:
  findings: ["模块A负责X", "模块B调用模块A"]

  ↓ 传递给 implementer

implementer 输入:
  context: {
    previousFindings: "模块A负责X，模块B调用模块A",
    specification: "在模块A中添加Y功能"
  }

  ↓ 传递给 verifier

verifier 输入:
  context: {
    target: implementer.changedFiles,
    previousFindings: implementer.result
  }
```

### 6.2 上下文压缩

当上下文过长时，使用结构化摘要：

```markdown
## 压缩规则

IF context > 2000 tokens:
  EXTRACT:
    - 关键决策（3-5 条）
    - 文件变更列表
    - 未解决问题列表
  DISCARD:
    - 详细搜索过程
    - 完整代码片段（保留关键行）
```

---

## 七、验证检查点

### 7.1 Skill 级别检查点

每个 Skill 在关键节点设置检查点：

```markdown
## 检查点模板

### Checkpoint 1: 需求确认
- [ ] 用户意图已明确
- [ ] 验收标准已定义
- [ ] 范围边界已确认

### Checkpoint 2: 设计确认
- [ ] 技术方案已确定
- [ ] 风险已识别
- [ ] 计划已批准

### Checkpoint 3: 实现完成
- [ ] 代码已编写
- [ ] 测试已通过
- [ ] 无 lint 错误

### Checkpoint 4: 验收通过
- [ ] 所有验收标准满足
- [ ] 无回归
- [ ] 文档已更新
```

### 7.2 Agent 级别验证

每个 Agent 在返回前自检：

```markdown
## Agent 自检清单

implementer:
  - [ ] 代码符合规格
  - [ ] 无硬编码敏感信息
  - [ ] 遵循项目代码风格

verifier:
  - [ ] typecheck 通过
  - [ ] lint 通过
  - [ ] 测试通过

reviewer:
  - [ ] 正确性 Pass
  - [ ] 安全性 Pass
  - [ ] 性能无 Concern
  - [ ] 可维护性 Pass
```

---

## 八、完整示例

### develop-feature 完整调用链

```markdown
# 用户请求：添加用户登录缓存功能

## Phase 0: 路由
MATCH → develop-feature

## Phase 1: Brainstorming
CALL superpowers:brainstorming
→ 确认：使用 Redis 缓存，TTL 30分钟，key格式 user:{id}

## Phase 2: 探索（并行）
Task(subagent_type: "researcher",
  prompt: "探索 auth 模块架构，定位登录逻辑位置")
Task(subagent_type: "researcher",
  prompt: "探索 Redis 连接配置和现有使用模式")
→ 发现：auth/service.ts:45 login()，redis/client.ts 已配置

## Phase 3: 计划
CALL EnterPlanMode
→ 计划：
  1. 在 auth/service.ts 添加缓存层
  2. 添加缓存失效逻辑
  3. 更新测试

## Phase 4: TDD 实现

### Step 1: 写测试
Task(subagent_type: "tester",
  prompt: """
  任务：为登录缓存编写测试
  目标文件：auth/service.test.ts
  场景：
  - WHEN 首次登录 THEN 缓存 miss，查数据库
  - WHEN 缓存命中 THEN 返回缓存数据
  - WHEN 缓存过期 THEN 重新查询
  """)
→ 测试 FAIL（预期）

### Step 2: 实现
Task(subagent_type: "implementer",
  prompt: """
  任务：实现登录缓存
  规格：
  - 在 auth/service.ts:45 login() 添加缓存逻辑
  - 使用 Redis，key格式 user:{id}
  - TTL 30分钟
  参考文件：redis/client.ts
  """)
→ 实现完成

### Step 3: 验证
Task(subagent_type: "verifier",
  prompt: "验证 auth 模块：typecheck + lint + test")
→ PASS

## Phase 5: 安全检查
Task(subagent_type: "security-auditor",
  prompt: "审计 auth/service.ts 缓存实现，检查敏感数据是否被缓存")
→ 发现：密码哈希不应缓存 → 调用 implementer 修复

## Phase 6: 收尾
CALL superpowers:verification-before-completion
→ 确认：功能完成，测试通过，安全审计通过
```
