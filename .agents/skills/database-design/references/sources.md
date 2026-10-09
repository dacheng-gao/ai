# 方法来源与核实边界

本技能是概念性综合及面向任务的工作指导，不是全文阅读证明、逐章摘要或各作者对某项目的结论。书籍只标识方法背景，不提供未经原文核对的引文、页码或精确章节归属。需要精确归属时，查用户提供的合法原文或权威出版资料。

| 来源 | 在本技能中的用途 | 边界 |
|---|---|---|
| Michael J. Hernandez, *Database Design for Mere Mortals* | 从业务信息进入表、字段、键与关系，检查模型能否表达真实事实 | 不把教学设计流程强制成每个局部任务的固定模板 |
| Silberschatz, Korth, Sudarshan, *Database System Concepts* | 关系理论、函数依赖、规范化、事务、索引与查询处理基础 | 产品实现和版本差异以目标数据库为准 |
| C. J. Date, *Database Design and Relational Theory* | 以依赖、键、冗余和更新异常推敲关系模型 | 理论关系与 SQL 的 NULL/重复等语义有区别；规范化不能代替事务分析 |
| Bill Karwin, *SQL Antipatterns* | 用失败场景检验字段、关系、完整性和查询结构 | 反模式是诊断线索，不是脱离语境的绝对禁令 |
| Dimitri Fontaine, [*The Art of PostgreSQL*](https://theartofpostgresql.com/) | 从应用需要理解 SQL 与数据库承担的数据处理责任 | 不推断全部业务规则都应搬入 SQL 或存储过程 |
| Markus Winand, [*Use The Index, Luke!*](https://use-the-index-luke.com/) | 从实际访问路径理解索引、排序、连接与分页 | 跨产品建议须核对当前 PostgreSQL 规划器、数据分布和版本能力 |
| [PostgreSQL 官方文档](https://www.postgresql.org/docs/) | 类型、约束、隔离、索引及 DDL 的实际语义 | 执行时访问目标主版本，不把 current 链接当部署版本 |

## 本次核实

2026-10-09 创建技能时，核对了 PostgreSQL 18 以下页面。样例的本地执行环境与结果见 [worked-example.md](worked-example.md)；这不表示已经实测所有特性或其他数据库。

- [约束](https://www.postgresql.org/docs/18/ddl-constraints.html)：NULL、引用范围、自动索引和可表达的规则。
- [多列索引](https://www.postgresql.org/docs/18/indexes-multicolumn.html)：前导列与 skip scan 的条件。
- [事务隔离](https://www.postgresql.org/docs/18/transaction-iso.html)：快照、Serializable 与整事务重试。
- [CREATE INDEX](https://www.postgresql.org/docs/18/sql-createindex.html)：并发构建与失败/事务限制。
- [JSON](https://www.postgresql.org/docs/18/datatype-json.html)：文档、索引和行级竞争。
- [Range](https://www.postgresql.org/docs/18/rangetypes.html)：区间与排斥约束。
- [部分索引](https://www.postgresql.org/docs/18/indexes-partial.html)：谓词与规划时证明。
- [覆盖与 index-only scan](https://www.postgresql.org/docs/18/indexes-index-only-scans.html)：覆盖不保证省去 heap 访问。
- [HOT](https://www.postgresql.org/docs/18/storage-hot.html)：索引关联列变化、页空间和更新成本。
- [分区](https://www.postgresql.org/docs/18/ddl-partitioning.html)：维护用途与完整性限制。
- [EXPLAIN](https://www.postgresql.org/docs/18/using-explain.html)：计划观察与实际执行。

下列是后续按任务核实的入口，不声称创建时已逐项验证：[日期时间](https://www.postgresql.org/docs/18/datatype-datetime.html)、[枚举](https://www.postgresql.org/docs/18/datatype-enum.html)、[显式锁](https://www.postgresql.org/docs/18/explicit-locking.html)、[RLS](https://www.postgresql.org/docs/18/ddl-rowsecurity.html)、[ALTER TABLE](https://www.postgresql.org/docs/18/sql-altertable.html)、[扩展统计](https://www.postgresql.org/docs/18/planner-stats.html)。

## MySQL / SQL Server 的补充书目

2026-10-09 核对以下出版社/作者资料中的书名、作者、版次和公开内容范围；不是对全文的核验。只提取与数据库设计相关的判断方法，运维与调参内容按任务触发。

| 书籍与权威入口 | 进入技能的判断方法 | 适用边界 |
|---|---|---|
| [High Performance MySQL, 4th Edition](https://www.oreilly.com/library/view/high-performance-mysql/9781492080503/) — Silvia Botros、Jeremy Tinley | 把数据结构、索引和可靠运行的成本一起评估 | 当前 InnoDB 行为与版本限制以官方文档为准 |
| [Efficient MySQL Performance](https://www.oreilly.com/library/view/efficient-mysql-performance/9781098105082/) — Daniel Nichter；[作者资料](https://hackmysql.com/book-0/) | 从访问路径与执行工作量定位响应问题 | 不把性能建议当业务正确性的依据 |
| [MySQL Cookbook, 4th Edition](https://www.oreilly.com/library/view/mysql-cookbook-4th/9781492093152/) — Sveta Smirnova、Alkin Tezuysal | 用局部可执行例子核对字符串、日期与查询语义 | 配方不是业务模型；5.7/8.0 示例须核对目标版本 |
| [Pro SQL Server Relational Database Design and Implementation](https://link.springer.com/book/10.1007/978-1-4842-6497-3) — Louis Davidson（2021） | 业务设计逻辑、关系结构、完整性与 OLTP 实现的连续映射 | 书中 SQL Server 2019 能力不是后续版本能力清单 |
| [T-SQL Fundamentals, 4th Edition](https://www.microsoftpressstore.com/store/t-sql-fundamentals-9780138101978) — Itzik Ben-Gan | 集合、查询语义、NULL/重复和正确访问 | 偏重语言与查询，不能替代概念建模 |
| [SQL Server Execution Plans, 3rd Edition](https://www.red-gate.com/simple-talk/featured/sql-server-execution-plans-third-edition-by-grant-fritchey/) — Grant Fritchey | 从实际执行工作、估计和访问算子验证设计 | 图示/工具可能随版本变化，不抄优化提示 |
| [Pro SQL Server Internals, 2nd Edition](https://link.springer.com/book/10.1007/978-1-4842-1964-5) — Dmitri Korotkevitch | 存储、索引与并发机制如何影响取舍 | 2016 时代的原理背景，不当成 2022/2025 能力清单 |

## MySQL 官方核实入口

本次读取 MySQL 8.4 以下页面，按对应问题组织进 [mysql.md](mysql.md)；具体 8.0 小版本门槛、运行参数和语句支持执行时再核实。

- [聚簇与二级索引](https://dev.mysql.com/doc/refman/8.4/en/innodb-index-types.html)、[事务隔离](https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html)。
- [CHECK](https://dev.mysql.com/doc/refman/8.4/en/create-table-check-constraints.html)、[外键](https://dev.mysql.com/doc/refman/8.4/en/create-table-foreign-keys.html)、[CREATE INDEX](https://dev.mysql.com/doc/refman/8.4/en/create-index.html)。
- [JSON](https://dev.mysql.com/doc/refman/8.4/en/json.html)、[EXPLAIN](https://dev.mysql.com/doc/refman/8.4/en/explain.html)、[Online DDL](https://dev.mysql.com/doc/refman/8.4/en/innodb-online-ddl-operations.html)。
- [MySQL 8.0 CHECK 的版本门槛](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html)：8.0.16 前后执行语义不同。

## SQL Server 官方核实入口

本次读取以下 Microsoft Learn 页面，以 `view=sql-server-ver16` 标识 2022 参考视图；共享页面仍可能包含后续版本说明，逐项检查 Applies to，不以 URL 参数保证全部内容只适用于 2022。

- [索引设计](https://learn.microsoft.com/en-us/sql/relational-databases/sql-server-index-design-guide?view=sql-server-ver16)、[Filtered index](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/create-filtered-indexes?view=sql-server-ver16)。
- [事务隔离](https://learn.microsoft.com/en-us/sql/t-sql/statements/set-transaction-isolation-level-transact-sql?view=sql-server-ver16)、[rowversion](https://learn.microsoft.com/en-us/sql/t-sql/data-types/rowversion-transact-sql?view=sql-server-ver16)。
- [唯一与 CHECK](https://learn.microsoft.com/en-us/sql/relational-databases/tables/unique-constraints-and-check-constraints?view=sql-server-ver16)、[Temporal tables](https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal/overview?view=sql-server-ver16)、[Query Store](https://learn.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store?view=sql-server-ver16)。
- [Computed-column 索引](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/indexes-on-computed-columns?view=sql-server-ver16)：确定性、精度和会话选项。

后续按任务核实：JSON computed-column 的具体转换/长度、filtered-index 的详细 SET options、table hints、CREATE INDEX edition/ONLINE/RESUMABLE 限制、PSP、columnstore、XACT_STATE 和 ADR。此处不声明已逐项运行验证。
