# Verification Checklist

## Purpose

本文件定义 `develop-feature` 的最小验证矩阵与交付证据门槛，用于把“功能已完成”的说法绑定到实际证据。

它与 `rules/deliverable-quality-gate.md` 对齐，但只保留功能开发场景需要的操作化版本。

## Verification Matrix

| Deliverable Type | Must Check | Typical Evidence |
|---|---|---|
| `code` | `Typecheck / Build`、`Lint / Static Analysis`、`Test`、适用的手动验证 | 命令、退出码、关键通过摘要 |
| `docs` | 结构回读、术语一致性、步骤/路径/命令回读、与实现一致性检查 | 回读结论、抽样命令或路径核对 |
| `mixed` | 同时满足 `code` 与 `docs` 要求，并检查文档承诺与代码行为一致 | 命令摘要 + 文档一致性说明 |

说明：

- 不适用项必须显式标记 `N/A`，并写明原因
- 不能因为改动小或“看起来简单”而静默跳过验证

## Minimum Evidence By Claim

### Claim: 功能已完成

至少需要：

- 已完成项与未完成项清单
- 与验收直接相关的验证证据
- 若有降级或跳过项，必须显式披露

### Claim: 无明显回归

至少需要：

- 与受影响行为直接相关的测试或手动验证
- 对关键失败路径、边界或兼容性的说明

### Claim: `production-ready`

至少需要：

- 所有适用 `MUST` 验证项已完成
- 无未披露阻断风险
- 证据强度与风险等级匹配

如果任何一项不满足，只能报告实际状态，例如 `Partial`、`Conditional Pass` 或 `Fail`。

## `N/A` Rules

只有在条目确实不适用时，才可以标记 `N/A`。

可接受示例：

- 纯文档改动的 `Typecheck / Build`：`N/A`，因为本次未修改可构建代码
- 无静态分析工具的仓库级检查：`N/A`，因为仓库当前未配置对应工具

不可接受示例：

- `Test: N/A`，因为“改动很小”
- `Manual Verification: N/A`，因为“理论上没问题”

## Reporting Template

建议按以下骨架汇报：

- `Artifact Type`
- `Scope`
- `Result: PASS | CONDITIONAL PASS | FAIL`
- `Evidence`
- `Risks`
- `Waiver: none | ...`
- `Done / Partial / Skipped`

## Final Gate Questions

在声称完成前，至少自检以下问题：

- 这次声称的“完成”，是否真的覆盖了用户目标与验收？
- 我是否运行或回读了足以支撑该结论的检查？
- 我是否把 `N/A` 当成了偷跳验证的借口？
- 代码与文档是否互相一致？
- 我是否披露了残余风险、限制和跳过项？
