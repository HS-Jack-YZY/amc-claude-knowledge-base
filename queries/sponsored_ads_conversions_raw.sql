-- PPC 转化原始数据探索
-- 数据源: amazon_attributed_events_by_conversion_time
-- 说明: 以最细粒度查询站内广告的所有转化数据（购买、加购、DPV、NTB 等）
-- 过滤: 仅站内广告（排除 DSP，即 ad_product_type IS NOT NULL）
-- 排除字段: user_id / request_tag / traffic_event_id（VERY_HIGH 阈值）

SELECT
  -- ========== 时间维度 ==========
  conversion_event_date,                  -- 转化发生日期
  traffic_event_date,                     -- 触发转化的流量事件日期

  -- ========== 账户 & Campaign 层级 ==========
  advertiser,
  ad_product_type,                        -- sponsored_products / sponsored_brands / sponsored_display / sponsored_television
  campaign,
  campaign_id,

  -- ========== Ad Group 层级 ==========
  ad_group,

  -- ========== 转化的 ASIN ==========
  tracked_asin,                           -- 发生转化的 ASIN（可能与 creative_asin 不同）

  -- ========== 归因类型 ==========
  conversion_event_subtype,               -- PURCHASE / ADD_TO_CART / DETAIL_PAGE_VIEW 等
  user_id_type,

  -- ========== 购买指标（总计 = promoted + brand halo） ==========
  SUM(total_purchases)                    AS total_purchases,              -- 总订单数
  SUM(purchases)                          AS purchases,                    -- promoted ASIN 订单数
  SUM(brand_halo_purchases)               AS brand_halo_purchases,         -- 品牌光环 ASIN 订单数
  SUM(total_units_sold)                   AS total_units_sold,             -- 总销量
  SUM(units_sold)                         AS units_sold,                   -- promoted ASIN 销量
  SUM(brand_halo_units_sold)              AS brand_halo_units_sold,        -- 品牌光环 ASIN 销量
  SUM(total_product_sales)                AS total_product_sales,          -- 总销售额（美元）
  SUM(product_sales)                      AS product_sales,                -- promoted ASIN 销售额
  SUM(brand_halo_product_sales)           AS brand_halo_product_sales,     -- 品牌光环 ASIN 销售额

  -- ========== 按归因类型拆分（clicks vs views） ==========
  SUM(purchases_clicks)                   AS purchases_clicks,             -- 点击归因的订单
  SUM(purchases_views)                    AS purchases_views,              -- 浏览归因的订单
  SUM(units_sold_clicks)                  AS units_sold_clicks,
  SUM(units_sold_views)                   AS units_sold_views,
  SUM(product_sales_clicks)               AS product_sales_clicks,
  SUM(product_sales_views)                AS product_sales_views,

  -- ========== 加购指标 ==========
  SUM(add_to_cart)                        AS add_to_cart,
  SUM(add_to_cart_clicks)                 AS add_to_cart_clicks,
  SUM(add_to_cart_views)                  AS add_to_cart_views,
  SUM(brand_halo_add_to_cart)             AS brand_halo_add_to_cart,

  -- ========== 详情页浏览指标 ==========
  SUM(detail_page_view)                   AS detail_page_view,
  SUM(detail_page_view_clicks)            AS detail_page_view_clicks,
  SUM(detail_page_view_views)             AS detail_page_view_views,
  SUM(brand_halo_detail_page_view)        AS brand_halo_detail_page_view,

  -- ========== New-to-Brand (NTB) 指标 ==========
  SUM(new_to_brand_purchases)             AS ntb_purchases,
  SUM(new_to_brand_purchases_clicks)      AS ntb_purchases_clicks,
  SUM(new_to_brand_purchases_views)       AS ntb_purchases_views,
  SUM(new_to_brand_units_sold)            AS ntb_units_sold,
  SUM(new_to_brand_product_sales)         AS ntb_product_sales,
  SUM(new_to_brand_product_sales_clicks)  AS ntb_product_sales_clicks,
  SUM(new_to_brand_product_sales_views)   AS ntb_product_sales_views,

  -- ========== Subscribe & Save 指标 ==========
  SUM(subscribe_and_save)                 AS subscribe_and_save,
  SUM(brand_halo_subscribe_and_save)      AS brand_halo_subscribe_and_save,
  SUM(new_to_brand_subscribe_and_save)    AS ntb_subscribe_and_save,

  -- ========== Reach ==========
  COUNT(DISTINCT user_id)                 AS unique_users

FROM amazon_attributed_events_by_conversion_time
WHERE ad_product_type IS NOT NULL          -- 排除 DSP，仅保留 Sponsored Ads
GROUP BY
  conversion_event_date, traffic_event_date,
  advertiser, ad_product_type, campaign, campaign_id,
  ad_group, tracked_asin,
  conversion_event_subtype, user_id_type
