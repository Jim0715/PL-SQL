--建立資料庫
CREATE DATABASE raidow;		
GO

--卸離資料庫
DROP DATABASE [raidow]      
GO

EXEC xp_enumerrorlogs       --確認目前的Error Log
EXECUTE sp_cycle_errorlog;  --刪除錯誤記錄檔 最多保留六份
EXEC sp_cycle_errorlog;     --簡寫


--創建新的資料庫Data和記錄檔
CREATE DATABASE raidow   
ON PRIMARY
(
	NAME='RAIDOW_data',FILENAME='C:\raidow\raidow_data.mdf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=30%  -- UNLIMITED指定檔案可成長直到磁碟已滿
)
LOG ON
(
	NAME='RAIDOW_Log',FILENAME='C:\raidow\raidow_rec.ldf',
	SIZE=30MB,MAXSIZE=UNLIMITED,FILEGROWTH=50%
)


--創建資料庫並加以分群
CREATE DATABASE[彩虹]
ON PRIMARY
(
	NAME='彩虹主檔',FILENAME='C:\彩虹\D\紅主.mdf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=30%
),
FILEGROUP 服管群
(
	NAME='服管1',FILENAME='C:\彩虹\E\服1.mdf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=40%	
),
(
	NAME='服管2',FILENAME='C:\彩虹\F\服2.mdf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=40%	
),
(
	NAME='服管3',FILENAME='C:\彩虹\G\服3.mdf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=40%	
),
FILEGROUP 人資群
(
	NAME='人資1',FILENAME='C:\彩虹\H\人1.mdf',
	SIZE=15MB,MAXSIZE=UNLIMITED,FILEGROWTH=50%	
),
(
	NAME='人資2',FILENAME='C:\彩虹\I\人2.mdf',
	SIZE=15MB,MAXSIZE=UNLIMITED,FILEGROWTH=50%	
)

LOG ON
(
	NAME='彩虹紀錄',FILENAME='C:\彩虹\J\紅記.mdf',
	SIZE=50MB,MAXSIZE=UNLIMITED,FILEGROWTH=30%	
)


EXEC sp_helpdb;               --查看所有資料庫的描述
EXEC sp_helpdb '彩虹';        --查看特定資料庫的描述
SELECT * FROM sys.databases;  --查看系統上有哪些資料庫


--使用指定資料庫
USE [彩虹]
GO

EXEC sp_helpfilegroup;         --查看有哪些群組
SELECT * FROM sys.filegroups;  --查看群組細部內容

EXEC sp_helpfile;              --查看資料庫中有哪些檔案
SELECT * FROM sys.sysfiles;    --查看檔案的細部內容
