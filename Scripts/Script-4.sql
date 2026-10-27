USE user_behavior;
--RFM分层
--平均值二分法
WITH
buy_base AS (
    SELECT user_id,item_id,ts
    FROM user_behavior
    WHERE behavior_type='buy'
),
rfm AS (
    SELECT
        user_id,
        DATEDIFF(
            FROM_UNIXTIME((SELECT MAX(ts) FROM buy_base)),
            FROM_UNIXTIME(MAX(ts))
        ) AS recency_days,
        COUNT(*) AS frequency,
        COUNT(DISTINCT item_id) AS monetary
    FROM buy_base
    GROUP BY user_id
),
rfm_avg AS (
    SELECT
        AVG(recency_days) avg_r,
        AVG(frequency) avg_f,
        AVG(monetary) avg_m
    FROM rfm
),
rfm_score AS (
    SELECT
        r.*,
        CASE WHEN r.recency_days <= a.avg_r THEN 1 ELSE 0 END AS r_high,
        CASE WHEN r.frequency >= a.avg_f THEN 1 ELSE 0 END AS f_high,
        CASE WHEN r.monetary >= a.avg_m THEN 1 ELSE 0 END AS m_high
    FROM rfm r, rfm_avg a
)
SELECT
    user_id,
    recency_days,
    frequency,
    monetary,
    CASE CONCAT(r_high,f_high,m_high)
        WHEN '111' THEN '重要价值客户'
        WHEN '101' THEN '重要发展客户'
        WHEN '011' THEN '重要保持客户'
        WHEN '001' THEN '重要挽留客户'
        WHEN '110' THEN '一般价值客户'
        WHEN '100' THEN '一般发展客户'
        WHEN '010' THEN '一般保持客户'
        ELSE '一般挽留客户'
    END AS rfm_customer_type
FROM rfm_score;
--平均值二分的缺点：受极端值影响大。购买次数较高的用户会把平均值拉高，导致「高频率」的人只剩很少，分层不均衡