---
name: product-discovery
description: >-
  Clarifies ambiguous feature requests into evidence-backed problems, scope, user
  scenarios, business rules and testable acceptance criteria; also analyzes user
  value assumptions and plans discovery experiments or prototype tests. Use when a
  request is vague, when writing or reviewing requirements, PRDs, user stories or
  acceptance criteria (需求澄清、需求整理、验收标准), or when deciding whether a
  feature is worth building. Exclude settled implementation work, deep domain
  modeling alone (use business-modeling), turning agreed criteria into test cases
  (use software-testing) and formatting an already-agreed spec.
---

# 问题发现与需求澄清

把功能请求连接到可核查的问题、可交付范围和可观察行为。任务只要求澄清或评审时，产出结论和建议；不自行实现产品、联系用户或运行线上实验。

## 选择入口

先读取已有访谈、工单、业务目标、契约、原型或使用数据中与当前决定相关的部分，标明哪些是真实记录、他人解释或待验证假设。没有资料时不编造用户画像、访谈原话、市场需求或收益。

- **不清楚为什么做、为谁做、是否值得**：读 [discovery.md](references/discovery.md)（访谈分析、机会—方案树、假设实验）。
- **问题已明确，行为、范围或体验不明确**：按下方默认流程；需要故事地图、EARS 句式或可用性验证时读 [requirements.md](references/requirements.md)。
- **两者都不清楚**：先用 discovery.md 判断问题是否成立、值得做，再对已成立的部分走默认流程。
- **单条规则有歧义**：直接用条件、输入、预期结果和反例澄清，不组织完整流程。
- **缺陷类需求**：写清当前行为、期望行为和**必须保持不变的行为**三项，再交给实现。

## 默认流程

1. **任务、边界与约束**：先核对需求落在哪个系统、由谁拥有数据和流程；若属于外部系统或与项目既有约束冲突，先指出。再看参与者在完成什么任务、现在怎么做、困难在什么情境发生；请求中的硬约束是什么。用户明确要求的技术方案保留；只是建议时检验它与目标的联系。
2. **追溯结果**：把“想要某个按钮”追溯到可观察结果，但不擅自用推测目标替换用户的要求。
3. **写关键行为**：谁在什么条件下触发，系统改变什么，成功与失败如何判断。权限、数据口径、质量约束只补充与当前场景相关的部分。
4. **切最小可用切片**：选择能完成用户任务的最小范围，保留必要的异常处理和规则；延后的范围写明。缺少正确性的半成品不叫最小可用版本。
5. **用例子钉住规则**：对含糊或有争议的规则给能区分不同解释的具体例子；未知结果保留为问题，不替业务填答案。
6. **检查完整性**：对照下方模板，每项要么有内容、要么标“不适用／待确认”。

项目材料无法解决、且不同解释会改变业务行为时：交付物中按优先级列出未决问题并标明哪些阻塞开发；向用户提问时先问最关键的一个，附影响说明和建议，同时继续整理无争议部分。用户期限紧但证据不足时，交付“可先做的部分 + 阻塞问题 + 补证据的最小动作”，不为赶进度把假设写成规则。仅影响低风险展示或组织方式的，采用合理假设并标明。

## 输出模板（默认格式，可按请求裁剪）

```markdown
## 问题与依据
- 要解决的问题：……（来源：访谈/工单/数据位置；未经验证的标“假设”）
- 目标结果：……（无目标值时写“待定”，不补造数字）

## 范围
- 本次包含：……
- 明确不含／延后：……

## 关键场景与规则
- R1：<规则>（来源：……）
  - 验收：当 <触发> 时，系统应 <响应>。
  - 例子：<输入/前提> → <预期结果>；反例：……（预期未知写“待定：原因”，不留空）
- 失败与异常：若 <异常条件>，则系统应 <响应>。

## 未决问题
- Q1：<问题>｜影响：<不同答案会如何改变行为>｜建议：……
```

验收句式使用 EARS（详见 requirements.md），语言跟随项目文档，中文项目默认用中文句式；具体例子用“前提 → 操作 → 结果”。已有 issue、spec 或需求文件时直接更新它，不另起平行文档；不强制 PRD、故事地图、原型三件套。

## 衔接与停止

- 概念、身份、状态或不变量复杂时，交给 `business-modeling`；需要把例子变成自动化检查时，交给 `software-testing`，复用同一条规则和例子，不重新猜测。
- 材料足以支撑下一步决定时停止。只完成访谈分析不宣称需求已获批准；只做模型推演不宣称用户验证通过。价值假设留到上线后用 `release-operations` 的结果反馈继续验证。

方法综合自 Fitzpatrick、Torres、Patton、Wiegers/Beatty 与 Mavin（EARS）的公开资料；核查范围见 [来源映射](../software-delivery/references/sources.md)。
