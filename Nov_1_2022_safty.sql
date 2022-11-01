--建立一個對應 Windows 帳戶的 Login
CREATE LOGIN [MB-201-00\John] FROM WINDOWS;

--建立一個對應 Windows 群組帳戶的 Login
CREATE LOGIN [MB-201-00\營建課] FROM WINDOWS;

--建立一個 SQL驗證 的 Login
CREATE LOGIN [Mickey] WITH PASSWORD='1234';


USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
GO


--建立一個 SQL驗證 的 Login，並借用Windows密碼安全性
CREATE LOGIN [Minnie] WITH PASSWORD='XxYy789' MUST_CHANGE, CHECK_POLICY=ON, CHECK_EXPIRATION=ON; 

--建立一個 SQL驗證 的 Login，並且不借用Windows密碼安全性
CREATE LOGIN [Goofy] WITH PASSWORD='1234', CHECK_POLICY=OFF; 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

EXEC sp_helplogins;
EXEC sp_helplogins 'Mickey';
EXEC sp_helplogins 'MB-201-00\John';

SELECT * FROM sys.server_principals;
SELECT * FROM sys.server_principals WHERE [type]='U';
SELECT * FROM sys.server_principals WHERE [type]='G';
SELECT * FROM sys.server_principals WHERE [type]='S';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--解除 SQL驗證Login 鎖定，並重新設新密碼，下次變更
ALTER LOGIN [Minnie] WITH PASSWORD='XxYy789' MUST_CHANGE UNLOCK;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
sysadmin
securityadmin	CREATE / ALTER / DROP Login
serveradmin	修改、調整 伺服器 的設定值
setupadmin	設定 此伺服器個體的對外連線  (連結伺服器、複寫個體)
processadmin	處理連線用戶 (Process)(處理序、連線) 
diskadmin	處理、調整 磁碟儲存
dbcreator	CREATE / ALTER / DROP 任何DB
bulkadmin	Bulk(匯入)  專職匯入工作
*/


--將指定Login，加入/移除 伺服器角色中
EXEC sp_addsrvrolemember 'Mickey','dbcreator';
EXEC sp_addsrvrolemember 'Mickey','securityadmin';
EXEC sp_addsrvrolemember 'Minnie','securityadmin';

EXEC sp_dropsrvrolemember 'Mickey','dbcreator';
EXEC sp_dropsrvrolemember 'Mickey','securityadmin';
EXEC sp_dropsrvrolemember 'Minnie','securityadmin';


--查詢指定伺服器角色中的成員
EXEC sp_helpsrvrolemember 'securityadmin';
EXEC sp_helpsrvrolemember 'dbcreator';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE 練練

--建立 同名對應 的使用者帳號
CREATE USER [Minnie];
--建立對應 指定Login 的使用者帳號
CREATE USER [Mouse] FROM LOGIN [Mickey];

/*
CREATE LOGIN [考試院\會計室] FROM WINDOWS;
CREATE USER [Accts] FROM LOGIN [考試院\會計室];
*/


USE 中文北風;
CREATE USER [Mouse] FROM LOGIN [Mickey];

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*  SQL 語法的分類
DDL：CREATE、ALTER、DROP
DML：INSERT、UPDATE、DELTE
DCL：GRANT、REVOKE、DENY
TCL：BEGIN TRAN、COMMIT、ROLLBACK
DQL：SELECT
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--查詢資料庫角色
EXEC sp_helprole;
SELECT * FROM sys.database_principals WHERE [type]='R';

/*
db_owner		在此資料庫中的最大能力角色
db_accessadmin		CREATE / ALTER / DROP User帳戶
db_securityadmin	GRANT / DENY / REVOKE User權限能力
db_ddladmin		CREATE / ALTER / DROP 的能力
db_backupoperator	備份資料庫的能力
db_datareader		可Select此資料庫中的所有資料
db_datawriter		可INSERT、UPDATE、DELTE此資料庫中的所有資料
db_denydatareader	不可Select此資料庫中的所有資料
db_denydatawriter	不可INSERT、UPDATE、DELTE此資料庫中的所有資料
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--將指定User，加入/移除 資料庫角色中
EXEC sp_addrolemember 'db_datareader','Mouse';
EXEC sp_addrolemember 'db_datawriter','Mouse';
EXEC sp_addrolemember 'db_datareader','Minnie';

EXEC sp_droprolemember 'db_datareader','Mouse';
EXEC sp_droprolemember 'db_datawriter','Mouse';
EXEC sp_droprolemember 'db_datareader','Minnie';


--查詢指定資料庫角色中的成員
EXEC sp_helprolemember 'db_datawriter';
EXEC sp_helprolemember 'db_datareader'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

EXEC sp_helplogins;
EXEC sp_helplogins 'Mickey';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--自訂資料庫角色
CREATE ROLE [資訊人員];
EXEC sp_addrolemember 'db_datareader','資訊人員';
EXEC sp_addrolemember 'db_datawriter','資訊人員';
EXEC sp_addrolemember 'db_backupoperator','資訊人員';

EXEC sp_addrolemember '資訊人員','Mouse';
EXEC sp_addrolemember '資訊人員','Minnie';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM sys.database_principals;
SELECT * FROM sys.database_role_members;

SELECT 
	(SELECT [name] FROM sys.database_principals WHERE [principal_id]=A.role_principal_id) AS 角色
	,(SELECT [name] FROM sys.database_principals WHERE [principal_id]=A.member_principal_id) AS 成員
FROM sys.database_role_members AS A;



CREATE VIEW 角色成員一覽
AS
	SELECT 
		(SELECT [name] FROM sys.database_principals WHERE [principal_id]=A.role_principal_id) AS 角色
		,(SELECT [name] FROM sys.database_principals WHERE [principal_id]=A.member_principal_id) AS 成員
	FROM sys.database_role_members AS A;
GO

SELECT * FROM 角色成員一覽;
SELECT * FROM 角色成員一覽 WHERE [角色]='db_datareader';
SELECT * FROM 角色成員一覽 WHERE [成員]='Mouse';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* ISO DCL語法
GRANT 權限1,權限2,....		GRANT | DENY | REVOKE
ON 物件
TO 對象
*/

GRANT SELECT,INSERT
ON [巨巨]
TO [Mouse];

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--權限 反向配置
--權限衝突時，「拒絕」大於「允許」
EXEC sp_addrolemember 'db_datareader','Minnie';
DENY SELECT ON [巨巨] TO [Minnie];
DENY SELECT ON [匠匠] TO [Minnie];

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GRANT SELECT,INSERT ON [巨巨] TO [Mouse];
GRANT SELECT,INSERT ON [巨巨] TO [資訊人員];

GRANT INSERT,SELECT ON 巨巨 TO Minnie;
DENY UPDATE,DELETE ON 巨巨 TO Minnie;
GRANT SELECT ON 巨巨 TO Mouse;
DENY DELETE ON 巨巨 TO Mouse;
GRANT SELECT ON 匠匠 TO Minnie;
DENY INSERT,UPDATE,DELETE ON 匠匠 TO Minnie;
GRANT INSERT,SELECT ON 匠匠 TO Mouse;
DENY DELETE ON 匠匠 TO Mouse


EXEC sp_helprotect NULL,NULL,NULL,'o';
EXEC sp_helprotect '巨巨',NULL,NULL,'o';
EXEC sp_helprotect NULL,'Mouse',NULL,'o';
