# AMC Knowledge Base for Claude Code

A comprehensive Amazon Marketing Cloud (AMC) knowledge base designed for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Enables Claude to write accurate AMC SQL queries by referencing real table schemas, field definitions, and aggregation threshold rules.

[中文说明](#中文说明)

---

## What's Included

### 18 AMC Table Schemas

| Category | Tables |
|----------|--------|
| **DSP Traffic** | `dsp_impressions`, `dsp_clicks`, `dsp_views`, `dsp_impressions_by_segments`, `dsp_video_events_feed` |
| **Conversions** | `conversions`, `conversions_with_relevance`, `amazon_attributed_events_by_conversion_time` |
| **Sponsored Ads** | `sponsored_ads_traffic` |
| **Amazon Live** | `amazon_live_traffic` |
| **Paid Features** | `conversions_all`, `audience_segment_membership`, `amazon_your_garage`, `brand_store_insights`, `amazon_retail_purchases`, `prime_video_channel_insights`, `experian_vehicle_purchases`, `cpg_insights_stream` |

### Each Table Schema Includes

- Full field list with data types
- Field descriptions
- Aggregation threshold levels (NONE / LOW / MEDIUM / HIGH / VERY_HIGH / INTERNAL)
- Analytics and audience table name variants

### Additional Resources

- SQL reference tips (time zones, attribution windows, cost unit conversions)
- Example SQL queries (Sponsored Products conversions, DSP reach & frequency, cost analysis)
- `/amc` slash command for interactive AMC SQL assistant mode

## Installation

### Quick Install

```bash
git clone https://github.com/HS-Jack-YZY/amc-claude-knowledge-base.git
cd amc-claude-knowledge-base
./install.sh /path/to/your/project
```

### Manual Install

1. Copy the `knowledge_base/` directory to your project root
2. Copy `commands/amc.md` to `.claude/commands/amc.md` in your project
3. Append the contents of `CLAUDE.md.template` to your project's `CLAUDE.md`

## Usage

### Automatic Mode

Once installed, Claude Code will automatically reference the AMC knowledge base when you mention AMC, Amazon Marketing Cloud, or ask to write AMC SQL queries. This is triggered by the rules in `CLAUDE.md`.

### `/amc` Command

Use the slash command for explicit AMC SQL assistant mode:

```
/amc Write a query to get DSP campaign reach and frequency
```

```
/amc Show me conversions by campaign for Sponsored Products with 7-day attribution
```

### Example Conversation

> **You:** I need an AMC query to analyze DSP campaign performance with cost metrics
>
> **Claude:** *(reads the knowledge base, identifies relevant tables, writes correct SQL with proper cost unit conversion)*

## Key AMC SQL Rules

These rules are embedded in the knowledge base and enforced by Claude:

- **Aggregation thresholds**: `VERY_HIGH` fields (like `user_id`) cannot appear in final SELECT — use only in CTEs for aggregation (e.g., `COUNT(DISTINCT user_id)`)
- **Cost units**: DSP uses microcents (÷100,000,000) and millicents (÷100,000) — check each field
- **Time zones**: AMC defaults to UTC; use `_utc` suffix fields for consistency
- **Attribution windows**: Use `SECONDS_BETWEEN()` for custom attribution periods
- **JOIN patterns**: Prefer `UNION ALL` over JOIN with `request_tag`

## Data Source

All table schemas are sourced from the [Amazon Ads API documentation - AMC Data Sources](https://advertising.amazon.com/API/docs/en-us/guides/amazon-marketing-cloud/datasources/overview).

## License

MIT

---

## 中文说明

### 项目简介

这是一个为 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 设计的 Amazon Marketing Cloud (AMC) 知识库。安装后，Claude 可以直接参考真实的表结构、字段定义和聚合阈值规则来编写准确的 AMC SQL 查询。

### 包含内容

- **18 张 AMC 表结构**：涵盖 DSP 流量、转化、赞助广告、Amazon Live 和付费功能
- **SQL 参考技巧**：时区、归因窗口、费用单位转换
- **示例 SQL 查询**：开箱即用的查询模板
- **`/amc` 命令**：交互式 AMC SQL 助手模式

### 安装方式

```bash
git clone https://github.com/HS-Jack-YZY/amc-claude-knowledge-base.git
cd amc-claude-knowledge-base
./install.sh /path/to/your/project
```

或手动安装：
1. 复制 `knowledge_base/` 目录到项目根目录
2. 复制 `commands/amc.md` 到项目的 `.claude/commands/amc.md`
3. 将 `CLAUDE.md.template` 内容追加到项目的 `CLAUDE.md`

### 使用方式

安装后，Claude Code 会在你提到 AMC 或需要编写 AMC SQL 时自动参考知识库。也可以使用 `/amc` 命令进入专门的 AMC SQL 助手模式：

```
/amc 写一个查询 DSP 广告活动触达和频次的 SQL
```

### 数据来源

所有表结构均来自 [Amazon Ads API 官方文档](https://advertising.amazon.com/API/docs/en-us/guides/amazon-marketing-cloud/datasources/overview)。
