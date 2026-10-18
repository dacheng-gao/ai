---
name: software-implementation
description: >-
  Implement behavior changes, diagnose defects and safely refactor existing code
  using contracts, focused evidence and incremental verification. Use for
  nontrivial code changes or legacy behavior risks. Exclude trivial text edits,
  design-only requests and standalone test-strategy work.
---

# 实现、调试与安全修改

交付符合已知契约、容易审查的最小正确变更。现有约定优先，技术手段由真实问题决定。

## 理解修改范围

先读取相关项目规则、当前修改、入口、直接依赖、已有测试及验证命令。沿行为路径定向阅读，不把整个仓库扫描完才开始。区分已有行为、目标行为和兼容要求；测试描述现状时也可能包含旧缺陷。

缺陷任务先建立复现或最小证据，提出可被检查区分的原因假设。选择最便宜、能改变诊断的观察；失败时更新假设，不堆叠猜测式补丁。无法复现时明确证据局限，只把有支持的改动称为修复候选。

## 小步实施

- 明确输入、结果、副作用、失败语义及负责规则的边界，再选择最小修改位置。遵守可信内部契约；在外部输入、权限或数据转换边界做必要验证。
- 已有清楚方案就直接实施。只有设计选择实质影响耦合和修改成本时使用 `software-design-philosophy`；语义或数据库约束未定时处理相应缺口，不偷偷发明政策。
- 改动难以验证或依赖复杂时，读 [safe-change.md](references/safe-change.md)，按需使用特征测试、依赖接缝和行为保持的重构。不要默认重写旧系统。
- 将结构调整与行为变化分成可理解的小步；两者确有依赖可以在同一任务内完成，但验证中要能分辨变化原因。
- 纯逻辑、状态转换或回归修复适合测试先行时，用失败测试确认问题，再实现、整理。已有测试足够或改动低风险时，不强制 TDD 或新增测试。

## 验证行为和差异

按影响范围执行已有快速检查，并增加必要的、能拒绝错误实现的行为检查。边界问题用集成检查，UI 行为用适当交互验证；不要用大量 mock 证明真实系统集成正确。复杂测试选择可用现有 `software-testing`。

检查最终差异：规则是否只在正确位置改变，错误是否清楚传播，公共契约是否有意变化，是否包含无关修改或机密。注释解释非显然约束与理由；改到契约或运行方式时同步必要文档。

失败若由本次修改造成则修复；环境或既有失败单独说明，不扩大改动。检查通过且没有新增问题就停止重复运行，不为增加测试数量制造工作。

## 交付

报告具体行为变化、验证结果和材料限制。没有执行的测试标未运行，局部通过不写成整个系统通过。完成授权代码修改不等同于提交、发布或用户验收。

Fowler 的重构与 Feathers 的遗留代码方法见 [来源映射](../software-delivery/references/sources.md)；本技能不把专家经验当作普遍性能或生产力保证。
