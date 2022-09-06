/*彙總 聚合函數 (Aggreate Function)
SUM、AVG、MAX、MIN、COUNT、VAR、VARP、STDEV、STDEVP
1.可進行分類編組
2.可利用計算或函數結果，進行分組
3.注意NULL值，彙總函數會略過 要用is null補值
4.彙總函數中，COUNT(*) 例外，可接受*
5.統計 VS 明細
*/
USE 中文北風
SELECT * FROM 員工

--做統計計算,所有GROUP BY欄位皆須出現在SELECT當中，否則無法製作
SELECT 稱呼,COUNT(員工編號) AS 人數
	,SUM(薪資) AS 薪資總和
	,AVG(薪資) AS 平均薪資
	,MAX(薪資) AS 最高薪資
	,MIN(薪資) AS 最低薪資
FROM 員工
GROUP BY 稱呼;

SELECT B.類別名稱
	,AVG(單價) AS 平均價格
	,MAX(單價) AS 最高價格
	,MIN(單價) AS 最低價格
FROM 產品資料 AS A JOIN 產品類別 AS B ON A.類別編號 = B.類別編號
GROUP BY B.類別名稱;

SELECT 稱呼,職稱,COUNT(員工編號) AS 人數
FROM 員工
GROUP BY 稱呼,職稱

SELECT SUBSTRING(地址,1,3) AS 縣市,COUNT(員工編號) AS 人數
FROM 員工
GROUP BY SUBSTRING(地址,1,3) --擷取字串

--統計
SELECT 稱呼,職稱,COUNT(員工編號) AS 人數
FROM 員工
GROUP BY 稱呼,職稱
--明細
SELECT * FROM 員工 WHERE 稱呼 = '小姐';

SELECT DISTINCT 職稱 FROM 員工; --有哪些職稱

--SQL 特有
--知道是女生，稱呼就不必
--GROUP BY (ALL) 如有ALL，即使職稱人數為0，也會列出
SELECT 職稱,COUNT(員工編號) AS 人數
FROM 員工
WHERE 稱呼='小姐'
GROUP BY ALL 職稱

--在GROUP BY前利用WHERE過濾掉不要的資料，HAVING發生在GROUP BY後
--要先做GROUP後才能做統計後的篩選
SELECT 稱呼,職稱,COUNT(員工編號) AS 人數
FROM 員工
WHERE 稱呼='小姐'
GROUP BY 稱呼,職稱
HAVING COUNT(員工編號) >= 3

--沒有GROUP BY的GROUP BY
SELECT COUNT(員工編號) AS 人數
	,SUM(薪資) AS 薪資總和
	,AVG(薪資) AS 平均薪資
	,MAX(薪資) AS 最高薪資
	,MIN(薪資) AS 最低薪資
FROM 員工

/*新增總人數*/
SELECT 稱呼,職稱,COUNT(*) AS 人數
FROM 員工
GROUP BY 稱呼,職稱
UNION ALL
SELECT NULL,NULL,COUNT(*) FROM 員工;

--ISO SQL:2006
SELECT 稱呼,職稱,COUNT(*) AS 人數
FROM 員工
GROUP BY CUBE(稱呼,職稱)  --依照GROUP BY的各角度進行加總

SELECT 稱呼,職稱,COUNT(*) AS 人數
FROM 員工
GROUP BY ROLLUP(稱呼,職稱) --依照GROUP BY的第一個欄位進行加總

--全體加總
SELECT 稱呼,職稱,COUNT(*) AS 人數
FROM 員工
GROUP BY GROUPING SETS ((稱呼,職稱),(職稱))

SELECT 稱呼,職稱,COUNT(*) AS 人數
FROM 員工
GROUP BY GROUPING SETS ((稱呼,職稱),(稱呼),(職稱),())

--HW 2003年銷售數量TOP 10
SELECT  TOP 10 A.產品編號,B.產品, SUM(數量) AS 銷售量
FROM 訂貨明細 AS A JOIN 產品資料 AS B ON A.產品編號=B.產品編號 
	JOIN 訂貨主檔 AS C ON A.訂單號碼=C.訂單號碼
WHERE C.訂單日期 BETWEEN '2003-1-1' AND '2003-12-31' 
GROUP BY ALL A.產品編號,B.產品
ORDER BY SUM(數量) DESC;

--2003年 最多不同客戶所購買之產品 TOP 10
SELECT  TOP 10 A.產品編號,B.產品, COUNT(DISTINCT C.客戶編號) AS 購買次數
FROM 訂貨明細 AS A JOIN 產品資料 AS B ON A.產品編號=B.產品編號 
	JOIN 訂貨主檔 AS C ON A.訂單號碼=C.訂單號碼
WHERE C.訂單日期 BETWEEN '2003-1-1' AND '2003-12-31' 
GROUP BY ALL A.產品編號, B.產品
ORDER BY 購買次數 DESC;

--HW 2004年有買過海鮮類的客戶，並且依照購買時間排序  111筆
SELECT A.訂單日期,D.產品,B.訂單號碼,C.客戶編號,C.公司名稱
FROM 訂貨主檔 AS A JOIN 訂貨明細 AS B ON A.訂單號碼=B.訂單號碼
	 JOIN 客戶 AS C ON A.客戶編號=C.客戶編號
	 JOIN 產品資料 AS D ON B.產品編號=D.產品編號
WHERE D.類別編號 = '8' AND YEAR(A.訂單日期) = '2004'--海鮮 透過產品類別
