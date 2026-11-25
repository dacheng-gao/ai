# 生命周期方法来源与覆盖

核查日期：2026-10-18；2026-10-24 与 2026-11-26 补充来源见文末专节。初始覆盖前述讨论的 **15 本书**及相关公开方法，后续两轮按工程短板持续增补经典软件工程与生命周期著作。本文是可追溯的概念提炼与 agent 工作方法综合，不是原著替代品、全文提取或逐章摘要。普通工程任务无需读取本文件或重新检索书目。

## 怎样理解证据

- **书目/范围核查**：作者或出版社介绍、目录能确认书名、作者和主题，不能证明已经通读原著或核实每个细节。
- **方法正文核查**：实际读取了作者/机构公开指南或章节的相关正文；只支持所读部分，不升级为整本书研究。
- **工程化综合**：本仓库对何时使用、输入、动作、验证、停止及权限边界的组织。除明确说明外，不冒称作者原有流程、统计结论或统一学派。

DORA 提供多年调查与统计研究，仍需考虑观察性数据、自报告和情境差异，不能据此保证单一实践的因果收益。《Specification by Example》提供约 50 个项目的案例经验；其余多为专家方法和案例综合。出处可信不等于适用于所有项目。没有进行系统文献综述或生产率元分析。

## 问题与需求

### 1. The Mom Test — Rob Fitzpatrick

[作者书站](https://www.momtestbook.com/)。已核查书目与定位，未通读正文。提炼方向：从过去经历、实际替代办法和投入理解问题，减少诱导性评价；赞许、购买意愿与真实行为证据分开。

落地：[discovery.md](../../product-discovery/references/discovery.md) 的访谈与证据选择。具体提问和证据强弱比较是概念性转述与综合，非逐条原文核验；不得编造访谈、承诺或付费信号。

### 2. Continuous Discovery Habits — Teresa Torres

[作者书籍介绍](https://www.producttalk.org/continuous-discovery-habits/)；[机会—方案树指南](https://www.producttalk.org/opportunity-solution-trees/)。已核查书目并读取指南关于结果、机会、方案、假设检验和输入条件的正文，未通读书籍。

落地：[discovery.md](../../product-discovery/references/discovery.md) 的机会—方案树、假设实验；[evolution.md](../../release-operations/references/evolution.md) 的结果反馈。保留证据驱动与持续学习，不把作者示例中的固定频率或方案数量变成所有任务的硬要求。

### 3. User Story Mapping — Jeff Patton

[作者故事地图资源页](https://jpattonassociates.com/story-mapping/)。已读取公开方法概述并核查书籍关联，未通读书籍。提炼方向：沿用户旅程形成共同理解，以完整任务切片组织范围与交付。

落地：[requirements.md](../../product-discovery/references/requirements.md) 的故事地图、切片与最小交接。任务主轴、异常正确性和不按技术层切片是综合操作指导，不能将一张地图当成全部需求。

### 4. Software Requirements，第 3 版 — Karl Wiegers、Joy Beatty

[Microsoft Press](https://www.microsoftpressstore.com/store/software-requirements-9780735679665)。已核查书目和介绍中的获取、分析、规格、验证、管理、数据及非功能要求范围，未通读原著。

落地：[requirements.md](../../product-discovery/references/requirements.md) 的层次、行为与变更影响；复用 [tech-docs 需求表达](../../tech-docs/references/requirements.md)。用条件与可观察结果消除歧义，按需要维护需求联系，不强制完整规格模板。

## 业务与设计

### 5. Learning Domain-Driven Design — Vlad Khononov

[O'Reilly 书目与目录](https://www.oreilly.com/library/view/learning-domain-driven-design/9781098100124/)。已核查业务分析、战略/战术设计、简单业务逻辑及已有系统采用 DDD 的主题，未通读正文。

落地：[collaborative-modeling.md](../../business-modeling/references/collaborative-modeling.md) 的业务复杂度、边界和实现策略。仅在真实规则需要时采用丰富领域模型，不把 DDD 当作所有模块的统一实现架构。

### 6. Domain-Driven Design — Eric Evans

[作者 DDD 资源页](https://www.domainlanguage.com/ddd/)。已核查书目、作者对框架及参考资料定位的说明，未通读原著或 PDF 参考全文。

落地：复用 [business-modeling](../../business-modeling/SKILL.md) 与 [method-lenses.md](../../business-modeling/references/method-lenses.md) 的统一语言、限界上下文、聚合与不变量。保留已有文件对概念性综合的声明；限界上下文、聚合、数据库表和微服务不强制一一对应。

### 7. Software Architecture in Practice，第 4 版 — Len Bass、Paul Clements、Rick Kazman

[Addison-Wesley / InformIT](https://www.informit.com/store/software-architecture-in-practice-9780136886099)。已核查书目和质量属性、分析、演进等主题，未通读正文。

落地：[decisions.md](../../software-architecture/references/decisions.md) 的质量场景、机制—代价映射和验证。质量场景结构为概念性转述；本技能不声称实施完整 ATAM，不凭架构图或技术名词证明指标达标。

### 8. A Philosophy of Software Design，第 2 版 — John Ousterhout

[作者页面与版次说明](https://web.stanford.edu/~ouster/cgi-bin/book.php)。已读取作者对新版、泛化、重要性判断及与 Clean Code 分歧的说明；未通读本轮所涉书籍正文。

落地：复用 [software-design](../../software-design/SKILL.md)，以信息隐藏、深模块和变更成本评价设计。泛化须有实际简化作用；不按方法长度、注释数量或抽象数量机械评分。跨书存在差异，按问题与证据选择，不假装所有经典观点一致。

## 实现与验证

### 9. Refactoring，第 2 版 — Martin Fowler

[作者重构网站](https://refactoring.com/)。已读取重构定义、小步变换、日常编程中的作用及版本说明，未通读所有模式。

落地：[safe-change.md](../../software-implementation/references/safe-change.md) 的结构变化与行为变化分步、检查和范围约束。保持可观察行为是重构的判据；并非任何清理或接口变化都属于重构。

### 10. Specification by Example — Gojko Adzic

[作者书页](https://gojko.net/books/specification-by-example/)。已核查书目、约 50 个项目案例的研究范围及协作规格/验收主题，未通读原著。

落地：[测试方法](../../software-testing/references/methods.md) 的规则—例子—验证—维护连接，以及需求阶段的验收例子。例子映射另有来源，见后文；不将其误归为本书自带固定流程。

### 11. Explore It! — Elisabeth Hendrickson

[Pragmatic Bookshelf 介绍、目录](https://pragprog.com/titles/ehxta/explore-it/)。已读取出版社对章程、观察、变化维度、状态与数据分析的说明，未通读正文。

落地：[测试方法](../../software-testing/references/methods.md) 的目标明确、边学边调整的探索；报告复现、观察与判定依据。具体测试章程是综合表达，不将无目的点击称为探索式测试。

### 12. Working Effectively with Legacy Code — Michael Feathers

[Pearson / InformIT](https://www.informit.com/store/working-effectively-with-legacy-code-9780131177055)。已核查书目、通过测试控制修改风险及避免全面重写的主题，未逐章核验特征测试和接缝的原文。

落地：[safe-change.md](../../software-implementation/references/safe-change.md) 的现状观察、特征测试、必要依赖接缝与小步修改；[evolution.md](../../release-operations/references/evolution.md) 的渐进演进。具体步骤为概念性转述和工程综合，现状测试不替代业务正确性判断。

## 交付与运行

### 13. Continuous Delivery — Jez Humble、David Farley

[作者网站](https://continuousdelivery.com/)；[持续交付原则正文](https://continuousdelivery.com/principles/)。已读取公开定义与五项原则的说明，未通读原著。

落地：[delivery.md](../../release-operations/references/delivery.md) 的制品、反馈、小批次与恢复；[flow.md](flow.md) 的减少交接和重复劳动。具体迁移步骤与权限控制为工程综合，不把持续交付等同于自动上线。

### 14. Accelerate — Nicole Forsgren、Jez Humble、Gene Kim

[IT Revolution 书目与研究介绍](https://itrevolution.com/product/accelerate/)；[DORA 持续交付能力指南](https://dora.dev/capabilities/continuous-delivery/)。已读取书目/研究介绍以及 DORA 对能力、结果及常见误区的公开说明，未复算原始数据或审阅全部论文。

落地：[flow.md](flow.md) 与 [evolution.md](../../release-operations/references/evolution.md) 的反馈、瓶颈和系统改进。多项能力共同影响结果，不能把单项工具部署或指标上涨当成因果证明，不用团队交付指标给个人排名。

### 15. Site Reliability Engineering，2016 年版 — Betsy Beyer、Chris Jones、Jennifer Petoff、Niall Richard Murphy 编

[公开目录](https://sre.google/sre-book/table-of-contents/)；[服务目标章节](https://sre.google/sre-book/service-level-objectives/)；[复盘文化章节](https://sre.google/sre-book/postmortem-culture/)。已读取目标与指标定义、选择及复盘哲学/工作流的相关正文，未通读全书。这里明确对应旧版在线正文，不混称新版内容。

落地：[reliability.md](../../release-operations/references/reliability.md) 的 SLI/SLO/SLA、观测、事故学习；错误预算应用、恢复和重复劳动治理为相关工程综合。数值与组织流程由项目决定，不照搬 Google 示例。

## 相关方法与技能机制

- **EventStorming — Alberto Brandolini**：[官方网站](https://www.eventstorming.com/)，已读取不同工作坊目的与协同探索说明。落地 [collaborative-modeling.md](../../business-modeling/references/collaborative-modeling.md)；未核查作者书籍全文。
- **C4 — Simon Brown**：[图示指南](https://c4model.com/diagrams)，已读取视图层级及按价值选取的说明。落地 [decisions.md](../../software-architecture/references/decisions.md)；不要求四层全画。
- **ADR — Michael Nygard**：[Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)，已读取文章正文。落地 [decisions.md](../../software-architecture/references/decisions.md)；使用项目现有目录和记录习惯，不照搬作者示例路径。
- **例子映射 — Matt Wynne**：[Introducing Example Mapping](https://cucumber.io/blog/bdd/example-mapping-introduction/)，已读取正文。落地 [测试方法](../../software-testing/references/methods.md)；保留规则、例子和问题的区别，不强制卡片颜色、会议人数或固定时长。
- **TDD — Kent Beck 提出，Martin Fowler 公开概述**：[Test Driven Development](https://martinfowler.com/bliki/TestDrivenDevelopment.html)，已读取概述。落地 [safe-change.md](../../software-implementation/references/safe-change.md)；未将其扩展为必须新增测试的通用要求。
- **NIST SSDF**：[官方项目说明](https://csrc.nist.gov/projects/ssdf)，已读取四组实践、按风险裁剪及适用说明。落地 [security.md](security.md)；未执行合规审计。
- **技能发现与渐进加载**：[OpenAI 官方 Build skills](https://learn.chatgpt.com/docs/build-skills)，已检索并读取正文；按本会话的 `skill-creator` 编写规则实现入口、可选参考和行为验证。明确边界的描述用于选择，正文仅在使用时加载，参考按需读取。

## 2026-10-24 补充来源

本轮按“为技能补充具体可操作的默认流程、模板与检查”为目标补充以下来源。核查层次同上文定义。

- **EARS — Alistair Mavin**：[官方页面](https://alistairmavin.com/ears/)，已读取正文中的通用句式与六种模式。落地 [requirements.md](../../product-discovery/references/requirements.md) 的验收句式及 product-discovery 输出模板。
- **Kiro 规格工作流**：[Specs 文档](https://kiro.dev/docs/specs/)，已读取三阶段（requirements/bugfix → design → tasks）及 bugfix 规格的“当前/期望/不变行为”。仅借鉴缺陷需求三项写法与三件套映射；不要求项目采用该工具或文件名。
- **A Philosophy of Software Design，第 2 版 — Ousterhout**：沿用上文第 8 项的核查范围。红旗清单、把复杂度往下拉、用定义消除错误、设计两次等为概念性转述，落地 [software-design](../../software-design/SKILL.md)；未逐章核对原文措辞。
- **Building Evolutionary Architectures，第 2 版 — Ford、Parsons、Kua、Sadalage**：[Thoughtworks 书目页](https://www.thoughtworks.com/insights/books/building-evolutionary-architectures-second-edition)，已核查书目及“适应度函数用于自动化架构治理”的定位，未通读正文。落地 [decisions.md](../../software-architecture/references/decisions.md)。*Fundamentals of Software Architecture* 第 2 版仅确认存在讨论架构特性度量与适应度函数的章节，未作为直接依据。
- **Tidy First? — Kent Beck**：[O'Reilly 书目](https://www.oreilly.com/library/view/tidy-first/9781098151232/)，已核查书目与公开评述中“结构整理与行为变化分开、整理不总是先做”的主张，未通读正文。落地 [safe-change.md](../../software-implementation/references/safe-change.md)。
- **Debugging: The 9 Indispensable Rules — David Agans**：依据对九条规则的通用知识整理，本轮未在线核查原文。落地 [debugging.md](../../software-implementation/references/debugging.md)，步骤为工程化改写。
- **Unit Testing: Principles, Practices, and Patterns — Vladimir Khorikov**：[Manning 第 9 章节选](https://livebook.manning.com/book/unit-testing/chapter-9) 及二手笔记，确认四要素与“只 mock 非托管依赖”的主张，未通读原著。落地 [methods.md](../../software-testing/references/methods.md) 及 software-testing 的测试价值检查。
- **DORA 2025 State of AI-assisted Software Development**：[Google Cloud 发布文章](https://cloud.google.com/blog/products/ai-machine-learning/announcing-the-2025-dora-report)、[DORA 报告页](https://dora.dev/research/2025/dora-report/)，已读取“AI 是放大器”“AI 采用与交付吞吐正相关、与交付稳定性负相关”的公开结论；七项 AI 能力名称在可读页面中未列出，未引用。落地 software-delivery 的切片验证要求。属观察性调查结论，不作因果保证。
- **Diátaxis — Daniele Procida**：[官方站点](https://diataxis.fr/)，已读取四类文档定义。落地 tech-docs 场景表中的技术指南分类。
- **Skill 编写规范**：[Claude Agent Skills best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)，已读取正文。本轮据此采用第三人称且含触发词的描述、提供默认方案而非罗列选项、复杂流程给可复制清单与输出模板、引用只保留一层。

## 2026-11-26 补充来源

本轮围绕软件开发生命周期与软件工程管理经典著作做系统性补盲，重点强化：风险与流经济学、轻量威胁建模、需求定型与无预设提问、聚合与类型化领域建模、分布式稳定性与数据流一致性、模块秘密与公共 API 契约、科学调试感染链、测试心理学与测试替身/异味、可观测性及可信在线实验。核查层次同上文定义（均为书目/公开指南核查 + 工程化综合，未通读全文，不编造页码或原句）。

### 交付统筹、流经济学与安全

- **The Mythical Man-Month（周年版，含 *No Silver Bullet*）— Frederick P. Brooks, Jr.**：确认书目与本质/偶然复杂度、概念完整性、第二系统效应等经典主题。落地 [software-delivery/SKILL.md](../SKILL.md) 与 [flow.md](flow.md)。
- **A Spiral Model of Software Development and Enhancement（1988）— Barry W. Boehm**：确认风险驱动生命周期核心思想（以最高风险不确定性决定每轮投入）。落地 [software-delivery/SKILL.md](../SKILL.md) 与 [flow.md](flow.md)。
- **The Principles of Product Development Flow — Donald G. Reinertsen**：确认书目与小批量经济学、在制品队列长度、延迟代价（Cost of Delay）及快速反馈主题。落地 [flow.md](flow.md)。
- **Team Topologies — Matthew Skelton、Manuel Pais**：[官方网站](https://teamtopologies.com/)，已核查认知负荷、团队类型与交互模式定位。落地 [flow.md](flow.md) 与 [decisions.md](../../software-architecture/references/decisions.md)。
- **Threat Modeling: Designing for Security — Adam Shostack**：[作者站点](https://shostack.org/)，已核查四问框架（What are we working on / What can go wrong / What are we going to do about it / Did we do a good job）与 STRIDE 威胁分类。落地 [security.md](security.md)。

### 问题发现与需求工程

- **Exploring Requirements: Quality Before Design — Donald C. Gause、Gerald M. Weinberg**：确认书目与设计前质量、无预设提问（Context-Free Questions）及需求歧义排查主题。落地 [product-discovery/SKILL.md](../../product-discovery/SKILL.md)、[discovery.md](../../product-discovery/references/discovery.md) 与 [requirements.md](../../product-discovery/references/requirements.md)。
- **Impact Mapping — Gojko Adzic**：[官方站点](https://www.impactmapping.org/)，已核查 Goal → Actor → Impact → Deliverable 四层映射结构。落地 [discovery.md](../../product-discovery/references/discovery.md)。
- **Shape Up — Ryan Singer（Basecamp）**：[官方在线书](https://basecamp.com/shapeup)，已核查 Appetite（投入边界）、Rabbit Holes（高风险暗礁）与 No-Gos（明确不做）定型思路。落地 [product-discovery/SKILL.md](../../product-discovery/SKILL.md) 与 [requirements.md](../../product-discovery/references/requirements.md)。

### 业务与领域建模

- **Implementing Domain-Driven Design（及 *Effective Aggregate Design* 专题）— Vaughn Vernon**：确认书目与聚合设计四条经验法则（保护真实不变量、小聚合、ID 引用、跨聚合最终一致）。落地 [collaborative-modeling.md](../../business-modeling/references/collaborative-modeling.md)。
- **Domain Modeling Made Functional — Scott Wlaschin**：确认 Pragmatic Bookshelf 书目与“用显式类型/状态结构让非法状态不可表示”及工作流管道主题。落地 [collaborative-modeling.md](../../business-modeling/references/collaborative-modeling.md)。

### 系统架构、分布式数据与集成

- **Release It!，第 2 版 — Michael T. Nygard**：确认 Pragmatic Bookshelf 书目与稳定性反模式（集成点阻塞、级联故障、无界结果集、重试风暴）及稳定性模式（超时、断路器、舱壁、背压/降载、稳态、快速失败）。落地 [software-architecture/SKILL.md](../../software-architecture/SKILL.md) 与 [resilience-and-integration.md](../../software-architecture/references/resilience-and-integration.md)。
- **Designing Data-Intensive Applications — Martin Kleppmann**：[官方书站](https://dataintensive.net/)、[O'Reilly 页面](https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/)，已核查记录系统与派生数据、复制延迟一致性模型、可靠写入与分布式取舍主题。落地 [resilience-and-integration.md](../../software-architecture/references/resilience-and-integration.md)。
- **Enterprise Integration Patterns — Gregor Hohpe、Bobby Woolf**：[官方站点](https://www.enterpriseintegrationpatterns.com/)，已核查幂等接收者、死信通道、关联标识等异步集成模式定位。落地 [resilience-and-integration.md](../../software-architecture/references/resilience-and-integration.md)。
- **Software Architecture: The Hard Parts — Neal Ford、Mark Richards、Pramod Sadalage、Zhamak Dehghani**：确认 O'Reilly 书目与分布式拆分/聚合驱动力、数据所有权与 Saga 权衡主题。落地 [resilience-and-integration.md](../../software-architecture/references/resilience-and-integration.md)。
- **Monolith to Microservices — Sam Newman**：确认 O'Reilly 书目与绞杀者模式、抽象分支、并行运行及数据逐步切分主题。落地 [resilience-and-integration.md](../../software-architecture/references/resilience-and-integration.md)。

### 模块、代码内部架构与公共 API 设计

- **On the Criteria To Be Used in Decomposing Systems into Modules（1972）— David L. Parnas**：确认论文核心主张——按可能变化的设计决策（秘密）而非执行步骤划分模块。落地 [software-design/SKILL.md](../../software-design/SKILL.md) 与 [api-and-contracts.md](../../software-design/references/api-and-contracts.md)。
- **Structured Design — Edward Yourdon、Larry L. Constantine**：确认经典耦合与内聚定义。落地 [architecture-and-coupling.md](../../software-design/references/architecture-and-coupling.md)。
- **Balancing Coupling in Software Design — Vlad Khononov**：确认 Addison-Wesley 书目与整合强度、距离、变化频率三维平衡原则（同时诊断紧耦合痛点与低变化场景的过度抽象）。落地 [software-design/SKILL.md](../../software-design/SKILL.md) 与 [architecture-and-coupling.md](../../software-design/references/architecture-and-coupling.md)。
- **Hexagonal Architecture（Ports and Adapters）— Alistair Cockburn**：[作者官方文章](https://alistair.cockburn.us/hexagonal-architecture/)，已核查通过端口与适配器隔离业务核心与外部驱动/被驱动设施的目标。落地 [architecture-and-coupling.md](../../software-design/references/architecture-and-coupling.md)。
- **Clean Architecture — Robert C. Martin**：确认 Prentice Hall / InformIT 书目与依赖原则（依赖指向高层策略）、无环依赖（ADP）与稳定依赖（SDP）；按需裁剪，避免机械多层仪式。落地 [architecture-and-coupling.md](../../software-design/references/architecture-and-coupling.md)。
- **Boundaries（Functional Core, Imperative Shell）— Gary Bernhardt**：确认公开演讲核心结构——纯逻辑核心与 I/O 外壳分离以提升可理解性与测试反馈速度。落地 [architecture-and-coupling.md](../../software-design/references/architecture-and-coupling.md)。
- **Fundamentals of Software Architecture — Mark Richards、Neal Ford**：确认 O'Reilly 书目与组件化模块化思维、按能力组织边界及权衡分析定位。落地 [architecture-and-coupling.md](../../software-design/references/architecture-and-coupling.md)。
- **Software Design X-Rays / Your Code as a Crime Scene — Adam Tornhill**：确认 Pragmatic Bookshelf 书目与基于版本控制历史识别热点（复杂度×变更频率）及变更耦合（Change Coupling）的行为代码分析思路。落地 [software-design/SKILL.md](../../software-design/SKILL.md) 与 [architecture-and-coupling.md](../../software-design/references/architecture-and-coupling.md)。
- **Design Patterns: Elements of Reusable Object-Oriented Software — Erich Gamma、Richard Helm、Ralph Johnson、John Vlissides**：确认 Addison-Wesley 书目与组合优于继承、面向接口编程及按真实张力选用模式的原则。落地 [architecture-and-coupling.md](../../software-design/references/architecture-and-coupling.md)。
- **Design Stamina Hypothesis — Martin Fowler**：确认公开论述关于“好设计在初期略慢但维持长期演进耐力，同时警惕过度设计”的经济权衡视角。落地 [architecture-and-coupling.md](../../software-design/references/architecture-and-coupling.md)。
- **Object-Oriented Software Construction，第 2 版 — Bertrand Meyer**：确认书目与契约式设计（DbC：前置/后置条件、不变量）及命令查询分离（CQS）核心定义。落地 [api-and-contracts.md](../../software-design/references/api-and-contracts.md)。
- **How to Design a Good API and Why It Matters — Joshua Bloch**：确认演讲/论文关于 API 不可逆性、最小惊讶、快速失败与最小可变性的核心准则。落地 [api-and-contracts.md](../../software-design/references/api-and-contracts.md)。
- **Practical Object-Oriented Design，第 2 版 — Sandi Metz**：确认书目与“重复代价低于错误抽象”、依赖方向与迪米特法则主题。落地 [api-and-contracts.md](../../software-design/references/api-and-contracts.md)。

### 实现、调试与工程协作

- **Code Complete，第 2 版 — Steve McConnell**：确认书目与软件构建实践（卫语句、表驱动、边界防御与构建检查）。落地 [software-implementation/SKILL.md](../../software-implementation/SKILL.md) 与 [safe-change.md](../../software-implementation/references/safe-change.md)。
- **The Pragmatic Programmer，20 周年版 — David Thomas、Andrew Hunt**：确认 Pragmatic Bookshelf 书目与曳光弹 vs 原型、单一知识源（DRY）、断言与错误处理分离、快速崩溃等主题。落地 [software-implementation/SKILL.md](../../software-implementation/SKILL.md) 与 [safe-change.md](../../software-implementation/references/safe-change.md)。
- **Why Programs Fail，第 2 版 — Andreas Zeller**：[官方书站](https://www.whyprogramsfail.com/)，已核查感染链（Defect → Infection → Failure）与系统性缩减复现（Delta Debugging）主题。落地 [debugging.md](../../software-implementation/references/debugging.md)。
- **Software Engineering at Google — Titus Winters、Tom Manshreck、Hyrum Wright**：[官方在线目录](https://abseil.io/resources/swe-book/html/toc.html)，已核查海勒姆定律（Hyrum's Law）与面向长期维护的代码审查原则。落地 [software-implementation/SKILL.md](../../software-implementation/SKILL.md) 与 [safe-change.md](../../software-implementation/references/safe-change.md)。

### 测试与验收

- **The Art of Software Testing，第 3 版 — Glenford J. Myers、Corey Sandler、Tom Badgett**：确认书目与测试心理学（以发现缺陷而非证明正确为目的）及错误猜测方法。落地 [software-testing/SKILL.md](../../software-testing/SKILL.md) 与 [methods.md](../../software-testing/references/methods.md)。
- **xUnit Test Patterns — Gerard Meszaros**：[官方站点](http://xunitpatterns.com/)，已核查五类测试替身定义（Dummy/Stub/Spy/Mock/Fake）与常见测试异味（Mystery Guest/Fragile/Erratic/Obscure）。落地 [methods.md](../../software-testing/references/methods.md)。
- **A Practitioner's Guide to Software Test Design — Lee Copeland**：确认书目与组合测试（Pairwise/All-Pairs）、等价类/边界值、决策表与状态转换覆盖主题。落地 [methods.md](../../software-testing/references/methods.md)。
- **Growing Object-Oriented Software, Guided by Tests — Steve Freeman、Nat Pryce**：确认书目与行走骨架（Walking Skeleton）及“倾听测试的设计反馈”主题。落地 [software-testing/SKILL.md](../../software-testing/SKILL.md) 与 [methods.md](../../software-testing/references/methods.md)。

### 发布、可观测性、实验与系统安全

- **Refactoring Databases: Evolutionary Database Design — Pramod J. Sadalage、Scott W. Ambler**：[官方站点](https://databaserefactoring.com/)，已核查演进式数据库重构与扩展—收缩过渡期思路。落地 [delivery.md](../../release-operations/references/delivery.md)。
- **Observability Engineering — Charity Majors、Liz Fong-Jones、George Miranda**：确认 O'Reilly 书目与高基数/高维度宽事件可观测性区别于传统预聚合监控的核心定位。落地 [reliability.md](../../release-operations/references/reliability.md)。
- **Trustworthy Online Controlled Experiments — Ron Kohavi、Diane Tang、Ya Xu**：[官方书站](https://experimentguide.com/)，已核查 OEC、护栏指标、特威曼定律（Twyman's Law）、样本比例不匹配（SRM）与偷看偏差主题。落地 [evolution.md](../../release-operations/references/evolution.md)。
- **The Field Guide to Understanding 'Human Error' — Sidney Dekker**：确认书目与系统安全新视角（人为失误是系统症状而非根因、局部理性分析）。落地 [reliability.md](../../release-operations/references/reliability.md)。

## 覆盖与剩余研究边界

初始 15 本书及后续两轮补充著作均已关联具体指令位置，覆盖软件开发全生命周期的关键节点：问题定义/访谈/影响地图/机会树/定型去风险、故事地图/EARS/歧义排查、统一语言/状态/聚合/类型化建模/事件风暴、质量场景/C4/ADR/适应度函数/稳定性防雪崩/数据流一致性/渐进拆迁、深模块/秘密列表/契约式设计/API 准则、关系数据与负载设计、安全变更/曳光弹/感染链调试/海勒姆定律、证伪测试心态/组合与性质测试/测试替身与异味/探索式测试、持续交付/演进式数据库重构/可观测性与诊断信号/新视角无责复盘/可信在线实验与退役，以及风险驱动的威胁建模（四问 + STRIDE）。

数据设计继续使用 [database-design](../../database-design/SKILL.md) 及其 [来源说明](../../database-design/references/sources.md)，文档继续使用 [tech-docs](../../tech-docs/SKILL.md) 及其 [书目](../../tech-docs/references/books-and-methods.md)。这些既有书目超出本次新增的 15 本书范围，保留原核查声明，不宣称本次重新通读。

若要精确引用、核验特定章节或对某作者展开完整研究，需要合法可用原文，逐项核实后更新相应方法与证据范围。当前文件可以指导实际工程任务，但“全部书目已有落实”不等于“所有理论已穷尽”，有限行为评估也不证明团队长期效率和幸福感已提升。
