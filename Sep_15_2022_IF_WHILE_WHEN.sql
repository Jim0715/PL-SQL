/*HomeWork
3-1 列出每類產品購買最多的前五客戶
3-2 列出每位客戶購買最多的3項產品
*/

--變數宣告只有一次性，而且須整批一起，不能分開執行
DECLARE @aa NVARCHAR(10);
SET @aa='巨匠電腦';
PRINT @aa;

DECLARE @bb INT;
SET @bb=100;
SET @bb=@bb+200;
PRINT @bb;

--為系統變數不能宣告
SELECT @@VERSION;
SELECT @@SERVERNAME;
SELECT @@SERVICENAME;
SELECT @@ROWCOUNT;
SELECT @@ERROR;
SELECT @@SPID;

--變數表 vs. 暫存表 vs. CTE vs. View

--變數表
DECLARE @TT TABLE 
(
	編號 INT,
	姓名 NCHAR(10),
	薪資 INT
)

INSERT INTO @TT VALUES(1,'AAA',100);
INSERT INTO @TT VALUES(2,'BBB',200);
INSERT INTO @TT VALUES(3,'CCC',300);
UPDATE @TT SET 姓名=RTRIM(姓名)+'ZZ' WHERE 編號=2;
INSERT INTO @TT VALUES(4,'DDD',400);
DELETE FROM @TT WHERE 編號=3;

SELECT * FROM @TT;

--SELECT中不可一邊查一邊給
USE 中文北風
--使用一個變數 
DECLARE @vv MONEY=(SELECT 單價 FROM 產品資料 WHERE 產品編號=10);
SET @vv=@vv+10;
PRINT @vv;
--如沒下WHERE條件時，會直接給最後一筆
DECLARE @name NVARCHAR(10);
SELECT @name=產品 FROM 產品資料;
PRINT @name;

--使用多個變數
DECLARE @name NVARCHAR(10);
DECLARE @price MONEY;
SELECT @name=產品,@price=單價 FROM 產品資料 WHERE 產品編號=10;
SET @price=@price+10;
PRINT @name;
PRINT @price;

--if...else
DECLARE @price MONEY;
SELECT @price=單價 FROM 產品資料 WHERE 產品編號=20;
IF @price<=50
	BEGIN
		PRINT '@price';
		PRINT '好便宜！';
	END
ELSE
	BEGIN
		PRINT '@price';
		PRINT '好貴喔！';
	END

SELECT * FROM sys.tables;
SELECT COUNT(*) FROM sys.tables WHERE [name]='AAA';
SELECT COUNT(*) FROM sys.tables WHERE [name]='員工';

--利用IF...ELSE 建表
IF (SELECT COUNT(*) FROM sys.tables WHERE [name]='AAA')>0
	TRUNCATE TABLE [AAA];
ELSE
	CREATE TABLE [AAA]
	(
		編號 INT,
		資料 NVARCHAR(10)
	)

--db 只有 WHILE 迴圈 
DECLARE @cc INT =1;
WHILE @cc<=10
	BEGIN
		PRINT @cc;
		SET @cc=@cc+1;
	END


DECLARE @maxId INT=(SELECT MAX(產品編號) FROM 產品資料);
DECLARE @id INT=1;
DECLARE @name NVARCHAR(10);
DECLARE @price MONEY;
--不准，通常id不會連號，而且SELECT可查全部，無須用到WHILE 
WHILE @id<=@maxId
  BEGIN
	SELECT @name=產品,@price=單價 FROM 產品資料 WHERE 產品編號=@id;	
	PRINT CONCAT(@id,', ',@name,', ',@price);
	SET @id=@id+1;
  END

SELECT 員工編號,姓名,職稱,稱呼 FROM 員工

--將字進行替換 但要查兩次
SELECT 員工編號,姓名,職稱,'母' FROM 員工 WHERE 稱呼='小姐'
UNION ALL
SELECT 員工編號,姓名,職稱,'公' FROM 員工 WHERE 稱呼='先生'
--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
SELECT 員工編號,姓名,職稱,
	CASE 稱呼
		WHEN '小姐' THEN '母'
		WHEN '先生' THEN '公'
	END AS 性別
FROM 員工


SELECT 產品編號,產品,單價,
	CASE 
		WHEN 單價>=100 THEN '高價位'
		WHEN 單價>=50 THEN '中價位'
		WHEN 單價>=20 THEN '低價位'
		ELSE '超便宜' END AS 價格等級
FROM 產品資料

/*
CASE 
	WHEN 1 THEN INSERT INTO...
	WHEN 2 THEN UPDATA...
	WHEN 3 THEN DELECT FROM...
	ELSE SELECT * FROM ...
END
*/

--IIF(邏輯判斷, 成立值, 不成立值)
SELECT 員工編號,姓名,職稱,IIF(稱呼='小姐','母','公') AS 性別
FROM 員工

SELECT 產品編號,產品,單價
	,IIF(單價>=100,'高價位',IIF(單價>=50,'中價位',IIF(單價>=20,'低價位','超便宜'))) AS 價位等級
FROM 產品資料

--CHOOSE(選項,值1,值2,值3,...)
SELECT 訂單號碼,客戶編號,訂單日期,B.貨運公司名稱
FROM 訂貨主檔 AS A JOIN 貨運公司 AS B ON A.送貨方式=B.貨運公司編號;
--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
SELECT 訂單號碼,客戶編號,訂單日期
	,CHOOSE(送貨方式,'快遞','郵寄','親送') AS 運送方式
FROM 訂貨主檔;

--純粹show出錯誤訊息
--RAISERROR(錯誤號或錯誤訊息，錯誤等級1~25，狀態1~127)
--1~10輕微(會直接跳過繼續執行)  11~16 中級 17~25嚴重
RAISERROR('這是自訂的錯誤訊息',16,10);

UPDATE 產品資料 SET 單價=500 WHERE 產品編號=500;
IF @@ROWCOUNT=0 RAISERROR('並未更新任何資料！！',16,10)

--THROW 錯誤號, 錯誤訊息, 狀態1~127  一律錯誤等級16
--讓SQL自己認為自己錯了，直接停下
THROW 50010,'這是自訂的錯誤訊息',10;

--可執行 文字型態的SQL命令
EXECUTE ('SELECT * FROM 產品編號');

DECLARE @name NVARCHAR(10);
SET @name='產品資料';
SELECT * FROM @name;

EXECUTE(@sql+@name);


DECLARE @sql NVARCHAR(100);
SET @sql='SELECT * FROM ';
DECLARE @name NVARCHAR(10);
SET @name='產品資料';
EXECUTE(@sql+@name);

SET @name='產品類別';
EXECUTE(@sql+@name);

SET @name='客戶';
EXECUTE(@sql+@name);

--CROSS APPLY (INNER JOIN)

SELECT A.客戶編號,A.公司名稱,B.訂單號碼
FROM 客戶 AS A JOIN 訂貨主檔 AS B ON A.客戶編號=B.客戶編號

SELECT A.客戶編號,A.公司名稱,B.訂單號碼
FROM 客戶 AS A CROSS APPLY ( SELECT 訂單號碼 FROM 訂貨主檔 WHERE 客戶編號=A.客戶編號) AS B

--OUTER APPLY (LEFT JOIN)
SELECT A.客戶編號,A.公司名稱,B.訂單號碼
FROM 客戶 AS A JOIN 訂貨主檔 AS B ON A.客戶編號=B.客戶編號

SELECT A.客戶編號,A.公司名稱,B.訂單號碼
FROM 客戶 AS A OUTER APPLY ( SELECT 訂單號碼 FROM 訂貨主檔 WHERE 客戶編號=A.客戶編號) AS B


--文字型 SQL命令
SELECT 類別名稱 FROM 產品類別
SELECT STRING_AGG(類別名稱,',') FROM 產品類別
SELECT STRING_AGG(QUOTENAME(類別名稱),',') FROM 產品類別

DECLARE @aa NVARCHAR(100) = (SELECT STRING_AGG(QUOTENAME(類別名稱),',') FROM 產品類別);
EXECUTE 'SELECT 縣市,' +@aa