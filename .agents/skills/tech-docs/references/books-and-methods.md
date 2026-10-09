# 书目与方法来源

这些资料覆盖不同问题：技术信息质量、表达与组织，以及需求、架构、测试和性能的专业内容。没有一本书替代整个生命周期的工程证据。

来源核查日期：2026-10-09。下列链接为出版社、作者或相关机构的公开介绍、目录与指南；本次没有获取并通读所有书籍全文。因此“可用于本技能”是结合这些可核实主题与工程实践作出的综合建议，不是书中逐字规则或逐章摘要。需要某书的精确论述、引文或页码时另行核对合法可用原文。

## 优先阅读的技术写作书

- **Docs for Developers: An Engineer’s Field Guide to Technical Writing** — Jared Bhatti、Sarah Corleissen、Jen Lambourne、David Nunez、Heidi Waterhouse。公开目录覆盖读者理解、规划、起草、编辑、示例、发布、反馈与维护。可用于把文档编制视为围绕用户任务迭代的工程工作，而非最终套模板。本次核查的是 2021 年第 1 版，不把其内容冒充新版新增内容。[Apress / Springer 书目与目录](https://link.springer.com/book/10.1007/978-1-4842-7217-6)。
- **Developing Quality Technical Information: A Handbook for Writers and Editors，第 3 版** — Michelle Carey、Moira McFadden Lanyi、Deirdre Longo、Eric Radzinski、Shannon Rouiller、Elizabeth Wilde。出版社列出准确、清楚、完整、具体、组织、可检索、风格、任务导向及视觉有效性等质量特征。可用于审阅实际问题，并按读者需要逐层展开信息；不能简化成任意加权总分。[IBM Press / InformIT 介绍与目录](https://www.informit.com/store/developing-quality-technical-information-a-handbook-9780133119008)。

## 表达与组织

- **The Pyramid Principle / The Minto Pyramid Principle（金字塔原理）** — Barbara Minto。作者公开介绍强调在核心观点下组织相关思想。可用于方案、评审与结果报告的重点和论据层次；操作步骤仍按执行顺序，参考手册仍服务查询，不能强迫所有文档采用同一种表达。[作者对方法的介绍](https://www.barbaraminto.com/concept)；[书籍与版本说明](https://www.barbaraminto.com/)。
- **On Writing Well** — William Zinsser。出版社将其定位于非虚构写作，涵盖科学技术和商业等主题。可作为清楚、直接的表达训练补充；英文写作建议不能机械套到中文，也不能取代软件契约与测试证据。[HarperCollins 书目](https://www.harpercollins.com/products/on-writing-well-william-zinsser)。具体章节观点未在本次全文核验。

## 生命周期中的专业书

- **Software Requirements，第 3 版（软件需求）** — Karl Wiegers、Joy Beatty。目录包括需求记录、高质量需求、数据、非功能需求与验证。可用于要求写出可观察行为、条件、约束与验收联系；现有代码不能替业务作需求决定。[Microsoft Press 介绍与目录](https://www.microsoftpressstore.com/store/software-requirements-9780735679641)。
- **Documenting Software Architectures: Views and Beyond，第 2 版** — Paul Clements 等。SEI 介绍覆盖架构视图、接口、行为及决策理由。可用于按读者关注选择视图、解释责任与关系，使图、文字和契约共同支持理解；不是要求每份方案画全套图。[CMU SEI 书目与内容介绍](https://www.sei.cmu.edu/library/documenting-software-architectures-views-and-beyond-second-edition/)。
- **Lessons Learned in Software Testing: A Context-Driven Approach** — Cem Kaner、James Bach、Bret Pettichord。出版社介绍覆盖测试设计、管理、策略与缺陷报告。可作为按上下文选择测试信息的专业补充；本技能中的用例可执行性、预期与实际结果分离是工程化综合，不声称某一用例模板来自该书。[Wiley-VCH 书目](https://www.wiley-vch.de/en/areas-interest/computing-computer-sciences/computer-science-17cs/software-engineering-17csj/software-measurement-testing-17csj4/lessons-learned-in-software-testing-978-0-471-08112-8)。
- **Systems Performance: Enterprise and the Cloud，第 2 版（性能之巅）** — Brendan Gregg。作者介绍和目录包含性能方法、观测工具、基准测试与容量分析。可用于要求性能报告说明环境、负载、口径及证据范围。性能指南的分位数、错误率与推断限制属于工程方法综合，不标成书中原句。[作者书目与目录](https://www.brendangregg.com/systems-performance-2nd-edition-book.html)。

## 免费的专业补充资料

- **Microsoft Writing Style Guide**：当前官方写作与术语指南；可帮助保持表达一致。经典纸质 **Microsoft Manual of Style** 可作为历史参考，实际规则优先核对当前指南，并尊重中文及项目约定。[Microsoft 官方指南](https://learn.microsoft.com/en-us/style-guide/welcome/)。
- **Diátaxis** — Daniele Procida：将教程、操作指南、参考和解释联系到不同读者需要。适合技术手册的信息组织，不是产品规格、测试报告和交付验收的统一模板。[官方方法介绍](https://diataxis.fr/)。

## 在本技能中的落实位置

- 读者任务、原始素材、证据对应、信息层次与术语解释：`evidence-and-writing.md`。
- 问题定位、后果、依据、修法及读者任务检查：`review-and-validation.md`。
- 需求、架构、测试、客户交付与操作资料：各场景指南；仅按适用性取用内容。
- 性能问题、负载、可复现数据与结论边界：`performance-testing.md`。
- 排版、链接、图表和中文编辑：`markdown-and-editing.md`，不以格式通过代替技术验证。

普通文档工作无需重复搜索这些书，也不要把推荐书目的历史地位或畅销宣传当成方法有效性的证据。实际采用的规则应接受具体任务、产物与读者反馈检验。
