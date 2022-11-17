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
