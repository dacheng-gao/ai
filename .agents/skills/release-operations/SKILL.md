---
name: release-operations
description: >-
  Prepare or execute authorized software releases, diagnose operational incidents,
  define reliability targets and use production feedback for evolution or retirement.
  Use for deployment, migration rollout, SLOs, incident learning or decommissioning.
  Exclude ordinary feature coding, GitHub workflow administration and runbook formatting alone.
---

# 发布、运行与持续演进

使变更可交付、运行可观察、故障可恢复，并把真实结果反馈到下一步开发。按当前任务选择一个入口；发布、可靠性、产品效果是不同结论。

## 确认对象与证据

读取相关发布流程、环境、制品版本、变更记录、服务依赖、运行指标和当前授权。区分准备方案、演练和实际操作；已有明确授权按范围执行，不要求重新审批。没有上线授权时完成可审查的方案或本地改动，不擅自执行生产操作或对外通知。

- 发布、流水线、迁移或灰度：[delivery.md](references/delivery.md)。
- 服务目标、告警、故障排查或复盘：[reliability.md](references/reliability.md)。
- 结果验证、技术债、遗留系统演进或退役：[evolution.md](references/evolution.md)。

不按章节顺序全部加载。事故处理中优先减小用户影响，避免为补写完整文档延误已经授权且依据充分的恢复动作。

## 工作闭环

先写清当前需要决定什么、可观察信号是什么、哪些变化可逆。对实际变更一次控制一个可辨认的变量或批次，按预定信号继续、停止或恢复；不得在结果不明时盲目重发可能重复产生副作用的操作。

使用工具核实实际版本与目标，命令和阈值取自项目事实；不存在的环境、仪表盘、回滚能力或负责人不能补造。先完成可独立验证的准备，只有确实缺少关键权限或信息时才询问。

恢复方式必须能处理变更后的状态：回滚代码、回退配置、向前修复、恢复备份有不同条件和数据后果。数据已迁移或外部副作用已发生时，不把重新部署旧版本当成通用撤销。

## 结束与交接

发布任务报告目标环境、实际制品、健康信号和未完成步骤；准备完成不能称为发布成功。事故任务区分影响已缓解、服务已恢复、原因已证实、预防项已落实。

长期指标或真实用户样本尚未积累时，交付观察口径和后续行动条件，不无限等待、不编造结果。退役任务只有依赖与数据处理等授权范围的必要工作完成才称为退役完成；不能用“暂无流量”单独证明无人依赖。

主要来源为 Humble/Farley、Forsgren/Humble/Kim、Google SRE 与相关工程综合，详见 [来源映射](../software-delivery/references/sources.md)。
