--新增已有資料的資料庫和記錄檔
EXEC sp_attach_db
'AdventureWorks2012','C:\資料庫檔\AdventureWorks2012_Data.mdf',
'C:\資料庫檔\AdventureWorks2012_log.ldf';
EXEC sp_attach_db
'中文北風','C:\資料庫檔\中文北風.mdf','C:\資料庫檔\中文北風_log.ldf';
EXEC sp_attach_db
'練練','C:\資料庫檔\練練.mdf','C:\資料庫檔\練練_log.ldf';

SELECT * FROM sys.databases;

--COMPATIBILITY_LEVEL這是要與資料庫建立相容的SQL Server版本
ALTER DATABASE [AdventureWorks2012] SET COMPATIBILITY_LEVEL=120;

