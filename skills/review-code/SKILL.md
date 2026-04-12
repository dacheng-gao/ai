---
name: review-code
description: Use when reviewing pull requests, diffs, patches, or repository files to identify merge-blocking issues, important risks, and evidence gaps without directly fixing the reviewed artifact.
argument-hint: "[PR-url | diff | patch | file...]"
---

# 代码评审

## Overview

`review-code` 是纯评审 lane。它的职责不是直接修代码，而是基于最小必要证据识别阻断问题、重要风险与证据缺口，并给出清晰、可执行、可追溯的评审结论。

它默认是代码优先的通用评审 skill，可用于未来安装到用户全局家目录后的普通仓库场景；当评审对象命中脚本、文档、规则、skills、prompt 或其他 agent 行为资产时，再追加专项检查视角。

## When to Use

适用于：

- PR、diff、patch 的合并前评审
- 仓库内局部文件或局部变更的质量审查
- 对提交后的变更做 targeted review，确认风险、缺口与后续动作
- 需要把评审结论显式绑定到证据，而不是给泛泛建议

## When Not to Use

以下情况不要直接进入本 skill：

- 任务目标是直接修复、重构、实现或补文档，而不是做评审结论
- 用户主要在问“这段代码做了什么”或“方案该怎么选”
- 任务本质是架构评审、需求收敛、缺陷修复或功能开发
- 只是在处理自己收到的 review feedback，而不是对变更本身做独立审查

遇到这些情况时，优先转交：

- 收到他人对自己代码的评审反馈：`superpowers:receiving-code-review`
- 完成任务后需要二次审阅确认：`superpowers:requesting-code-review`
- 缺陷处理：`skills/fix-bug/SKILL.md`
- 功能交付：`skills/develop-feature/SKILL.md`
- 结构调整：`skills/refactor/SKILL.md`
- 纯问答：`skills/answer/SKILL.md`
- 架构层风险评审：`skills/architecture-review/SKILL.md`

## Hard Gates

1. 在给出正式评审结论前，必须先对齐：`评审对象 / 范围 / 评审目标 / 不做 / 当前证据`。
2. 在评审范围不清时，不得输出泛化结论；先缩小范围或显式标记未覆盖区域。
3. 在没有最小证据面的情况下，不得使用“没问题”“看起来可以合并”之类成功表述。
4. 不得把个人偏好、风格洁癖或可选重构包装成阻断问题。
5. 不得把 `review-code` 退化成代修、重写方案或顺手实现的 lane。
6. 当变更过大、上下文不足、验证缺失或 review unit 缠结时，必须先降级结论或要求拆分，而不是伪装成已完成全面评审。
7. 在没有新鲜证据前，不得声称“已通过”“可合并”“production-ready”。

## Operating Loop

1. `Align`
   - 用最短形式回显：`对象 / 范围 / 目标 / 不做 / 证据`
   - 默认先确认本次评的是 `PR / diff / patch / file`
   - 若用户只说“帮我 review”，先用最小代价锁定评审对象
2. `Classify`
   - 识别产物类型：`code / script / doc / mixed`
   - 识别评审场景：`pre-merge / post-change audit / targeted file review`
   - 识别风险等级：`low / standard / high-risk`
   - 命中 `rules / skills / prompts / agent behavior` 时，显式追加对应视角
3. `Gather Evidence`
   - 收集最小必要证据：diff、相关上下文文件、验证记录、需求或验收依据
   - 若证据缺失，继续评审可以，但必须在结论中显式披露 `evidence gap`
   - 优先让证据能回链到文件、命令、日志、输出或需求来源
4. `Review`
   - 先做基础四问：`目标是否达成 / 实现是否正确 / 验证是否充分 / 交付是否可用`
   - `code` 默认检查：正确性、安全、边界条件、回归风险、复杂度、可维护性
   - `script` 默认检查：参数与路径安全、危险操作保护、失败退出、恢复路径、幂等性
   - `doc` 默认检查：事实一致性、结构清晰度、步骤可执行性、术语一致性、过时信息
   - 只有在对象命中时才追加规则、skills、prompt、PRD、测试文档等专项检查
5. `Decide`
   - 先产出 findings，再产出双轨结论：
   - `Review Action`: `Approve | Comment | Request Changes`
   - `Quality Result`: `PASS | CONDITIONAL PASS | FAIL`
   - 默认只使用这三种高可解释组合：
     - `Approve + PASS`
     - `Comment + CONDITIONAL PASS`
     - `Request Changes + FAIL`
6. `Report`
   - 输出 `Findings -> Open Questions -> Review Action -> Quality Result -> Evidence -> Risks / Gaps -> Done / Partial / Skipped`
   - 若未发现阻断问题，也必须说明证据边界与残余风险

## Severity Model

- `Critical`
  - 会阻断合并、发布或可信交付
  - 典型包括：正确性错误、安全问题、行为回归、高风险未验证、危险脚本路径、关键规则冲突
- `Important`
  - 非立即阻断，但应在当前轮修正，或由用户显式接受风险
  - 典型包括：证据不足、回归覆盖缺口、复杂度明显恶化、文档与实现偏移
- `Suggestion`
  - 可选优化项，不默认大量输出
  - 只有在用户要求更全面建议，或当前没有更高优先级问题时再给少量代表项

每条 finding 至少应包含：

- `Location`
- `Severity`
- `Issue`
- `Why it matters`
- `Evidence`
- `Recommended fix`

## Decision Model

`Review Action` 面向协作动作：

- `Approve`
  - 未发现阻断问题，剩余问题均不影响放行
- `Comment`
  - 存在重要但非阻断的问题，或证据存在缺口但不足以直接拒绝
- `Request Changes`
  - 存在阻断问题，或当前证据不足以支持安全放行

`Quality Result` 面向治理判定：

- `PASS`
  - 所有适用 `MUST` 已满足，且证据与结论一致
- `CONDITIONAL PASS`
  - 无阻断问题，但存在已披露的非阻断缺口、限制或证据不足
- `FAIL`
  - 存在阻断问题，或在缺少关键证据时仍无法支持可交付结论

若要偏离默认三种组合，必须显式说明原因、牺牲项与残余风险。

## Load Only What You Need

按需读取配套规则与参考文件：

- `rules/deliverable-quality-gate.md`
  - 需要确认通用门禁、代码/脚本/文档专项门禁、`PASS / CONDITIONAL PASS / FAIL` 判定时读取
- `rules/output-style.md`
  - 需要确认对外输出骨架与措辞边界时读取
- `rules/roles.md`
  - 评审对象涉及高风险、多方案、规则或 agent 行为资产时读取
- `skills/review-code/references/review-check-matrix.md`
  - 需要详细 artifact-type 检查矩阵、severity 边界、evidence downgrade 规则时读取
- `skills/review-code/references/review-verdict-examples-and-anti-patterns.md`
  - 需要快速对齐 verdict 写法、finding 表达方式和常见误判反模式时读取

不要把所有规则与参考文件一次性压进上下文。

## Red Flags

出现以下信号时，说明评审正在退化：

- 还没锁定对象与范围，就开始给“总体没问题”的结论
- 用个人偏好替代 correctness、security 或 verification 问题
- diff 很大或变更缠结，却仍假装做了全面评审
- 没有测试、构建或需求证据，却把推测写成事实
- 把评审变成代修、重构设计或 feature 规划
- 因为是文档、规则或 prompt 文件，就跳过可执行性与行为后果检查
- 因为改动小，就省略 evidence gap、残余风险或验证缺口

## Deliverable Contract

对用户的交付至少应包含：

- `Findings`
- `Open Questions`
- `Review Action`
- `Quality Result`
- `Evidence`
- `Risks / Gaps`
- `Done / Partial / Skipped`

输出 findings 时，默认按严重度排序；若改动范围很小，默认最多先给 Top 5 个最高价值问题。

若未发现阻断问题，必须明确写出：`未发现阻断问题`，并补充证据边界、测试缺口或残余风险。

若当前路径没有更优替代方案，应明确写出：`当前路径合理，暂无更优替代建议。`

## Exit Criteria

- 已明确本次评审的对象、范围、非目标与证据边界
- findings 具备可执行性，且与严重度一致
- 结论与证据一致，没有虚假确定性
- 需要的专项检查已按对象类型启用，而不是默认全开
- 对外汇报满足 `rules/output-style.md` 与 `rules/deliverable-quality-gate.md`
