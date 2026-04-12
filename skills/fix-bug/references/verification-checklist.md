# Verification Checklist

## Purpose

本文件定义 `fix-bug` 的最小验证矩阵与证据门槛，用于把“已复现”“已定位根因”“已修复”“无明显回归”等说法绑定到实际证据。

它与 `rules/deliverable-quality-gate.md` 对齐，但只保留缺陷修复场景需要的操作化版本。

## Verification Matrix

| Deliverable Type | Must Check | Typical Evidence |
|---|---|---|
| `code bugfix` | 复现证据、根因覆盖验证、`Typecheck / Build`、`Lint / Static Analysis`、`Test`、适用的手动验证 | 命令、退出码、失败转通过摘要 |
| `docs-only` | 结构回读、问题说明与当前实现一致性、步骤/路径/命令回读 | 回读结论、抽样核对 |
| `mixed` | 同时满足代码与文档要求，并检查修复说明与实际行为一致 | 命令摘要 + 文档一致性说明 |

说明：

- 不适用项必须显式标记 `N/A`，并写明原因
- 不能因为“问题已经看起来消失”就跳过根因或回归验证

## Minimum Evidence By Claim

### Claim: 已复现

至少需要：

- 明确的复现步骤、触发条件、失败输出、日志或等价证据

### Claim: 根因已定位

至少需要：

- 能解释问题现象的证据链
- 能说明问题发生在哪一层、为什么发生
- 已排除关键竞争假设，或说明为何当前证据已足够

### Claim: 已修复

至少需要：

- 与根因直接相关的测试或等价验证
- 修复后原始症状消失的证据
- 若只是 workaround / mitigation / rollback，必须按真实状态表述

### Claim: 无明显回归

至少需要：

- 与受影响路径直接相关的测试或手动验证
- 对关键失败路径、兼容性或边界的说明

## `N/A` Rules

只有在条目确实不适用时，才可以标记 `N/A`。

可接受示例：

- 纯文档修复说明的 `Typecheck / Build`：`N/A`，因为本次未修改可构建代码
- 仓库未配置静态分析工具：`N/A`，因为当前仓库没有对应工具链

不可接受示例：

- `Test: N/A`，因为“修复很小”
- `Regression check: N/A`，因为“现在看起来正常”

## Reporting Template

建议按以下骨架汇报：

- `Artifact Type`
- `Scope`
- `Result: PASS | CONDITIONAL PASS | FAIL`
- `Root Cause: confirmed | likely | unknown`
- `Repair Type: root-cause fix | workaround | rollback | mitigation`
- `Evidence`
- `Risks`
- `Waiver: none | ...`
- `Done / Partial / Skipped`

## Final Gate Questions

在声称完成前，至少自检以下问题：

- 我是否真的复现了问题，还是只看到了零散症状？
- 我是否把假设写成了根因？
- 我是否验证了根因场景，而不只是验证“现在不报错”？
- workaround、rollback 或 mitigation 是否被诚实标识？
- 我是否披露了残余风险、限制和未完成项？
