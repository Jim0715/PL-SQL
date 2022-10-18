/* Query Store (Azure SQL、SQL2016地端企業版、SQL2017後，全版本皆有此功能)
將此資料庫所發生的所有「執行計畫」全部儲存
*/

/*  設定
ALTER DATABASE 中文北風 SET QUERY_STORE=ON
{
        = OFF [ ( FORCED ) ] 
    | = ON [ ( <query_store_option_list> [,...n] ) ] 
    | CLEAR [ ALL ]
}

<query_store_option_list> ::=
{
      OPERATION_MODE = { READ_WRITE | READ_ONLY }
    | CLEANUP_POLICY = ( STALE_QUERY_THRESHOLD_DAYS = number )
    | DATA_FLUSH_INTERVAL_SECONDS = number
    | MAX_STORAGE_SIZE_MB = number
    | INTERVAL_LENGTH_MINUTES = number
    | SIZE_BASED_CLEANUP_MODE = { AUTO | OFF }
    | QUERY_CAPTURE_MODE = { ALL | AUTO | CUSTOM | NONE }
    | MAX_PLANS_PER_QUERY = number
    | WAIT_STATS_CAPTURE_MODE = { ON | OFF }
    | QUERY_CAPTURE_POLICY = ( <query_capture_policy_option_list> [,...n] )
}
*/

ALTER DATABASE 中文北風 SET QUERY_STORE=ON
( OPERATION_MODE = READ_WRITE,
  CLEANUP_POLICY=(STALE_QUERY_THRESHOLD_DAYS=30),
  DATA_FLUSH_INTERVAL_SECONDS = 900,
  MAX_STORAGE_SIZE_MB = 1024,
  INTERVAL_LENGTH_MINUTES = 60,
  SIZE_BASED_CLEANUP_MODE = AUTO,
  QUERY_CAPTURE_MODE = AUTO,
  MAX_PLANS_PER_QUERY = 200  
);

/*  索引 Index 加速用戶的查詢速度
1. 貼近使用者的搜尋方式，才是良好的索引
2. 索引本身皆為排過序的，方可進行二分搜尋法
3. 樹系索引，比較適合「萬中選一」，進行少量資料的搜尋
4. 資料庫不會利用多個索引進行一次查詢，一次查詢中不會動用多個索引，所以有機會要製作「複合索引」
5. 製作索引的資料不得超過900Byte
6. 非叢集索引搜尋(Seek) > 非叢集索引掃描 > 索引交互Lookup(查找參閱) > 叢集索引掃描 = 資料表掃描(差不多一樣爛)
7. 不要在 Where 部份使用運算或函數，會導致無法二分搜尋法，只能掃描(爛透了)
8. 謹慎考量索引的製作，索引的製作及使用是要耗費成本，後續也需要付出維護的成本
9. 該張資料表的索引愈多，Select還不見得會變快，但是Insert鐵定愈慢
10. 該張資料表需要大量Insert，該資料表盡量不要做索引


「Heap」
若資料表無任何索引，則進行資料表掃描
SQLServer利用「Heap」，提升資料表掃描的速度
「Heap」= NoIndex = Table Scan

叢集索引(Clustered Index)
1. 每張Table只能一個
2. 還會造成整張Table的資料，依照排列
3. 叢集索引，你希望整張Table的資料怎麼排列才是最好的？
4. 叢集索引 不等於 PK
5. 等同 整張表

非叢集索引(NonClustered Index)
1. 藉由 Heap / 叢集索引 製作出來的
2. 如同一張資料表的小抄
3. 非叢集索引：製作索引的值 + 叢集索引的值
4. 每張Table最多可以 999 個
5. 非叢集索引製作時，考量 Where 及 Select 的欄位

非叢集索引 的 Include (SQL2005)
1. 可以 Include 用戶需要查詢的額外非索引欄位
2. 能夠讓非叢集索引 可 Cover更多的Select 查詢
3. 付出代價：(利還是大於弊)
    整體索引變大，稍微增加搜尋索引的時間(通常不會有嚴重影響)
    索引被維護的機會成本會增加(通常資料不太會變動)
    
非叢集索引 的 Filter Index (篩選，過濾索引)
1. 挑選需要的資料列來製作索引(具有針對性)
2. 優點： 索引較小，搜尋較快，較低機會維護
*/


/*  索引的好壞及使用狀況
1. 查詢存放區(Query Store)(SQL2016)
2. 遺漏索引(SQL2008)
   例：SELECT * FROM sys.dm_db_missing_index_details
3. 整台SQLServer個體的索引使用狀況
SELECT * FROM sys.dm_db_index_usage_stats
SELECT * FROM sys.databases

SELECT * FROM sys.dm_db_index_usage_stats WHERE [database_id]=5;
SELECT OBJECT_NAME([Object_id]),* FROM sys.indexes;

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


EXEC sp_helpindex '歷史交易記錄';

SELECT * FROM 歷史交易記錄 WHERE [ProductID]=880;
SELECT [ProductID],[TransactionDate] FROM 歷史交易記錄 WHERE [ProductID]=880;				--0.00575
SELECT [ProductID],[TransactionDate],[Quantity] FROM 歷史交易記錄 WHERE [ProductID]=890;		--0.649
SELECT [ProductID],[TransactionDate],[Quantity] FROM 歷史交易記錄 WHERE [ProductID]=880;		--0.795
SELECT [ProductID],[TransactionDate],[Quantity],[ActualCost] FROM 歷史交易記錄 WHERE [ProductID]=880;	--0.795



SELECT * FROM sys.dm_db_index_usage_stats
SELECT * FROM sys.databases

SELECT * FROM sys.dm_db_index_usage_stats WHERE [database_id]=5;
SELECT OBJECT_NAME([Object_id]),* FROM sys.indexes;


 --WHERE ProductID; 額外欄位 [Quantity]  [ActualCost]
CREATE NONCLUSTERED INDEX [產品號非叢集]
ON [歷史交易紀錄]([ProductID]) INCLUDE ([Quantity],[ActualCost] ) 
ON 索引群;

SELECT * FROM Production.
SELECT * from 員工;


--DROP INDEX 電話號碼非叢集 ON 員工

CREATE NONCLUSTERED INDEX 電話號碼非叢集
ON 員工(電話號碼) INCLUDE(員工編號,姓名,職稱,稱呼)
WHERE 電話號碼 IS NULL
ON 索引群;

SELECT 員工編號,姓名,電話號碼 from 員工 WHERE 電話號碼 LIKE '%3' --資料表掃描
SELECT 員工編號,姓名,電話號碼 from 員工 WHERE 電話號碼 IS NULL     --索引搜尋


--二分索引下，WHERE只能做比大小
CREATE NONCLUSTERED INDEX 業務同仁非叢集
ON 員工(電話號碼) INCLUDE(員工編號,姓名,稱呼,內部分機號碼)
WHERE 職稱 IN ('業務','業務主管','業務經理')
WITH (SORT_IN_TEMPDB=ON,ONLINE=ON) --1.來減少建立索引花費時間
ON 索引群;

SELECT * FROM 員工 WHERE 職稱='業務經理'  --資料表掃描
SELECT 員工編號,姓名,稱呼,內部分機號碼 FROM 員工 WHERE 職稱='業務經理'; --資料表掃描

