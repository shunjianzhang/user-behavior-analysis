USE user_behavior;
--每个用户最近一次购买时间(RFM的R)
SELECT USER_id,from_unixtime(max(ts)) AS last_buy_time
FROM user_behavior
WHERE behavior_type='buy'
GROUP BY user_id;

--每个用户的购买次数(RFM的F)
SELECT user_id,count(*) AS buy_freq
FROM user_behavior
WHERE behavior_type='buy'
GROUP BY user_id 
ORDER BY buy_freq DESC
LIMIT 20;

--数据集中缺少每次购买的金额(RFM的M)，跳过，后续用“购买的不同商品数”代替
--计算显示转化率：每个品类的 购买/浏览 比
SELECT category_id,
       SUM(CASE WHEN behavior_type='buy' THEN 1 ELSE 0 END ) * 1.0 
       / NULLIF(SUM(CASE WHEN behavior_type='pv' THEN 1 ELSE 0 END ),0)
	   AS buy_rate
FROM user_behavior
GROUP BY category_id
ORDER BY buy_rate DESC;

--购买转化率
SELECT 
    SUM(IF(behavior_type='buy',1,0)) AS buy_cnt,
    SUM(IF(behavior_type='pv',1,0)) AS pv_cnt,
    ROUND(SUM(IF(behavior_type='buy',1,0))*100 / SUM(IF(behavior_type='pv',1,0)),2) AS buy_pv_rate
FROM user_behavior;
