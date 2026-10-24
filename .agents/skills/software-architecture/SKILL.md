---
name: software-architecture
description: >-
  Designs or reviews system-level architecture: quality attribute scenarios,
  system and service boundaries, integration and failure behavior, technology
  choices, feasibility spikes, architecture decision records and migration paths.
  Use for 架构设计/技术方案评审, choosing between architectural options, assessing
  scalability/availability/security risks, or planning an evolution of a running
  system. Exclude routine coding, settled diagram edits and module-internal design
  without system-level consequences (use software-design-philosophy).
---

# 系统架构与技术验证

让重要质量要求有可解释的实现路径，让高代价决定能被证据检验。保留已有架构与约束，按当前问题决定分析深度。模块内部的接口与信息隐藏用 `software-design-philosophy`，数据库约束与事务协议用 `database-design`。

## 默认流程

1. **驱动因素**：从当前系统、需求、依赖契约、运行测量和已有决定中找出受影响边界；列出兼容、部署环境、团队能力、预算、期限等已知限制。不从“高并发”“高可用”推造数值，不因框架流行而选型。
2. **质量场景**：把最重要的 1–3 个质量要求写成“来源/刺激 → 环境 → 受影响部分 → 响应 → 衡量方式”。没有目标值时标“待确认”，仍可分析结构与可行性。
3. **责任与结构**：明确事实与规则由谁拥有、调用方向、同步或异步边界、事务与失败语义。业务语义未定先澄清，不在架构里替业务做决定。
4. **方案比较**（仅当有真实选择）：包含“保留现状/渐进修改”方案；比较收益、代价、失败行为、运维负担，以及什么证据会推翻结论。明显的局部选择不做比较表。
5. **先验证最可能推翻方案的未知**：供应商能力、关键延迟、数据迁移可行性、隔离保证等，用有判定标准和结束条件的技术试验回答。试验代码不自动进入生产，样本表现不代表生产容量。
6. **演进与守护**：改变公开接口、事件或存储时，走查新旧共存、回填、切换和恢复；为关键质量要求指定一个持续检查（适应度函数），防止架构随时间退化。
7. **记录**：重大且需长期保留理由的决定写 ADR；仍是提案就标“提议”。

各步骤的展开方法（质量场景、C4 视图、ADR、技术试验、适应度函数、演进走查）见 [decisions.md](references/decisions.md)。

## 默认判断倾向

- 先在单个部署单元内把模块边界做清楚，只有独立部署、独立扩展、故障隔离或团队自治有实际证据时才拆分为分布式服务。
- 优先选团队已掌握、项目已在用的技术；新技术需说明它解决了哪个已存在的问题及运维代价。
- 一致性要求来自业务：不能把“提交时必须成立”的规则悄悄改成“后台稍后修复”。
- 画图只回答当前读者的问题，不为形式完整画全套 C4 层级；图与真实接口或部署矛盾时修正图。

## 输出模板（默认格式，可裁剪）

```markdown
## 结论
<推荐方案，一两句话；是否需要用户决定>

## 驱动因素
- 质量场景 Q1：<刺激> 在 <环境> 下，<部分> 应 <响应>，以 <衡量方式> 判定（目标值：…/待确认）
- 约束：…

## 方案与取舍
| 方案 | 满足哪些场景 | 代价与风险 | 推翻条件 |
| --- | --- | --- | --- |

## 关键视图／契约
<只放回答问题所需的图或接口说明>

## 验证与守护
- 已验证：…（证据）
- 待验证：…（试验设计与判定标准）
- 持续检查：…（适应度函数）

## 实施顺序与风险
1. …（不可逆步骤单独标出）
```

## 停止条件

结论、必要视图/契约、关键取舍与证据、实施顺序和未决风险足以支持当前决定或授权实现时停止。不为预想规模增加分布式组件；设计请求只交付可审查方案，不实际发布或迁移。

主要来源：Bass/Clements/Kazman 质量属性方法、Brown 的 C4、Nygard 的 ADR、Ford/Parsons 等的演进式架构与适应度函数；详见 [来源映射](../software-delivery/references/sources.md)。
