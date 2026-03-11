-- PPC 流量原始数据探索
-- 数据源: sponsored_ads_traffic
-- 说明: 以最细粒度查询站内广告的所有流量数据（曝光、点击、花费、视频指标）
-- 维度: 日期 × 广告类型 × Campaign × Ad Group × Creative × ASIN × 搜索词 × 关键词 × 匹配类型 × 广告位
-- 排除字段: user_id / event_id / ip_address（VERY_HIGH 阈值，不能出现在最终 SELECT）

SELECT
  -- ========== 时间维度 ==========
  event_date,
  event_hour,

  -- ========== 账户 & Campaign 层级 ==========
  advertiser,
  entity_id,
  marketplace_name,
  currency_iso_code,
  portfolio_id,
  portfolio_name,
  ad_product_type,                -- sponsored_products / sponsored_brands / sponsored_display / sponsored_television
  campaign,
  campaign_id,
  campaign_id_string,
  campaign_budget_type,           -- DAILY_BUDGET / LIFETIME_BUDGET
  campaign_start_date,
  campaign_end_date,

  -- ========== Ad Group 层级 ==========
  ad_group,
  ad_group_type,
  ad_group_status,                -- ENABLED / PAUSED / ARCHIVED

  -- ========== Creative / ASIN 层级 ==========
  creative,
  creative_type,                  -- static_image / video / third_party_creative
  creative_asin,                  -- 广告中展示的 ASIN（仅 SP/SD 部分事件有值）

  -- ========== 搜索词 & 关键词 ==========
  customer_search_term,           -- 用户实际搜索的词
  targeting,                      -- 广告主设置的投放关键词
  match_type,                     -- BROAD / PHRASE / EXACT / NULL

  -- ========== 广告展示位置 & 设备 ==========
  placement_type,                 -- Top of Search on-Amazon / Detail Page on-Amazon / Homepage on-Amazon / Off Amazon
  operating_system,               -- iOS / Android / Windows / macOS
  is_amazon_business,             -- 是否在 Amazon Business 站点

  -- ========== 用户 ID 类型（非 user_id 本身）==========
  user_id_type,                   -- adUserId / sisDeviceId / adBrowserId / NULL

  -- ========== 流量指标（聚合） ==========
  SUM(impressions)                        AS impressions,
  SUM(clicks)                             AS clicks,
  SUM(spend) / 100000000.0               AS spend,                        -- microcents → dollars
  SUM(viewable_impressions)               AS viewable_impressions,
  SUM(unmeasurable_viewable_impressions)  AS unmeasurable_viewable_impressions,

  -- ========== 视频指标（聚合） ==========
  SUM(five_sec_views)                     AS video_5s_views,
  SUM(video_first_quartile_views)         AS video_25pct_views,
  SUM(video_midpoint_views)               AS video_50pct_views,
  SUM(video_third_quartile_views)         AS video_75pct_views,
  SUM(video_complete_views)               AS video_100pct_views,
  SUM(video_unmutes)                      AS video_unmutes,

  -- ========== Reach（需要在 CTE 中聚合 VERY_HIGH 字段） ==========
  COUNT(DISTINCT user_id)                 AS unique_users

FROM sponsored_ads_traffic
GROUP BY
  event_date, event_hour,
  advertiser, entity_id, marketplace_name, currency_iso_code,
  portfolio_id, portfolio_name,
  ad_product_type, campaign, campaign_id, campaign_id_string,
  campaign_budget_type, campaign_start_date, campaign_end_date,
  ad_group, ad_group_type, ad_group_status,
  creative, creative_type, creative_asin,
  customer_search_term, targeting, match_type,
  placement_type, operating_system, is_amazon_business,
  user_id_type
