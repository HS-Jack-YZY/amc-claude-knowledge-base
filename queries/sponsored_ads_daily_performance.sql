-- 站内广告每日综合表现
-- 数据源: sponsored_ads_traffic + amazon_attributed_events_by_conversion_time
-- 说明: 按日期和广告产品类型汇总流量（曝光、点击、花费）和转化（订单、销售额、NTB 等）
-- 注意: SP/SD 转化归因建议使用 amazon_attributed_events_by_traffic_time 表，
--       SB 使用 amazon_attributed_events_by_conversion_time 表。
--       本查询使用 UNION ALL 分别处理不同广告类型的转化归因。

WITH traffic_data AS (
  -- 流量数据：曝光、点击、花费
  SELECT
    event_date,
    ad_product_type,
    campaign,
    impressions,
    clicks,
    spend / 100000000.0 AS spend_dollars,
    viewable_impressions,
    -- 转化指标占位（流量表不含转化数据）
    0 AS total_purchases,
    0 AS purchases,
    CAST(0 AS DECIMAL(38,4)) AS total_product_sales,
    0 AS total_units_sold,
    0 AS detail_page_view,
    0 AS add_to_cart,
    0 AS new_to_brand_purchases,
    CAST(0 AS DECIMAL(38,4)) AS new_to_brand_product_sales
  FROM sponsored_ads_traffic
),

-- SP/SD 转化数据（按流量时间归因）
sp_sd_conversions AS (
  SELECT
    traffic_event_date AS event_date,
    ad_product_type,
    campaign,
    -- 流量指标占位（转化表不含曝光/点击数据）
    0 AS impressions,
    0 AS clicks,
    0.0 AS spend_dollars,
    0 AS viewable_impressions,
    -- 14 天归因窗口的转化指标
    IF(SECONDS_BETWEEN(traffic_event_dt_utc, conversion_event_dt_utc) <= 14*24*60*60, total_purchases, 0) AS total_purchases,
    IF(SECONDS_BETWEEN(traffic_event_dt_utc, conversion_event_dt_utc) <= 14*24*60*60, purchases, 0) AS purchases,
    IF(SECONDS_BETWEEN(traffic_event_dt_utc, conversion_event_dt_utc) <= 14*24*60*60, total_product_sales, CAST(0 AS DECIMAL(38,4))) AS total_product_sales,
    IF(SECONDS_BETWEEN(traffic_event_dt_utc, conversion_event_dt_utc) <= 14*24*60*60, total_units_sold, 0) AS total_units_sold,
    IF(SECONDS_BETWEEN(traffic_event_dt_utc, conversion_event_dt_utc) <= 14*24*60*60, detail_page_view, 0) AS detail_page_view,
    IF(SECONDS_BETWEEN(traffic_event_dt_utc, conversion_event_dt_utc) <= 14*24*60*60, add_to_cart, 0) AS add_to_cart,
    IF(SECONDS_BETWEEN(traffic_event_dt_utc, conversion_event_dt_utc) <= 14*24*60*60, new_to_brand_purchases, 0) AS new_to_brand_purchases,
    IF(SECONDS_BETWEEN(traffic_event_dt_utc, conversion_event_dt_utc) <= 14*24*60*60, new_to_brand_product_sales, CAST(0 AS DECIMAL(38,4))) AS new_to_brand_product_sales
  FROM amazon_attributed_events_by_traffic_time
  WHERE ad_product_type IN ('sponsored_products', 'sponsored_display')
),

-- SB 转化数据（按转化时间归因）
sb_conversions AS (
  SELECT
    conversion_event_date AS event_date,
    ad_product_type,
    campaign,
    0 AS impressions,
    0 AS clicks,
    0.0 AS spend_dollars,
    0 AS viewable_impressions,
    total_purchases,
    purchases,
    total_product_sales,
    total_units_sold,
    detail_page_view,
    add_to_cart,
    new_to_brand_purchases,
    new_to_brand_product_sales
  FROM amazon_attributed_events_by_conversion_time
  WHERE ad_product_type = 'sponsored_brands'
),

-- 合并所有数据
all_data AS (
  SELECT event_date, ad_product_type, campaign,
         impressions, clicks, spend_dollars, viewable_impressions,
         total_purchases, purchases, total_product_sales, total_units_sold,
         detail_page_view, add_to_cart, new_to_brand_purchases, new_to_brand_product_sales
  FROM traffic_data

  UNION ALL

  SELECT event_date, ad_product_type, campaign,
         impressions, clicks, spend_dollars, viewable_impressions,
         total_purchases, purchases, total_product_sales, total_units_sold,
         detail_page_view, add_to_cart, new_to_brand_purchases, new_to_brand_product_sales
  FROM sp_sd_conversions

  UNION ALL

  SELECT event_date, ad_product_type, campaign,
         impressions, clicks, spend_dollars, viewable_impressions,
         total_purchases, purchases, total_product_sales, total_units_sold,
         detail_page_view, add_to_cart, new_to_brand_purchases, new_to_brand_product_sales
  FROM sb_conversions
)

SELECT
  event_date,
  ad_product_type,
  campaign,
  -- 流量指标
  SUM(impressions)              AS impressions,
  SUM(clicks)                   AS clicks,
  SUM(spend_dollars)            AS spend,
  SUM(viewable_impressions)     AS viewable_impressions,
  -- 转化指标（14d 归因窗口）
  SUM(total_purchases)          AS total_purchases_14d,
  SUM(purchases)                AS purchases_14d,
  SUM(total_product_sales)      AS total_sales_14d,
  SUM(total_units_sold)         AS total_units_sold_14d,
  SUM(detail_page_view)         AS detail_page_views_14d,
  SUM(add_to_cart)              AS add_to_cart_14d,
  SUM(new_to_brand_purchases)   AS ntb_purchases_14d,
  SUM(new_to_brand_product_sales) AS ntb_sales_14d
FROM all_data
GROUP BY event_date, ad_product_type, campaign
