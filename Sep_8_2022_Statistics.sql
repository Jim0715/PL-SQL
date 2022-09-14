--瑼Ｚ�蝟餌絞�詨捆��
SELECT compatibility_level  
FROM sys.databases WHERE name = '銝剜��◢';  
--靽格鞈�摨怎摰寞�
ALTER DATABASE 銝剜��◢ 
SET COMPATIBILITY_LEVEL = 150;  
GO
/* HomeWork
1. 2003年 各月營收金額(包含上月業績、月成長(Format百分比))
SELECT C.閮�遢, C.璆剔蜀, C.銝�璆剔蜀,CONCAT((round(C.璆剔蜀/C.銝�璆剔蜀*100,2)),'%') AS ����
FROM
	(SELECT ROW_NUMBER() OVER (ORDER BY YEAR(A.閮�交�) ASC) AS ��, YEAR(A.閮�交�) AS 閮撟港遢, MONTH(A.閮�交�) AS 閮�遢 ,SUM(B.��) AS 璆剔蜀,LAG(SUM(B.��)) OVER (ORDER BY YEAR(A.閮�交�) ASC) AS 銝�璆剔蜀
	FROM 閮疏銝餅� AS A JOIN 
	(SELECT 閮�Ⅳ,ROUND(SUM(�桀*�賊�*(1+�)),0) AS �� FROM 閮疏�敦 GROUP BY 閮�Ⅳ) AS B
	ON A.閮�Ⅳ=B.閮�Ⅳ
	WHERE A.閮�交� BETWEEN '2002-12-01' AND '2003-12-31' 
	GROUP BY YEAR(A.閮�交�),MONTH(A.閮�交�))
	AS C
WHERE C.�� BETWEEN '2' AND '13';

2. 每位客戶的平均購買間隔天數
SELECT 摰Ｘ蝺刻�, AVG(�詨榆憭拇) AS 撟喳�鞈潸眺��憭拇
FROM
	(SELECT 摰Ｘ蝺刻�, 閮�交�, 銝活鞈潸眺, DATEDIFF(day, 銝活鞈潸眺,閮�交� )  AS �詨榆憭拇
	 FROM
		 (SELECT 摰Ｘ蝺刻�, 閮�交�,LAG(閮�交�) OVER (PARTITION BY 摰Ｘ蝺刻� ORDER BY 閮�交� ASC) AS 銝活鞈潸眺
		 FROM 閮疏銝餅�
		 GROUP BY 摰Ｘ蝺刻�  , 閮�交�) AS A) AS B
GROUP BY 摰Ｘ蝺刻� 
ORDER BY 摰Ｘ蝺刻� ASC

https://docs.microsoft.com/zh-tw/sql/t-sql/functions/percentile-cont-transact-sql?view=sql-server-ver16
3-1. 全體同仁的薪資中位數
--PERCENTILE_CONT ���仿�嗅� (鞈��葉銝�摰��府��)嚗� PERCENTILE_DISC ��敺��喳�鞈��葉�祕��
	SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY �芾�) OVER() AS MedianCont  
	,PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY �芾�) OVER() AS MedianDisc  
	FROM �∪極; 

3-2. 整體產品的售價 25% 中位數 50% 75% 90%
SELECT DISTINCT '銝凋���(�∪祕��)' AS 憿,
	 PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY �桀 ) OVER() AS [25%],
	 PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY �桀) OVER() AS [50%],
	 PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY �桀) OVER() AS [0.75%],
	 PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY �桀) OVER () AS [0.9%]
	 FROM �Ｗ�鞈�
UNION ALL
SELECT DISTINCT '銝凋���(�祕��)' AS 憿,
	 PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY �桀 ) OVER() AS [25%],
	 PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY �桀) OVER() AS [50%],
	 PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY �桀) OVER() AS [0.75%],
	 PERCENTILE_DISC(0.9) WITHIN GROUP (ORDER BY �桀) OVER () AS [0.9%]
	 FROM �Ｗ�鞈�;
	 
3-3. 各項產品的售價 25% 中位數 50% 75% 90%
SELECT DISTINCT '銝凋���(�∪祕��)' AS 憿, B.憿�迂,
	PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY A.�桀) OVER(PARTITION BY B.憿�迂) AS [25%],
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY A.�桀) OVER(PARTITION BY B.憿�迂) AS [50%],
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY A.�桀) OVER(PARTITION BY B.憿�迂) AS [75%],
	PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY A.�桀) OVER(PARTITION BY B.憿�迂) AS [90%]
FROM �Ｗ�鞈� AS A JOIN �Ｗ�憿 AS B ON A.憿蝺刻�=B.憿蝺刻�
UNION ALL
SELECT DISTINCT '銝凋���(�祕��)' AS 憿, B.憿�迂,
	PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY A.�桀) OVER(PARTITION BY B.憿�迂) AS [25%],
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY A.�桀) OVER(PARTITION BY B.憿�迂) AS [50%],
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY A.�桀) OVER(PARTITION BY B.憿�迂) AS [75%],
	PERCENTILE_DISC(0.9) WITHIN GROUP (ORDER BY A.�桀) OVER(PARTITION BY B.憿�迂) AS [90%]
FROM �Ｗ�鞈� AS A JOIN �Ｗ�憿 AS B ON A.憿蝺刻�=B.憿蝺刻�

4-1. 每位員工在該職位群中的薪資百分位
SELECT �瑞迂,�∪極蝺刻�,憪�,�芾�,CASE WHEN �瑚�蝢支葉�芾���>0 THEN ROUND(CONVERT(FLOAT,(�瑚�蝢支葉�芾���*100))/(�桀��瑚�蝢日��格-1), 2) ELSE 0 END AS �Ｗ�憿銝剔��寞�曉�雿�
FROM
	(SELECT �瑞迂,�∪極蝺刻�,憪�, �芾�,(RANK() OVER(PARTITION BY �瑞迂 ORDER BY �芾�))-1 AS �瑚�蝢支葉�芾��� ,COUNT(1) OVER(PARTITION BY �瑞迂) AS �桀��瑚�蝢日��格
	FROM �∪極 GROUP BY �瑞迂,�∪極蝺刻�,憪�,�芾�) AS A
	
4-2. 每項產品在該類產品群中的價格百分位
SELECT 憿蝺刻�,憿�迂,�Ｗ�,�桀,CASE WHEN �Ｗ�憿銝剔��寞��>0 THEN ROUND(CONVERT(FLOAT,(�Ｗ�憿銝剔��寞��*100))/(�桀�憿���-1), 2) ELSE 0 END AS �Ｗ�憿銝剔��寞�曉�雿�
FROM
	(SELECT A.憿蝺刻�,B.憿�迂,A.�Ｗ�,A.�桀,(RANK() OVER(PARTITION BY B.憿�迂 ORDER BY �桀))-1 AS �Ｗ�憿銝剔��寞�� ,COUNT(1) OVER(PARTITION BY B.憿�迂) AS �桀�憿���
	FROM �Ｗ�鞈� AS A JOIN �Ｗ�憿 AS B ON A.憿蝺刻�=B.憿蝺刻�
	) AS A
ORDER BY 憿蝺刻�

5-1. 各類產品(列)、各年(欄) 的 銷售金額 樞紐分析
SELECT *
FROM
	(SELECT 閮撟港遢,憿�迂,SUM(��) AS 憿蝮賡�桅�
	 FROM
		 (SELECT YEAR(B.閮�交�) AS 閮撟港遢,D.憿�迂,ROUND(SUM(A.�桀*A.�賊�*(1+A.�)),0) AS �� FROM 閮疏�敦 AS A
		  JOIN 閮疏銝餅� AS B ON A.閮�Ⅳ=B.閮�Ⅳ JOIN �Ｗ�鞈� AS C ON A.�Ｗ�蝺刻�=C.�Ｗ�蝺刻� JOIN �Ｗ�憿 AS D ON C.憿蝺刻�=D.憿蝺刻�
		  GROUP BY A.�Ｗ�蝺刻�,B.閮�交�,D.憿�迂) AS E
	 GROUP BY 閮撟港遢,憿�迂 ) AS F
PIVOT (
	-- 閮剖�敶蜇甈��撘�
	MAX(憿蝮賡�桅�) 
	-- 閮剖�頧蔭甈�嚗蒂��頧蔭甈�銝剝�敶蜇��隞嗅潔��箸甈�
	FOR 閮撟港遢 IN ("2002","2003","2004")
) p;

5-2. 各縣市(列)、各類產品(欄) 的 銷售數量 樞紐分析
SELECT �疏��,憌脫�,隤踹��,ISNULL(暺�,0) AS 暺�,�亦��,[蝛憿�/暻亦�],[��/摰嗥汗],ISNULL(�寡ˊ��,0) AS �寡ˊ��,瘚琿悅
FROM
	(SELECT *
	 FROM
		 (SELECT �疏��,憿�迂,SUM(��) AS 憿蝮賡�桅�
		  FROM
		 	  (SELECT B.�疏��,D.憿�迂,ROUND(SUM(A.�桀*A.�賊�*(1+A.�)),0) AS �� FROM 閮疏�敦 AS A
		 	   JOIN 閮疏銝餅� AS B ON A.閮�Ⅳ=B.閮�Ⅳ JOIN �Ｗ�鞈� AS C ON A.�Ｗ�蝺刻�=C.�Ｗ�蝺刻� JOIN �Ｗ�憿 AS D ON C.憿蝺刻�=D.憿蝺刻�
		 	   GROUP BY B.�疏��,A.�Ｗ�蝺刻�,B.閮�交�,D.憿�迂) AS E
		  GROUP BY �疏��,憿�迂 ) AS F
	 PIVOT (
		 -- 閮剖�敶蜇甈��撘�
		 MAX(憿蝮賡�桅�) 
		 -- 閮剖�頧蔭甈�嚗蒂��頧蔭甈�銝剝�敶蜇��隞嗅潔��箸甈�
		 FOR 憿�迂 IN (憌脫�,隤踹��,暺�,�亦��,[蝛憿�/暻亦�],[��/摰嗥汗],�寡ˊ��,瘚琿悅)
	 ) p) AS G
*/

/* 子查詢 (SubQuery) PART2
	
	1. 原本需要多次查詢才可完成，希望一次搞定
	2. 撰寫上較為直覺
	3. 單一子查詢，最多32層
	4. 獨立子查詢 vs. 關聯子查詢

*/

/* 子查詢的使用位置
	
	1. 通長大部分的子查詢，可以用其他方式解決，避免子查詢
	2. WHERE: 通常效率極差
		2.1. 直接取單一值: 可使用變數來改寫
		2.2. 比對清單: 有時較為直覺，但是通常可以用JOIN 來取代，效率較高
		2.3. 測試存在: 通常效率奇佳，有奇效
	3. FROM: 使用平率非常高，對整體查詢效率幾乎不受影響
	4. COLUMN: 撰寫上較為技巧，時間效能依照查詢出的資料筆數而定

*/


USE 中文北風

SELECT TOP(10) 員工編號, 姓名, 稱呼, 職稱, 薪資 
FROM  員工 
ORDER BY 薪資 DESC;

SELECT TOP(5) 員工編號, 姓名, 稱呼, 職稱, 薪資 
FROM  員工 
ORDER BY 薪資 DESC;

---- 找薪資第 6-10 的員工
--- 子查詢不可使用 ORDER BY  0.0502
SELECT * 
FROM  (SELECT TOP(10) 員工編號, 姓名, 稱呼, 職稱, 薪資 
	FROM  員工 ORDER BY 薪資 DESC ) AS A
EXCEPT       ---INTERSECT | EXCEPT
SELECT *
FROM (SELECT TOP(5) 員工編號, 姓名, 稱呼, 職稱, 薪資 
	FROM  員工 ORDER BY 薪資 DESC ) AS B
ORDER BY 薪資 DESC; 

--- 進階版 0.0426
SELECT A.* 
FROM (SELECT TOP(10) 員工編號, 姓名, 稱呼, 職稱, 薪資 
	FROM  員工 ORDER BY 薪資 DESC ) AS A
	LEFT JOIN
	(SELECT TOP(5) 員工編號, 姓名, 稱呼, 職稱, 薪資 
		FROM  員工 ORDER BY 薪資 DESC ) AS B
	ON A.員工編號=B.員工編號
WHERE B.員工編號 IS NULL

--- 取前五但是不是最前面的五個 0.0420
SELECT TOP(5) 員工編號, 姓名, 稱呼, 職稱, 薪資 
FROM  員工 
WHERE 員工編號 NOT IN(SELECT TOP(5) 員工編號 FROM  員工 ORDER BY 薪資 DESC )
ORDER BY 薪資 DESC;

--- 0.0242 超進階
SELECT *
FROM (
	SELECT 員工編號, 姓名, 稱呼, 職稱, 薪資
		,(SELECT COUNT(*) FROM 員工 AS B WHERE B.薪資>A.薪資) AS 排名
	FROM 員工 AS A
	) AS C
WHERE 排名>=6 AND 排名<=15
ORDER BY 薪資 DESC


--- 視窗型函數(另類子查詢)
SELECT 員工編號, 姓名, 稱呼, 職稱, 薪資
	, ROW_NUMBER() OVER(ORDER BY 薪資 DESC) AS 列號	
FROM 員工 AS A

--0.157
SELECT *
FROM ( SELECT 員工編號,姓名,稱呼,職稱,薪資
			,ROW_NUMBER() OVER(ORDER BY 薪資 DESC) AS 列號
		FROM 員工 AS A ) AS B
WHERE 列號>=26 AND 列號<=30;


--視窗型函數 排序家族
SELECT 員工編號,姓名,稱呼,職稱,薪資
	,ROW_NUMBER() OVER(ORDER BY 薪資 DESC) AS 列號
FROM 員工 AS A

SELECT 員工編號,姓名,稱呼,職稱,薪資
	,RANK() OVER(ORDER BY 薪資 DESC) AS 排名
FROM 員工 AS A

SELECT 員工編號,姓名,稱呼,職稱,薪資
	,DENSE_RANK() OVER(ORDER BY 薪資 DESC) AS 排名
FROM 員工 AS A


---- 適合查詢 百分比的資料
SELECT 員工編號,姓名,稱呼,職稱,薪資
	,NTILE(4) OVER(ORDER BY 薪資 DESC) AS 群組
FROM 員工 AS A




SELECT 客戶編號, 訂單號碼 FROM 訂貨主檔;
SELECT 客戶編號, 訂單號碼 FROM 訂貨主檔 ORDER BY 客戶編號;

SELECT 客戶編號, 訂單號碼
		, ROW_NUMBER() OVER(PARTITION BY 客戶編號 ORDER BY 客戶編號 ) AS 流水號
FROM 訂貨主檔;


--MySQL
--SELECT 員工編號,姓名,稱呼,職稱,薪資 FROM 員工 ORDER BY 薪資 DESC LIMITS 10,10;

--- SQL2012 略過前五筆
SELECT 員工編號,姓名,稱呼,職稱,薪資
FROM 員工
ORDER BY 薪資 DESC OFFSET 5 ROWS;

---  略過前五筆取接下來的五筆
SELECT 員工編號,姓名,稱呼,職稱,薪資
FROM 員工
ORDER BY 薪資 DESC OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;


SELECT 員工編號,姓名,稱呼,職稱,薪資
		, LAG(薪資) OVER(ORDER BY 薪資 ASC ) AS 後一位薪資
		, 薪資 - LAG(薪資) OVER(ORDER BY 薪資 ASC ) AS 薪資差
		, LAG(薪資, 2) OVER(ORDER BY 薪資 ASC ) AS 後二位薪資
		, LAG(薪資, 2, 0) OVER(ORDER BY 薪資 ASC ) AS 後二位薪資
FROM 員工 AS A

SELECT 員工編號,姓名,稱呼,職稱,薪資
		, LEAD(薪資, 1, 0) OVER(ORDER BY 薪資 ASC ) AS 後一位薪資
		, 薪資 - LEAD(薪資) OVER(ORDER BY 薪資 ASC ) AS 薪資差
		, LEAD(薪資, 2) OVER(ORDER BY 薪資 ASC ) AS 後二位薪資
		, LEAD(薪資, 2, 0) OVER(ORDER BY 薪資 ASC ) AS 後二位薪資
FROM 員工 AS A


SELECT 稱呼, 職稱, COUNT(*) 人數
FROM 員工
GROUP BY 稱呼, 職稱

--- 樞紐 查詢資料呈現 (源自於 GROUP BY)
SELECT 稱呼, 職稱, COUNT(*) 人數
FROM 員工
GROUP BY 稱呼, 職稱

--- |
--- V

SELECT [職稱], [小姐], [先生]
FROM (	SELECT 稱呼, 職稱, COUNT(*) 人數
		FROM 員工
		GROUP BY 稱呼, 職稱 ) AS A
PIVOT (SUM(人數) FOR 稱呼 IN([小姐], [先生])) AS P

