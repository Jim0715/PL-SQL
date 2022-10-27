--建立一個對應 Windows 帳戶的Login
CREATE LOGIN [MB-201-21\MB-201] FROM WINDOWS;

--建立一個對應 Windows 群組帳戶的Login
CREATE LOGIN [MB-201-21\製造部] FROM WINDOWS;

--建立一個 SQL驗證 的 Login
CREATE LOGIN [Jim] WITH PASSWORD= '1234';

--SQL 驗證，執行後要重新啟動SQL
USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
GO

--建立一個 SQL驗證 的 Login，並借用Windows密碼安全性
CREATE LOGIN [Minnie] WITH PASSWORD='XxYy789' MUST_CHANGE, CHECK_POLICY=ON, CHECK_EXPIRATION=ON; 

--建立一個 SQL驗證 的 Login，並且不借用Windows密碼安全性
CREATE LOGIN [Goofy] WITH PASSWORD='1234', CHECK_POLICY=OFF; 


EXEC sp_helplogins;
EXEC sp_helplogins 'Jim';
EXEC sp_helplogins 'MB-201-21\MB-201';

--G 群組 S SQL驗證 U 使用者驗證
SELECT * FROM sys.server_principals;
SELECT * FROM sys.server_principals WHERE [type]='S';
SELECT * FROM sys.server_principals WHERE [type]='G';
SELECT * FROM sys.server_principals WHERE [type]='S';

