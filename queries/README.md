# AMC SQL Queries

已编写的 AMC SQL 查询集合。

## 查询列表

| 文件 | 描述 | 数据源 |
|------|------|--------|
| [dsp_roas_by_region.sql](dsp_roas_by_region.sql) | 按美国州/地区查询 DSP 广告的销售额、花费和 ROAS | `dsp_impressions` + `amazon_attributed_events_by_conversion_time` |

## 注意事项

- 所有查询遵循 AMC SQL 限制（无 ORDER BY、无 SELECT *、聚合阈值规则）
- 地理维度（州/地区）仅适用于 DSP 广告，Sponsored Ads 无地理数据
- 花费单位：`dsp_impressions.total_cost` 为 millicents，需除以 100,000 转换为美元
- 销售单位：`total_product_sales` 已是美元
