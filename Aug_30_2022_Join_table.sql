/* 暫存表 
1. 無論用戶當下使用何資料庫，一律建立在 tempdb 資料庫
2. 依然會成磁碟IO的讀寫，而非記憶體
3. 個人暫存 vs. 全域共用暫存
4. 消失時機
*/

USE 練練;
GO

--個人暫存 (較為常用)
CREATE TABLE #TT
(
	編號 INT,
	姓名 NCHAR(10),
	薪資 INT
)
GO

INSERT INTO #TT VALUES(1,'AAA',100);
INSERT INTO #TT VALUES(2,'BBB',200);
INSERT INTO #TT VALUES(3,'CCC',300);
UPDATE #TT SET 姓名=RTRIM(姓名)+'ZZ' WHERE 編號=2;
INSERT INTO #TT VALUES(4,'DDD',400);
DELETE FROM #TT WHERE 編號=3;

SELECT * FROM #TT;


--全域共用暫存 (該執行用戶的暫存表)
CREATE TABLE ##TTT
(
	編號 INT,
	姓名 NCHAR(10),
	薪資 INT
)
GO

INSERT INTO ##TTT VALUES(1,'AAA',100);
INSERT INTO ##TTT VALUES(2,'BBB',200);
INSERT INTO ##TTT VALUES(3,'CCC',300);
UPDATE ##TTT SET 姓名=RTRIM(姓名)+'ZZ' WHERE 編號=2;
INSERT INTO ##TTT VALUES(4,'DDD',400);
DELETE FROM ##TTT WHERE 編號=3;

SELECT * FROM ##TTT;


/* Join 語法 多張表都有的
1. 浪費時間，會運算很久 (一個一個比對)
2. 彌補 資料庫正規劃→資料分散在各資料表中

*/
USE 練練;
GO

SELECT * FROM 巨巨;
SELECT * FROM 匠匠;

--SQL89
SELECT 巨巨.品名 AS 巨巨品名,巨巨.價錢 AS 巨巨價錢,匠匠.品名 AS 匠匠品名 ,匠匠.價錢 AS 匠匠價錢 
FROM 巨巨,匠匠
WHERE  巨巨.品名 = 匠匠.品名 AND 巨巨.價錢>=40;

--SQL92
SELECT A.品名 AS 巨巨品名,A.價錢 AS 巨巨價錢,B.品名 AS 匠匠品名 ,B.價錢 AS 匠匠價錢 
FROM 巨巨 AS A INNER JOIN 匠匠 AS B ON A.品名 = B.品名 --A與B聯集，品名都相同
WHERE  A.價錢>=40;

USE 中文北風
GO

SELECT * FROM 產品資料;		--0.03

--0.076
SELECT A.產品編號,A.產品,B.供應商,C.類別名稱,A.單價,A.單位數量,A.庫存量
FROM [產品資料] AS A INNER JOIN 供應商 AS B ON A.供應商編號=B.供應商編號
	JOIN 產品類別 AS C ON A.類別編號=C.類別編號


SELECT * FROM 訂貨主檔	--0.0138

--0.1
SELECT A.訂單號碼,B.公司名稱,B.連絡人,B.連絡人職稱,B.電話
	,A.訂單日期,C.姓名 AS 負責員工
	,D.貨運公司名稱 AS 運送方式,A.運費
FROM 訂貨主檔 AS A JOIN 客戶 AS B ON A.客戶編號=B.客戶編號
	JOIN 員工 AS C ON A.員工編號=C.員工編號
	JOIN 貨運公司 AS D ON A.送貨方式=D.貨運公司編號

SELECT A.訂單號碼,B.公司名稱,B.連絡人,B.連絡人職稱,B.電話
	,A.訂單日期,C.姓名 AS 負責員工
	,D.貨運公司名稱 AS 運送方式,A.運費
INTO 詳細訂單一覽
FROM 訂貨主檔 AS A JOIN 客戶 AS B ON A.客戶編號=B.客戶編號
	JOIN 員工 AS C ON A.員工編號=C.員工編號
	JOIN 貨運公司 AS D ON A.送貨方式=D.貨運公司編號

SELECT * FROM 詳細訂單一覽;		--0.011


--0.04
SELECT A.訂單號碼,A.客戶編號,A.員工編號,A.訂單日期,D.貨運公司名稱,A.運費
FROM 訂貨主檔 AS A JOIN 貨運公司 AS D ON A.送貨方式=D.貨運公司編號

SELECT CHOOSE(5,'AA','BB','CC','DD','EE','FF')

--0.0139
SELECT A.訂單號碼,A.客戶編號,A.員工編號,A.訂單日期,A.運費
	,CHOOSE(A.送貨方式,'快遞','郵寄','親送') AS 運送方式
FROM 訂貨主檔 AS A JOIN 貨運公司 AS D ON A.送貨方式=D.貨運公司編號
--CHOOSE 依順序給予相對的文字


SELECT A.品名 AS 巨巨產品,A.價錢 AS 巨巨售價
	,B.品名 AS 匠匠產品,B.價錢 AS 匠匠售價
FROM 巨巨 AS A LEFT OUTER JOIN 匠匠 AS B ON A.品名=B.品名

SELECT A.品名 AS 巨巨產品,A.價錢 AS 巨巨售價
	,B.品名 AS 匠匠產品,B.價錢 AS 匠匠售價
FROM 巨巨 AS A RIGHT JOIN 匠匠 AS B ON A.品名=B.品名


SELECT A.品名 AS 巨巨產品,A.價錢 AS 巨巨售價
	  ,B.品名 AS 匠匠產品,B.價錢 AS 匠匠售價
FROM 巨巨 AS A LEFT OUTER JOIN 匠匠 AS B ON A.品名=B.品名
WHERE B.品名 IS NULL;


--調薪後，薪資大於7萬
--當條件的，不一定要拿來當SELECT
USE 中文北風
GO

SELECT A.員工編號,A.姓名,A.薪資
FROM 員工 AS A
WHERE 薪資*1.05>=70000;

--SQL Server特有
--其中一个表中存在匹配，则返回行；结合了LEFT JOIN 和RIGHT JOIN 的结果
SELECT A.品名 AS 巨巨產品,A.價錢 AS 巨巨售價
	,B.品名 AS 巨巨產品,B.價錢 AS 巨巨售價
FROM 巨巨 AS A FULL OUTER JOIN 巨巨 AS B ON A.品名 = B.品名;

--兩個資料表在結合時，不指定任何條件，即將兩個資料表中所有的可能排列組合出來
SELECT A.品名 AS 巨巨產品,A.價錢 AS 巨巨售價
	,B.品名 AS 巨巨產品,B.價錢 AS 巨巨售價
FROM 巨巨 AS A CROSS JOIN 巨巨 AS B;

--對照表
SELECT 員工編號,姓名,職稱,主管 FROM 員工;

SELECT A.員工編號,A.姓名,A.職稱,
	B.員工編號 AS 主管編號 ,B.姓名 AS 主管姓名, B.職稱 AS 主管
FROM 員工 AS A LEFT JOIN 員工 AS B ON A.主管=B.員工編號;