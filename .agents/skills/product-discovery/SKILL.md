---
name: product-discovery
description: >-
  Investigate user problems and value assumptions, clarify software requirements,
  scope, user journeys and acceptance examples. Use for ambiguous feature requests,
  product discovery or task-based prototype evaluation. Exclude settled implementation,
  domain modeling alone and formatting an already-agreed specification.
---

# 问题发现与需求澄清

把功能请求连接到可核查的问题、可交付范围和可观察行为。任务只要求澄清或评审时，产出结论和建议；不自行实现产品、联系用户或运行线上实验。

## 选择入口

读取已有访谈、工单、业务目标、契约、原型或使用数据中与当前决定相关的部分。标明真实记录、他人解释和待验证假设；没有资料不能编造用户画像、访谈原话、市场需求或收益。

- **不清楚为什么做、为谁做、是否有效**：读 [discovery.md](references/discovery.md)，选择访谈分析、机会梳理或假设实验。
- **问题已明确，行为/范围/体验尚不明确**：读 [requirements.md](references/requirements.md)，使用目标场景、故事地图、实例和任务式原型验证。
- **局部规则歧义**：直接用条件、输入、预期结果和反例澄清，不为一个问题组织完整发现流程。

## 形成足够的共同理解

1. 找出参与者正在完成的任务、现有替代办法、困难发生的情境，以及请求中的硬约束。技术方案是用户明确要求时保留；只是建议时检验它与目标的联系。
2. 将“用户想要某按钮”追溯到可观察结果，但不要擅自用推测的目标替换用户的要求。
3. 把关键行为描述为：谁在什么条件下触发，系统改变什么，成功/失败如何判断。权限、数据口径、质量约束仅补充与当前场景相关的内容。
4. 选择一个能完成用户任务的最小切片，保留必要异常处理和规则；后续范围明确延期，不把欠缺正确性的半成品称为最小可用版本。
5. 为含糊或有争议的规则给具体例子，并把未知结果保留为问题。需要业务语义深入分析时，可用现有 `business-modeling`；需要自动化验证时，把确认例子交给 `software-testing`，不重复定义规则。

项目材料无法解决且不同解释会改变业务行为时，提出一个有影响说明的聚焦问题；继续整理无争议的场景。仅影响低风险展示或组织形式时，采用合理假设并说明。

## 交付与停止

交付当前请求需要的最小结果：问题依据、目标场景、范围、关键规则及验收例子、未决事项的影响。可以直接在对话或已有需求记录内表达，不强制 PRD、地图、原型三件套。

当材料足以支撑下一步决定时停止。若只完成访谈分析，不宣称需求已获业务批准；若只做模型模拟，不宣称用户验证通过。发现阶段的价值假设进入上线反馈继续验证。

方法由 Fitzpatrick、Torres、Patton、Wiegers/Beatty 的公开资料与工程实践综合；书目及实际核查范围见 [来源映射](../software-delivery/references/sources.md)。
