/*
交易行為 ACID Iso/ation 確保用戶 Select 資料的正確性
*/


--Output    搭配 DML 使用 inserted / deleted

SELECT * FROM [匠匠];
INSERT INTO [匠匠] VALUES(26,'御飯糰',30);
UPDATE [匠匠] SET 價錢=45 WHERE 產品編號=26;
DELETE FROM [匠匠] WHERE 產品編號=26;

--↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ 

INSERT INTO [匠匠]
	OUTPUT inserted.* --輸出新增項目
VALUES(26,'御飯糰',30);

DELETE FROM [匠匠]
	OUTPUT deleted.* --輸出刪除項目
WHERE 產品編號=26;

UPDATE [匠匠] SET 價錢=45
	OUTPUT inserted.產品編號,inserted.品名,inserted.價錢,deleted.價錢
		,inserted.價錢-deleted.價錢 AS 價差
WHERE 產品編號=26;

-------------------------------------------------
SELECT * FROM 練習訂單;

INSERT INTO 練習訂單(金額) VALUES(1111);
INSERT INTO 練習訂單(金額) OUTPUT inserted.訂單編號 VALUES(5678);

-------------------------------------------------

CREATE TABLE 匠匠追蹤表
(
    產品編號 INT,
	舊產品 NVARCHAR(10),
	舊售價 MONEY,
	新產品 NVARCHAR(10),
	新售價 MONEY,
	異動狀態 NVARCHAR(10),
	帳號 NVARCHAR(100) DEFAULT SUSER_SNAME(),
	異動時間 DATETIME2(2) DEFAULT SYSDATETIME()
)
GO

SELECT * FROM 匠匠追蹤表;

SELECT * FROM 匠匠;

INSERT INTO [匠匠]
	OUTPUT inserted.*,'新增產品'
		INTO 匠匠追蹤表(產品編號,新產品,新售價,異動狀態)
VALUES(26,'御飯糰',30);


UPDATE [匠匠]
SET 品名='大顆御飯糰',價錢=45
	OUTPUT inserted.*,deleted.品名,deleted.價錢,'產品資料異動'
		INTO 匠匠追蹤表(產品編號,新產品,新售價,舊產品,舊售價,異動狀態)
WHERE 產品編號=26;


DELETE FROM [匠匠]
	OUTPUT deleted.*,'刪除產品'
		INTO 匠匠追蹤表(產品編號,舊產品,舊售價,異動狀態)
WHERE 產品編號=26;

-------------------------------------------------

CREATE PROC 匠匠新增 @id INT,@name NVARCHAR(10),@price MONEY
AS
	INSERT INTO [匠匠]
		OUTPUT inserted.*,'新增產品'
			INTO 匠匠追蹤表(產品編號,新產品,新售價,異動狀態)
	VALUES(@id,@name,@price);
GO

CREATE PROC 匠匠修改 @id INT,@name NVARCHAR(10),@price MONEY
AS
	UPDATE [匠匠]
	SET 品名=@name,價錢=@price
		OUTPUT inserted.*,deleted.品名,deleted.價錢,'產品資料異動'
			INTO 匠匠追蹤表(產品編號,新產品,新售價,舊產品,舊售價,異動狀態)
	WHERE 產品編號=@id;
GO

CREATE PROC 匠匠刪除 @id INT
AS
	DELETE FROM [匠匠]
		OUTPUT deleted.*,'刪除產品'
			INTO 匠匠追蹤表(產品編號,舊產品,舊售價,異動狀態)
	WHERE 產品編號=@id;
GO


EXEC 匠匠新增 27,'金莎',80;
EXEC 匠匠修改 27,'大金莎',180;
EXEC 匠匠刪除 27;

SELECT * FROM 匠匠;
SELECT * FROM 匠匠追蹤表;

-------------------------------------------------
--SQL2016 時態表

--DROP TABLE 新巨巨;
--SELECT * FROM sys.tables


CREATE TABLE dbo.新巨巨
(    
	產品編號 INT NOT NULL PRIMARY KEY
	, 產品名稱 NVARCHAR(10) NOT NULL  
	, 售價 MONEY NOT NULL     
	, [開始時間] DATETIME2(2) GENERATED ALWAYS AS ROW START  
	, [結束時間] DATETIME2(2) GENERATED ALWAYS AS ROW END  
	, PERIOD FOR SYSTEM_TIME (開始時間, 結束時間)
)    
WITH (SYSTEM_VERSIONING = ON);  --設定時態表 


DROP TABLE 新巨巨;
ALTER TABLE 新巨巨 SET (SYSTEM_VERSIONING = OFF);
DROP TABLE 新巨巨;
DROP TABLE [dbo].[MSSQL_TemporalHistoryFor_2069582411];


---------------------------------------------------------------------------
CREATE TABLE dbo.新巨巨
(    
	產品編號 INT NOT NULL PRIMARY KEY
	, 產品名稱 NVARCHAR(10) NOT NULL  
	, 售價 MONEY NOT NULL     
	, [開始時間] DATETIME2(2) GENERATED ALWAYS AS ROW START  
	, [結束時間] DATETIME2(2) GENERATED ALWAYS AS ROW END  
	, PERIOD FOR SYSTEM_TIME (開始時間, 結束時間)
)    
WITH (SYSTEM_VERSIONING = ON(HISTORY_TABLE=dbo.新巨巨追蹤));  --設定時態表 

INSERT INTO 新巨巨 (產品編號,產品名稱,售價)
	SELECT 產品編號,品名,價錢 FROM 練練.dbo.巨巨

SELECT * FROM 新巨巨

INSERT INTO 新巨巨(產品編號,產品名稱,售價) VALUES(28,'波卡',35);
DELETE FROM 新巨巨 WHERE 產品編號=29;
UPDATE 新巨巨 SET 產品名稱='大金沙',售價=180 WHERE 產品編號=28;
INSERT INTO 新巨巨(產品編號,產品名稱,售價) VALUES(31,'芝多司',30);
UPDATE 新巨巨 SET 產品名稱='大波卡',售價=50 WHERE 產品編號=30;
UPDATE 新巨巨 SET 產品名稱='大盒金沙',售價=280 WHERE 產品編號=28;

SELECT * FROM 新巨巨
SELECT * FROM 新巨巨 FOR SYSTEM_TIME ALL;
SELECT * FROM 新巨巨 FOR SYSTEM_TIME ALL WHERE 產品編號 = 28 ORDER BY 結束時間;

SELECT * FROM 新巨巨 
	FOR SYSTEM_TIME CONTAINED IN('2022-10-04 11:30:00.00','2022-10-04 11:35:00.00')

ALTER TABLE 新巨巨 SET (SYSTEM_VERSIONING = OFF);  
ALTER TABLE 新巨巨 SET (SYSTEM_VERSIONING = ON(HISTORY_TABLE=dbo.新巨巨追蹤)); 
SELECT * FROM 新巨巨追蹤

-----------------------------------------------------------------------------------

SELECT * INTO 新匠匠 FROM [dbo].[匠匠];

SELECT * FROM 新匠匠

DELETE FROM 新匠匠 WHERE 產品編號>=26;

--三個動作,分別進行
INSERT INTO 新匠匠 VALUES(26,'AAA',260); 
INSERT INTO 新匠匠 VALUES(27,'BBB','BBB'); 
INSERT INTO 新匠匠 VALUES(28,'CCC',280); 

--一次送三筆
INSERT INTO 新匠匠 VALUES(26,'AAA',260), (27,'BBB','BBB'),(28,'CCC',280);



--BEGIN TRANSACTION 交易行為 搭配 COMMIT(確認) / ROLLBACK(取消)
--包在一起的，要不全部成功，要不全部失敗

--外顯、明確交易(Explicit)
BEGIN TRAN
	INSERT INTO 新匠匠 VALUES(26,'AAA',260); 
	INSERT INTO 新匠匠 VALUES(27,'BBB','BBB'); 
	INSERT INTO 新匠匠 VALUES(28,'CCC',280); 
COMMIT  --確認 (為持久性資料)

BEGIN TRAN
	INSERT INTO 新匠匠 VALUES(26,'AAA',260); 
	INSERT INTO 新匠匠 VALUES(27,'BBB',270); 
	INSERT INTO 新匠匠 VALUES(28,'CCC',280); 
ROLLBACK --取消

--隱含、不明確交易(Implicit) 只要一筆失敗 全失敗,否則每句結尾都帶COMMIT
SET IMPLICIT_TRANSACTIONS ON;
SELECT * FROM

--BEGIN TRAN
INSERT INTO 新匠匠 VALUES(29,'DDD',290);  --COMMIT
UPDATE 新匠匠 SET 價錢=價錢*10 WHERE 產品編號=26;  --COMMIT
DELETE FROM 新匠匠 WHERE 產品編號=27;  --COMMIT
INSERT INTO 新匠匠 VALUES(30,'EEE','EEE');  --COMMIT


--自動交易
INSERT INTO 新匠匠 VALUES(26,'AAA',260); 
INSERT INTO 新匠匠 VALUES(27,'BBB','BBB'); 
INSERT INTO 新匠匠 VALUES(28,'CCC',280); 
-----↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
BEGIN TRAN
	INSERT INTO 新匠匠 VALUES(26,'AAA',260); 
COMMIT
BEGIN TRAN
	INSERT INTO 新匠匠 VALUES(27,'BBB','BBB');  
COMMIT
BEGIN TRAN
	INSERT INTO 新匠匠 VALUES(28,'CCC',280);  
COMMIT


------------------------------------

CREATE TABLE AAA
(
    編號 INT PRIMARY KEY,
	資料 NCHAR(5)
);

CREATE TABLE BBB
(
	編號 INT PRIMARY KEY,
	關聯編號 INT FOREIGN KEY REFERENCES AAA(編號),
	資料 NCHAR(5) 
);

INSERT INTO AAA VALUES(1,'AAA'),(2,'BBB'),(3,'CCC');

--此環境下，錯則跳過
BEGIN TRAN
	INSERT INTO BBB VALUES(101,1,'AA');
	INSERT INTO BBB VALUES(102,4,'BB');
	INSERT INTO BBB VALUES(103,3,'CC');
COMMIT

SELECT * FROM BBB;

--此環境下，錯則全錯
SET XACT_ABORT ON; 
BEGIN TRAN
	INSERT INTO BBB VALUES(104,1,'DD');
	INSERT INTO BBB VALUES(105,4,'EE');
	INSERT INTO BBB VALUES(106,3,'FF');
COMMIT

-------------------------------------------------------------------

--巢狀交易

SELECT @@TRANCOUNT
BEGIN TRAN
	SELECT @@TRANCOUNT
	BEGIN TRAN
		SELECT @@TRANCOUNT
	COMMIT
	BEGIN TRAN
		SELECT @@TRANCOUNT

	ROLLBACK
	--COMMIT	

	SELECT @@TRANCOUNT
COMMIT
SELECT @@TRANCOUNT


/*
CREATE PROC 中信轉帳
AS
    BEGIN TRAN
	  ....
	  ....
	COMMIT
GO

CREATE PROC 台北富邦轉帳
AS
    BEGIN TRAN
	  ....
	  ....
	COMMIT
GO

CREATE PROC 跨行轉帳
AS
  BEGIN TRAN
	EXEC 中信轉帳;
	EXEC 台北富邦轉帳;
  COMMIT
GO
*/

-----------------------------------------------------

--第一張查詢
BEGIN TRAN
	UPDATE 巨巨 SET 價錢=50 WHERE 產品編號=5;

ROLLBACK
COMMIT


--第二張查詢
SET TRANSACTION ISOLATION  
