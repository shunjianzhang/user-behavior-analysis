USE user_behavior;
--改善分层方法：利用NTILE 窗口函数分层
WITH buy_base AS(
		SELECT user_id,item_id,ts 
		FROM user_behavior
		WHERE behavior_type='buy'
),
	rfm AS (
		SELECT user_id,
		 	  DATEDIFF(FROM_UNIXTIME((SELECT max(ts) FROM buy_base)),
		   			   FROM_UNIXTIME(max(ts))) AS recency_days,
		  	  count(*) AS frequency,
		      count(DISTINCT item_id) AS monetary
		FROM buy_base 
		GROUP BY user_id 
	),
	rfm_scored AS (
		SELECT user_id,recency_days,frequency,monetary,
			NTILE(4) OVER (ORDER BY recency_days DESC ) AS r_score,
			NTILE(4) OVER (ORDER BY frequency ASC ) AS f_score,
			NTILE(4) OVER (ORDER BY monetary ASC ) AS m_score
		FROM rfm
	)
	SELECT user_id,r_score,f_score,m_score,
	CASE 
		WHEN r_score>=3 AND f_score>=3 AND m_score>=3 THEN '重要价值用户'
		WHEN r_score>=3 AND f_score< 3 AND m_score>=3 THEN '重要发展用户'
		WHEN r_score< 3 AND f_score>=3 AND m_score>=3 THEN '重要保持用户'
		WHEN r_score< 3 AND f_score< 3 AND m_score>=3 THEN '重要挽留用户'
		WHEN r_score>=3 AND f_score>=3 AND m_score< 3 THEN '一般价值用户'
		WHEN r_score>=3 AND f_score< 3 AND m_score< 3 THEN '一般发展用户'
		WHEN r_score< 3 AND f_score>=3 AND m_score< 3 THEN '一般保持用户'
		ELSE '一般挽留用户'
	END AS user_type
	FROM rfm_scored
	ORDER BY r_score DESC ,f_score DESC;

--看各类用户占比
WITH buy_base AS(
		SELECT user_id,item_id,ts 
		FROM user_behavior
		WHERE behavior_type='buy'
),
	rfm AS (
		SELECT user_id,
		 	  DATEDIFF(FROM_UNIXTIME((SELECT max(ts) FROM buy_base)),
		   			   FROM_UNIXTIME(max(ts))) AS recency_days,
		  	  count(*) AS frequency,
		      count(DISTINCT item_id) AS monetary
		FROM buy_base 
		GROUP BY user_id 
	),
	rfm_scored AS (
		SELECT user_id,recency_days,frequency,monetary,
			NTILE(4) OVER (ORDER BY recency_days DESC ) AS r_score,
			NTILE(4) OVER (ORDER BY frequency ASC ) AS f_score,
			NTILE(4) OVER (ORDER BY monetary ASC ) AS m_score
		FROM rfm
	)
	SELECT 
	CASE 
		WHEN r_score>=3 AND f_score>=3 AND m_score>=3 THEN '重要价值用户'
		WHEN r_score>=3 AND f_score< 3 AND m_score>=3 THEN '重要发展用户'
		WHEN r_score< 3 AND f_score>=3 AND m_score>=3 THEN '重要保持用户'
		WHEN r_score< 3 AND f_score< 3 AND m_score>=3 THEN '重要挽留用户'
		WHEN r_score>=3 AND f_score>=3 AND m_score< 3 THEN '一般价值用户'
		WHEN r_score>=3 AND f_score< 3 AND m_score< 3 THEN '一般发展用户'
		WHEN r_score< 3 AND f_score>=3 AND m_score< 3 THEN '一般保持用户'
		ELSE '一般挽留用户'
	END AS user_type,
	COUNT(*) AS cnt
	FROM rfm_scored
	GROUP BY user_type
	ORDER BY cnt DESC ;