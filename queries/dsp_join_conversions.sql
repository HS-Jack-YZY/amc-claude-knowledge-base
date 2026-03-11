-- DSP Impressions JOIN Conversions
-- 将 DSP 曝光数据与转化数据通过 user_id 关联，按 campaign 维度汇总关键指标
-- 注意：user_id 为 VERY_HIGH 阈值字段，仅在 CTE 内部使用，不出现在最终输出中

WITH dsp_with_conversions AS (
  SELECT
    di.campaign,
    di.user_id,
    di.impressions,
    c.conversions,
    c.total_product_sales
  FROM dsp_impressions di
  JOIN conversions c
    ON di.user_id = c.user_id
)
SELECT
  campaign,
  SUM(impressions) AS total_impressions,
  COUNT(DISTINCT user_id) AS unique_users,
  SUM(conversions) AS total_conversions,
  SUM(total_product_sales) AS total_sales
FROM dsp_with_conversions
GROUP BY campaign
