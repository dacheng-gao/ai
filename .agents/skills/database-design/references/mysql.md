# MySQL / InnoDB 设计

在目标产品确为 MySQL 时读取。优先核对版本、存储引擎、SQL mode、字符集/排序规则、事务隔离、连接时区及运行权限。这里以 MySQL 8.0/8.4 的 InnoDB 为常见基线；MariaDB、其他兼容产品或后续版本须单独核实，不能视为同一个引擎。

## 方法与书籍

- **High Performance MySQL，第 4 版，Silvia Botros / Jeremy Tinley**：把 schema、索引、负载和可靠运行作为整体考虑；主键与二级索引成本、容量和维护也是设计的一部分。书中运维范围不自动成为本次任务范围。
- **Efficient MySQL Performance，Daniel Nichter**：从查询响应、扫描工作量与访问模式进入优化，优先减少不必要工作，再定位限制因素；不能用单一服务器指标或更强硬件替代原因分析。
- **MySQL Cookbook，第 4 版，Sveta Smirnova / Alkin Tezuysal**：用针对字符串、日期、汇总及存储程序的小样例验证具体实现语义；配方适合局部验证，不能替代完整业务模型和并发协议。

这些是方法性综合，书目/出版资料已核实，未声称逐页阅读。具体引擎行为以目标版本官方文档与执行证据为准，来源见 [sources.md](sources.md)。

## 逻辑模型到物理存储

InnoDB 用主键聚簇存储，二级索引携带主键列；宽主键的成本会传播到二级索引。业务候选键与聚簇技术键分开判断，比较短而稳定的键、业务复合键及跨节点生成的需要；不要把自增主键当唯一合法方案。随机键与递增键有不同页访问/分裂和热点，按实际负载验证，不能保证某种 UUID 或整数天然最快。

| 语义 | 决策与核实点 |
|---|---|
| 精确数值 | `DECIMAL(p,s)` 或明确单位的整数；范围与舍入由业务决定，UNSIGNED 与引用列的有无符号必须一致 |
| 文本 | 按 Unicode、比较和长度语义选择 `utf8mb4`/collation；大小写、重音、尾空格的等价关系可能影响唯一键。不要为节省猜测的空间默认 ASCII |
| 时间 | `TIMESTAMP` 有会话时区转换和范围限制，`DATETIME` 不承担同样转换；UTC 约定、连接设置、时间精度及原地区时区需明确，不能直接映射为 PostgreSQL timestamptz |
| 状态/布尔 | enum、文本/整数加 CHECK 或引用表按演进语义选；`BOOLEAN` 是整数别名，要限定 0/1 时明确约束 |
| 半结构内容 | 原生 JSON 保证可解析，不保证业务 schema；热点路径可用带明确类型/长度/collation 的生成列或函数索引。不能给整份 JSON 直接套 B-tree/GIN |
| 技术 ID | `AUTO_INCREMENT` 与稳定业务唯一键分别声明；不保证连续编号，既有有无符号和客户端数值范围需兼容 |

## 完整性与 NULL

MySQL 8.0.16 起才实际支持此版本系列的 CHECK 执行；更早版本解析成功不等于规则被保证。还要核对约束的 ENFORCED 状态、NULL 语义与可用表达式，不把跨行总量塞进 CHECK。

普通 UNIQUE 允许多个含 NULL 的组合。若“无批次”也必须唯一，可把缺失标记与规范化值一起纳入生成列键，或把缺失桶独立建模；不能只用 `COALESCE(batch_id,0)` 而允许真实 0 造成碰撞。原始 nullable 列仍承担真实关联，生成的键只承担所需相等语义。

```sql
-- 假设该桶只按组织和批次区分；实际还有仓库/商品等维度时加入完整键。
batch_missing tinyint GENERATED ALWAYS AS (batch_id IS NULL) STORED,
batch_key bigint GENERATED ALWAYS AS (COALESCE(batch_id, 0)) STORED,
UNIQUE KEY uq_bucket (tenant_id, batch_missing, batch_key)
```

缺失标记避免真实 0 与 NULL 碰撞。该片段不定义原始 batch_id 的关联和合法范围，仍须按确认的业务补齐。

MySQL 8.0/8.4 没有 PostgreSQL 风格的部分索引、INCLUDE、排斥约束或可延迟外键。活跃子集唯一性可按已确认语义使用生成列 + UNIQUE，例如：

```sql
-- 示例前提：活跃且分配代码的记录唯一；NULL 代表未分配，可重复。
active_code varchar(64) GENERATED ALWAYS AS (
    CASE WHEN active = 1 THEN external_code ELSE NULL END
) STORED,
UNIQUE KEY uq_active_code (tenant_id, active_code)
```

它不是物理部分索引：其他记录也会进入索引，有生成列和更新成本。明确原列/生成列比较规则、active 取值以及恢复活跃时的竞争；若未分配不允许重复，这个例子不适用。

外键需匹配类型/符号及字符比较规则。InnoDB 引用端缺少可用前缀索引时自动创建索引，先检查实际索引，避免重复；引用目标以完整主键/唯一键表达，不依赖已弃用的非标准非唯一引用。跨组织关联仍需包含共同作用域。

InnoDB 不支持用户分区表上的外键；不能为分区收益悄悄移除引用完整性。`foreign_key_checks=0` 再开启不自动重新验证期间的数据；不能把它当安全迁移方案。

## 事务与写路径

InnoDB 默认 Repeatable Read，但实际配置需确认。普通一致性读取、locking read 与 UPDATE 的观察及锁语义不同；锁定读取可能涉及记录、gap/next-key，取决于隔离、索引与访问条件。不要照搬 PostgreSQL 的 RR，也不要泛称“行锁只锁目标行”。

预留量/余额适合时使用单语句条件更新并检查 affected rows；跨行上限或预约冲突则需要共同 guard/适当范围锁及事务协议。共同 guard 取锁后，不沿用等待前的普通快照聚合；选择明确隔离与读法，验证新增、取消、移动和缩减等全部入口。

给锁定范围建立正确访问索引，控制事务大小和锁顺序。死锁后重新执行整个业务事务；锁等待超时可能只回滚语句，应用须明确回滚整个单元，不能接着提交部分工作。外部副作用与请求结果去重仍需单独协议。

`INSERT ... ON DUPLICATE KEY UPDATE` 可被任一相关唯一键触发；核对实际冲突含义。`REPLACE` 有删除后插入语义，不能默认当更新使用。两者都不保证请求幂等或一致的业务结果。

## 读取、索引与验证

按实际筛选、连接、排序、返回量评估复合 B-tree。二级索引中已有主键可覆盖一部分查询；覆盖宽列仍增加空间和写入，不需另建“只有主键”的重复二级索引。函数、类型转换与 collation 不匹配可能妨碍查找；前缀索引只比较前缀，前缀 UNIQUE 不等同完整值唯一。

按需评估函数/生成列、倒序、全文、空间、多值 JSON 索引或不可见索引的目标版本能力。不可见索引仍有维护成本，唯一性也仍会执行；它主要改变规划器选择，不能用来证明删除约束安全或已降低写成本。

在隔离环境比较 `EXPLAIN`、`EXPLAIN ANALYZE`（MySQL 8.0.18+，支持语句范围按版本核实）、实际返回与扫描/循环；ANALYZE 会执行被分析的语句，不在真实数据上试写。使用 slow log、Performance Schema/sys 的受权证据定位频率、锁等待与资源工作量；某个 `Using index`/`filesort` 标记不足以判断好坏。

写入验证看二级索引维护、redo/undo、长事务、purge、锁等待、页分裂及复制影响，只有相关问题出现时才深化。分区、缓存和副本也要满足唯一性、外键与新鲜度要求。

在线 DDL 按具体操作查 INSTANT/INPLACE/COPY、LOCK 与版本限制。INPLACE 不等于不重建，online 不等于无 metadata lock；很多 DDL 隐式提交，不能承诺普通 ROLLBACK 撤回。按项目流程拆分兼容、回填、核对与切换，明确失败后恢复方式。

## 反例验证

设计后重点尝试：大小写/重音下重复编号、多个 NULL 桶、不同组织关联、非法布尔/数量、同一请求不同内容、两个事务竞争最后容量、等待后使用旧快照、长事务期间 DDL。仅按场景选择，不为简单类别表启动全套压测。

创建时，在隔离的本机 MySQL 26.7.0 实例验证了上述两种生成列键：活跃重复/恢复活跃被拒绝，未分配与停用重复允许；NULL 桶重复被拒绝，真实 0 与 NULL 可共存；非法布尔 CHECK 被拒绝。结果仅验证这些基本机制，不是 MySQL 8.0/8.4 运行兼容性或性能证明，这两个版本仍须按实际部署验证。
