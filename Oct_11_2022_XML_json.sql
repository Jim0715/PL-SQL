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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 產品編號,品名,價錢
FROM 巨巨
ORDER BY 產品編號 ASC
FOR XML RAW;

SELECT 產品編號,品名,CAST(價錢 AS MONEY) AS 售價
FROM 巨巨
ORDER BY 產品編號 ASC
FOR XML RAW('產品'),ROOT('巨巨產品');

SELECT 產品編號,品名,CAST(價錢 AS MONEY) AS 售價
FROM 巨巨
ORDER BY 產品編號 ASC
FOR XML RAW('產品'),ROOT('巨巨產品'),ELEMENTS;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 產品編號,品名,CAST(價錢 AS MONEY) AS 售價
FROM 巨巨
ORDER BY 產品編號 ASC
FOR XML AUTO;

SELECT 產品編號,品名,CAST(價錢 AS MONEY) AS 售價
FROM 巨巨
ORDER BY 產品編號 ASC
FOR XML AUTO,ROOT('巨巨產品');

SELECT 產品編號,品名,CAST(價錢 AS MONEY) AS 售價
FROM 巨巨
ORDER BY 產品編號 ASC
FOR XML AUTO,ROOT('巨巨產品'),ELEMENTS;

-----------------------------------------------------------------------------------------------------------------------------------------
SELECT 產品編號 '@產品號',品名 '產品名',CAST(價錢 AS MONEY) '售價'
FROM 巨巨
ORDER BY 產品編號 ASC
FOR XML PATH('產品'),ROOT('巨巨產品');

SELECT 員工編號 '員工號',
	IIF(稱呼='先生','男','女') '個資/@性別',
	姓名 '個資/姓名',
	CAST(出生日期 AS DATE ) '個資/生日',
	職稱 '職務/@職位',
	CAST(雇用日期 AS DATE) '職務/到期日',
	薪資 '職務/薪水'
FROM 員工
FOR XML PATH('員工'),ROOT('員工資料')

------------------------------------------------------------------------------------------------------------------------------
--query
SELECT 資料.query ('dataroot/產品清單/產品')
FROM 產品型錄 WHERE 編號=1;

--可搭配 IOS W3 XQuery(FLOOR)
--for、let、order by、where、return
SELECT 資料.query('
		<產品列表>
		{
			for $i in dataroot/產品清單
					return $i/產品
		}
		</產品列表>')
FROM 產品型錄 WHERE 編號=1;


--value
SELECT 資料.value('(dataroot/產品清單/產品)[4]','NVARCHAR(10)') AS 產品名
	,資料.value('(dataroot/產品清單/單價)[4]','MONEY') AS 售價
FROM 產品型錄 WHERE 編號=1;

SELECT 資料.value('(dataroot/產品清單[產品編號=58]/產品)[1]','NVARCHAR(10)') AS 產品名
	,資料.value('(dataroot/產品清單[產品編號=58]/單價)[1]','MONEY') AS 售價
FROM 產品型錄 WHERE 編號=1;

DECLARE @pid INT=58;
SELECT 資料.value('(dataroot/產品清單[產品編號=sql:variable("@pid")]/產品)[1]','NVARCHAR(10)') AS 產品名
	,資料.value('(dataroot/產品清單[產品編號=sql:variable("@pid")]/單價)[1]','MONEY') AS 售價
FROM 產品型錄 WHERE 編號=1;

CREATE PROC XML產品查詢 @pid INT
AS
	SELECT 資料.value('(dataroot/產品清單[產品編號=sql:variable("@pid")]/產品)[1]','NVARCHAR(10)') AS 產品名
		,資料.value('(dataroot/產品清單[產品編號=sql:variable("@pid")]/單價)[1]','MONEY') AS 售價
	FROM 產品型錄 WHERE 編號=1;
GO
EXEC XML產品查詢 58;


--EXIST
--查看有無資料
SELECT 資料.exist('dataroot/產品清單[產品編號=50]/產品')
FROM 產品型錄 WHERE 編號=1;

ALTER PROC XML產品查詢 @pid INT
AS
	IF(SELECT 資料.exist('dataroot/產品清單[產品編號=sql:variable("@pid")]/產品') FROM 產品型錄 WHERE 編號=1)=1
		SELECT 資料.value('(dataroot/產品清單[產品編號=sql:variable("@pid")]/產品)[1]','NVARCHAR(10)') AS 產品名
			,資料.value('(dataroot/產品清單[產品編號=sql:variable("@pid")]/單價)[1]','MONEY') AS 售價
		FROM 產品型錄 WHERE 編號=1;
	ELSE
		SELECT '並未查詢到相關資料' AS 查詢結果
GO

EXEC XML產品查詢 5000;
EXEC XML產品查詢 50;
EXEC XML產品查詢 25;

-------------------------------------------------------------------------------------------------------------------------
UPDATE 產品型錄
  SET 資料.modify('replace value of (dataroot/產品清單[產品="海哲皮"]/產品/text())[1] with "超Q海哲皮"')
WHERE 編號=1;

  
UPDATE 產品型錄
  SET 資料.modify('replace value of (dataroot/產品清單[產品="花枝"]/單價/text())[1] with 35')
WHERE 編號=1;


UPDATE 產品型錄
  SET 資料.modify('delete (dataroot/產品清單[產品="花枝"])[1]')
WHERE 編號=1;


DECLARE @myDoc xml
SET @myDoc = N'<產品清單>
	<產品編號>58</產品編號>
	<產品>大花枝</產品>
	<單位數量>每袋3公斤</單位數量>
	<單價>45</單價>
	<庫存量>62</庫存量>
	<類別名稱>海鮮</類別名稱>
	<供應商>大鈺</供應商>
	</產品清單>'
UPDATE 產品型錄
SET 資料.modify('insert sql:variable("@myDoc") into (dataroot)[1]')
WHERE 編號=1

--------------------------------------------------------------------------------------------------------------------
--JSON
SELECT 產品編號,品名,CAST(價錢 AS MONEY) AS 售價
FROM 巨巨
ORDER BY 產品編號 ASC
FOR JSON AUTO;

SELECT 產品編號,品名,CAST(價錢 AS MONEY) AS 售價
FROM 巨巨
ORDER BY 產品編號 ASC
FOR JSON AUTO,ROOT('巨巨產品');

SELECT 產品編號,品名,CAST(價錢 AS MONEY) AS 售價
FROM 巨巨
ORDER BY 產品編號 ASC
FOR JSON PATH;

--------------------------------------------------------------------------------------------------------------------------
DECLARE @json NVARCHAR(MAX)
SET @json = '{"name":"John","surname":"Doe","age":45,"skills":["SQL","C#","MVC"]}';    
SELECT * FROM OPENJSON(@json);


DECLARE @json NVARCHAR(MAX)
SET @json =   
 N'[  
      {  
        "Order": {  
          "Number":"SO43659",  
          "Date":"2011-05-31T00:00:00"  
        },  
        "AccountNumber":"AW29825",  
        "Item": {  
          "Price":2024.9940,  
          "Quantity":1  
        }  
      },  
      {  
        "Order": {  
          "Number":"SO43661",  
          "Date":"2011-06-01T00:00:00"  
        },  
        "AccountNumber":"AW73565",  
        "Item": {  
          "Price":2024.9940,  
          "Quantity":3  
        }  
     }  
]'  
  
SELECT * FROM  
OPENJSON ( @json )  
WITH (   
    訂單編號 varchar(200) '$.Order.Number' ,  
    訂單日 datetime '$.Order.Date',  
    客戶編號 varchar(200) '$.AccountNumber',  
	單價 MONEY '$.Item.Price',  
    數量 int '$.Item.Quantity'  
);

---------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------


USE 練習

SELECT 客戶編號,公司名稱,連絡人,連絡人職稱,電話,傳真電話,地址
INTO 客戶訂單資料
FROM 中文北風.dbo.客戶;

ALTER TABLE 客戶訂單資料 ADD 訂單資料 XML;

SELECT * FROM 客戶訂單資料;


UPDATE 客戶訂單資料
SET 訂單資料=(SELECT 訂單號碼,CONVERT(DATE,訂單日期) AS 訂單日,送貨方式,運費
	FROM 中文北風.dbo.訂貨主檔 WHERE 客戶編號=客戶訂單資料.客戶編號
	FOR XML RAW('訂單'),ROOT('訂單資料'))

SELECT * FROM 客戶訂單資料

-----------------------------

SELECT 客戶編號,公司名稱,連絡人,連絡人職稱,電話,傳真電話,地址
INTO 客戶訂單資料2
FROM 中文北風.dbo.客戶

ALTER TABLE 客戶訂單資料2 ADD 訂單資料 NVARCHAR(MAX);

UPDATE 客戶訂單資料2
SET 訂單資料=(SELECT 訂單號碼 AS OrderID,CONVERT(DATE,訂單日期) AS OrderDate,送貨方式 AS OrderType,運費 AS ShippingFee
	FROM 中文北風.dbo.訂貨主檔 WHERE 客戶編號=客戶訂單資料2.客戶編號
	FOR JSON AUTO)


SELECT * FROM 客戶訂單資料2


DECLARE @data NVARCHAR(MAX);
SELECT @data=訂單資料 FROM 客戶訂單資料2 WHERE 客戶編號='ANTON';
WITH Temp
AS
(
	SELECT 'ANTON' AS 客戶編號,* FROM OPENJSON(@data)
	WITH(
		訂單號碼 INT '$.OrderID',
		訂單日 DATETIME2(2) '$.OrderDate',
		送貨方式 INT '$.OrderType',
		運費 MONEY '$.ShippingFee'
	)
)
--SELECT * FROM Temp

SELECT A.客戶編號,公司名稱,連絡人,連絡人職稱,電話
	,B.訂單號碼,B.訂單日,B.送貨方式,B.運費
FROM 客戶訂單資料2 AS A CROSS APPLY(SELECT * FROM Temp WHERE Temp.客戶編號=A.客戶編號) AS B
WHERE A.客戶編號='ANTON'
