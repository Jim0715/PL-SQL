USE 中文北風
SELECT * FROM 員工;               -- 0.004 s
SELECT * FROM 員工 ORDER BY 薪資; --預設 ASC 遞增排序  0.016s
SELECT * FROM 員工 ORDER BY 薪資 DESC; --遞減排序
SELECT * FROM 員工 ORDER BY 稱呼 ASC,薪資 DESC;  --多欄排序
SELECT * FROM 員工 ORDER BY 稱呼 ASC,薪資 DESC;
SELECT * FROM 員工 ORDER BY 4,8 DESC;
