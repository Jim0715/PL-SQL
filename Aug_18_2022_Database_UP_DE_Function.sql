USE [練習]
GO

--SQL Sever 特有
--儲存 預存程序 回傳資料
 EXEC sp_helpdb  --回傳系統上的所有DB資訊
 CREATE TABLE 資料庫資訊      --創建資料表
(
	名稱 NVARCHAR(100),
	容量 NVARCHAR(100),
	擁有者 NVARCHAR(200),
	編號 INT,
	建立時間 DATETIME2(2),
	狀態 NVARCHAR(1024),
	相容層級 INT
)
GO
SELECT * FROM 資料庫資訊;

--將指令回傳的資料存入其表中，只有欄位跟資料會過去，其他不會
INSERT INTO 資料庫資訊 EXEC sp_helpdb  

SELECT * FROM 員工表3;

--更新資料庫，無法改回
UPDATE [員工表3]
SET 姓名='ZZZ'
WHERE 員工號=2456;

UPDATE [員工表3]
SET 薪資=薪資+3000
WHERE 薪資<40000;

--不帶條件，會認為要全改
UPDATE [員工表3]
SET 薪資=薪資+3000;

--刪除後，無法改回
DELECT FROM [員工表3]
WHERE 員工號=5;


-- DELETE vs. TRUNCATE
DELETE FROM [員工表3];
TRUNCATE TABLE [員工表3];
