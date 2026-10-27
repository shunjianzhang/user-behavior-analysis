# 电商用户行为分析 + RFM 用户分层

基于天池「UserBehavior」淘宝用户行为数据集，完成从数据入库到用户价值分层的完整分析。

## 背景

分析淘宝用户行为（浏览 pv / 加购 cart / 收藏 fav / 购买 buy），用 RFM 模型对用户做 8 类价值分层，输出差异化运营建议。

## 技术栈

- Python（pandas + SQLAlchemy）：数据导入
- MySQL 8.0：数据存储与 SQL 分析
- SQL 窗口函数（NTILE）：RFM 分层

## 数据来源

天池「UserBehavior」数据集：https://tianchi.aliyun.com/dataset/dataDetail?dataId=649

取前 10 万条子集（原始约 1 亿条）。

## 方法

MySQL 建表 + SQL 聚合分析 + RFM 分层（NTILE 四档打分）。

## 结论

1. 行为分布：pv 占约 89.71%，buy 占约 2.10%
2. 购买转化率：2.34%
3. RFM 分层：重要价值用户占 32.34%，建议重点维护该群体；针对重要保持、一般挽留这类流失风险较高的用户推送定向优惠召回，对一般发展新用户发放新人券促进转化。

## 复现

建表 → import_data.py 导入 → 运行 SQL。
