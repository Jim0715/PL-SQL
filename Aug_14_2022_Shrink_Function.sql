/*
Shrink 功能目標
1. 搬家
2. 併檔
*/
EXEC sp_helpdb '彩虹';
GO
select * from sys.database_files

USE [彩虹]
GO
DBCC SHRINKDATABASE(N'彩虹',60)
--僅僅是將空間給收縮了，並沒有做善後處理，數據庫文件的碎片只能是更多了
GO

DBCC SHRINKFILE (N'服管3',10)   --縮減空白檔案的預設大小
GO

--將將指定檔案中資料移轉並刪除檔案
--EMPTYFILE 會將指定檔案中資料移轉至同一檔案群組中的其他檔案
DBCC SHRINKFILE(N'服管3',EMPTYFILE)
GO
ALTER DATABASE [彩虹] REMOVE FILE [服管3]; 
GO
DBCC SHRINKFILE(N'服管2',EMPTYFILE)
GO
ALTER DATABASE [彩虹] REMOVE FILE [服管2]; 
GO
DBCC SHRINKFILE(N'人資2',EMPTYFILE)
GO
ALTER DATABASE [彩虹] REMOVE FILE [人資2]; 
GO

--創建資料庫子檔，並新增新群組
ALTER DATABASE [彩虹] ADD FILE
(
	NAME='服管2',FILENAME='C:\彩虹\H\服2.ndf',
	SIZE=10MB,FILEGROWTH=40%
) TO FILEGROUP [服管群]
GO

ALTER DATABASE [彩虹] ADD FILEGROUP [數專群]
GO
ALTER DATABASE [彩虹] ADD FILE
(
	NAME='行銷1',FILENAME='C:\彩虹\I\行1.ndf',
	SIZE=20MB,FILEGROWTH=30%
) TO FILEGROUP [數專群]
GO
