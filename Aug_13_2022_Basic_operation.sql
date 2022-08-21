--建立資料庫
CREATE DATABASE raidow;		
GO

--刪除資料庫
DROP DATABASE [raidow]      
GO

EXECUTE sp_detach_db '訓練';                           --資料庫卸離
EXECUTE sp_attach_db '訓練','C:\訓練家\訓練資料.mdf';   --資料庫附加

EXEC sp_helpfile; --查看資料庫中的檔案
SELECT * FROM sys.sysfiles;  --查看資料庫中的檔案細部資訊
EXEC sp_helpfilegroup;  --查看資料庫中的群組
SELECT * FROM sys.filegroups;  --查看資料庫中的群組細部資訊
SELECT * FROM sys.databases;   --查看server上的有哪些資料庫

EXEC xp_enumerrorlogs       --確認目前的Error Log
EXECUTE sp_cycle_errorlog;  --刪除錯誤記錄檔 最多保留六份
EXEC sp_cycle_errorlog;     --簡寫


--創建新的資料庫Data和記錄檔前，要先創建資料夾
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
	NAME='服管1',FILENAME='C:\彩虹\E\服1.ndf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=40%	
),
(
	NAME='服管2',FILENAME='C:\彩虹\F\服2.ndf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=40%	
),
(
	NAME='服管3',FILENAME='C:\彩虹\G\服3.ndf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=40%	
),
FILEGROUP 人資群
(
	NAME='人資1',FILENAME='C:\彩虹\H\人1.ndf',
	SIZE=15MB,MAXSIZE=UNLIMITED,FILEGROWTH=50%	
),
(
	NAME='人資2',FILENAME='C:\彩虹\I\人2.ndf',
	SIZE=15MB,MAXSIZE=UNLIMITED,FILEGROWTH=50%	
)

LOG ON
(
	NAME='彩虹紀錄',FILENAME='C:\彩虹\J\紅記.ldf',
	SIZE=50MB,MAXSIZE=UNLIMITED,FILEGROWTH=30%	
)


--使用指定資料庫
USE [彩虹]
GO


--創建資料庫前，要先新建資料夾
CREATE DATABASE 訓練
ON PRIMARY
(
	NAME='訓練Data',FILENAME='c:\訓練家\訓練資料.mdf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=30MB
)
LOG ON
(
	NAME='訓練Log',FILENAME='C:\訓練家\訓練紀錄.ldf',
	SIZE=30MB,MAXSIZE=UNLIMITED,FILEGROWTH=50%
)


/* 有 User 正在使用時，以下動作無法執行
1. 刪除
2. 離線
3. 卸離
4. 還原
5. 某些設定不得調整
*/

--當有使用者仔使用時，使用此方式卸離資料庫
--設定資料庫為SINGLE_USER模式
ALTER DATABASE [彩虹] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
--先將資料庫切換到非要卸離的資料庫
USE master
GO
--卸載資料庫
EXEC sp_detach_db '彩虹';
GO

--設定資料庫為MULTI_USER
ALTER DATABASE [新新] SET MULTI_USER;


ALTER DATABASE [彩虹] SET ONLINE;   --資料庫連線
GO
ALTER DATABASE [彩虹] SET OFFLINE;  --資料庫離線
GO


EXEC sp_helpdb '彩虹';     --查詢資料庫內容
EXEC sp_detach_db '彩虹';  --資料庫卸載
EXEC sp_attach_db '彩虹','C:\彩虹\D\紅主.mdf',                              --附加主資料庫和多個副資料庫
		'C:\彩虹\E\服1.ndf','C:\彩虹\E\服2.ndf','C:\彩虹\E\服3.ndf',
		'C:\彩虹\F\人1.ndf','C:\彩虹\F\人2.ndf','C:\彩虹\G\紅記.ldf';
GO

CREATE DATABASE [彩虹]           --附加主資料庫和多個副資料庫
ON
(FILENAME='C:\彩虹\D\紅主.mdf'),
(FILENAME='C:\彩虹\E\服1.ndf'),
(FILENAME='C:\彩虹\F\服2.ndf'),
(FILENAME='C:\彩虹\G\服3.ndf'),
(FILENAME='C:\彩虹\H\人1.ndf'),
(FILENAME='C:\彩虹\I\人2.ndf'),
(FILENAME='C:\彩虹\J\紅記.ldf')
FOR ATTACH;
GO


ALTER DATABASE [彩虹] MODIFY FILEGROUP [服管群] DEFAULT;  --將此群組設為預設
ALTER DATABASE [彩虹] MODIFY FILEGROUP [數專群] READ_ONLY;  --將不能對此群組做任何事情。只能檢查錯誤


ALTER DATABASE [彩虹] SET RECOVERY SIMPLE; --備份復原用的檔案
ALTER DATABASE [彩虹] SET ANSI_NULLS ON; --當您建立或變更計算資料行索引或索引檢視表時，ANSI_NULLS 也必須是 ON
ALTER DATABASE [彩虹] SET ANSI_NULL_DEFAULT ON; --如果未明確指定資料行的 Null 屬性狀態，ALTER TABLE 和 CREATE TABLE 陳述式所建立的新資料行會接受 Null 值
