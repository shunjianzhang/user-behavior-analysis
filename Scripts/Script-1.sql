SHOW DATABASES;
USE user_behavior;
SHOW tables;

--去重用户数、商品数
SELECT COUNT(*) AS total_rows,
         COUNT(DISTINCT user_id) AS users,
         COUNT(DISTINCT item_id) AS items
  FROM user_behavior;

SELECT count(*) FROM user_behavior;
SELECT * FROM user_behavior LIMIT 5;
	




