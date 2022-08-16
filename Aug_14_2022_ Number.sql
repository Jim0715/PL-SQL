CREATE TABLE 編號測試表2
(
	編號 INT IDENTITY (1,1),
	全球唯一編號1 UNIQUEIDENTIFIER,  --16 位元組二進位值
	資料 NVARCHAR (10)
)
GO
INSERT INTO 編號測試表2(資料) VALUES('AAA');
INSERT INTO 編號測試表2(資料) VALUES('BBB');
INSERT INTO 編號測試表2(資料) VALUES('CCC');
INSERT INTO 編號測試表2(全球唯一編號1,資料) VALUES(NEWID(),'DDD');
INSERT INTO 編號測試表2(全球唯一編號1,資料) VALUES(NEWID(),'EEE');
INSERT INTO 編號測試表2(全球唯一編號1,資料) VALUES(NEWID(),'FFF');
SELECT * FROM [編號測試表2]

--若要將 uniqueidentifier 資料類型的資料行，設定其「預設值(Default)」為 0，也就是 00000000-0000-0000-0000-000000000000。

CREATE TABLE 編號測試表3
(
	自動編號 INT IDENTITY (1,1),
	全球唯一編號1 UNIQUEIDENTIFIER DEFAULT NEWID(),            --舊 因數值南轅北轍
	全球唯一編號2 UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),  --新
	資料 NVARCHAR (10)
)
GO
INSERT INTO 編號測試表3(資料) VALUES('AAA');
INSERT INTO 編號測試表3(資料) VALUES('BBB');
INSERT INTO 編號測試表3(資料) VALUES('CCC');
SELECT * FROM [編號測試表3];
