---
name: software-design
description: >-
  Evaluates or designs module boundaries, internal codebase architecture,
  dependency direction, coupling balance, public APIs, and code-level refactors
  that fit current requirements and near-term evolution while avoiding premature
  over-engineering. Use for module/package structure, codebase architecture or
  API reviews, choosing where a rule should live, diagnosing tight coupling or
  over-abstraction, or planning a significant refactor inside a codebase.
  Exclude system-level deployment topology, distributed tradeoffs and quality
  attribute scenarios (use software-architecture) and routine local edits with
  no real design choice.
---

# 模块与代码架构设计

目标是设计或评审出**贴合当前需求、易于应对短期演进、同时避免过早过度设计**的模块与代码内部架构——用科学依据降低理解和修改代码的总成本，而不是堆叠抽象、层次或模式。系统级质量场景、分布式拓扑与技术可行性交给 `software-architecture`；行为保持的重构执行交给 `software-implementation`。

## 默认流程

1. **界定当前与短期变化**：先从需求、代码和 Git 变更历史（若有）确认——本次必须满足什么行为；哪些变化已有明确证据（近期需求或反复修改的**热点**与**变更耦合**）；哪些只是未经证实的假想未来。
2. **检查边界、依赖与复杂度**：按下方“设计失衡红旗”（同时排查**设计不足/耦合泄露**与**过度设计/空转抽象**）定位具体位置，只记录有代码或场景依据的问题。
3. **校准演进投入（三档准则）**：
   - **当前 + 已有证据的短期变化**：立即建立清晰模块边界、深接口或显式扩展接缝。
   - **合理但未确认的未来变化**：**不提前建通用框架或插件机制**；只通过隔离 I/O、消除循环依赖、保持单一知识归属来“留出好改的余地”。
   - **假想远期变化**：明确拒绝，避免为不存在的需求引入偶然复杂度。
4. **至少想两种边界方案**（仅限高代价或跨模块边界）：用调用方代码草图比较，选让常见用法最简单、泄露知识最少、层次最薄且不引入多余间接层的一种。显然的局部选择不凑备选。
5. **给出可审查结论**：先结论，再依据（具体位置或调用草图）、接受的代价、明确排除的过度设计，以及什么信号出现时应升级结构。

按需加载两份参考（不默认全读）：
- 涉及**耦合均衡、内部分层、依赖方向、能力分包、热点分析或设计模式取舍** → 读 [architecture-and-coupling.md](references/architecture-and-coupling.md)。
- 涉及**公共 API 演进、Parnas 秘密列表、契约式设计（DbC/CQS/LSP）或纠偏错误抽象** → 读 [api-and-contracts.md](references/api-and-contracts.md)。

## 核心设计原则

- **深模块与信息隐藏（Ousterhout / Parnas）**：小而有语义的接口隐藏大量实现决策（存储格式、外部协议、规则算法）；按“可能变化的秘密”与业务能力组织模块，不按执行流程图步骤拆散同一知识。
- **平衡耦合而非消灭耦合（Khononov / Constantine）**：用**整合强度 × 距离 × 变化频率**判断耦合。把一起变化的代码放近（高内聚）；跨远距离且高变化处用窄契约解耦；对稳定不变的内部实现不要强加多余接口层。
- **核心策略与外部细节隔离（Hexagonal / Clean Architecture / Functional Core）**：业务规则与纯逻辑不依赖 Web 框架、ORM 或第三方 SDK 细节，依赖指向更稳定的核心与边界契约；**反仪式化**——只为真实易变或需独立快测的边界设端口/适配器，不为简单 CRUD 套多层透传。
- **把复杂度往下拉并用定义消除错误（Ousterhout）**：宁可模块内部多做一点，也不把调用顺序、配置组合或无意义的边界异常推给每个调用方；真正无效的状态仍须尽早明确报错。
- **不同层次，不同抽象；重复优于错误抽象（Ousterhout / Metz）**：相邻层接口若几乎一样，删除多余一层；概念可能分化时，保留适度重复比过早抽一个塞满开关参数的“万能抽象”更安全。
- **按证据投入，而非按美学重构（Fowler / Tornhill）**：在会被反复修改的热点与难以撤回的公开契约上做战略投入；从不改动的稳定旧代码保持原样。

## 设计失衡红旗清单

评审时双向对照（既查耦合泄露，也查过度设计）；命中须给出具体位置与改进方向，未命中不罗列。

| 类别 | 红旗 | 识别方式 |
| --- | --- | --- |
| **设计不足 / 耦合泄露** | 信息泄露 / 散弹修改 | 同一格式、协议或规则知识散落在多处，改一处须同步改多个模块（或 Git 历史高频变更耦合） |
| | 时间顺序分解 | 按“先读、再处理、再写”拆模块，同一领域知识被切碎在多个步骤类里 |
| | 业务策略依赖外部框架 | 核心规则直接耦合 HTTP 请求对象、ORM 注解或第三方 SDK 数据结构，脱离基础设施无法测试 |
| | 模块循环依赖 | A 与 B 互相引用，或稳定基础模块反向依赖易变的业务/上层模块 |
| | 联体方法 / 隐含调用顺序 | 读懂或安全调用一个方法必须同时了解另一方法的内部实现或隐藏状态顺序 |
| | 特殊与通用混杂 | 通用机制里塞满针对某个调用方的特例分支与布尔开关 |
| **过度设计 / 偶然复杂度** | 浅模块与仪式化多层 | 接口复杂度接近实现复杂度；`Controller → Service → ServiceImpl → Repo` 只是逐层透传参数与调用 |
| | 单一实现空接口 | 为永不替换的内部类机械创建 `IFoo / FooImpl` 接口，增加跳转成本却不隔离任何变化 |
| | 投机性通用框架 | 当前只有 1–2 种用法，却预建插件注册表、抽象工厂、配置 DSL 或通用规则引擎 |
| | 透传方法／变量 | 参数或方法穿过多层只为传到底层，说明层次划分或上下文归属有误 |
| **可读性边界** | 难以命名 / 注释复述代码 / 不直观 | 找不到准确名字（职责不清）、注释重复代码而非解释约束理由、需跳读多处才能理解副作用 |

## 输出模板（默认格式，可裁剪）

```markdown
## 结论
<推荐的模块/架构方案或评审结论，一两句话>

## 变化边界与依据
- 当前与短期已确认变化：……（来源：需求/代码/Git 热点）
- 明确不为之提前设计的假想变化：……

## 关键发现／设计方案
- <模块/边界或红旗位置>：问题或职责 → 推荐边界/接口草图 → 依赖方向与知识归属

## 取舍与重审信号
- 接受的代价 / 放弃的备选：……
- 何时升级结构（重审信号）：<例如：当接入第二个支付渠道或该模块变更频率明显上升时再抽取统一端口>
```

## 评审检查与停止

交付前核对：1) 调用方和后续维护者需要知道的细节是否变少？2) 已确认的短期变化是否集中在单一边界内，且没有为未证实的远期变化增加空转抽象？3) 依赖方向是否清晰无环，核心逻辑能否脱离外部基础设施独立测试？4) 公开契约或数据边界变化是否有兼容与回退路径？

结论、依据、取舍和重审信号足以支持当前决定或授权实现时停止；设计评审不自动授权修改代码。

## 来源与边界

以 John Ousterhout《A Philosophy of Software Design》（第 2 版）与 Parnas（1972）信息隐藏为复杂度骨架，整合 Khononov《Balancing Coupling in Software Design》、Yourdon/Constantine《Structured Design》、Cockburn 六边形架构、Martin《Clean Architecture》、Bernhardt（Functional Core）、Richards/Ford《Fundamentals of Software Architecture》、Tornhill《Software Design X-Rays》、GoF《Design Patterns》、Fowler、Meyer、Bloch 与 Metz 的工程原则；详见 [来源映射](../software-delivery/references/sources.md)。经典观点间存在真实张力（例如 Ousterhout 反对为短函数而拆分浅模块，与部分 *Clean Code* 做法不同；Clean Architecture 的多层切分若机械套用会产生浅模块），本技能以**实际变更成本、耦合证据与认知负荷**作为统一裁决标准。
