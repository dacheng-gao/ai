# SQL Server 设计

在目标为 SQL Server/Azure SQL 时读取。确认服务器版本、edition/服务层、数据库 compatibility level、collation、RCSI/ALLOW_SNAPSHOT_ISOLATION 与驱动/会话设置。以下以 SQL Server 2022、兼容级别 160 的常见磁盘表为基线；2025、Azure SQL、内存优化表的能力不可混用。

## 方法与书籍

- **Pro SQL Server Relational Database Design and Implementation，Louis Davidson（2021）**：从业务可理解的设计逻辑走到关系结构、完整性与可维护的 OLTP 实现；表是否准确表达事实与是否高效实现要分别检验。该书涉及 SQL Server 2019 能力，后续版本按官方文档核实。
- **T-SQL Fundamentals，第 4 版，Itzik Ben-Gan**：用集合、逻辑查询处理与准确的 SQL 语义设计和验证访问；行序、NULL、重复和分页都是正确性问题。
- **SQL Server Execution Plans，第 3 版，Grant Fritchey**：从执行计划理解引擎实际做的工作，再判断访问结构和估计是否合理；不能凭图标、相对 cost 或 missing-index 提示直接下结论。
- **Pro SQL Server Internals，第 2 版，Dmitri Korotkevitch**：把存储、索引、锁、版本与日志的机制联系到设计后果。该版涉及 SQL Server 2016 时代能力；用于原理背景，当前特性/限制按目标版本核实。

这是经书目和公开资料核对的方法综合，不是已通读全文的声明。出处与官方入口见 [sources.md](sources.md)。

## 身份、聚簇与类型

磁盘 rowstore 的 heap、clustered index 与业务主键分别判断。PRIMARY KEY 不必等于聚簇键，DDL 应明确 CLUSTERED/NONCLUSTERED 选择；聚簇键会影响非聚簇索引的行定位成本。通常先比较窄、稳定且适合访问的键，但递增键可能有末页写热点，随机 GUID 也可能有页分裂与空间成本，不预设统一胜者。

| 语义 | 候选能力与边界 |
|---|---|
| 技术身份 | `bigint IDENTITY`、sequence 或 `uniqueidentifier`；IDENTITY 本身不代替 PK/UNIQUE，也不保证连续编号或发生顺序 |
| 精确金额/数量 | `decimal(p,s)` 或有明确单位的整数；精度、范围、计算与舍入由业务决定，不能因类型名称默认 money 满足所有口径 |
| 文本 | 按实际字符集选 `nvarchar` 或支持 UTF-8 的适当 varchar/collation；比较规则、长度、隐式转换与应用参数类型会影响唯一性和索引查找 |
| 时间 | 通常比较 `datetime2`、`datetimeoffset`、`date`；offset 不代表原始地区时区。`rowversion`/旧称 timestamp 是变化标记，不是时间 |
| 状态 | CHECK 或引用表，`bit` 表达二值/可空标记；没有 PostgreSQL enum/range 同名能力可直接移植 |
| 半结构数据 | 2022 常用 `nvarchar` + ISJSON，必要时提取有明确类型和长度的 computed column 再索引；不默认支持后续版本的原生 JSON/JSON index |

## 完整性与历史

NOT NULL 不拒绝空串。明确要求拒绝空串但允许纯空格时，应评估 `DATALENGTH(column) > 0` 等符合语义的检查；`LEN` 忽略尾部空格，TRIM 还会改变输入判定范围。文本等值比较也可能忽略尾空格，不能机械采用 `column <> ''` 代替所需语义。

普通唯一索引将 NULL 纳入唯一组合；单列通常只能一个 NULL。需要“仅已分配值唯一”或“仅活跃值唯一”时比较 filtered unique index，而不是把 PostgreSQL/MySQL 的默认 NULL 行为套过来。

```sql
-- 示例前提：活跃且分配了代码时，组织内代码唯一。
CREATE UNIQUE NONCLUSTERED INDEX uq_mapping_active_code
ON dbo.CustomerMapping(tenant_id, external_code)
WHERE active = 1 AND external_code IS NOT NULL;
```

谓词受 filtered-index 表达式限制，不能任意照搬业务函数或在过滤谓词中引用 computed column；规划器需能证明查询满足条件，参数化可能影响可用性。computed-column index 还要核对确定性、精度及 SET options；所需 SET options 影响创建与写入会话，不仅是建索引时。

外键不会自动建立引用端索引；按连接和父记录操作评估。复合外键保持作用域，级联路径/循环限制需核对。普通 CHECK 仍有 NULL/UNKNOWN 问题，也不能直接保证跨行集合总量；约束被禁用、未验证或不受信任时不报告完整性已保障。已有数据需要按支持的验证流程重新取得可信约束，不能仅启用开关。

System-versioned temporal tables 保存系统修改历史，适合需要这种语义的查询，不自动表达业务生效时间、操作者、修改理由或当时确认的交易快照。按保留期、历史表索引、纠错与删除语义选用；不能为“有历史”就增加全套 temporal。

## 事务、竞争与恢复

Read Committed 可能基于共享锁，也可能因 RCSI 开启使用语句级行版本；Snapshot 是事务级快照且需允许设置。两者均不能单独证明跨行业务不变量。SQL Server Serializable 使用范围锁等机制，不能移植 PostgreSQL SSI 的性能与失败论证。

单行条件更新可用 `OUTPUT` 和影响行数裁决；输出行不等于最终提交成功，要以 COMMIT 结果决定业务返回。`rowversion` 可作乐观并发令牌，所有变化/更新的匹配语义和冲突恢复要明确，不能拿它作为审计时间或只靠重试掩盖拒绝。

需要共同 guard 时，可按协议选择 `UPDLOCK` 等显式锁，检查隔离、持锁期限、空结果及锁升级；需要防止范围插入时比较合适索引下的 Serializable/`HOLDLOCK`。多对象按固定顺序锁，检查新增、取消、转移和容量变更全部入口。不要把 ROWLOCK 当不会升级的保证，也不要把 NOLOCK 当一致的加速读取。

失败处理需明确事务是否仍可提交；用已有框架或适当的 TRY/CATCH、XACT_STATE/XACT_ABORT 协议回滚并有界重试整个单元。不能从已失败/部分完成状态直接重试语句。`MERGE` 的匹配、并发与副作用按具体业务验证，不默认给所有 upsert/幂等任务采用。

## 负载与索引

围绕真实读取比较 clustered/nonclustered B-tree、filtered index 与 INCLUDE 覆盖。区分 Seek Predicate、Residual Predicate、返回量、Key/RID Lookup 和排序；Index Seek 也可能做大量工作。覆盖列虽非键，也有更新和空间成本。

计划受统计信息、参数、参数类型、估计器/兼容级别与缓存影响；查计划偏差后再评估参数敏感、统计更新或 SQL Server 2022 PSP 的具体适用性。不要默认 RECOMPILE、OPTIMIZE FOR 或强制计划；missing-index 提示不完整考虑写成本、重复索引和业务约束。

Columnstore 适合有依据的分析扫描，不是 OLTP 点查的通用默认；评估 rowgroup、delta store、删除/更新、批量和混合负载。索引视图需满足定义/会话限制，会把计算成本转到写入；只有需要时比较。分区主要围绕裁剪和保留/切换管理设计，同时检查唯一键、对齐与维护复杂度。

在隔离环境使用估计/实际计划、`SET STATISTICS IO/TIME` 和授权可读的 Query Store 证据；实际计划会执行语句。估计 cost 和图中百分比不是耗时验收；Query Store 的计划历史有助于发现回归，但缺少数据不能声称性能达标。

写入检查日志、版本存储/tempdb（启用 ADR 等配置会改变具体存放）、锁等待/死锁、页分裂、latch 与维护成本。只围绕实际限制调查，不为常规小表调整服务器配置。

## 演进和验证

核对 ONLINE/RESUMABLE、edition/服务层、版本、对象限制与实际锁；online 不等于没有短时锁和资源消耗。DDL/大回填仍要安排兼容窗口、分批恢复与旧数据核对，不直接采用 PostgreSQL CONCURRENTLY 或 MySQL ALGORITHM。

重点反例：多个 NULL 与普通唯一键、活跃/停用恢复冲突、大小写等价、跨组织引用、禁用/不可信约束、RCSI 下两个事务读相同总量、乐观令牌冲突、快照/历史口径与并发分页。没有引擎环境时只能报告文档核对和设计推演，不把 T-SQL 外观正确称为运行通过。
