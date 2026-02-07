---
name: refactor
description: 当代码结构调整可能改变行为、时序或输出（性能优化、重写、模块拆分、同步改异步、数据模型迁移）时使用。
---

# 重构

## 概述

**这是一个编排技能** - 组织 superpowers 基础技能来完成重构流程。

本项目依赖 [superpowers plugin](https://github.com/obra/superpowers) 提供的基础开发流程。

## 必需子技能 (REQUIRED SUB-SKILLS)

按以下顺序调用：

1. **superpowers:brainstorming** - 分析现有设计，探索重构方案
   - 理解当前架构
   - 提出重构选项
   - 确认行为边界

2. **superpowers:writing-plans** - 编写重构计划
   - 定义行为边界（什么可以变，什么不能变）
   - 分解为安全的步骤
   - 保存到 `docs/plans/`

3. **superpowers:test-driven-development** - 测试保护下的重构
   - 先写/更新测试（捕获现有行为）
   - 在测试保护下重构
   - 保持测试绿色

4. **superpowers:verification-before-completion** - 完成前验证

## 快速参考

| 阶段 | 调用技能 | 输出 |
|---|---|---|
| 1. 分析 | brainstorming | 重构方案 |
| 2. 计划 | writing-plans | 重构计划 + 行为边界 |
| 3. 实施 | test-driven-development | 重构代码 + 测试 |
| 4. 验证 | verification-before-completion | 验证证据 |

## 何时使用

- 性能优化、重写、模块拆分
- 同步改异步、数据模型迁移
- 任何可能改变行为、时序或输出的调整

**不适用：** 仅修 bug → fix-bug；新功能 → develop-feature

## 工作流程

```
用户请求重构
       ↓
调用 superpowers:brainstorming
       ↓
   确认行为边界
       ↓
调用 superpowers:writing-plans
       ↓
   计划包含边界定义
       ↓
调用 superpowers:test-driven-development
       ↓
   先写测试捕获现有行为
   然后在测试保护下重构
       ↓
调用 superpowers:verification-before-completion
       ↓
   完成
```

## 异常处理

| 异常场景 | 处理方式 |
|---------|----------|
| 无法明确行为边界 | 列出不确定项，请用户确认可接受的行为变化范围 |
| 基线测试不足以覆盖边界 | 先补充测试再开始重构 |
| superpowers 子技能不可用 | 回退到 loop-until-done 框架手动执行对应阶段 |
| 重构中测试持续红色 | 回退到上次绿色状态，缩小重构步幅 |

## 行为边界清单

重构的核心是**定义行为边界**，必须明确列出：

- [ ] 公共 API 与返回结构
- [ ] 数据 schema 与迁移兼容性
- [ ] 输出顺序与格式
- [ ] 错误类型、消息与状态码
- [ ] 时序、并发与副作用
- [ ] 资源占用（CPU、内存、I/O）

## 项目特定补充

在 superpowers 技能基础上，本项目额外要求：

- [ ] 重构计划保存在 `docs/plans/YYYY-MM-DD-<名称>-refactor.md`
- [ ] 行为边界必须明确写入计划
- [ ] 变更前必须有基线测试
- [ ] 大型重构需要回滚计划

## 完成标准

- [ ] brainstorming 完成方案分析
- [ ] writing-plans 完成重构计划（含边界定义）
- [ ] TDD 完成（测试保护下的重构）
- [ ] 所有测试通过，无回归
- [ ] verification-before-completion 通过

## 常见错误

### 流程违规
- 跳过边界定义直接重构
- 重构后才写测试
- 无基线测试就声称"行为不变"

### 调用问题
- 只说"用 superpowers"但不指定具体技能名
- 调用顺序错误
- 中途跳过验证

## 借口 vs 事实

| 借口 | 事实 |
| --- | --- |
| "重构不改行为，不需要测试" | 时序与副作用会改变行为，必须先写测试捕获。 |
| "我先重构再写测试" | 重构后的测试不能证明行为不变，违反 TDD。 |
| "边界很明显，不需要写" | "明显"的边界经常被遗漏，必须明确列出。 |
| "有 feature flag 就安全" | flag 降低风险，不是验证，仍需测试。 |

## 红旗 - 立即停止

- 重构前未定义行为边界
- 写代码前未调用 test-driven-development
- 声称"行为不变"但无基线测试
- 说"用 superpowers"但不指定具体技能名

## 示例：行为边界定义

```typescript
// 重构前：先写测试定义边界
test('loadUserProfile behavior boundary', async () => {
  const api: Api = {
    fetchUser: async () => ({ id: 'u1' }),
    fetchPosts: async () => ['p1', 'p2'],
  };

  const result = await loadUserProfile(api);

  // 边界：输出结构不变
  expect(result).toHaveProperty('userId');
  expect(result).toHaveProperty('postCount');

  // 边界：数据来源不变
  expect(result.userId).toBe('u1');
  expect(result.postCount).toBe(2);
});
```

## 与原技能的区别

**原版本：** 自定义重构流程（定义边界 → 基线 → 实现 → 验证）

**新版本：** 编排者模式，调用 superpowers 技能

好处：
- 方案探索由 brainstorming 处理
- 计划编写由 writing-plans 处理
- 测试保护由 TDD 强制执行
- superpowers 更新时自动受益
