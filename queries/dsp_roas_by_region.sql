-- DSP ROAS by US State/Region
-- 按美国州/地区查询 DSP 广告的销售额、花费和 ROAS
-- 注意：地理维度仅适用于 DSP 广告，Sponsored Ads 无地理数据

WITH regional_data AS (
  -- DSP 广告花费（按展示地区）
  SELECT
    iso_state_province_code,
    0.0 AS total_product_sales,
    total_cost / 100000.0 AS ad_spend_dollars
  FROM dsp_impressions
  WHERE iso_country_code = 'US'

  UNION ALL

  -- DSP 归因销售（按展示地区）
  SELECT
    iso_state_province_code,
    total_product_sales,
    0.0 AS ad_spend_dollars
  FROM amazon_attributed_events_by_conversion_time
  WHERE ad_product_type IS NULL
    AND iso_country_code = 'US'
)
SELECT
  iso_state_province_code AS state,
  SUM(total_product_sales) AS total_sales,
  SUM(ad_spend_dollars) AS total_ad_spend,
  IF(SUM(ad_spend_dollars) > 0,
     SUM(total_product_sales) / SUM(ad_spend_dollars),
     0) AS roas
FROM regional_data
GROUP BY iso_state_province_code
