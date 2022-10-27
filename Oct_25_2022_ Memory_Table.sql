/*記憶體表
1. 不支援交易行為
2. 等同 隔離等級 UNCOMMITTED
3. 若需要交易行為或超高效能，請搭配「原生編譯」預存程序
4. 記憶體表不支援「Truncate Table」，若需清空記憶體表資料，只能乖乖Delete

5. 記憶體表沒版法製作叢集索引，記憶體表本身的資料就是亂的(記憶體)
*/


ALTER DATABASE 新新
	ADD FILEGROUP [記憶體群] CONTAINS MEMORY_OPTIMIZED_DATA;

ALTER DATABASE 新新 ADD FILE
(NAME = '記憶1',FILENAME='C:\新新家\MM')
TO FILEGROUP [記憶體群];

USE [新新];

ALTER DATABASE [新新] MODIFY FILEGROUP [行銷群] READ_WRITE;


CREATE TABLE [dbo].[SQL普通] (
  c1 INT NOT NULL PRIMARY KEY,
  c2 NCHAR(48) NOT NULL
)
ON [行銷群]
GO

CREATE TABLE [dbo].[記憶1] (
  c1 INT NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),
  c2 NCHAR(48) NOT NULL
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_AND_DATA);		-- SCHEMA_ONLY | SCHEMA_AND_DATA
GO

CREATE TABLE [dbo].[記憶2] (
  c1 INT NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),
  c2 NCHAR(48) NOT NULL
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_AND_DATA);
GO


---------------------------------------------------------------------------
SET STATISTICS TIME OFF;
SET NOCOUNT ON;

DECLARE @starttime datetime2 = sysdatetime();
DECLARE @timems INT;
DECLARE @i INT = 1
DECLARE @rowcount INT = 1000000
DECLARE @c NCHAR(48) = N'12345678901234567890123456789012345678'

BEGIN TRAN;
  WHILE @I <= @rowcount
  BEGIN
    INSERT INTO [dbo].[SQL普通](c1,c2) VALUES (@i, @c)
    SET @i += 1
  END;
COMMIT;


SET @timems = datediff(ms, @starttime, sysdatetime());
SELECT 'Disk-based table and interpreted Transact-SQL: ' + CAST(@timems AS VARCHAR(10)) + ' ms';

---------------------------------------------------------------------------
DECLARE @starttime datetime2 = sysdatetime();
DECLARE @timems INT;
DECLARE @i INT = 1
DECLARE @rowcount INT = 1000000
DECLARE @c NCHAR(48) = N'12345678901234567890123456789012345678'

BEGIN TRAN
  WHILE @i <= @rowcount
    BEGIN
      INSERT INTO [dbo].[記憶1](c1,c2) VALUES (@i, @c);
      SET @i += 1;
    END;
COMMIT;


SET @timems = datediff(ms, @starttime, sysdatetime());
SELECT ' memory-optimized table w/ hash index and interpreted Transact-SQL: ' + CAST(@timems as VARCHAR(10)) + ' ms';

---------------------------------------------------------------------------

--原生編譯 預存程序
CREATE PROCEDURE [dbo].[usp_InsertMemoryData] @rowcount INT, @c NCHAR(48)
  WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
  AS 
	BEGIN ATOMIC 
	  WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'us_english')
	  DECLARE @i INT = 1;

	  WHILE @i <= @rowcount
	  BEGIN;
		INSERT INTO [dbo].[記憶2](c1,c2) VALUES (@i, @c);
		SET @i += 1;
	  END;
	END;
GO

---------------------------------------------------------------------------
--5.313
SET STATISTICS TIME OFF;
SET NOCOUNT ON;


DECLARE @starttime datetime2 = sysdatetime();
DECLARE @timems INT;
DECLARE @i INT = 1
DECLARE @rowcount INT = 1000000
DECLARE @c NCHAR(48) = N'12345678901234567890123456789012345678'

EXEC usp_InsertMemoryData @rowcount, @c;

SET @timems = datediff(ms, @starttime, sysdatetime());
SELECT 'memory-optimized table w/hash index and native SP:' + CAST(@timems as varchar(10)) + ' ms';

-----------------------------------------------------------------------------------------------------------

SELECT * FROM [SQL普通];	--11.11
SELECT * FROM [記憶1];		--4.5
SELECT * FROM [記憶2];		--4.5


SELECT * FROM [SQL普通] WHERE [c1]=786543;		--0.00328
SELECT * FROM [記憶1] WHERE [c1]=786543;		--0.0000175
SELECT * FROM [記憶2] WHERE [c1]=786543;		


SELECT * FROM [SQL普通] WHERE [c1]>=786541 AND [c1]<=786545;		--0.00328
SELECT * FROM [記憶1] WHERE [c1]>=786541 AND [c1]<=786545;		--3.122
SELECT * FROM [記憶2] WHERE [c1]>=786541 AND [c1]<=786545;		--3.122
SELECT * FROM [記憶2] WHERE [c1] IN(786541,786542,786543,786544,786545);   --0.0825

----------------------------------------------------------------------------------------
DROP TABLE [dbo].[記憶1];

CREATE TABLE [dbo].[記憶1] (
  c1 INT NOT NULL PRIMARY KEY NONCLUSTERED,
  c2 NCHAR(48) NOT NULL
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_AND_DATA);
GO

-----

DECLARE @starttime datetime2 = sysdatetime();
DECLARE @timems INT;
DECLARE @i INT = 1
DECLARE @rowcount INT = 1000000
DECLARE @c NCHAR(48) = N'12345678901234567890123456789012345678'

BEGIN TRAN
  WHILE @i <= @rowcount
    BEGIN
      INSERT INTO [dbo].[記憶1](c1,c2) VALUES (@i, @c);
      SET @i += 1;
    END;
COMMIT;

SET @timems = datediff(ms, @starttime, sysdatetime());
SELECT ' memory-optimized table w/ hash index and interpreted Transact-SQL: ' + CAST(@timems as VARCHAR(10)) + ' ms';


SELECT * FROM [SQL普通];	--11.11
SELECT * FROM [記憶1];		--4.5
SELECT * FROM [記憶2];		--4.5

SELECT * FROM [SQL普通] WHERE [c1]=786543;		--0.00328
SELECT * FROM [記憶1] WHERE [c1]=786543;		--0.0004596
SELECT * FROM [記憶2] WHERE [c1]=786543;		--0.0000175

SELECT * FROM [SQL普通] WHERE [c1]>=786541 AND [c1]<=786545;	--0.00328
SELECT * FROM [記憶1] WHERE [c1]>=786541 AND [c1]<=786545;		--0.000534
SELECT * FROM [記憶2] WHERE [c1]>=786541 AND [c1]<=786545;		--3.122

SELECT * FROM [SQL普通] WHERE [c1]>=786541 AND [c1]<=786545 ORDER BY [c1] ASC;	--0.00328
SELECT * FROM [SQL普通] WHERE [c1]>=786541 AND [c1]<=786545 ORDER BY [c1] DESC;	--0.00328
SELECT * FROM [記憶1] WHERE [c1]>=786541 AND [c1]<=786545 ORDER BY [c1] ASC;	--0.000534
SELECT * FROM [記憶1] WHERE [c1]>=786541 AND [c1]<=786545 ORDER BY [c1] DESC;	--0.0119
