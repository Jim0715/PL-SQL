ALTER TABLE [員工表] ADD [到職日] DATE CONSTRAINT 到職日預設 DEFAULT GETDATE();   --新增欄位
ALTER TABLE [員工表] ALTER COLUMN [姓名] NVARCHAR(20);                           --修改欄位
ALTER TABLE [員工表] DROP COLUMN [到職日];                                       --刪除欄位

ALTER TABLE [員工表] DROP CONSTRAINT 到職日預設;


ALTER TABLE [員工表] ADD CONSTRAINT 最低薪資檢查 CHECK(薪資>=30000);              --一開始資料有衝突就不處理
ALTER TABLE [員工表] WITH CHECK ADD CONSTRAINT 最低薪資檢查 CHECK(薪資>=30000);   --一開始資料有衝突就不處理
--解決方式：修改資料、之前打得不算從現在開始檢查
ALTER TABLE [員工表] WITH NOCHECK ADD CONSTRAINT 最低薪資檢查 CHECK(薪資>=30000); --現在輸入的才做檢查


SELECT * FROM [員工表]
INSERT INTO [員工表] VALUES(3,'DDD',1,'1986-06-06',36000);              --一次輸入一筆資料
ALTER TABLE [員工表] ADD CONSTRAINT 薪資預設 DEFAULT(25250) FOR [薪資];  --新增欄位預設數值

INSERT INTO [員工表] VALUES(4,'EEE',0,'1993-2-23');                     --即使預設，還是要輸入DEFAULT
INSERT INTO [員工表] VALUES(4,'EEE',0,'1993-2-23',DEFAULT);
INSERT INTO [員工表] VALUES(4,'EEE',0,'1993-2-23',NULL);

INSERT INTO [員工表](員工號,生日,姓名) VALUES(5,'1958-6-6','FFF');       --指定特定欄位
INSERT INTO [員工表] VALUES(6,'GGG',1,'1994-4-4',40000),                --一次輸入多筆資料
		(7,'HHH',0,'1995-5-5',50000),(8,'III',0,'1996-6-6',60000);
    

--暫時 關閉/開啟 條件約束
ALTER TABLE [員工表] NOCHECK CONSTRAINT 最低薪資檢查;
INSERT INTO [員工表] VALUES(7,'HHH',1,'1910-05-08',50000);              --一次輸入一筆資料
ALTER TABLE [員工表] CHECK CONSTRAINT 最低薪資檢查;
