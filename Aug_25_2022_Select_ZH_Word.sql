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