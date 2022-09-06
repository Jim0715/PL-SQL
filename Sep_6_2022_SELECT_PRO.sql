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

--各職位的女生人數 (不准用GROUP BY) 
--列出各產品類別中高於該產品均價的產品
--列出2002年四季的營收
--2003找出客戶累計金額超出13000
--每位客戶最後一次下單時間
--有買過海鮮的客戶，依照最近訂單購買時間排序










