---
name: refactor
description: Use when 代码结构调整可能改变行为、时序或输出（性能优化、重写、模块拆分、同步改异步、数据模型迁移）。
---

# 重构

## 概述
先定义行为边界，再在测试保护下重构。时序/并发变化也算行为变化。

## 必需子技能
- **REQUIRED SUB-SKILL:** superpowers:verification-before-completion

## 核心流程
1. 定义意图 + 行为边界
2. 建立基线（测试 + 关键指标）
3. 小步实现
4. 验证行为与性能
5. 记录范围 + 回滚点

## 行为边界清单
- 公共 API 与返回结构
- 数据 schema 与迁移兼容性
- 输出顺序与格式
- 错误类型、消息与状态码
- 时序、并发与副作用
- 资源占用（CPU、内存、I/O）

## 快速参考
| 步骤 | 输出 |
| --- | --- |
| 边界 | 允许的行为变化清单 |
| 基线 | 证明现状的测试 + 指标 |
| 变更 | 小而可审的重构提交 |
| 验证 | 回归测试 + 性能检查 |
| 记录 | 变更记录 + 回滚计划 |

## 示例
```ts
type Api = {
  fetchUser(): Promise<{ id: string }>;
  fetchPosts(): Promise<string[]>;
};

// Boundary: output contract and errors stay the same; timing may change.
test('loadUserProfile keeps output contract', async () => {
  const api: Api = {
    fetchUser: async () => ({ id: 'u1' }),
    fetchPosts: async () => ['p1', 'p2'],
  };

  await expect(loadUserProfile(api)).resolves.toEqual({
    userId: 'u1',
    postCount: 2,
  });
});

export async function loadUserProfile(api: Api) {
  const [user, posts] = await Promise.all([
    api.fetchUser(),
    api.fetchPosts(),
  ]);

  return { userId: user.id, postCount: posts.length };
}
```

## 常见错误
- 以“只是重构”为由跳过基线测试
- 顺手扩大范围
- 用性能宣称替代测试
- 改了行为却未记录边界
- 高风险变更无回滚计划

## 借口 vs 事实
| 借口 | 事实 |
| --- | --- |
| “重构不改行为” | 时序与副作用会改变行为，应定义边界。 |
| “手测够了” | 手测不能防回归，基线测试可以。 |
| “有 feature flag 就不必测” | flag 只降风险，不是验证。 |
| “测试可以后补” | 重构后的测试不能证明安全性。 |
| “来不及回滚” | 沉没成本不是质量策略。 |

## 红旗 - 立刻停止
- 没有明确的行为边界清单
- 基线测试缺失或失败
- “测试后补”
- “只是清理而已”
- 跨模块大范围变更无范围控制
