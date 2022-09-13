/* View (檢視) 固定儲存起來的一段SQL SELECT 查詢語法，只是個代名詞
該年代時代的產物，完全沒有提升查詢效能的作用
1. 簡化(隱藏)複雜的SQL語法
2. 方便權限配置及控管
3. 也是另類的子查詢
4. 不能做ORDER BY
*/
USE 中文北風

SELECT * FROM 訂貨主檔

CREATE VIEW 詳細訂單檢視
AS
	SELECT A.訂單號碼,B.公司名稱,B.連絡人,B.連絡人職稱,B.電話,C.姓名 AS 負責員工
		,D.貨運公司名稱 AS 運送方式,A.運費
	FROM 訂貨主檔 AS A JOIN 客戶 AS B ON A.客戶編號=B.客戶編號
	JOIN 員工 AS C ON A.員工編號 = C.員工編號
	JOIN 貨運公司 AS D ON A.送貨方式=D.貨運公司編號
GO

SELECT * FROM 詳細訂單檢視;
--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
SELECT * FROM (
	SELECT A.訂單號碼,B.公司名稱,B.連絡人,B.連絡人職稱,B.電話,C.姓名 AS 負責員工
		,D.貨運公司名稱 AS 運送方式,A.運費
	FROM 訂貨主檔 AS A JOIN 客戶 AS B ON A.客戶編號=B.客戶編號
	JOIN 員工 AS C ON A.員工編號 = C.員工編號
	JOIN 貨運公司 AS D ON A.送貨方式=D.貨運公司編號) AS [詳細訂單檢視]

--建立兩個View 達到權限的控管
CREATE VIEW 員工全資料檢視
AS
	SELECT [員工編號], [姓名], [職稱], [稱呼], [出生日期], [雇用日期], [地址], [薪資], [電話號碼], [內部分機號碼], [相片], [附註], [主管]
GO

CREATE VIEW 員工一般資料檢視
AS
	SELECT [員工編號], [姓名], [職稱], [稱呼],[雇用日期], [內部分機號碼], [相片], [主管]
GO

SELECT * FROM 員工全資料檢視;
SELECT * FROM 員工一般資料檢視;

/* SCHEMABINDING 使用的前提
1. 不得使用 * 號
2. 物件皆需使用兩段式寫法
*/

USE 練練

CREATE VIEW 巨巨產品檢視
WITH SCHEMABINDING /*限定 禁制更改或刪除*/
AS
	SELECT 巨巨.產品編號,巨巨.品名
	FROM dbo.巨巨
GO

SELECT * FROM 巨巨產品檢視;

ALTER TABLE 巨巨 DROP COLUMN 價錢;
DROP VIEW 巨巨產品檢視


CREATE VIEW 巨巨40元以上產品檢視
AS 
	SELECT 產品檢視,品名,價錢
	FROM 巨巨
	WHERE 價錢>=40
GO

SELECT * FROM 巨巨40元以上產品檢視;
SELECT * FROM sys.tables; --查看有哪些表
SELECT * FROM sys.views;  --查看有哪些是視觀圖


/*利用VIEW 來編修 (INSERT、UPDATE、DELECT)資料的前提
1. 來源必須唯一張TABLE (不能發生JOIN)
2. 來源TABLE不能有衍生欄位
3.VIEW內容不能為彙總結果(不能GROUP BY)
*/
INSERT INTO 巨巨40元以上產品檢視 VALUES (26,'可樂',30) --可自由新增資料

--更改VIEW 的內容
ALTER VIEW 巨巨40元以上產品檢視
AS
	SELECT 產品檢視,品名,價錢
	FROM 巨巨
	WHERE 價錢>=40
	WITH CHECK OPTION  --新增前會檢查上方的條件，符合才會新增
GO

INSERT INTO 巨巨40元以上產品檢視 VALUES (27,'樂事',30)