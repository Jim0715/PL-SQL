USE 練習;
GO

/* UNION
1.UNION依然需要花費 時間、運算成本
2.UNION的來源資料欄位數必須相同
3.UNION的來源資料欄位型別必須相同
4.UNION的結果欄位名稱，會以第一份查詢結果的欄位為最後結果欄位名稱
*/

SELECT 品名 FROM 巨巨
UNION  --合併，去除重複值
SELECT 品名 FROM 匠匠;

SELECT 品名 FROM 巨巨
UNION ALL  --合併，全部合再一起
SELECT 品名 FROM 匠匠;

--定序 Collation
--會造成資料庫中的「文字資料」 搜尋、排序 出問題

SELECT * FROM fn_helpcollations();
SELECT * FROM fn_helpcollations() WHERE [name] LIKE '%taiwan%' ;
SELECT * FROM fn_helpcollations() WHERE [name] LIKE '%taiwan%' COLLATE Chinese_Taiwan_Bopomofo_CI_AI;
SELECT * FROM fn_helpcollations() WHERE [name] LIKE '%japan%';
SELECT * FROM fn_helpcollations() WHERE [name] LIKE '%korean%';



SELECT * FROM 員工 ORDER BY 姓名;

USE 新新;
CREATE TABLE 新巨巨
(
    產品編號 INT,
	產品名 NVARCHAR(20),
	售價 MONEY
)

INSERT INTO 新巨巨 SELECT * FROM 練練.dbo.巨巨;

SELECT * FROM 新巨巨;

SELECT A.*,B.*
FROM 新新.dbo.新巨巨 AS A JOIN 中文北風.dbo.產品資料 AS B ON A.產品名=B.產品 COLLATE Chinese_Taiwan_Stroke_CI_AI;


USE 中文北風;
SELECT * FROM 員工 ORDER BY 姓名;
SELECT * FROM 員工 ORDER BY 姓名 COLLATE Chinese_Taiwan_Bopomofo_CI_AI; --按照注音排序


--建立資料庫，指定定序
CREATE DATABASE 訓練
ON PRIMARY
(
	NAME='練習Data',FILENAME='C:\練習家\練習資料.mdf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=30MB
)

LOG ON
(
	NAME='練習Log',FILENAME='C:\練習家\練習記錄.ldf',
	SIZE=30MB,MAXSIZE=UNLIMITED,FILEGROWTH=50%
)
COLLATE Japanese_CI_AI
GO


--建立資料表，文字欄位定序
CREATE TABLE 練習表
(
    文字欄位1 NVARCHAR(30) COLLATE Japanese_CI_AI,
	文字欄位2 NVARCHAR(30) COLLATE Chinese_Taiwan_Bopomofo_CI_AI,
	文字欄位3 NVARCHAR(30) COLLATE Korean_90_CI_AI_KS,
	數值1 INT
)

--查詢資料庫的定序
SELECT * FROM sys.databases;
SELECT [database_id],[name],[collation_name] FROM sys.databases;

USE 中文北風
EXEC sp_help '產品資料'
