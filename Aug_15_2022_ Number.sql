/*自動編號
1. 整數型別 (INT、BIGINT)
2. 每張資料表只能一個

問題點：
1. 破表(號碼用盡)
2. 跳號
*/

SELECT * FROM 編號測試表

CREATE TABLE 編號測試表
(
	編號 INT IDENTITY(1,1),
	姓名 NVARCHAR (10),
	薪資　INT
)
INSERT INTO 編號測試表 VALUES('DDD','400');--跳號產生
/*
IDENTITY [ (seed , increment) ]
seed：這是載入資料表的第一個資料列所用的值。
increment：這是加入先前載入的資料列之識別值的累加值。
*/


CREATE TABLE 編號測試表2
(
	編號 INT IDENTITY (1,1),
	全球唯一編號1 UNIQUEIDENTIFIER,  --16 位元組二進位值
	資料 NVARCHAR (10)
)
GO
INSERT INTO 編號測試表2(資料) VALUES('AAA');
INSERT INTO 編號測試表2(資料) VALUES('BBB');
INSERT INTO 編號測試表2(全球唯一編號1,資料) VALUES(NEWID(),'CCC');
INSERT INTO 編號測試表2(全球唯一編號1,資料) VALUES(NEWID(),'DDD');
SELECT * FROM [編號測試表2]

--若要將 uniqueidentifier 資料類型的資料行，設定其「預設值(Default)」為 0，也就是 00000000-0000-0000-0000-000000000000。

CREATE TABLE 編號測試表3
(
	自動編號 INT IDENTITY (1,1),
	全球唯一編號1 UNIQUEIDENTIFIER DEFAULT NEWID(),            --舊 因數值南轅北轍 Creates a random GUID
	全球唯一編號2 UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),  --新 Creates a sequential GUID
	資料 NVARCHAR (10)
)
GO
INSERT INTO 編號測試表3(資料) VALUES('AAA');
INSERT INTO 編號測試表3(資料) VALUES('BBB');
INSERT INTO 編號測試表3(資料) VALUES('CCC');
SELECT * FROM [編號測試表3];


--當有自動編號的欄位發生編號時，可用此進行人工補單
SET IDENTITY_INSERT [編號測試表] ON;
INSERT INTO 編號測試表(編號,姓名,薪資) VALUES(10,'EEE',800);
SET IDENTITY_INSERT [編號測試表] OFF;
