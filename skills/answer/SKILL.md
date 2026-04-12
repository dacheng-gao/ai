---
name: answer
description: Use when explaining code, answering technical questions, comparing approaches, or providing repository-grounded analysis without entering an implementation or remediation workflow.
---

# 回答问题

## Overview

`answer` 是轻量问答 lane。它的职责是：直接回答用户问题，按需收集最小必要证据，并把结论、不确定性和边界说清楚。

它不是实现 lane，也不是 review、bugfix 或架构治理 lane。除非用户明确转向实现或修复，否则不要把问答伪装成开发流程。

## When to Use

适用于：

- 解释代码、函数、模块、数据流或仓库内已有实现
- 回答技术概念、最佳实践、方案差异或设计取舍
- 评估“这段代码做了什么”“为什么这样写”“哪个方案更合适”
- 给出基于仓库上下文的只读分析与建议

## When Not to Use

以下情况不要直接进入本 skill：

- 用户真实目标是修 bug、做 feature、重构或代码评审
- 任务需要修改文件、补测试、运行高影响命令或形成正式交付
- 问题本质是架构风险评审、需求收敛或测试设计
- 用户给的是手段问题，但真实需要先识别 `XY` 并转到更合适的 lane

遇到这些情况时，优先转交：

- 功能交付：`skills/develop-feature/SKILL.md`
- 缺陷修复：`skills/fix-bug/SKILL.md`
- 结构调整：`skills/refactor/SKILL.md`
- 代码评审：`skills/review-code/SKILL.md`
- 架构评审：`skills/architecture-review/SKILL.md`

## Hard Gates

1. 默认保持只读模式；除非用户明确改变目标，否则不得擅自进入实现、改文件或 Git 变更。
2. 回答代码库问题时，必须先收集最小必要证据，不得凭印象编造实现细节。
3. 若用户问题存在重大歧义、关键上下文缺失或明显 `XY` 风险，必须先澄清或重述真实问题，再作答。
4. 若回答依赖事实判断、代码行为、验证结果或外部资料，必须显式绑定证据或说明证据缺口。
5. 不确定时必须明确标注不确定；不得用猜测伪装成结论。
6. 在没有实际执行验证的情况下，不得声称“已验证”“确定会通过”或等价成功表述。

## Operating Loop

1. `Align`
   - 用最短形式锁定问题：`用户想知道什么 / 是否需要仓库证据 / 是否只要结论或还要依据`
2. `Gather`
   - 涉及仓库时，先做最小必要证据收集，如代码搜索、文件回读、接口定位、调用链核对
   - 涉及通用知识时，优先用稳定事实回答；若事实可能变化或风险较高，再补权威来源
3. `Answer`
   - 先给结论，再给依据；确有必要再给最小下一步
   - 涉及代码时，尽量引用 `file:line` 或等价定位
   - 仅在有助于消除歧义时提供示例
4. `Challenge`
   - 若用户问的是手段而不是目标，或当前路径成本明显偏高，应直接指出更短、更稳妥的路径
5. `Report`
   - 明确区分：`已确认事实 / 基于证据的推断 / 未确认部分`

## Load Only What You Need

按需读取以下规则或相邻 skill：

- `rules/output-style.md`
  - 需要确认问答输出骨架与表达边界时读取
- `skills/develop-feature/SKILL.md`
  - 问答已转向实现方案或行为变更时读取
- `skills/fix-bug/SKILL.md`
  - 问答已转向错误调查、复现与修复时读取
- `skills/review-code/SKILL.md`
  - 用户其实在请求正式代码评审时读取
- `skills/architecture-review/SKILL.md`
  - 讨论已上升到系统级结构、容量、可靠性或治理风险时读取

不要为了回答一个简单问题而装载整套开发流程。

## Red Flags

出现以下信号时，说明问答正在退化：

- 没有读代码或查证据，就断言仓库行为
- 把“可能”“大概”“通常”写成确定事实
- 用户只是问解释，却直接开始改代码或设计方案
- 为了显得完整，给出超出问题范围的大段背景堆砌
- 明明存在更短答案，却把问答拉成长流程
- 把轻量建议包装成“已经验证的结论”

## Deliverable Contract

对用户的交付至少应包含：

- 对当前问题的直接回答
- 关键依据或证据定位
- 不确定性或证据缺口
- 必要时给出最小下一步

若当前路径没有更优替代方案，应明确写出：`当前路径合理，暂无更优替代建议。`

## Exit Criteria

- 用户提出的核心问题已被回答
- 关键结论与证据边界一致，没有虚假确定性
- 涉及仓库实现时，已提供最小必要定位或证据
- 未擅自越界进入实现、修复或评审流程
- 对外表达满足仓库内 `rules/output-style.md`
