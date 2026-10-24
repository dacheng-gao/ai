---
name: software-implementation
description: >-
  Implements business features and behavior changes, diagnoses and fixes defects,
  and safely refactors existing or legacy code using contracts, small verified
  steps and focused evidence. Use for nontrivial code changes
  (实现业务需求、修复缺陷、调试、重构遗留代码), especially when behavior must be preserved or the
  cause of a bug is unclear. Exclude trivial text edits, design-only requests and
  standalone test-strategy work.
---

# 实现、调试与安全修改

交付符合已知契约、容易审查的最小正确变更。现有约定优先，技术手段由真实问题决定。

## 选择入口

- **实现功能或行为变化**：按下方默认流程。
- **缺陷或异常行为**：先读 [debugging.md](references/debugging.md)，复现并定位原因后再回到默认流程第 3 步。
- **改动难以验证、缺少测试或依赖复杂**：读 [safe-change.md](references/safe-change.md)（特征测试、依赖接缝、先整理再改行为、TDD 适用条件）。

## 默认流程

复制并跟踪以下清单：

```
- [ ] 1. 读：项目规则、当前未提交改动、入口、直接依赖、已有测试与验证命令
- [ ] 2. 定契约：输入、结果、副作用、失败语义、负责该规则的边界；区分现有行为、目标行为、兼容要求
- [ ] 3. 定位置：最小修改点；需要先整理结构才能让改动变简单时，先整理（行为不变）
- [ ] 4. 改：结构调整与行为变化分步进行，每步可验证
- [ ] 5. 验：运行已有快速检查 + 能拒绝错误实现的行为检查；失败则回到第 3 或 4 步
- [ ] 6. 审差异：规则只在正确位置改变、错误清楚传播、公开契约变化是有意的、无无关修改或机密
```

小范围改动可把 1–2 步合并为一次定向阅读、5–6 步合并为一次检查，不必逐项汇报。

要点：

- 沿行为路径定向阅读，不先扫完整个仓库。测试描述的是现状，也可能固化了旧缺陷。
- 遵守可信内部契约，只在外部输入、权限、数据转换等信任边界校验。能用类型或数据结构让非法状态无法表示时，优先于在各处补检查。
- 已有清楚方案就直接实施。设计选择会实质影响耦合和修改成本时用 `software-design-philosophy`；业务语义或数据库约束未定时处理那个缺口，不偷偷发明政策。
- “先让改动变容易，再做容易的改动”：结构整理只覆盖本次所需范围，不顺手做全面重构。
- 纯逻辑、状态转换或回归修复适合先写失败测试；已有测试足够或改动低风险时，不强制 TDD 或新增测试。复杂测试选择用 `software-testing`。
- 边界问题用集成检查，UI 行为用交互验证；不要用大量 mock 证明真实集成正确。
- 注释解释非显然的约束与理由；改到契约或运行方式时同步必要文档。

## 失败与停止

- 本次修改造成的失败就修复；环境或既有失败单独报告，不扩大改动。
- 连续两次修复没有进展时停下，回到最小复现重新检查前提，不继续堆补丁。
- 检查通过、差异解释清楚就停止，不为增加测试数量或“顺便优化”制造工作。

## 交付

报告具体行为变化、验证命令与结果、材料限制。未执行的检查标“未运行”并写明原因；局部通过不写成系统通过。完成代码修改不等于提交、发布或用户验收。

方法来源：Fowler《Refactoring》、Feathers《Working Effectively with Legacy Code》、Beck《Tidy First?》与 TDD、Agans《Debugging》；见 [来源映射](../software-delivery/references/sources.md)。
