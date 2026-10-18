---
name: software-delivery
description: >-
  Coordinate end-to-end software delivery or a feature spanning requirements,
  design, implementation, verification and release readiness. Use when the task
  needs decisions or handoffs across lifecycle stages. Exclude isolated edits,
  single-stage reviews, book recommendations and lifecycle explanations alone.
---

# 软件交付闭环

围绕用户授权的交付结果推进，按实际不确定性选择方法。完整生命周期是能力覆盖范围，不是每个任务必须走完的流程。

## 从当前阻碍进入

先确定任务是探索、评审、方案还是实施，读取相关项目约定、现有修改和直接证据。保持原请求类型；交付功能不自动意味着上线、对外通知或删除旧系统。已经明确的授权无需反复确认。

找出当前最可能导致错误交付的缺口：问题是否值得解决、行为是否明确、规则是否自洽、技术是否可行、实现是否正确、能否安全交付、真实使用是否有效。先处理影响后续正确性的缺口；已确认的决定不重做。简单明确的局部改动直接实现并验证，不补生命周期计划。

## 按需衔接已有能力

下列同仓库技能是可选协作入口，只在当前工作需要时读取相应 `SKILL.md`，再选择其中相关参考。它们不是要全部调用的任务清单；缺少某个技能不阻止凭当前证据完成已明确的工作。

- 价值、用户场景、范围或验收含义不清：[product-discovery](../product-discovery/SKILL.md)。
- 概念、规则、状态或责任存在歧义：[business-modeling](../business-modeling/SKILL.md)。
- 质量目标、系统边界或关键技术风险：[software-architecture](../software-architecture/SKILL.md)。
- 模块/API 复杂度与信息隐藏：[software-design-philosophy](../software-design-philosophy/SKILL.md)；关系数据、约束和事务选择：[database-design](../database-design/SKILL.md)。
- 行为实现、缺陷修复或遗留代码修改：[software-implementation](../software-implementation/SKILL.md)。
- 验收例子、测试选择与结果判断：[software-testing](../software-testing/SKILL.md)。测试从澄清行为时开始，不等待编码结束。
- 发布准备、运行可靠性、结果反馈或退役：[release-operations](../release-operations/SKILL.md)。
- 需要实质性编写交付文档时使用 [tech-docs](../tech-docs/SKILL.md)；已有短结论无需再次走文档流程。

每次衔接复用当前任务里的目标、规则来源、决定、未决项、受影响契约和证据位置。用原有 issue、测试、ADR 或对话承载即可，不创建重复状态库，不要求每一步新建文件。后一步发现反例时，仅回到对应规则或决定修正，再更新受影响实现与检查。

## 让方法产生可检验的结果

- 用一个能够推翻当前判断的案例、实验或检查处理关键不确定性；单纯重述同一结论不算验证。
- 区分业务期望、现有实现、设计提议和执行结果。模型可以发现遗漏和生成候选方案，不能代替用户证言、业务授权或运行测量。
- 范围较大时按可使用、可验证的业务切片推进；不要先做完所有数据库、再所有接口、最后才整合。关键技术风险可以先做有结束条件的试验。
- 只有存在会改变选择的真实备选时比较方案；按已知约束、失败代价、维护成本选择，不制造加权分数或假定业务指标。
- 已有明确方案就实施；材料不足时仅询问改变正确性的关键问题，并推进独立部分。不能以调查、计划或反复讨论代替已经授权的实现。

涉及权限、敏感数据、供应链或退役时，按风险读取 [安全与隐私](references/security.md)。涉及多方协作、长任务衔接或团队流程改进时，读 [工作流与减负](references/flow.md)。来源追溯、书籍覆盖与核查局限见 [来源映射](references/sources.md)，普通工程任务不需要加载书目。

## 完成条件

对照用户请求检查：交付物是否存在且可审查，关键行为是否有适当证据，相关契约/操作信息是否更新，未决风险是否明确。区分本地检查、集成环境验证、业务验收、实际发布和上线效果，不越级宣称完成。

完成当前授权范围内的必要工作后停止。报告结果、实际验证和影响使用的限制；不追加无关重构、全套审计或新的审批流程。

维护本技能集合时，可用 [行为评估场景](references/evaluation.md) 检查选择准确性、执行质量和流程负担；这份资料不属于日常交付流程。
