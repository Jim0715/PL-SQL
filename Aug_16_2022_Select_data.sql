/*
實務上，禁止使用*號
* 號：懶惰、不清楚資料表架構
1. 網路傳輸一堆無用的資料
2. 造成資料庫的查詢最佳化判斷失準，(索引的判斷使用失準) ex字典→注音、部首
*/

SELECT * FROM [員工表];
SELECT 員工號,姓名,性別,薪資 FROM [員工表];
SELECT 員工號,姓名,性別,薪資 FROM [員工表] WHERE 薪資>=50000;

CREATE TABLE [員工表2]
(
	工號 INT,
	姓名 NVARCHAR(10),
	性別 BIT,
	薪水 INT
)


SELECT * FROM [員工表2]


--將員工表查詢結果放入員工表2(現有資料表)中
INSERT INTO [員工表2](工號,薪水,姓名,性別)   
	SELECT 員工號,薪資,姓名,性別 FROM [員工表] WHERE 薪資>=50000;
  
SELECT 員工號,姓名,性別,薪資 FROM [員工表] WHERE 員工號<=2470;

--查詢結果另存入員工表3(新的資料表)中
SELECT 員工號,姓名,性別,薪資
INTO [員工表3]     
FROM [員工表]
WHERE 員工號<=2470


SELECT 員工號,姓名,性別,薪資      --查0筆
FROM [員工表]
WHERE 5>10;

SELECT 員工號,姓名,性別,薪資,生日  --透過查0筆新建資料夾
INTO [員工表4] 
FROM [員工表]
WHERE 1=0  --= false

SELECT * FROM [員工表4];
EXEC sp_help '員工表4';
