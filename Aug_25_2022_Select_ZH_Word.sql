USE 中文北風
GO

SELECT * FROM 員工 WHERE 職稱 = '業務主管'  --要一字不差
SELECT * FROM 員工 WHERE 職稱 = '業務主管' OR 職稱 = '工程師'  --查詢出這兩種職稱
SELECT * FROM 員工 WHERE 職稱 IN( '業務主管' ,'工程師');  --與上方相同

/*
模糊搜尋 需用字元
% 可代替任意字元，含空白字元，且不限字數
_ 可代替任意字元，不含空白字元，且一次一字
*/
SELECT * FROM 員工 WHERE 姓名 LIKE '陳%';
SELECT * FROM 員工 WHERE 姓名 LIKE '張%'OR 姓名 LIKE '陳%'OR 姓名 LIKE '林%'; --查詢多個模糊字元
SELECT * FROM 員工 WHERE 姓名 LIKE '[張陳林]%'; --與上方相同，資料庫特有
SELECT * FROM 客戶 WHERE 客戶編號 LIKE '[ADF][O-Z]%'; --找出ADF中的編號，從O到Z排列

SELECT * FROM 產品資料 WHERE 產品 LIKE '%肉%';

SELECT LEN('巨匠電腦認證中心')
SELECT LEFT('巨匠電腦認證中心',4) --從左取4個字
SELECT RIGHT('巨匠電腦認證中心',4) --從右取4個字
SELECT SUBSTRING('巨匠電腦認證中心',5,2) --擷取字串
SELECT LOWER('Gjun Inc.')
SELECT UPPER('Gjun Inc.')
SELECT REPLACE('巨匠電腦桃園認證中心','桃園','台北') --取代文字
SELECT REVERSE('巨匠電腦')  --顛倒
SELECT CHARINDEX('桃園','巨匠電腦桃園認證中心') --查詢字串在第幾個字
SELECT QUOTENAME('巨匠電腦') --加上中括號

--SQL 2017
SELECT STRING_AGG (姓名,',') FROM 員工; --將所有姓名以逗點分隔

--SQL 2016
SELECT * FROM string_split('AA,BB,CC,DD,EE,FF',',');

--ISNULL(值,NULL取代值)
SELECT * FROM 員工
SELECT 姓名 +':'+ISNULL(電話號碼,'未填寫') FROM 員工; --如有NULL，全替換成未填寫
SELECT 姓名+',主管'+CONVERT(nvarchar,ISNULL(主管,0)) FROM 員工;  --將數值轉換為文字nvarchar
SELECT '('+員工編號+')'+姓名+', '+薪資+'：'+電話號碼 FROM 員工;  --錯誤，無法轉型
SELECT CONCAT('(',員工編號,')',姓名,', ',薪資,'：',電話號碼) FROM 員工; --合併字串，並轉型

--NULLIF(值1,值2)
SELECT NULLIF (100,100) --相等，回傳NULL
SELECT NULLIF (100,200) --不相等，傳回值1

--COALESCE(值1, 值2, 值3, .....)
SELECT COALESCE(NULL,NULL,NULL,NULL,NULL,100,NULL,NULL,NULL,NULL)
SELECT COALESCE(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)

CREATE TABLE 練習員工表
(
  員工編號 INT IDENTITY(1,1) PRIMARY KEY,
  姓名 NVARCHAR(10),
  員工種類 TINYINT,
  薪資 MONEY,
  時薪 MONEY,
  工作時數 MONEY,
  銷售金額 MONEY,
  傭金比率 MONEY
)
GO

INSERT INTO 練習員工表 VALUES('王小明',1,35000,NULL,NULL,NULL,NULL)
INSERT INTO 練習員工表 VALUES('李小明',1,28000,NULL,NULL,NULL,NULL)
INSERT INTO 練習員工表 VALUES('林大雄',2,NULL,110,275,NULL,NULL)
INSERT INTO 練習員工表 VALUES('廖小美',2,NULL,125,346,NULL,NULL)
INSERT INTO 練習員工表 VALUES('林美麗',2,NULL,105,758,NULL,NULL)
INSERT INTO 練習員工表 VALUES('錢夫人',3,NULL,NULL,NULL,7567632,0.1)
INSERT INTO 練習員工表 VALUES('ㄚ土伯',3,NULL,NULL,NULL,543243,0.08)
INSERT INTO 練習員工表 VALUES('忍太郎',3,NULL,NULL,NULL,357654,0.12)
GO

SELECT * FROM 練習員工表
SELECT 員工編號,姓名,員工種類
	, COALESCE(薪資*15,時薪*工作時數,銷售金額*傭金比率) AS 給付金額 --顯示第一個發生非NULL的值
FROM 練習員工表


--CONVERT (目標型別,值[,格式參數])  CAST轉換型態
SELECT * FROM 員工
SELECT CONVERT (NVARCHAR,GETDATE());
SELECT CONVERT (NVARCHAR,GETDATE(),101); --格式參數：100,101,102,111
SELECT 員工編號,姓名,職稱,雇用日期,CONVERT(NVARCHAR,CAST(薪資 AS MONEY),1) AS 薪資 FROM 員工;


--FORMAT(值,格式化)
SELECT FORMAT(54000,'C')
SELECT FORMAT(0.8756,'X')
SELECT FORMAT(54000,'#.0')
SELECT FORMAT(0.8756,'#.0%')
SELECT FORMAT(GETDATE(),'D') --年月日
SELECT FORMAT(GETDATE(),'d') --///
SELECT FORMAT(GETDATE(),'F') --日期+時分+秒
SELECT FORMAT(GETDATE(),'f') --日期+時分
SELECT FORMAT(GETDATE(),'T') --時分秒
SELECT FORMAT(GETDATE(),'t') --時分
SELECT FORMAT(GETDATE(),'yyyy-MM-dd dddd HH:mm:ss')

SELECT DATEPART (WEEKDAY,GETDATE()) --一週中的第幾天
SELECT FORMAT (GETDATE(),'ddd') --顯示週別

SELECT FORMAT(54000.567,'C','fr-fr') --金錢符號轉換 C# 






