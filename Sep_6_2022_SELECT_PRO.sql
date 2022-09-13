/* 子查詢 (SubQuery)
1.原本需要多次查詢方可完成，希望一次搞定
2.撰寫上較為直覺
3.單一子查詢，最多32層
4.獨立子查詢 vs. 關聯子查詢
*/

/* 子查詢的使用位置
通常大部分的子查詢，可以用在其他方式解決，避免子查詢
WHERE：通常一般而言，效率奇差
	1. 直接取單一值，可使用變數來改寫
	2.比對清單：雖然有時比較直覺，但通常可以用JOIN來取代，效率較高
	3.測試存在：通常效率極佳，有奇效
FROM：使用頻率非常高，對整體查詢效率幾乎不影響
Column：撰寫上較為技巧，時間效能依照查詢出的資料筆數而定
*/

USE 練練
--直接取單一值
SELECT MAX(價錢) FROM 匠匠
SELECT * FROM 巨巨 WHERE 價錢>=123.79;
--合併如下，但效率低
SELECT * FROM 巨巨
	WHERE 價錢>=(SELECT MAX(價錢) FROM 匠匠);
--效率高
DECLARE @VV MONEY=(SELECT MAX(價錢) FROM 匠匠);
SELECT * FROM 巨巨 WHERE 價錢>= @VV ;


--比對清單
SELECT 品名 FROM 匠匠
SELECT * FROM 巨巨 WHERE 品名 IN (SELECT 品名 FROM 匠匠);
SELECT * FROM 巨巨 WHERE 品名 NOT IN (SELECT 品名 FROM 匠匠);

USE 中文北風
--HW 沒改過東西的客戶
--0.0644
SELECT * FROM 客戶 WHERE 客戶編號 NOT IN (SELECT 客戶編號 FROM 訂貨主檔);
SELECT A.* FROM 客戶 AS A LEFT JOIN 訂貨主檔 AS B ON A.客戶編號=B.客戶編號 WHERE B.訂單號碼 IS NULL
--HW 2004年未買出的產品
SELECT * FROM 產品資料  WHERE 產品編號
	NOT IN (SELECT 產品編號 FROM 訂貨明細 AS A JOIN 訂貨主檔 AS B ON A.訂單號碼=B.訂單號碼 WHERE B.訂單日期 BETWEEN '2002-01-01' AND '2002-12-31' );


--測試是否存在,關聯子查詢
--0.0296
SELECT * FROM 客戶 WHERE NOT EXISTS (SELECT * FROM 訂貨主檔 WHERE 客戶編號=客戶.客戶編號)

USE 練練
SELECT * FROM 巨巨 AS A
	WHERE EXISTS(SELECT * FROM 匠匠 AS B WHERE B.品名=A.品名);

SELECT * FROM 巨巨 AS A
	WHERE NOT EXISTS(SELECT * FROM 匠匠 AS B WHERE B.品名=A.品名);

--1.
SELECT * FROM 訂貨明細
--2.
SELECT 訂單號碼,產品編號,單價*數量*(1-折扣) AS 金額 FROM 訂貨明細
--3.
SELECT 訂單號碼,ROUND(SUM(單價*數量*(1-折扣)),0) AS 金額 
FROM 訂貨明細 GROUP BY 訂單號碼
--4.
SELECT A.訂單號碼,A.客戶編號,A.訂單日期,B.金額,A.運費,B.金額+A.運費 AS 總金額
FROM 訂貨主檔 AS A JOIN (SELECT 訂單號碼,ROUND(SUM(單價*數量*(1-折扣)),0) AS 金額 
FROM 訂貨明細 GROUP BY 訂單號碼) AS B ON A.訂單號碼=B.訂單號碼

/* HomeWork
--各職位的女生人數 (不准用GROUP BY) 
SELECT DISTINCT 職稱,COUNT(稱呼) OVER (PARTITION BY 職稱) AS 人數
FROM 員工
WHERE 稱呼='小姐'

--列出各產品類別中高於該產品均價的產品
SELECT  類別名稱,產品,單價,類別平均價格
FROM
	(SELECT B.類別名稱,A.產品,A.單價,AVG(A.單價) OVER (PARTITION BY 類別名稱 ) AS 類別平均價格
	FROM 產品資料 AS A JOIN 產品類別 AS B ON A.類別編號=B.類別編號) AS A
WHERE 單價>類別平均價格

--列出2002年四季的營收
SELECT 年份,ISNULL("第1季",0) AS 第1季,ISNULL("第2季",0) AS 第2季,"第3季","第4季"
FROM
   (SELECT *
	FROM
		(SELECT DISTINCT 年份,訂單季度,ROUND(SUM(價格) OVER (PARTITION BY 訂單季度 ORDER BY 訂單季度),0) AS 總額
		FROM
			(SELECT YEAR(B.訂單日期) AS 年份 ,CONCAT('第',DATEPART(Q, B.訂單日期),'季')  AS 訂單季度,A.訂單號碼,單價*數量*(1+折扣) AS 價格
			FROM 訂貨明細 AS A JOIN 訂貨主檔 AS B ON A.訂單號碼=B.訂單號碼
			WHERE B.訂單日期 BETWEEN '2002-01-01' AND '2002-12-31' ) AS C) AS D
	PIVOT (
		-- 設定彙總欄位及方式
		MAX(總額) 
		-- 設定轉置欄位，並指定轉置欄位中需彙總的條件值作為新欄位
		FOR 訂單季度 IN ("2002","第1季","第2季","第3季","第4季")
	) p) AS E;
	
--2003找出客戶累計金額超出13000
SELECT 年份,客戶編號,累計總額 AS 累計總額大於13000
FROM
   (SELECT DISTINCT 年份,客戶編號,ROUND(SUM(價格) OVER (PARTITION BY 客戶編號 ORDER BY 客戶編號),0) AS 累計總額
	FROM
		(SELECT YEAR(B.訂單日期) AS 年份 ,A.訂單號碼,B.客戶編號,單價*數量*(1+折扣) AS 價格
		FROM 訂貨明細 AS A JOIN 訂貨主檔 AS B ON A.訂單號碼=B.訂單號碼
		WHERE B.訂單日期 BETWEEN '2003-01-01' AND '2003-12-31' ) AS C) AS D
WHERE 累計總額>13000;

--每位客戶最後一次下單時間
SELECT DISTINCT 客戶編號 ,LAST_VALUE(訂單日期) OVER (PARTITION BY 客戶編號 ORDER BY 客戶編號) AS 最後下單時間
FROM
   (SELECT ROW_NUMBER() OVER (ORDER BY 訂單日期) AS 序號,訂單日期,客戶編號
	FROM
		(SELECT  B.訂單日期 ,A.訂單號碼,B.客戶編號,A.單價*A.數量*(1+A.折扣) AS 價格
		FROM 訂貨明細 AS A JOIN 訂貨主檔 AS B ON A.訂單號碼=B.訂單號碼) AS C) AS D
			
--有買過海鮮的客戶，依照最近訂單購買時間排序
SELECT DISTINCT LAST_VALUE(訂單日期) OVER (PARTITION BY 客戶編號 ORDER BY 客戶編號) AS 最近購買時間 ,客戶編號,類別名稱
FROM
	(SELECT ROW_NUMBER() OVER (ORDER BY 訂單日期) AS 序號,訂單日期,訂單號碼,客戶編號,類別名稱
		FROM
			(SELECT  B.訂單日期 ,A.訂單號碼,B.客戶編號,D.類別名稱
			FROM 訂貨明細 AS A JOIN 訂貨主檔 AS B ON A.訂單號碼=B.訂單號碼
			JOIN 產品資料 AS C ON A.產品編號=C.產品編號 JOIN 產品類別 AS D ON C.類別編號=D.類別編號
			WHERE D.類別名稱='海鮮') AS E) AS F
ORDER BY 最近購買時間 DESC
*/










