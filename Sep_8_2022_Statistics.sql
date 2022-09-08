/*
1. 2003年 各月營收金額(包含上月業績、月成長(Format百分比))

2. 每位客戶的平均購買間隔天數


https://docs.microsoft.com/zh-tw/sql/t-sql/functions/percentile-cont-transact-sql?view=sql-server-ver16
3-1. 全體同仁的薪資中位數
3-2. 整體產品的售價 25% 中位數50% 75% 90%
3-3. 各類產品的售價 25% 中位數50% 75% 90%

4-1. 每位員工在該職位群中的薪資百分位
4-2. 每項產品在該類產品群中的價格百分位

5-1. 各類產品(列)、各年(欄) 的 銷售金額 樞紐分析
5-2. 各縣市(列)、各類產品(欄) 的 銷售數量 樞紐分析

*/

USE 中文北風

SELECT *
FROM ( SELECT 員工編號,姓名,稱呼,職稱,薪資
	   FROM 員工 ORDER BY 薪資 DESC) AS A
ORDER BY 薪資 ASC


SELECT *
FROM ( SELECT TOP(10) 員工編號,姓名,稱呼,職稱,薪資
	   FROM 員工 ORDER BY 薪資 DESC) AS A
ORDER BY 薪資 ASC

--聯集和交集  6-10
SELECT *
FROM( SELECT TOP (10) 員工編號,姓名,稱呼,職稱,薪資
	  FROM 員工 ORDER BY 薪資 DESC) AS A

EXCEPT        --INTERSECT(交集) , EXCEPT(扣除) 
SELECT *
FROM( SELECT TOP (5) 員工編號,姓名,稱呼,職稱,薪資
	  FROM 員工 ORDER BY 薪資 DESC) AS B
ORDER BY 薪資 DESC;


SELECT  A.*
FROM( SELECT TOP (10) 員工編號,姓名,稱呼,職稱,薪資
	  FROM 員工 ORDER BY 薪資 DESC) AS A
	LEFT JOIN
 (SELECT TOP (5) 員工編號,姓名,稱呼,職稱,薪資
	  FROM 員工 ORDER BY 薪資 DESC) AS B 
  ON A.員工編號=B.員工編號
 WHERE B.員工編號 IS NULL;

 --0.420
 SELECT TOP(5) 員工編號,姓名,稱呼,職稱,薪資
 FROM 員工
 WHERE 員工編號 NOT IN (SELECT TOP(5) 員工編號 FROM 員工 ORDER BY 薪資 DESC)
 ORDER BY 薪資 DESC;

 SELECT *
 FROM (SELECT 員工編號,姓名,稱呼,職稱,薪資,
		(SELECT COUNT(*) FROM 員工 AS B WHERE B.薪資>A.薪資) AS 排名 FROM 員工 AS A) AS C
WHERE 排名>=25 AND 排名<=29
ORDER BY 薪資 DESC;

--SQL 2005
--視窗型函數
SELECT 員工編號,姓名,稱呼,職稱,薪資
	,ROW_NUMBER() OVER (ORDER BY 薪資 DESC) AS 列號
FROM 員工 AS A

SELECT * 
FROM ( SELECT 員工編號,姓名,稱呼,職稱,薪資
	,ROW_NUMBER() OVER (ORDER BY 薪資 DESC) AS 列號
FROM 員工 AS A) AS B
WHERE 列號>=26 AND 列號<=30;


--視窗型，排序家族
--金額重複的部分會有相同的排序，但後續的資料並不會接續排序
SELECT 員工編號,姓名,稱呼,職稱,薪資
	,RANK() OVER (ORDER BY 薪資 DESC) AS 排名
FROM 員工 AS A

--不重複排序後，會接續排序
SELECT 員工編號,姓名,稱呼,職稱,薪資
	,DENSE_RANK() OVER (ORDER BY 薪資 DESC) AS 排名
FROM 員工 AS A 

--依薪資分組
SELECT 員工編號,姓名,稱呼,職稱,薪資
	,NTILE(4) OVER (ORDER BY 薪資 DESC) AS 群組
FROM 員工 AS A

--ROW_NUMBER()  從頭排到尾 PARTITION BY 群組  ORDER BY 由小到大排序
SELECT 客戶編號,訂單號碼
	,ROW_NUMBER() OVER (PARTITION BY 客戶編號 ORDER BY 訂單號碼) AS 流水號
FROM 訂貨主檔;

--SQL2012
--下移5列做排序
SELECT 員工編號,姓名,稱呼,職稱,薪資
FROM 員工
ORDER BY 薪資 DESC OFFSET 5 ROWS;

--下移5列做排序，取前5列
SELECT 員工編號,姓名,稱呼,職稱,薪資
FROM 員工
ORDER BY 薪資 DESC OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;


SELECT 員工編號,姓名,稱呼,職稱,薪資
	,LAG(薪資) OVER (ORDER BY 薪資 ASC) AS 前一位薪資
	,薪資-LAG(薪資) OVER(ORDER BY 薪資 ASC) AS 薪資差
	,LAG(薪資,2) OVER(ORDER BY 薪資 ASC) AS 前兩位薪資
	,LAG(薪資,2,0) OVER(ORDER BY 薪資 ASC) AS 前兩位薪資
FROM 員工 AS A

SELECT 員工編號,姓名,稱呼,職稱,薪資
	,LEAD(薪資) OVER (ORDER BY 薪資 ASC) AS 後一位薪資
	,薪資-LEAD(薪資) OVER(ORDER BY 薪資 ASC) AS 薪資差
	,LEAD(薪資,2) OVER(ORDER BY 薪資 ASC) AS 後兩位薪資
	,LEAD(薪資,2,0) OVER(ORDER BY 薪資 ASC) AS 後兩位薪資
FROM 員工 AS A

--樞紐資料呈現
SELECT 稱呼,職稱,COUNT(*) 人數
FROM 員工
GROUP BY 稱呼,職稱;
--- ↓↓↓↓↓↓
SELECT [職稱],ISNULL([小姐],0) AS [小姐],[先生]
FROM (SELECT 稱呼,職稱,COUNT(*) 人數
FROM 員工
GROUP BY 稱呼,職稱) AS A
PIVOT (SUM(人數) FOR 稱呼 IN ([小姐],[先生])) AS P;
