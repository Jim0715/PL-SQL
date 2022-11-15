/* 監控、觀察 SQLServer
即時
1. 活動監視器
2. SQL Profiler
3. 擴充事件(Profiler二代)



記錄 / 日後查閱
1. SQL Profiler
2. 擴充事件(Profiler二代)



7. Query Store (查詢存放區)
https://learn.microsoft.com/zh-tw/sql/relational-databases/performance/tune-performance-with-the-query-store?view=sql-server-ver16

*/  

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

EXEC sp_who;
EXEC sp_who2;


SELECT * FROM sys.dm_exec_sessions;
SELECT * FROM sys.dm_exec_sessions WHERE [session_id]>50 AND [login_name]<>'sa';
SELECT * FROM sys.dm_exec_connections;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--將Profiler Trace追蹤檔 轉成Table
SELECT * FROM fn_trace_gettable(N'C:\CC\我的追蹤.trc',DEFAULT);
SELECT * INTO #TT FROM fn_trace_gettable(N'C:\CC\我的追蹤.trc',DEFAULT);

SELECT * FROM #TT WHERE [LoginName] IS NOT NULL;
SELECT * FROM #TT WHERE [LoginName]='Mickey';
SELECT * FROM #TT WHERE [Duration]>=3000;
SELECT * FROM #TT WHERE [Duration]>=3000 AND [TextData] IS NOT NULL;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM sys.fn_xe_file_target_read_file(N'C:\CC\查過_練練_巨巨_匠匠_追蹤_0_133129842571540000.xel', NULL, NULL, NULL);
SELECT * INTO #TT FROM sys.fn_xe_file_target_read_file(N'C:\CC\查過_練練_巨巨_匠匠_追蹤_0_133129842571540000.xel', NULL, NULL, NULL);
SELECT * FROM #TT;


SELECT DATEADD(HOUR,8,[timestamp_utc]) AS 發生時間
	,CONVERT(XML,[event_data]) AS 事件
FROM #TT;
	
SELECT 
	CONVERT(XML,[event_data]).value('(event/@timestamp)[1]','DATETIME2') AS 發生時間	
	,CONVERT(XML,[event_data]).value('(event/action[@name="username"]/value)[1]','NVARCHAR(1024)') AS 帳號
	,CONVERT(XML,[event_data]).value('(event/action[@name="client_app_name"]/value)[1]','NVARCHAR(1024)') AS 應用程式
	,CONVERT(XML,[event_data]).value('(event/data[@name="batch_text"]/value)[1]','NVARCHAR(1024)') AS SQL語法
	,CONVERT(XML,[event_data]).value('(event/data[@name="duration"]/value)[1]','INT') AS 總耗時	
FROM #TT

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--稽核(Audit)

USE [master]
GO

CREATE SERVER AUDIT [我的稽核結果(事件檢視)]
TO APPLICATION_LOG WITH (QUEUE_DELAY = 1000, ON_FAILURE = FAIL_OPERATION)
GO

CREATE SERVER AUDIT [我的稽核結果(檔案)]
TO FILE 
(	FILEPATH = N'C:\CC'
	,MAXSIZE = 500 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE)
GO

---------------------------------

--伺服器層級稽核

USE [master]
GO

CREATE SERVER AUDIT SPECIFICATION [Login帳號稽核]
FOR SERVER AUDIT [我的稽核結果(事件檢視)]
ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
ADD (SERVER_PERMISSION_CHANGE_GROUP)
GO


ALTER SERVER AUDIT [我的稽核結果(事件檢視)] WITH (STATE=ON);
ALTER SERVER AUDIT SPECIFICATION [Login帳號稽核] WITH (STATE=ON);

---------------------------------

--資料庫層級稽核

USE [練練]
GO

CREATE DATABASE AUDIT SPECIFICATION [查過巨巨_匠匠]
FOR SERVER AUDIT [我的稽核結果(檔案)]
ADD (SELECT ON OBJECT::[dbo].[匠匠] BY [public]),
ADD (SELECT ON OBJECT::[dbo].[巨巨] BY [public])
GO

USE [master]
ALTER SERVER AUDIT [我的稽核結果(檔案)] WITH (STATE=ON);
GO

USE [練練]
ALTER DATABASE AUDIT SPECIFICATION [查過巨巨_匠匠] WITH (STATE=ON);
GO


---------------------------------


SELECT * FROM fn_get_audit_file('C:\CC\我的稽核結果(檔案)_07874EA4-339B-4B36-840C-D7C2AED29B9A_0_133129891408380000.sqlaudit',NULL,NULL);
SELECT * INTO #TT FROM fn_get_audit_file('C:\CC\我的稽核結果(檔案)_07874EA4-339B-4B36-840C-D7C2AED29B9A_0_133129891408380000.sqlaudit',NULL,NULL);

SELECT * FROM #TT;
SELECT A.event_time
	,A.succeeded
	,A.server_principal_name
	,A.database_principal_name
	,A.[statement]
FROM #TT AS A
WHERE A.succeeded=0;
