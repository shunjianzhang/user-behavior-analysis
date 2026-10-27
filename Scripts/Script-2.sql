USE user_behavior;
--各品类热度TOP10
SELECT category_id,count(*) AS cnt
FROM user_behavior
GROUP BY category_id
ORDER BY cnt DESC 
LIMIT 10;

--各行为占比（pv浏览、buy购买、cart加购、fav收藏）
SELECT
behavior_type,
CONCAT(ROUND((count(*)/(SELECT count(*) FROM user_behavior)*100),2),'%') AS cnt_percent
FROM user_behavior
GROUP BY behavior_type;

--按天看行为量（时间戳转日期）
SELECT date(FROM_UNIXTIME(ts)) AS d,count(*) AS cnt
FROM user_behavior
GROUP BY d
ORDER BY d;