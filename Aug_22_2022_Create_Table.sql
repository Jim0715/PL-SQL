--計算欄位 Computed column
CREATE TABLE [員工表]
(
	[員工編號] INT,
	[姓名] NVARCHAR(10),
	性別 BIT,
	生日 DATE,
	年齡 AS YEAR(GETDATE())-YEAR([生日]),
	薪資 INT,
	年薪 AS 薪資*15 PERSISTED --可讓您在具決定性但不精確的計算資料行上建立索引
	--相片 VARBINARY(MAX)
)
ON [人資群]
--TEXTIMAGE_ON [大型物件群]; 需先創建群組
GO

SELECT GETDATE()		--DATETIME
SELECT SYSDATETIME()	--DATETIME2

/*
Contraint 條件約束 確保資料的正確性
1. NULL / NOT NULL
2. CHECK
3. DEFAULT
4. Primary Key (PK) 主鍵
5. Unique 唯一
6. Foreign Key (FK) 外鍵
*/

USE 訓練
GO

EXEC sp_help '員工表';
DROP TABLE 員工表;

-- 約束條件與對應欄位放一起
CREATE TABLE 員工表
(
	員工號 INT NOT NULL,  --不能是空值
	姓名 NVARCHAR(10) NOT NULL,
	性別 BIT NULL,
	--生日 DATE NULL,
	生日 DATE CHECK (生日<GETDATE() AND (YEAR(GETDATE())-YEAR(生日)>=16)),
	--檢查生日欄位不得為超過今天的日期和小於16歲
	--薪資 INT NULL CHECK(薪資>=25250)  --一般檢查方式
	薪資 INT CONSTRAINT 最低薪資檢查 CHECK (薪資>=25250) NOT NULL
	--提示中顯示約束條件
)

--將約束條件獨立放一起
CREATE TABLE 員工表
(
	員工號 INT NOT NULL,  --不能是空值
	姓名 NVARCHAR(10) NOT NULL,
	性別 BIT NULL,
	生日 DATE,
	薪資 INT CONSTRAINT 薪資預設 DEFAULT(25250),
	--薪資 INT NULL,
	建檔時間 DATETIME2(2) CONSTRAINT 預設建檔時間 DEFAULT(GETDATE()),
		--整張資料表的Constraint
		CONSTRAINT 姓名唯一 UNIQUE(姓名),
		CONSTRAINT 員工表主鍵 PRIMARY KEY (員工號),
		CONSTRAINT 未來生日檢查 CHECK (生日<GETDATE()),
		CONSTRAINT 童工檢查 CHECK (YEAR(GETDATE())-YEAR(生日)>=16),
		CONSTRAINT 最低薪資檢查 CHECK (薪資>=25250)
)
