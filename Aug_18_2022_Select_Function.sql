USE 中文北風

SELECT * FROM 員工;               -- 0.004 s
SELECT * FROM 員工 ORDER BY 薪資; --預設 ASC 遞增排序  0.016s
SELECT * FROM 員工 ORDER BY 薪資 DESC; --遞減排序
SELECT * FROM 員工 ORDER BY 稱呼 ASC,薪資 DESC;  --多欄 指定特定排序方式
SELECT * FROM 員工 ORDER BY 4,8 DESC;    --針對特定欄位進行排序

SELECT 員工編號,姓名,稱呼,雇用日期,薪資 FROM 員工  --選取需要的欄位查詢


--衍生欄位 (Derived column)  []可用違反規則的名字
SELECT 員工編號,姓名,稱呼 AS [性別],稱呼
	,雇用日期
	,YEAR(GETDATE())-YEAR(雇用日期) AS [年資]  --別名
	,薪資
	,薪資*15 AS [年薪]
FROM 員工;

SELECT * FROM 訂貨主檔
SELECT ALL 客戶編號 FROM 訂貨主檔        --0.0138 ALL為預設值
SELECT DISTINCT 客戶編號 FROM 訂貨主檔   --0.0377 取相異 利用結果進行比對

--SQL Server TOP
SELECT TOP(5) 員工編號,姓名,稱呼,雇用日期,薪資 FROM 員工  --取前5筆資料查看
SELECT TOP(5) 員工編號,姓名,稱呼,雇用日期,薪資 FROM 員工 ORDER BY 薪資 DESC;--取前5筆資料並排序
SELECT TOP(10) PERCENT 員工編號,姓名,稱呼,雇用日期,薪資 FROM 員工 ORDER BY 薪資 DESC;-- 將返回完整結果集的前 10%

SELECT TOP(11) WITH TIES 員工編號,姓名,稱呼,雇用日期,薪資 FROM 員工 ORDER BY 薪資 DESC;
--WITH TIES允許您返回更多行，其值與有限結果集中的最後一行匹配(相同值)
SELECT TOP(11) WITH TIES 員工編號,姓名,稱呼,雇用日期,薪資 FROM 員工;  --需接ORDER BY


--Updata Delect Top
UPDATE [員工]
SET [地址]='台'+[地址]
WHERE [員工編號]<=3;

UPDATE TOP(3) [員工]
SET [地址]='台'+[地址];

--DELECT TOP(50) PERCENT FROM [員工];






