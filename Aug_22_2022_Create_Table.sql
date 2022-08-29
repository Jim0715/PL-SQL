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

/*
日期- 你不需要時間
smalldatetime - 你不需要秒
datetime2(0) - 你不需要小數秒
datetime2(1-7) - 您需要指定精度的小數秒
datetimeoffset(0-7) - 您需要具有時區意識的日期和時間
time(0-7) - 您只需要指定精度的小數秒時間（無日期）
*/


--FOREIGN KEY REFERENCES 外鍵，可限制欄位值只能來自另一張資料表的主鍵欄位

CREATE TABLE 小員工
(
	員工號 INT PRIMARY KEY,
	姓名 NVARCHAR,
	薪資 INT
)

CREATE TABLE 小訂單
(
	訂單編號 INT PRIMARY KEY ,
	金額 INT,
	負責員工 INT CONSTRAINT 員工訂單關聯 FOREIGN KEY REFERENCES 小員工(員工號)
			ON UPDATE CASCADE		-- NO ACTION | CASCADE | SET NULL | SET DEFAULT
			ON DELETE SET NULL,
	訂單時間 DATETIME2(2) DEFAULT SYSDATETIME()
)
GO
/*
update 则是主键表中被参考字段的值更新，delete是指在主键表中删除一条记录：
on update 和 on delete 后面可以跟的词语有四个
no action ， set null ， set default ，cascade
no action 表示 不做任何操作，
set null 表示在外键表中将相应字段设置为null
set default 表示设置为默认值(restrict)
cascade 表示级联操作，就是说，如果主键表中被参考字段更新，外键表中也更新，主键表中的记录被删除，外键表中改行也相应删除
*/
