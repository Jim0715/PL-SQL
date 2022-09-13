/*ISO SQL 2003
--CTE (Common Table Expression)
  臨時性、一次性的查詢 VIEW

 1. 簡化子查詢撰寫的複雜度
 2. 可以遞迴查詢(子查詢)
 3. 增進 真正的子查詢 的查詢效能
*/

SELECT 產品編號 ,品名 ,價錢
FROM (SELECT * FROM 巨巨) AS A
--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
WITH TEMP(貨號,貨品名,售價)
AS 
(
	SELECT * FROM 巨巨
)
SELECT * FROM TEMP ORDER BY 售價 DESC;

USE 中文北風


WITH T1
AS
( SELECT TOP(10) 員工編號,姓名,稱呼,職稱,薪資
  FROM 員工 ORDER BY 薪資 DESC )
, T2
AS
( SELECT TOP(5) 員工編號,姓名,稱呼,職稱,薪資
  FROM 員工 ORDER BY 薪資 DESC )

SELECT * FROM T1 LEFT JOIN T2 ON T1.員工編號=T2.員工編號;


WITH T1
AS
( SELECT 稱呼,職稱,COUNT(*) 人數
  FROM 員工
  GROUP BY 稱呼,職稱
 )

SELECT [職稱],[小姐],[先生]
FROM T1 
PIVOT (SUM(人數) FOR 稱呼 IN([小姐],[先生])) AS P;

/* CTE 遞迴
1. 最多可遞迴32767次
2. 預設只會執行100次
3. 可利用 查詢提示 來調整遞迴次數
*/
--自己查自己
--先找出頂頭上司
WITH EE(員工號,姓名,職稱,階層)
AS 
(
	SELECT 員工編號,姓名,職稱,1 
	FROM 員工
	WHERE 主管 IS NULL
	UNION ALL
	SELECT A.員工編號,A.姓名,A.職稱,B.階層+1
	FROM 員工 AS A JOIN EE AS B ON A.主管=B.員工號
)
SELECT * FROM EE;

--OPTION (MAXRECURSION 5);  限制遞迴次數
WITH EE(員工號,姓名,職稱,階層)
AS 
(
	SELECT 員工編號,姓名,職稱,1 
	FROM 員工
	WHERE 主管 IS NULL
	UNION ALL
	SELECT A.員工編號,A.姓名,A.職稱,B.階層+1
	FROM 員工 AS A JOIN EE AS B ON A.主管=B.員工號
)
SELECT * FROM EE OPTION (MAXRECURSION 5);  --限制遞迴次數


/*HomeWork
1. CTE 員工完整領導階層 (例：(2)陳季軒→(1)張謹雯→(4)林美麗)
2.找出沒來上班的 (題目如下)
*/

/*
有一員工表.結構如下
EmployeeID Name 
------------------
1001 張三
1002 李四
1003 王五
另有一張員工出勤刷卡表
EmployeeID Date
----------------------
1001 2007/03/24
1002 2007/03/24
1003 2007/03/24
1001 2007/03/25
1002 2007/03/25
1001 2007/03/26
1003 2007/03/26

從上面可以看出..員工王五在2007/03/25沒有刷卡.李四在2007/03/26沒有刷卡.
所以我想得出如下的資訊:
EmployeeID Date
-----------------------
1003 2007/03/25
1002 2007/03/26


-----------------------------------------------------------------------
-----------------------------------------------------------------------

CREATE TABLE #員工
(
  員工編號 VARCHAR(4),
  姓名 NVARCHAR(10)
)
go
CREATE TABLE #出缺勤
(
  員工編號 VARCHAR(4),
  上班日 DATE
)
go

INSERT INTO #員工 VALUES('1001','張三')
INSERT INTO #員工 VALUES('1002','李四')
INSERT INTO #員工 VALUES('1003','王五')

INSERT INTO #出缺勤 VALUES('1001','2007/03/24')
INSERT INTO #出缺勤 VALUES('1002','2007/03/24')
INSERT INTO #出缺勤 VALUES('1003','2007/03/24')
INSERT INTO #出缺勤 VALUES('1001','2007/03/25')
INSERT INTO #出缺勤 VALUES('1002','2007/03/25')
INSERT INTO #出缺勤 VALUES('1001','2007/03/26')
INSERT INTO #出缺勤 VALUES('1003','2007/03/26')
*/