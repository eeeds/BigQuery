#standardSQL
WITH REPETIDO AS (SELECT
  COUNT(*) AS num_duplicate_rows,
  *
FROM
  `data-to-insights.ecommerce.all_sessions_raw`
GROUP BY
  fullVisitorId,
  channelGrouping,
  time,
  country,
  city,
  totalTransactionRevenue,
  transactions,
  timeOnSite,
  pageviews,
  sessionQualityDim,
  date,
  visitId,
  type,
  productRefundAmount,
  productQuantity,
  productPrice,
  productRevenue,
  productSKU,
  v2ProductName,
  v2ProductCategory,
  productVariant,
  currencyCode,
  itemQuantity,
  itemRevenue,
  transactionRevenue,
  transactionId,
  pageTitle,
  searchKeyword,
  pagePathLevel1,
  eCommerceAction_type,
  eCommerceAction_step,
  eCommerceAction_option
HAVING
  num_duplicate_rows > 1)

  SELECT SUM(num_duplicate_rows)
  FROM REPETIDO;