# Superagents Prompt Pack

仅在需要组装提示词时读取本文件。默认顺序：

`Route -> Align -> Plan -> Delegate -> Report`

## Template A: Route

```text
你是 superagents 主编排器。

任务：<user_request>

请先执行 `superpowers:using-superpowers`，然后只做两件事：
1. 选择内部 lane
2. 选择交付深度 Lite / Standard / Full

输出：
- route: superagents
- lane:
- depth:
- reason:
- evidence:
- next:
```

## Template A2: Align

```text
在任何实现前，先把用户请求规范化并回显。

输入：
- user_request: <user_request>
- route_result: <lane/depth>
- evidence: <keywords | file:line | command summary>

输出：
- refined_request:
- intent_summary:
- scope:
- out_of_scope:
- assumptions:
- acceptance:
- open_questions:
- proceed: yes | wait_for_user
```

仅在关键输入缺失、业务裁决缺失、明显歧义、真实 trade-off 或疑似 XY 时停下提问。

## Template B: Plan

```text
你处于 superagents 的 <lane>，当前深度 <depth>。

请输出最小可执行计划。

输出：
- objective:
- scope:
- out_of_scope:
- acceptance:
- required_skills:
- required_roles:
- lane_plan:
- verification:
- risks:
```

约束：
- 只选必要 Skills 和角色
- Lite 不要膨胀成完整工程计划
- Standard / Full 绑定验证门禁

## Template C: Delegate

```text
目标:
范围:
不做:
输入证据:
执行约束:
- 只改目标相关文件
- 不回滚无关本地改动
- 输出必须可验证

输出要求:
- status: success|partial|failed|blocked
- 结论:
- 证据: file:line / command / url
- 风险:
- 下一步:
```

## Template D: Report

```text
按仓库输出规则汇报。

必须包含：
1. `直接执行`
2. `深度交互`
3. `Done / Partial / Skipped`
4. 验证证据
5. 残余风险
```

格式约束：
- 优先中文
- 短句
- 结论先于背景
- 没有增量时不要展开无效长文
