---
name: fix-bug
description: 当处理缺陷、回归、失败测试、崩溃、错误输出、性能下降或不稳定行为（包括需要先补充复现或证据的情况）时使用。
---

# 修复缺陷

## 概述

**这是一个编排技能** - 组织 superpowers 基础技能来完成 bug 修复流程。

本项目依赖 [superpowers plugin](https://github.com/obra/superpowers) 提供的基础调试流程。

## 必需子技能 (REQUIRED SUB-SKILLS)

按以下顺序调用：

1. **superpowers:systematic-debugging** - 根因分析
   - Phase 1: Root Cause Investigation
   - Phase 2: Pattern Analysis
   - Phase 3: Hypothesis and Testing

2. **superpowers:test-driven-development** - 测试驱动修复
   - RED: 写失败测试
   - GREEN: 最小修复
   - REFACTOR: 清理

3. **superpowers:verification-before-completion** - 完成前验证

## 快速参考

| 阶段 | 调用技能 | 输出 |
|---|---|---|
| 1. 诊断 | systematic-debugging | 根因 + 复现步骤 |
| 2. 修复 | test-driven-development | 测试 + 修复 |
| 3. 验证 | verification-before-completion | 验证证据 |

## 何时使用

- 缺陷、回归、失败测试、崩溃
- 错误输出、性能下降、不稳定行为
- **包括**需要先补充复现或证据的情况

**不适用：** 新功能 → develop-feature；重构 → refactor

## 工作流程

```
用户报告 Bug
       ↓
调用 superpowers:systematic-debugging
       ↓
   根因已确认？
       ↓ 是
调用 superpowers:test-driven-development
       ↓
   RED → GREEN → REFACTOR
       ↓
调用 superpowers:verification-before-completion
       ↓
   完成
```

## 异常处理

| 异常场景 | 处理方式 |
|---------|----------|
| systematic-debugging 无法确认根因 | 列出候选假设和已排除项，请用户提供更多上下文 |
| 根因确认但无法复现 | 记录环境差异，在最接近的条件下编写测试 |
| superpowers 子技能不可用 | 回退到 loop-until-done 框架手动执行对应阶段 |
| 修复引入新回归 | 回滚修复，重新进入 systematic-debugging |

## 项目特定补充

在 superpowers 技能基础上，本项目额外要求：

- [ ] 修复后更新相关文档（如果行为变化影响用户）
- [ ] 在代码中添加解释根因的注释（如果不是显而易见的）
- [ ] 考虑添加监控以早期发现类似问题

## 完成标准

- [ ] systematic-debugging 完成根因分析
- [ ] TDD 循环完成（红→绿→重构）
- [ ] 所有测试通过，无回归
- [ ] verification-before-completion 通过

## 常见错误

### 流程违规
- 跳过 systematic-debugging 直接修复
- 修复后写测试（违反 TDD）
- 测试通过就声称完成（无验证证据）

### 调用问题
- 只说"使用 superpowers"但不具体调用技能名
- 调用顺序错误（如先 TDD 后调试）
- 中途跳过验证步骤

## 借口 vs 事实

| 借口 | 事实 |
| --- | --- |
| "很明显，不需要调试流程" | "明显"的根因经常是错的，必须验证。 |
| "我先修复再写测试" | 测试后置无法证明测试有效，违反 TDD。 |
| "superpowers 太复杂了" | 不用系统的调试方法会花更多时间。 |
| "我已经知道怎么修了" | 知道怎么修 ≠ 知道根因。 |
| "测试可以后补" | 补的测试会通过，无法验证有效性。 |

## 红旗 - 立刻停止

- 提出修复方案前未调用 systematic-debugging
- 写代码前未调用 test-driven-development
- 声称完成前未调用 verification-before-completion
- 说"用 superpowers"但不指定具体技能名

## 与原技能的区别

**原版本：** 自定义调试流程（调研 → 定位 → 修复）

**新版本：** 编排者模式，调用 superpowers 技能

好处：
- 消除重复定义
- superpowers 更新时自动受益
- 与其他项目使用一致的基础流程
