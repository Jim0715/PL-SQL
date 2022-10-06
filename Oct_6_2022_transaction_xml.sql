--巢狀交易

SELECT @@TRANCOUNT
BEGIN TRAN
	SELECT @@TRANCOUNT
	BEGIN TRAN
		SELECT @@TRANCOUNT
	COMMIT
	BEGIN TRAN
		SELECT @@TRANCOUNT

	ROLLBACK
	--COMMIT	

	SELECT @@TRANCOUNT
COMMIT
SELECT @@TRANCOUNT


/*
CREATE PROC 中信轉帳
AS
    BEGIN TRAN
	  ....
	  ....
	COMMIT
GO
CREATE PROC 台北富邦轉帳
AS
    BEGIN TRAN
	  ....
	  ....
	COMMIT
GO

CREATE PROC 跨行轉帳
AS
  BEGIN TRAN
	EXEC 中信轉帳;
	EXEC 台北富邦轉帳;
  COMMIT
GO
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--左邊

USE 練練

SELECT * FROM 巨巨;

BEGIN TRAN
	UPDATE 巨巨 SET 價錢=30 WHERE 產品編號=5;


COMMIT
ROLLBACK

----------------------

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--右邊
USE 練練

SELECT * FROM 巨巨;
SELECT * FROM 巨巨 WHERE 產品編號=25;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--右邊
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

BEGIN TRAN
	SELECT * FROM 巨巨;


COMMIT

--------------------

INSERT INTO 巨巨 VALUES(30,'波卡',35);

UPDATE 巨巨 SET 價錢=50 WHERE 產品編號=5;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
CREATE PROC 關帳結算
AS
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
  SELECT COUNT(*) FROM ...		100
  .....
  .....
  .....
  SELECT SUM(收銀金額) FROM ...
  SELECT AVG(收銀金額) FROM ...		/102
GO

CREATE PROC 列印季報表
AS
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  .....
  .....
  .....
  .....  
GO
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER DATABASE 練練 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE 練練 SET READ_COMMITTED_SNAPSHOT ON;
ALTER DATABASE 練練 SET MULTI_USER;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER DATABASE 練練 SET ALLOW_SNAPSHOT_ISOLATION ON;

--左邊
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRAN
	UPDATE 巨巨 SET 價錢=50 WHERE 產品編號=5;
	SELECT * FROM 巨巨;

COMMIT
ROLLBACK


--右邊
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRAN
	UPDATE 巨巨 SET 價錢=30 WHERE 產品編號=27;
	SELECT * FROM 巨巨;

COMMIT
ROLLBACK


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--左邊
BEGIN TRAN
	UPDATE 巨巨 SET 價錢=60 WHERE 產品編號=5;
	SELECT * FROM 匠匠;


COMMIT
ROLLBACK


--右邊
BEGIN TRAN
	UPDATE 匠匠 SET 價錢=60 WHERE 產品編號=5;
	SELECT * FROM 巨巨;

COMMIT

ALTER DATABASE 練練 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE 練練 SET READ_COMMITTED_SNAPSHOT ON;
ALTER DATABASE 練練 SET MULTI_USER;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ISO XML(SQL2005) / JSON(SQL2016)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE 練習XML

CREATE TABLE 練習XML
(
    編號 INT,
	XML資料 XML
)
ON [人事群]
TEXTIMAGE_ON [會計群];

--Well Form
--INSERT INTO 練習XML VALUES(1,N'<員工資料><員編>1<姓名>王小明</姓名><薪資>30000</薪資></員工資料>');
--INSERT INTO 練習XML VALUES(1,N'<員工資料><員編>1</員編><Name>王小明</name><薪資>30000</薪資></員工資料>');
INSERT INTO 練習XML VALUES(1,N'<員工資料><員編>1</員編><姓名>王小明</姓名><薪資>30000</薪資></員工資料>');

SELECT * FROM 練習XML

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE XML SCHEMA COLLECTION 員工履歷XML格式
AS
 '<xs:schema xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
	<xs:element name="員工">
      <xs:complexType>
	  <xs:sequence>
		<xs:element name="員工編號" type="xs:integer" minOccurs="1" maxOccurs="1"/>
		<xs:element name="姓名" type="xs:string" minOccurs="1" maxOccurs="1"/>
		<xs:element name="性別" type="xs:string" minOccurs="1" maxOccurs="1"/>
		<xs:element name="薪資" type="xs:decimal" minOccurs="1" maxOccurs="1"/>
	  </xs:sequence>
     </xs:complexType>
	</xs:element>
</xs:schema>'
GO

--Valid XML Document

DROP TABLE 練習XML

CREATE TABLE 練習XML
(
    編號 INT,
	XML資料 XML(dbo.員工履歷XML格式)
)
ON [人事群]
TEXTIMAGE_ON [會計群];


--INSERT INTO 練習XML VALUES(1,'<員工><員工編號>1</員工編號><性別>男</性別><姓名>王小明</姓名><薪資>30000</薪資><嗜好>游泳、睡覺</嗜好></員工>');
--INSERT INTO 練習XML VALUES(1,'<員工><員工編號>1</員工編號><姓名>王小明</姓名><性別>男</性別><薪資>30000</薪資><嗜好>游泳、睡覺</嗜好></員工>');
--INSERT INTO 練習XML VALUES(1,'<員工><員工編號>1</員工編號><姓名>王小明</姓名><性別>男</性別><薪資>AAA</薪資><嗜好>游泳、睡覺</嗜好></員工>');
--INSERT INTO 練習XML VALUES(2,'<員工><員工編號>2</員工編號><姓名>李小英</姓名><性別>女</性別><薪資>40000</薪資><興趣>AAA</興趣></員工>');
INSERT INTO 練習XML VALUES(2,'<員工><員工編號>2</員工編號><姓名>李小英</姓名><性別>女</性別><薪資>40000</薪資></員工>');

SELECT * FROM 練習XML

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE XML員工資料
(
  員工號 INT,
  姓名 NCHAR(10),
  性別 NCHAR(2),
  職稱 NCHAR(5),
  薪資 MONEY
)
GO

CREATE TABLE #tempXML
(
  資料 VARCHAR(MAX)
)
GO

--將整份XML資料匯入暫存表中
BULK INSERT #tempXML FROM 'C:\BB\員工資料.xml'
WITH(ROWTERMINATOR='|\n')
/*
SELECT * FROM #tempXML
TRUNCATE TABLE #tempXML
*/

DECLARE @doc VARCHAR(MAX)
DECLARE @pid INT
SELECT @doc=資料 FROM #tempXML
EXEC sp_xml_preparedocument @pid OUTPUT,@doc

INSERT INTO XML員工資料(員工號,姓名,性別,職稱,薪資)
  SELECT * FROM OPENXML(@pid,'員工資料集/員工資料')
  WITH
  (
	員工號 INT './員工編號',
	姓名 NCHAR(10) './姓名',
	性別 NCHAR(2) './稱呼',
	職稱 NCHAR(5) './職稱',
	薪資 MONEY './薪資'
  )
  
EXEC sp_xml_removedocument @pid

SELECT * FROM XML員工資料


