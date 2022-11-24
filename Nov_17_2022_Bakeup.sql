SELECT * FROM sys.databases;
SELECT A.[database_id],A.[name], A.[recovery_model_desc] FROM sys.databases AS A;

ALTER DATABASE 中文北風 SET RECOVERY BULK_LOGGED;	-- SIMPLE | FULL | BULK_LOGGED
ALTER DATABASE 中文北風 SET RECOVERY FULL;


--強烈建議先備份
--1.
EXEC sp_helpdb '訓練'
--2.
--刪除LDF，有記憶體表不能用；最大2T，不刪也不會無限長
--3.
CREATE DATABASE [練習]
ON
( FILENAME='C:\練習家\練習資料庫.mdf')
FOR ATTACH_REBUILD_LOG;

/*
其實不需要清除ldf或想辦法ldf變小
其實只需要定時定期「Backup Log」即可
LDF就會不斷循環重複使用固定的儲存空間
*/

/*
備份方式：Full、Diffrerntial(差異備份)、log(以時間切分)、File/filegroup
*/
--備份磁帶機(必須為本機磁帶機)
BACKUP DATABASE 中文北風 TO TAPE='C:'

--備份磁碟
BACKUP DATABASE 中文北風 TO DISK='C:\BB\北風完整.bak';
BACKUP DATABASE 中文北風 TO DISK='\\FileServer\Backup\北風完整.bak';
BACKUP DATABASE 中文北風 TO DISK='C:\Backup\北風完整.bak';
---------------------------------------------------------------------------------

BACKUP DATABASE 中文北風 TO DISK='C:\BB\北風完整.bak';

DROP DATABASE 中文北風;

RESTORE DATABASE 中文北風 FROM DISK='C:\BB\北風完整.bak';
-------------------------------------------------------------------

--備份集(組)(BackupSet)、媒體集(MediaSet)  幾分之幾
BACKUP DATABASE 中文北風
TO DISK='C:\BB\北風完整-1.bak',DISK='C:\BB\北風完整-2.bak',DISK='C:\BB\北風完整-3.bak';

--BACKUP DATABASE [AdventureWorks2012] TO DISK='C:\BB\AW完整.bak';
BACKUP DATABASE [AdventureWorks2012]
	TO DISK='C:\BB\AW完整-1.bak',DISK='C:\BB\AW完整-2.bak',DISK='C:\BB\AW完整-3.bak';

DROP DATABASE [AdventureWorks2012]
RESTORE DATABASE [AdventureWorks2012] FROM DISK='C:\BB\AW完整-1.bak',DISK='C:\BB\AW完整-2.bak',DISK='C:\BB\AW完整-3.bak';

------------------------------------------------------------------------------------------------------------------------------

--鏡像備份(企業版才有),*n份
BACKUP DATABASE [AdventureWorks2012]
TO DISK='C:\BB\AW完整1.bak'
MIRROR
TO DISK='C:\BB\AW完整2.bak'
MIRROR
TO DISK='C:\BB\AW完整3.bak'
WITH FORMAT,INIT;

--備份集 鏡像備份
BACKUP DATABASE [AdventureWorks2012]
TO DISK='C:\BB\AW完整1-1.bak',DISK='C:\BB\AW完整1-2.bak'
MIRROR
TO DISK='C:\BB\AW完整2-1.bak',DISK='C:\BB\AW完整2-2.bak'
WITH FORMAT,INIT;
---------------------------------------------------------------------
--備份壓縮
BACKUP DATABASE [AdventureWorks2012] TO DISK='C:\BB\AW完整.bak';
BACKUP DATABASE [AdventureWorks2012] TO DISK='C:\BB\AW完整壓.bak' WITH COMPRESSION;

----------------------------------------------------------------------------------------
--加密備份
BACKUP DATABASE [AdventureWorks2012] TO DISK='C:\BB\AW完整加密壓.bak'
	WITH COMPRESSION, ENCRYPTION(ALGORITHM=AES_256, SERVER CERTIFICATE=[透明加密憑憑]);

-------------------------------------------------------------------------------------------
--在同一備份檔中，置入多個資料庫備份
BACKUP DATABASE 中文北風 TO DISK = 'C:\BB\備備.bak' WITH COMPRESSION;
BACKUP DATABASE [AdventureWorks2012] TO DISK ='C:\BB\備備.bak';
BACKUP DATABASE 新新 TO DISK ='C:\BB\備備.bak' WITH COMPRESSION;
BACKUP DATABASE 練習 TO DISK ='C:\BB\備備.bak';
BACKUP DATABASE 練練 TO DISK ='C:\BB\備備.bak';

BACKUP DATABASE 中文北風 TO DISK ='C:\BB\備備.bak'
	WITH NAME='北風完整備份',DESCRIPTION='完整了喔！',COMPRESSION;
------------------------------------------------------------------------------
--查詢備份檔中，資料庫備份的資訊
RESTORE HEADERONLY FROM DISK='C:\BB\備備.bak';

--查詢備份檔中，指定資料庫備份的檔案資訊
RESTORE FILELISTONLY FROM DISK='C:\BB\備備.bak' WITH FILE=2;
----------------------------------------------------------------------------------

DBCC CHECKDB(N'中文北風');--檢查指定資料庫中所有物件的完整性

ALTER DATABASE [中文北風] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DBCC CHECKDB(N'中文北風',REPAIR_ALLOW_DATA_LOSS);  --幫忙修復有問題的資料庫
ALTER DATABASE [中文北風] SET MULTI_USER;

------------------------------------------------------------------------------------

BACKUP DATABASE 中文北風 TO DISK='C:\BB\北風完整.bak';

SELECT * INTO 中文北風.dbo.新客戶 FROM 中文北風.dbo.客戶;
BACKUP DATABASE 中文北風 TO DISK='C:\BB\北風差異.bak' WITH DIFFERENTIAL;

SELECT * INTO 中文北風.dbo.新產品 FROM 中文北風.dbo.產品資料;
BACKUP DATABASE 中文北風 TO DISK='C:\BB\北風差異2.bak' WITH DIFFERENTIAL;

------------------------------------------------------------------------------------
SELECT * INTO 中文北風.dbo.新供應商 FROM 中文北風.dbo.供應商;
/*
利用「離線」，模擬資料庫損毀 (離線→刪除mdf)
若該資料庫的Log檔案，尚有「結尾交易」未備份，SQLServer會強制要求備份「結尾交易」，方可進行還原
*/
--RESTORE DATABASE 中文北風 FROM DISK='C:\BB\北風完整.bak'

--備份結尾交易紀錄   不論有幾份備份，都要加WITH NORECOVERY
BACKUP LOG 中文北風 TO DISK='C:\BB\北風交易尾.bak' WITH NO_TRUNCATE;

--交易紀錄(有幾份一次復原幾份) (最後要是RECOVERY)
RESTORE DATABASE 中文北風 FROM DISK='C:\BB\北風完整.bak' WITH NORECOVERY;
RESTORE DATABASE 中文北風 FROM DISK='C:\BB\北風差異2.bak' WITH NORECOVERY;
RESTORE DATABASE 中文北風 FROM DISK='C:\BB\北風交易尾.bak' WITH RECOVERY;


-----------------------------------------------------------------------------------------------------------
SELECT * FROM sys.databases;
SELECT [database_id],[name],A.is_master_key_encrypted_by_server FROM sys.databases AS A;

--1. 必須 master 資料庫，產生DMK(Database Master Key)
USE [master]
CREATE MASTER KEY ENCRYPTION BY PASSWORD='XxYy789';

--2. 產生憑證
USE [master]
CREATE CERTIFICATE 透明加密憑憑
	WITH SUBJECT='透明式加密所使用的憑證',EXPIRY_DATE='9999-12-31';

--3. 在資料庫中設定「透明式加密」
USE [練習]
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE [透明加密憑憑]
GO

--4. 在資料庫設定 啟用/停用「透明式加密」
ALTER DATABASE [練習] SET ENCRYPTION ON
GO

SELECT [database_id],[name],A.[is_master_key_encrypted_by_server],A.[is_encrypted] FROM sys.databases AS A;


BACKUP DATABASE 練習 TO DISK='C:\BB\練習完整壓.bak' WITH COMPRESSION;

--錯誤操作
DROP TABLE 練習.dbo.歷史交易紀錄;
DROP TABLE 練習.dbo.歷史交易記錄2;

RESTORE HEADERONLY FROM DISK='C:\BB\練習完整壓.bak';
RESTORE FILELISTONLY FROM DISK='C:\BB\練習完整壓.bak';

--RESTORE DATABASE 練習2 FROM DISK='C:\BB\練習完整壓.bak' WITH RECOVERY;

--還原成新資料庫，並搬移至新位置
RESTORE DATABASE 練習2 FROM DISK='C:\BB\練習完整壓.bak'
WITH MOVE '練習Data' TO 'C:\練習2家\練習2主.mdf'
	,MOVE '練習Log' TO 'C:\練習2家\練習2記.mdf',RECOVERY;


SELECT * INTO 練習.dbo.歷史交易紀錄 FROM 練習2.dbo.歷史交易紀錄;
SELECT * INTO 練習.dbo.歷史交易紀錄2 FROM 練習2.dbo.歷史交易記錄2;

DROP DATABASE 練習2;

-------------------------------------------------------------------------
ALTER DATABASE 練習 SET RECOVERY FULL; 

--模擬之前的正常操作
SELECT * INTO 練習.dbo.北風客戶 FROM 中文北風.dbo.客戶;
SELECT * INTO 練習.dbo.北風供應商 FROM 中文北風.dbo.供應商;
SELECT * INTO 練習.dbo.北風產品客戶 FROM 中文北風.dbo.產品類別;

--錯誤操作
DROP TABLE 練習.dbo.員工表;
DROP TABLE 練習.dbo.員工表2;
DROP TABLE 練習.dbo.員工表3;
DELETE FROM 練習.dbo.員工表4;
UPDATE 練習.dbo.北風產品 SET 單價=1000;

--立刻備份交易記錄檔
BACKUP LOG 練習 TO DISK = 'C:\BB\練習交易壓.bak' WITH COMPRESSION,NORECOVERY;

--利用Log備份，還原指定的時間點
RESTORE DATABASE 練習 FROM DISK='C:\BB\練習完整壓.bak' WITH NORECOVERY;
RESTORE DATABASE 練習 FROM DISK='C:\BB\練習交易壓.bak'
		WITH STOPAT='2022-11-24 20:05:00',RECOVERY;

-----------------------------------------------------------------------------
--快照

EXEC sp_helpdb '練習'
EXEC sp_helpdb '新新'

USE [新新]
SELECT * FROM sys.sysfiles;

CREATE DATABASE 新新快照
ON
( NAME='新新主檔',FILENAME='C:\快照家\新新照主.mdf'),
( NAME='人事1',FILENAME='C:\快照家\人事1照.ndf'),
( NAME='人事2',FILENAME='C:\快照家\人事2照.ndf'),
( NAME='行銷1',FILENAME='C:\快照家\行銷1照.ndf'),
( NAME='會計1',FILENAME='C:\快照家\會計1照.ndf')
AS SNAPSHOT OF [新新]
GO


SELECT * FROM [新新快照].[dbo].[新巨巨];
SELECT * FROM [新新].[dbo].[新巨巨];

UPDATE [新新].[dbo].[新巨巨] SET  產品名 = '貴雪魚',售價=40 WHERE 產品編號=20;
DELETE FROM [新新].[dbo].[新巨巨] WHERE 產品編號=6;

UPDATE A
SET A.產品名=B.產品名,A.售價=B.售價
FROM [新新].[dbo].[新巨巨] AS A JOIN [新新快照].[dbo].[新巨巨] AS B ON A.產品編號=B.產品編號
WHERE B.產品編號=5;



--利用快照資料庫，直接還原 原資料庫(有記憶體表的不能使用此功能)
--還原過程中，使用者不能使用
USE [master];
RESTORE DATABASE [新新] FROM DATABASE_SNAPSHOT='新新快照';

DROP DATABASE [新新快照];

----------------------------------------------------------------------------------------------------------
--系統資料庫
EXEC sp_helpdb

/* 系統資料庫
master 必須備份 
msdb   必須備份 
model  備份與否，自行決定，其他台SQLServer 也有
temdb  無須備份
*/

BACKUP DATABASE [master] TO DISK='C:\BB\master完整.bak';
BACKUP DATABASE [msdb] TO DISK='C:\BB\msdb完整.bak';

RESTORE DATABASE [master] FROM DISK='C:\BB\master完整.bak';--失敗

--將SQLServer啟動為「單一使用者」執行個體模式
--組態管理員→執行個體→屬性→啟動參數→「-m」→重新啟動SQLServer

RESTORE DATABASE [master] FROM DISK='C:\BB\master完整.bak' WITH REPLACE;
RESTORE DATABASE [msdb] FROM DISK='C:\BB\msdb完整.bak' WITH REPLACE;

--組態管理員→執行個體→屬性→啟動參數→「-m」→重新啟動SQLServer
