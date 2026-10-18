# 生命周期方法来源与覆盖

核查日期：2026-10-18。覆盖前述讨论的 **15 本书**及相关公开方法。本文是可追溯的概念提炼与 agent 工作方法综合，不是原著替代品、全文提取或逐章摘要。普通工程任务无需读取本文件或重新检索书目。

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

落地：复用 [software-design-philosophy](../../software-design-philosophy/SKILL.md)，以信息隐藏、深模块和变更成本评价设计。泛化须有实际简化作用；不按方法长度、注释数量或抽象数量机械评分。跨书存在差异，按问题与证据选择，不假装所有经典观点一致。

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

## 覆盖与剩余研究边界

上述 15 本书均已关联具体指令位置，含全部前述方法类别：事实访谈、假设实验、机会树、场景/故事地图/原型、统一语言/状态/不变量/事件风暴、质量场景/C4/ADR/技术试验、信息隐藏/数据约束/重构/TDD、实例化需求/风险测试/探索/验收、持续交付/迁移/发布控制、服务目标/复盘/结果反馈/演进与退役。

数据设计继续使用 [database-design](../../database-design/SKILL.md) 及其 [来源说明](../../database-design/references/sources.md)，文档继续使用 [tech-docs](../../tech-docs/SKILL.md) 及其 [书目](../../tech-docs/references/books-and-methods.md)。这些既有书目超出本次新增的 15 本书范围，保留原核查声明，不宣称本次重新通读。

若要精确引用、核验特定章节或对某作者展开完整研究，需要合法可用原文，逐项核实后更新相应方法与证据范围。当前文件可以指导实际工程任务，但“全部书目已有落实”不等于“所有理论已穷尽”，有限行为评估也不证明团队长期效率和幸福感已提升。
