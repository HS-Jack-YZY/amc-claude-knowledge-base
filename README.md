# AMC Knowledge Base for Claude Code

一个为 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 设计的 Amazon Marketing Cloud (AMC) 综合知识库。安装后，Claude 可以直接参考真实的表结构、字段定义、SQL 语法规则和聚合阈值规则来编写准确的 AMC SQL 查询。

[English](#english)

---

## 项目简介

Amazon Marketing Cloud (AMC) 是亚马逊广告的数据分析云平台。本知识库为 Claude Code 提供完整的 AMC 参考资料，包括：

- 18 张 AMC 数据表的完整结构定义
- AMC 平台概念文档（什么是 AMC、API 使用、工作流管理等）
- SQL 语法参考（函数、表达式、限制等）
- 可直接使用的 SQL 查询模板
- `/amc` 和 `/amc-info` 两个交互式 slash command

## 包含内容

### 18 张 AMC 表结构

| 分类 | 表 |
|------|-----|
| **DSP 流量** | `dsp_impressions`, `dsp_clicks`, `dsp_views`, `dsp_impressions_by_segments`, `dsp_video_events_feed` |
| **转化** | `conversions`, `conversions_with_relevance`, `amazon_attributed_events_by_conversion_time` |
| **赞助广告** | `sponsored_ads_traffic` |
| **Amazon Live** | `amazon_live_traffic` |
| **付费功能** | `conversions_all`, `audience_segment_membership`, `amazon_your_garage`, `brand_store_insights`, `amazon_retail_purchases`, `prime_video_channel_insights`, `experian_vehicle_purchases`, `cpg_insights_stream` |

### AMC 概念文档（5 篇）

| 文档 | 说明 |
|------|------|
| [Overview & Availability](knowledge_base/concepts/overview.md) | AMC 是什么、优势、关键功能、支持区域 |
| [How AMC Works](knowledge_base/concepts/how_it_works.md) | 访问方式、账户/实例、数据、查询、隐私 |
| [Aggregation Threshold Guide](knowledge_base/concepts/aggregation_threshold.md) | 聚合阈值级别、规则、实际示例 |
| [API Guide](knowledge_base/concepts/api_guide.md) | 认证、Base URL、Header、Marketplace ID、首次 API 调用、S3 设置 |
| [Workflow Management](knowledge_base/concepts/workflow_management.md) | 创建/执行/调度工作流、自定义参数、获取结果 |

### SQL 参考文档（5 篇）

| 文档 | 说明 |
|------|------|
| [SQL Overview](knowledge_base/sql_reference/overview.md) | 数据类型、运算符、语法 |
| [SQL Basics](knowledge_base/sql_reference/basics.md) | SELECT, JOIN, WHERE, GROUP BY, HAVING, CTE, LIMIT |
| [Functions](knowledge_base/sql_reference/functions.md) | 字符串、数学、聚合、日期时间、条件、数组、窗口、哈希、JSON、统计函数 |
| [Expressions](knowledge_base/sql_reference/expressions.md) | CONTAINED_IN, BUILT_IN_PARAMETER, CUSTOM_PARAMETER, UUID |
| [Limitations](knowledge_base/sql_reference/limitations.md) | 不支持的特性、变通方法、强制要求 |

### SQL 查询模板（6 个）

| 文件 | 描述 | 数据源 |
|------|------|--------|
| [dsp_roas_by_region.sql](queries/dsp_roas_by_region.sql) | 按美国州/地区查询 DSP 广告的销售额、花费和 ROAS | `dsp_impressions` + `amazon_attributed_events_by_conversion_time` |
| [dsp_join_conversions.sql](queries/dsp_join_conversions.sql) | DSP 曝光与转化关联，按 campaign 汇总曝光数、用户数、转化数、销售额 | `dsp_impressions` + `conversions` |
| [sponsored_ads_daily_performance.sql](queries/sponsored_ads_daily_performance.sql) | 站内广告每日综合表现：流量 + 转化，按日期/广告类型/campaign 汇总 | `sponsored_ads_traffic` + `amazon_attributed_events_by_traffic_time` + `amazon_attributed_events_by_conversion_time` |
| [sponsored_ads_traffic_raw.sql](queries/sponsored_ads_traffic_raw.sql) | PPC 流量全字段探索：最细粒度的曝光/点击/花费/视频数据 | `sponsored_ads_traffic` |
| [sponsored_ads_conversions_raw.sql](queries/sponsored_ads_conversions_raw.sql) | PPC 转化全字段探索：购买/加购/DPV/NTB/S&S 等全部转化指标 | `amazon_attributed_events_by_conversion_time` |
| [asin_daily_performance.sql](queries/asin_daily_performance.sql) | 单 ASIN 每日站内广告综合表现：流量 + 转化，含 SP/SD/SB 分归因逻辑 | `sponsored_ads_traffic` + `amazon_attributed_events_by_traffic_time` + `amazon_attributed_events_by_conversion_time` |

### 每张表结构包含

- 完整字段列表及数据类型
- 字段描述
- 聚合阈值级别（NONE / LOW / MEDIUM / HIGH / VERY_HIGH / INTERNAL）
- Analytics 和 Audience 表名变体

## 安装方式

1. 复制 `knowledge_base/` 目录到你的项目根目录
2. 复制 `.claude/commands/amc.md` 和 `.claude/commands/amc-info.md` 到项目的 `.claude/commands/` 目录
3. 在项目的 `CLAUDE.md` 中添加以下 AMC 规则：

```markdown
## AMC SQL 知识库

当用户提到 AMC、Amazon Marketing Cloud 或需要编写 AMC SQL 查询时：

1. 先读取 `knowledge_base/README.md` 获取表索引和 SQL 技巧
2. 根据需求读取 `knowledge_base/` 下对应的表结构文件
3. 编写 SQL 时严格遵守聚合阈值规则（VERY_HIGH 字段不能出现在最终 SELECT）

也可以使用 `/amc` 命令直接进入 AMC SQL 助手模式。
```

## 使用方式

### 自动模式

安装后，Claude Code 会在你提到 AMC 或需要编写 AMC SQL 时自动参考知识库。这由 `CLAUDE.md` 中的规则触发。

### `/amc` 命令

交互式 AMC SQL 助手模式，直接编写 SQL 查询：

```
/amc 写一个查询 DSP 广告活动触达和频次的 SQL
```

```
/amc Show me conversions by campaign for Sponsored Products with 7-day attribution
```

### `/amc-info` 命令

AMC 知识问答助手，可回答 AMC 概念性问题：

```
/amc-info 什么是聚合阈值？
```

```
/amc-info AMC 支持哪些地区？
```

### 对话示例

> **你：** 我需要一个分析 DSP 广告活动效果的 AMC 查询，包含费用指标
>
> **Claude：** *（读取知识库，识别相关表，编写正确的 SQL 并进行费用单位转换）*

## AMC SQL 关键规则

以下规则已嵌入知识库，Claude 会自动遵守：

- **聚合阈值**：`VERY_HIGH` 字段（如 `user_id`）不能出现在最终 SELECT — 只能在 CTE 中用于聚合（如 `COUNT(DISTINCT user_id)`）
- **费用单位**：DSP 使用微分（microcents，÷100,000,000）和毫分（millicents，÷100,000）— 需检查每个字段的单位
- **时区**：AMC 默认使用 UTC；使用 `_utc` 后缀字段保持一致
- **归因窗口**：使用 `SECONDS_BETWEEN()` 实现自定义归因时间段
- **JOIN 模式**：不要用 `request_tag` 做 JOIN 键，优先使用 `UNION ALL` 合并数据源

## 数据来源

所有表结构均来自 [Amazon Ads API 官方文档 - AMC Data Sources](https://advertising.amazon.com/API/docs/en-us/guides/amazon-marketing-cloud/datasources/overview)。

## 许可证

MIT

---

<a id="english"></a>

## English

[中文说明](#amc-knowledge-base-for-claude-code)

A comprehensive Amazon Marketing Cloud (AMC) knowledge base designed for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Enables Claude to write accurate AMC SQL queries by referencing real table schemas, field definitions, SQL syntax rules, and aggregation threshold rules.

### What's Included

#### 18 AMC Table Schemas

| Category | Tables |
|----------|--------|
| **DSP Traffic** | `dsp_impressions`, `dsp_clicks`, `dsp_views`, `dsp_impressions_by_segments`, `dsp_video_events_feed` |
| **Conversions** | `conversions`, `conversions_with_relevance`, `amazon_attributed_events_by_conversion_time` |
| **Sponsored Ads** | `sponsored_ads_traffic` |
| **Amazon Live** | `amazon_live_traffic` |
| **Paid Features** | `conversions_all`, `audience_segment_membership`, `amazon_your_garage`, `brand_store_insights`, `amazon_retail_purchases`, `prime_video_channel_insights`, `experian_vehicle_purchases`, `cpg_insights_stream` |

#### AMC Concept Documents (5)

| Document | Description |
|----------|-------------|
| [Overview & Availability](knowledge_base/concepts/overview.md) | What is AMC, benefits, key features, supported regions |
| [How AMC Works](knowledge_base/concepts/how_it_works.md) | Access methods, accounts/instances, data, queries, privacy |
| [Aggregation Threshold Guide](knowledge_base/concepts/aggregation_threshold.md) | Detailed threshold levels, rules, practical examples |
| [API Guide](knowledge_base/concepts/api_guide.md) | Authentication, base URLs, headers, marketplace IDs, first API call, S3 setup |
| [Workflow Management](knowledge_base/concepts/workflow_management.md) | Create/execute/schedule workflows, custom parameters, get results |

#### SQL Reference Documents (5)

| Document | Description |
|----------|-------------|
| [SQL Overview](knowledge_base/sql_reference/overview.md) | Data types, operators, grammar |
| [SQL Basics](knowledge_base/sql_reference/basics.md) | SELECT, JOIN, WHERE, GROUP BY, HAVING, CTEs, LIMIT |
| [Functions](knowledge_base/sql_reference/functions.md) | String, math, aggregate, date/time, conditional, array, window, hash, JSON, statistical |
| [Expressions](knowledge_base/sql_reference/expressions.md) | CONTAINED_IN, BUILT_IN_PARAMETER, CUSTOM_PARAMETER, UUID |
| [Limitations](knowledge_base/sql_reference/limitations.md) | Unsupported features, workarounds, mandatory requirements |

#### SQL Query Templates (6)

| File | Description | Data Sources |
|------|-------------|--------------|
| [dsp_roas_by_region.sql](queries/dsp_roas_by_region.sql) | DSP ad sales, spend and ROAS by US state/region | `dsp_impressions` + `amazon_attributed_events_by_conversion_time` |
| [dsp_join_conversions.sql](queries/dsp_join_conversions.sql) | DSP impressions joined with conversions by campaign | `dsp_impressions` + `conversions` |
| [sponsored_ads_daily_performance.sql](queries/sponsored_ads_daily_performance.sql) | Sponsored ads daily performance: traffic + conversions by date/ad type/campaign | `sponsored_ads_traffic` + `amazon_attributed_events_by_traffic_time` + `amazon_attributed_events_by_conversion_time` |
| [sponsored_ads_traffic_raw.sql](queries/sponsored_ads_traffic_raw.sql) | PPC traffic full-field exploration: impressions/clicks/spend/video at finest granularity | `sponsored_ads_traffic` |
| [sponsored_ads_conversions_raw.sql](queries/sponsored_ads_conversions_raw.sql) | PPC conversion full-field exploration: purchases/add-to-cart/DPV/NTB/S&S | `amazon_attributed_events_by_conversion_time` |
| [asin_daily_performance.sql](queries/asin_daily_performance.sql) | Single ASIN daily ad performance with SP/SD/SB attribution logic | `sponsored_ads_traffic` + `amazon_attributed_events_by_traffic_time` + `amazon_attributed_events_by_conversion_time` |

#### Each Table Schema Includes

- Full field list with data types
- Field descriptions
- Aggregation threshold levels (NONE / LOW / MEDIUM / HIGH / VERY_HIGH / INTERNAL)
- Analytics and audience table name variants

### Installation

1. Copy the `knowledge_base/` directory to your project root
2. Copy `.claude/commands/amc.md` and `.claude/commands/amc-info.md` to your project's `.claude/commands/` directory
3. Add the following AMC rules to your project's `CLAUDE.md`:

```markdown
## AMC SQL Knowledge Base

When the user mentions AMC, Amazon Marketing Cloud, or needs to write AMC SQL queries:

1. First read `knowledge_base/README.md` for table index and SQL tips
2. Read corresponding table schema files under `knowledge_base/` as needed
3. Strictly follow aggregation threshold rules when writing SQL (VERY_HIGH fields cannot appear in final SELECT)

You can also use the `/amc` command to enter AMC SQL assistant mode.
```

### Usage

#### Automatic Mode

Once installed, Claude Code will automatically reference the AMC knowledge base when you mention AMC, Amazon Marketing Cloud, or ask to write AMC SQL queries. This is triggered by the rules in `CLAUDE.md`.

#### `/amc` Command

Interactive AMC SQL assistant mode for writing queries:

```
/amc Write a query to get DSP campaign reach and frequency
```

```
/amc Show me conversions by campaign for Sponsored Products with 7-day attribution
```

#### `/amc-info` Command

AMC knowledge Q&A assistant for conceptual questions:

```
/amc-info What is aggregation threshold?
```

```
/amc-info Which regions does AMC support?
```

### Key AMC SQL Rules

These rules are embedded in the knowledge base and enforced by Claude:

- **Aggregation thresholds**: `VERY_HIGH` fields (like `user_id`) cannot appear in final SELECT — use only in CTEs for aggregation (e.g., `COUNT(DISTINCT user_id)`)
- **Cost units**: DSP uses microcents (÷100,000,000) and millicents (÷100,000) — check each field
- **Time zones**: AMC defaults to UTC; use `_utc` suffix fields for consistency
- **Attribution windows**: Use `SECONDS_BETWEEN()` for custom attribution periods
- **JOIN patterns**: Don't use `request_tag` as JOIN key — prefer `UNION ALL` to combine data sources

### Data Source

All table schemas are sourced from the [Amazon Ads API documentation - AMC Data Sources](https://advertising.amazon.com/API/docs/en-us/guides/amazon-marketing-cloud/datasources/overview).

### License

MIT
