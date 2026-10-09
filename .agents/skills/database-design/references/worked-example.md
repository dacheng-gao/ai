# 业务到 DDL 的演练

仅在需要具体映射和反例时读取。这是假设性场景，不是任何项目的产品真相。

## 一、独占资源预约

假设已确认：组织内资源有唯一编号；预约引用同组织资源；有限非空时间段按 `[开始,结束)` 解释；状态为 booked/cancelled；未取消预约不得重叠，取消保留记录并释放时间段。按组织读取 booked 预约，按开始时间与 ID 排序。除此之外的授权、状态流转和请求重试协议尚未设计。

| 业务事实 | 存储选择与理由 |
|---|---|
| 组织、资源和一次预约 | 三个不同粒度，分开存储；预约不是资源的一组重复字段 |
| 资源编号与技术 ID | 组织内编号唯一；技术 ID 用于关联，不代替编号约束 |
| 同组织关系 | 带 `tenant_id` 的候选键与复合外键；单独外键不能证明同属组织 |
| 非空且有限的半开区间 | 显式起止列、CHECK 与 `tstzrange(..., '[)')`；相邻允许，反向/无限端点拒绝 |
| 未取消的冲突 | 部分 GiST 排斥约束，作用域含组织与资源；并发写入由数据库裁决 |
| 预约列表 | 部分 B-tree 索引服务稳定子集和排序；不盲目覆盖所有返回列 |

[postgresql-example.sql](postgresql-example.sql) 是可执行的教学 fixture，含 DDL、合法相邻/取消后复用、作用域与非法区间等反例。只在新建的隔离数据库执行，它会安装 `btree_gist` 并创建教学表；不作为现有项目迁移。扩展权限不足时，应报告并选择其他已证明正确的协议，而不是偷偷安装到业务库。

两个会话插入重叠 booked 预约：第二个应等待第一个裁决；第一个提交后第二个以 `23P01` 冲突失败，第一个回滚则第二个可以继续。测试读最终已提交数据，不能仅看其中一个会话报错。

列表 SQL 的候选形状：

```sql
SELECT id, resource_id, starts_at, ends_at
FROM dd_booking
WHERE tenant_id = 1 AND status = 'booked'
  AND starts_at >= TIMESTAMPTZ '2026-10-10 00:00:00+00'
ORDER BY starts_at, id
LIMIT 50;
```

用实际量级、活跃占比、参数与统计信息验证。此 fixture 很小，顺序扫描正常，不能据此断言索引有效或无效。取消会修改部分索引/约束的相关列，需要计入写成本。资源删除被历史预约引用时拒绝；若业务需要删除或匿名化资源，必须另定历史语义。

## 二、跨行容量不能用行 CHECK 代替

假设另一业务按资源限制所有有效分配的总量。`allocation.quantity > 0` 只能保证每行数量，不保证 `SUM(quantity) <= resource.capacity`。

可选协议之一是共同 guard 行，适用前提为所有影响容量的写入口使用同一协议：

```sql
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT capacity FROM resource WHERE id = :id FOR UPDATE;
-- 在成功取锁后的新语句读取，不沿用等待前的 SUM 或同一语句快照。
SELECT COALESCE(SUM(quantity), 0) FROM allocation
WHERE resource_id = :id AND active;
-- 核对总量及本次改变量；满足条件才新增/修改。
COMMIT;
```

新增、取消、移动和缩减容量都要加入协议；跨资源移动按确定顺序锁全部相关 guard，控制死锁并有界重试。资源还不存在时没有行可锁，应先解决身份建立的竞争。Repeatable Read 下等待锁不自动刷新事务快照，不可照搬上述论证。

若选余额/预留量行进行原子条件更新，必须说明它是原始事实还是同步派生事实，分配明细如何同事务提交及核对；若选 Serializable，说明整事务重试与副作用处理。这三种方案不是必须同时实现。

## 验证记录

2026-10-09，在临时 PostgreSQL 18.6（Homebrew）实例中执行 `psql -X -v ON_ERROR_STOP=1 -f postgresql-example.sql`：DDL 和合法相邻/取消后复用成功；七个违反例分别捕获预期的约束 SQLSTATE；最终行数及状态断言通过。

另用两个独立 psql 会话交错写入同一资源的重叠预约，`pg_stat_activity` 观察到第二会话等待 `Lock/transactionid`；第一会话提交后第二会话返回 `23P01`，该日期最终只有一条已提交预约。没有执行吞吐、延迟或生产量级负载测试，也未测试所有冲突/回滚分支。

创建时的独立前向评估使用不同的业务任务，避免只检验能否复述此样例。单个样例的成功不能证明所有设计都正确；后续应用仍须验证目标业务和目标版本。
