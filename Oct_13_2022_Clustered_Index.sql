
/*  索引 Index 加速用戶的查詢速度
1. 貼近使用者的搜尋方式，才是良好的索引
2. 索引本身皆為排過序的，方可進行二分搜尋法
3. 樹系索引，比較適合「萬中選一」，進行少量資料的收尋
4. 資料庫不會利用多個索引來進行一次查詢，一次查詢不會動用多個索引,所以有機會要製作「複合索引」
5. 製作索引的資料不得超過900 Byte
6. 非叢集索引搜尋(Seed) > > 非叢集索引掃描 > 索引交互Lookup(查詢參閱) > 叢集索引掃描 = 資料表掃描(差不多一樣爛)
7. 不要在 WHERE 部分使用運算或函數，會導致無法二分搜尋法
8. 謹慎考量索引的製作，索引的製作及使用是要耗費成本，後續也要付出維護的成本
9. 該張資料表的索引越多，Select不見得變快，但是Insert鐵定越慢
10. 該張資料表需要大量Insert，該張表盡量不要做索引

「Heap」
若資料表無任何索引，則進行資料表掃描 (Table Scan)
SQLServer利用「Heap」，提升資料表掃描的速度
「Heap」= NoIndex = Table Scan

叢集索引(Clustered Index)
1. 每張Table只能一個
2. 還會造成整張Table的資料，依照排列
3. 叢集索引，你希望整張Table的資料怎麼排列才是最好的？
4. 叢集索引不一定等於PK

非叢集索引 (NonClutered Index)
1. 藉由Heap / 叢集索引 製作出來的
2. 每張Table 最多可以999個
3. 非叢集索引：製作索引的值+叢集索引的值
4. 非叢集索引製作時，考量Where及Select的欄位
*/



SELECT *
INTO 練習.dbo.北風產品
FROM 中文北風.dbo.產品資料;

SELECT * FROM 北風產品;

CREATE CLUSTERED INDEX 北風產品類別叢集
ON 北風產品([類別編號])
ON [索引群];

SELECT * FROM 北風產品;		--0.03

--叢集索引不一定等於PK
CREATE TABLE 練習員工
(
	員工編號 INT CONSTRAINT 練習員工表主鍵 PRIMARY KEY,
	姓名 NVARCHAR (10),
	部門編號 INT,
	薪資 INT
)

DROP TABLE 練習員工;


--建立索引
CREATE TABLE 練習員工
(
	員工號 INT NOT NULL,
	姓名 NVARCHAR (10),
	部門編號 INT,
	薪資 INT
)
GO

CREATE CLUSTERED INDEX 部門叢集 ON 練習員工(部門編號);
GO
ALTER TABLE 練習員工 ADD CONSTRAINT 練習員工號主鍵 PRIMARY KEY(員工號);
GO

SELECT * FROM 練習員工


SELECT * FROM 員工 WHERE 姓='孫' AND 名='小美';

/*複合索引  辨識度高的放前面 (A,B)
CREATE NONCLUSTERED INDEX 姓名索引(名,姓)
WHERE 姓='孫' AND 名='小美'   0
WHERE 名='小美'               0
WHERE 姓='孫'                 X
*/


SELECT *
INTO 歷史交易紀錄
FROM [AdventureWorks2012].Production.TransactionHistory;

SELECT * FROM [歷史交易紀錄]  --0.7125

CREATE CLUSTERED INDEX [日期叢集] ON [歷史交易紀錄]([TransactionDate]);

SELECT * FROM [歷史交易紀錄];--0.7954
SELECT * FROM [歷史交易紀錄] WHERE [TransactionDate]='2008-5-5';--0.00486

SELECT * FROM [歷史交易紀錄] WHERE [TransactionDate]>='2007-1-1' AND [TransactionDate]<'2008-1-1';  --0.3
SELECT * FROM [歷史交易紀錄] WHERE YEAR ([TransactionDate])=2007; --0.795

SELECT * FROM [歷史交易紀錄] WHERE [ProductID]=870;  --0.7957


CREATE NONCLUSTERED INDEX 產品號非叢集 ON [歷史交易紀錄]([ProductID]);

SELECT * FROM [歷史交易紀錄] WHERE [ProductID] = 870;  --0.795
SELECT [ProductID],[TransactionDate] FROM [歷史交易紀錄] WHERE [ProductID] = 870; --0.0017
