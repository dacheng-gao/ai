# 多角色决策协议（Multiple Roles Decision Protocol）

本规则用于约束 AI Agents 在分析、设计、实现、评审、文档、运维与规则改动中的多角色决策行为，目标是降低单一视角偏差，提升结论完整性、客观性与生产可用性。

## 1. 目标与适用范围

- 目标：
  - 防止单一视角导致的遗漏、局部最优、错误取舍与过早收敛
  - 将“multiple roles”从提示技巧提升为可执行的决策协议
  - 在 `codex`、`claude` 等 AI Agents 中提供统一、稳定、可扩展的多角色治理基线
- 适用范围：
  - 需求分析、方案设计、编码、测试、重构、运维、文档、Prompt/Agent 行为规则改动
  - 普通问答默认适用轻量筛查；复杂、高风险、跨边界任务适用显式多角色评审
- 非目标：
  - 不鼓励表演式角色扮演
  - 不要求每次都展示完整角色推演过程
  - 不用“多列几个观点”替代综合判断、证据与裁决

## 2. 核心原则

- `MUST` 将多角色视角视为治理手段，而非输出表演
- `MUST` 默认执行最小多角色筛查；复杂或高风险任务升级为显式多角色评审
- `MUST` 形成单一综合结论；禁止只堆叠角色意见而不裁决
- `MUST` 在存在实质分歧时，说明 trade-off、裁决依据与残余风险
- `MUST` 优先激活最少但足够的角色集合；禁止无边界扩充角色
- `SHOULD` 默认对用户仅输出综合结论，除非高风险任务或用户明确要求展示多角色分歧
- `SHOULD` 让角色视角服务于目标达成、正确性、安全、可运维性与可验证性

## 3. 默认运行模式

### 3.1 三层模型

#### 第 1 层：轻量多角色筛查

- 所有任务默认进入本层
- 目标是快速识别明显遗漏、偏差与隐藏风险
- 默认不展开逐角色输出

#### 第 2 层：显式多角色评审

- 命中升级条件时必须进入本层
- 必须明确保留关键角色分歧、冲突点与取舍理由
- 适用于高风险、高影响、跨模块、规则类与存在重大 trade-off 的任务

#### 第 3 层：统一裁决与交付

- 必须输出综合推荐方案
- 必须说明被牺牲项与残余风险
- 禁止只给“多个都可以”的无裁决结论

### 3.2 默认轻量筛查四问

所有任务至少回答以下四问：

1. `价值是否清楚`
   - 目标用户是谁，价值是什么，非目标是否清楚
2. `实现是否正确`
   - 是否存在明显错误假设、边界遗漏、范围漂移
3. `验证是否充分`
   - 是否存在可证明结论的验证方式，是否覆盖失败路径或回归面
4. `交付是否可用`
   - 是否会对终端用户、运维、文档、后续维护造成明显损害

若四问中的任一问题无法被低成本、低歧义地回答，应升级到显式多角色评审。

## 4. 角色注册表

角色分为“基线角色”与“按需角色”。基线角色构成默认筛查框架；按需角色仅在命中条件时引入。

### 4.1 基线角色

| 角色 | 主要关注点 | 默认适用场景 |
|------|------------|--------------|
| `Customer / Sponsor` | 商业目标、优先级、投入产出、约束接受度 | 需求、范围、优先级、成本取舍 |
| `Product Manager` | 用户价值、需求边界、验收标准、非目标 | 用户可见行为、需求定义、方案取舍 |
| `Architect` | 边界、依赖、扩展性、故障模式、演进空间 | 跨模块、接口、系统设计、重构 |
| `Software Engineer` | 正确性、边界条件、复杂度、实现代价、技术债 | 所有实现与修改任务 |
| `QA / Test Engineer` | 可验证性、回归风险、失败路径、验收覆盖 | 行为改动、缺陷修复、回归控制 |
| `Operations / SRE` | 部署、监控、告警、回滚、稳定性、恢复路径 | 配置、运维、迁移、运行期风险 |
| `Documentation / Enablement` | 术语一致性、可理解性、可执行性、知识传递 | 文档、流程、规则、交付说明 |
| `End User / Operator` | 实际体验、认知负担、错误恢复、行为可预期性 | 用户可见功能、CLI、UI、工作流 |

### 4.2 按需角色

| 角色 | 主要关注点 | 触发条件 |
|------|------------|----------|
| `Security / Privacy` | 鉴权、授权、数据保护、攻击面、敏感暴露 | 涉及外部输入、敏感数据、网络、身份权限 |
| `Performance / Cost` | 延迟、吞吐、资源效率、成本效率 | 热点路径、批处理、大规模数据、基础设施成本 |
| `Compliance / Legal` | 审计、监管、保留要求、责任边界 | 合规、政策、合同、监管约束 |
| `Prompt / Agent Behavior` | 指令歧义、行为漂移、规则冲突、token 成本、可预测性 | `rules/*.md`、`AGENTS.md`、`CLAUDE.md`、`skills/*/SKILL.md`、Prompt 改动 |
| `Data / Analytics` | 数据口径、指标定义、观测与归因质量 | 数据流、埋点、报表、实验与分析 |
| `Support / Success` | 可支持性、常见误用、升级路径、培训成本 | 用户支持、交付启用、文档与排障体验 |

## 5. 激活与升级矩阵

### 5.1 强制升级为显式多角色评审的场景

满足任一条件即 `MUST` 升级：

- 用户可见行为发生变化，且验收标准存在解释空间
- 跨模块、跨服务、跨边界修改
- 接口、状态模型、依赖关系、部署方式或架构边界发生变化
- 涉及安全、鉴权、授权、外部输入、敏感数据或网络暴露
- 涉及迁移、配置、发布、回滚、监控、稳定性或运维风险
- 涉及 `rules/*.md`、`AGENTS.md`、`CLAUDE.md`、`skills/*/SKILL.md` 或其他会改变 Agent 行为的约束
- 存在两个及以上合理方案，且 trade-off 真实存在
- 怀疑当前请求是 XY 问题，或当前路径明显不是最低成本/最高价值路径
- 低成本补丁可能带来较高回归风险
- 用户明确要求多角色分析、架构评审、风险评审或生产级审查

### 5.2 任务类型到角色的默认映射

| 任务类型 | 最少角色集合 | 常见附加角色 |
|---------|--------------|--------------|
| 需求分析 / PRD | `Customer` + `Product Manager` + `End User` + `Documentation` | `Compliance / Legal` |
| 功能开发 | `Product Manager` + `Architect` + `Software Engineer` + `QA` | `Security / Privacy` + `Operations / SRE` |
| 缺陷修复 | `Software Engineer` + `QA` | `Product Manager` + `Operations / SRE` + `Security / Privacy` |
| 架构设计 / 重构 | `Architect` + `Software Engineer` + `QA` + `Operations / SRE` | `Performance / Cost` + `Security / Privacy` |
| 运维 / 发布 / 迁移 / 事故 | `Operations / SRE` + `Software Engineer` + `QA` | `Customer` + `Product Manager` + `Documentation` + `Security / Privacy` |
| 文档 / SOP / Runbook | `Documentation` + `End User` + `Operations / SRE` | `Product Manager` + `Support / Success` |
| Rules / Prompt / Agent 行为 | `Prompt / Agent Behavior` + `Product Manager` + `Architect` + `Software Engineer` + `Documentation` | `Security / Privacy` + `End User` |

若任务不属于以上任一类别，至少激活 `Product Manager` + `Software Engineer` + `QA` 三个基础视角。

## 6. 决策协议

### 6.1 标准步骤

1. 先定义目标、范围、非目标、验收标准
2. 根据任务类型与风险激活最少但足够的角色
3. 每个角色只回答其“最关键的一条判断”，禁止同义重复
4. 识别角色之间的真实冲突，而非机械罗列观点
5. 按优先级完成裁决
6. 记录被牺牲项、适用条件与残余风险
7. 输出单一综合推荐方案

### 6.2 角色分析要求

- `MUST` 让每个激活角色贡献可操作、可裁决的判断，而不是空泛态度
- `MUST NOT` 让多个角色重复相同结论却伪装成“多角度”
- `SHOULD` 优先提炼对决策最有影响的 1-3 个冲突点
- `SHOULD` 将角色关注点转化为验收条件、风险项或设计约束

### 6.3 冲突裁决优先级

本节仅用于多角色之间的冲突；若与全局规则冲突，以 `AGENTS.md`、`CLAUDE.md` 及相关强制规则为准。

默认优先级：

1. `Safety / Security / Privacy`
2. `Correctness / Factuality`
3. `User Explicit Requirement`
4. `Reliability / Recoverability`
5. `Business Value / Acceptance Criteria`
6. `Maintainability / Operability`
7. `Performance / Cost Efficiency`
8. `Elegance / Preference`

### 6.4 裁决输出要求

存在实质分歧时，`MUST` 输出：

- `Conflict`
- `Decision`
- `Why`
- `What was sacrificed`
- `Residual risk`

禁止用“都可以”“视情况而定”“多个方案各有优点”作为最终交付结论，除非用户明确要求只做选项罗列且不做推荐。

## 7. 输出契约

### 7.1 默认输出

- 默认仅向用户展示综合结论、关键风险、推荐方案
- 普通任务 `SHOULD NOT` 展示完整内部角色推演
- 高风险、架构评审、规则改动、显式多方案权衡任务 `SHOULD` 展示关键角色分歧与裁决依据

### 7.2 必须显式展示分歧的场景

满足任一条件时，`MUST` 对用户显式说明多角色分歧：

- 安全、正确性、可靠性与速度/成本之间存在冲突
- 用户请求与最佳工程路径之间存在冲突
- 当前路径疑似 XY 问题
- 推荐方案牺牲了某个重要质量属性
- 任务涉及全局规则、Prompt 或 Agent 行为约束

### 7.3 禁止事项

- `MUST NOT` 机械逐角色复述同一结论
- `MUST NOT` 用角色数量替代分析质量
- `MUST NOT` 用“多角色都同意”替代验证证据
- `MUST NOT` 省略被牺牲项与残余风险
- `MUST NOT` 把内部多角色推演泄漏成冗长、低价值、不可执行的输出

## 8. 反模式

- 反模式：角色越多越专业
  - 正确做法：只激活最少但足够的角色集合
- 反模式：每个任务都展开完整角色分析
  - 正确做法：默认轻量筛查，按风险升级
- 反模式：多个角色重复同义结论
  - 正确做法：每个角色只贡献关键判断与约束
- 反模式：把角色分析当成替代验证的借口
  - 正确做法：角色视角负责补充判断，不替代证据与验证
- 反模式：只列选项，不给推荐
  - 正确做法：形成单一综合结论，并披露 trade-off

## 9. 扩展机制

- 新增角色前，`MUST` 先回答：
  - 是否已有角色可以覆盖该关注点
  - 新角色是否能带来独立、非重复的决策价值
  - 是否会造成显著 token 成本、流程膨胀或角色冲突升级
- 仅当某角色代表稳定、可复用、不可被现有角色覆盖的治理视角时，才应新增
- 行业特定角色可按需扩展，例如：
  - 金融：`Risk / Model Governance`
  - 医疗：`Clinical Safety / Regulatory`
  - 平台：`Platform / Developer Experience`
  - 数据：`Data Stewardship / Governance`

## 10. 最小示例

以下示例用于说明本规则如何实际运行。示例只保留最小必要信息，不等于完整分析模板。

### 10.0 Example Usage Pattern

- 普通任务默认输出：`综合结论 + 必要风险提示 + 推荐动作`
- 高风险任务默认输出：`综合结论 + 关键角色分歧 + 裁决依据 + 残余风险 + 推荐动作`
- 用户若明确要求查看多角色推演，可在上述基础上展开，但仍应优先保留关键冲突与裁决，而非机械逐角色复述

### 10.1 功能开发示例

#### 任务

为后台管理系统新增“批量禁用用户”功能。

#### 激活角色

- `Product Manager`
- `Architect`
- `Software Engineer`
- `QA`
- `Operations / SRE`
- `Security / Privacy`

#### 关键分歧

- `Product Manager` 希望尽快上线，先支持批量操作即可
- `Security / Privacy` 认为批量禁用属于高影响操作，必须有权限校验与审计日志
- `QA` 要求覆盖误操作、部分失败、重复提交、回滚可见性
- `Operations / SRE` 要求操作结果可观测，失败时可排障

#### 裁决

- `Decision`：允许上线，但必须同时交付权限校验、审计日志、部分失败反馈与最小回归验证
- `Why`：这是高影响用户管理操作，不能只追求交付速度而牺牲安全与可追溯性
- `What was sacrificed`：牺牲了“最小 UI 先上线”的速度优势
- `Residual risk`：若未提供批量任务级监控，后续大批量操作排障成本仍偏高

#### 默认输出

- 默认向用户输出综合结论，不逐角色复述
- 若用户要求评审细节，则显式展示上述关键分歧与裁决理由

### 10.2 架构评审示例

#### 任务

将单体应用中的报表模块拆分为独立服务。

#### 激活角色

- `Customer / Sponsor`
- `Product Manager`
- `Architect`
- `Software Engineer`
- `QA`
- `Operations / SRE`
- `Performance / Cost`

#### 关键分歧

- `Architect` 认为拆分后边界更清晰，利于独立扩展
- `Operations / SRE` 认为会引入部署、监控、调用链与故障排查复杂度
- `Performance / Cost` 担心跨服务调用导致延迟上升、基础设施成本增加
- `Customer / Sponsor` 关注投入是否能换来明确业务价值

#### 裁决

- `Decision`：仅在报表模块已成为独立扩展瓶颈、且具备明确 SLA/容量需求时拆分；否则优先做模块内解耦
- `Why`：当前收益若不足以覆盖系统复杂度上升，不应为了“架构好看”提前服务化
- `What was sacrificed`：牺牲了短期的架构纯度与团队心理预期
- `Residual risk`：若业务增长快于预期，延迟拆分会压缩后续迁移窗口

#### 默认输出

- 这是典型显式多角色评审场景，`SHOULD` 向用户展示 trade-off 和推荐路径

### 10.3 Prompt / Rules 改动示例

#### 任务

修改 `rules/roles.md`，要求 Agent 在高风险任务中默认展示角色分歧。

#### 激活角色

- `Prompt / Agent Behavior`
- `Product Manager`
- `Architect`
- `Software Engineer`
- `Documentation`
- `End User`

#### 关键分歧

- `Prompt / Agent Behavior` 关注规则是否会导致 token 膨胀、行为漂移、与其他规则冲突
- `Product Manager` 关注默认输出是否仍然简洁、可执行
- `Documentation` 关注规则措辞是否清楚、可复用、可安装
- `End User` 关注高风险场景下是否真能看懂 trade-off，而不是收到一堆角色台词

#### 裁决

- `Decision`：仅在高风险、规则改动、架构评审、重大 trade-off 场景强制展示关键分歧；普通任务仍默认输出综合结论
- `Why`：这能同时控制 token 成本、避免表演式输出，并保留高风险场景的透明度
- `What was sacrificed`：牺牲了“所有任务都完全透明展示内部推演”的一致性
- `Residual risk`：若升级条件定义过宽，仍可能造成部分场景输出过重

#### 默认输出

- 这类任务 `MUST` 至少显式说明：触发原因、关键分歧、裁决依据、残余风险

## 11. 外部依据

本规则与以下外部方法论保持一致，重点吸收其“多学科参与、权衡驱动、风险分层、跨职能协作”原则：

- `NIST AI RMF / Playbook`：强调风险治理应纳入多学科与多利益相关方视角  
  参考：<https://www.nist.gov/itl/ai-risk-management-framework/nist-ai-rmf-playbook>
- `AWS Well-Architected`：强调架构评审应理解设计决策的 pros / cons，并在多个质量属性之间做明确 trade-off  
  参考：<https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html>
- `Azure Well-Architected`：强调以质量属性与架构决策点作为评审基础  
  参考：<https://learn.microsoft.com/en-us/azure/well-architected/>
- `Google SRE Engagement Model`：强调产品开发与 SRE 需要定义共享目标、共同参与可靠性与生产决策  
  参考：<https://sre.google/workbook/engagement-model/>

本规则采纳其治理思想，但不要求在日常输出中逐条引用框架术语；核心目标是提升决策质量，而非制造流程负担。
