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


/* Contraint 條件約束 確保資料的正確性
1. NULL / NOT NULL
2. CHECK
3. DEFAULT
4. Primary key (PK) 主鍵
5. Unique 唯一
6. Foreign key (FK) 外鍵
*/


EXECUTE sp_help '員工表';
DROP TABLE 員工表;
CREATE TABLE  
