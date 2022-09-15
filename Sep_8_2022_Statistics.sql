--цквш?ч│╗ч╡▒?╕хо╣??
SELECT compatibility_level  
FROM sys.databases WHERE name = 'ф╕нц??Чщви';  
--ф┐оцФ╣ш│Зц?х║лчЫ╕хо╣цА?
ALTER DATABASE ф╕нц??Чщви 
SET COMPATIBILITY_LEVEL = 150;  
GO
/* HomeWork
1. 2003х╣??Дц??ЯцФ╢?Сщ?(?ЕхРлф╕Кц?ценч╕╛?Бц??РщХ╖(Format?╛х?цп?)
SELECT C.шиВхЦо?Иф╗╜, C.ценч╕╛, C.ф╕КхАЛц?ценч╕╛,CONCAT((round(C.ценч╕╛/C.ф╕КхАЛц?ценч╕╛*100,2)),'%') AS ?Иц???
FROM
	(SELECT ROW_NUMBER() OVER (ORDER BY YEAR(A.шиВхЦо?ец?) ASC) AS ?Чш?, YEAR(A.шиВхЦо?ец?) AS шиВхЦох╣┤ф╗╜, MONTH(A.шиВхЦо?ец?) AS шиВхЦо?Иф╗╜ ,SUM(B.?Сщ?) AS ценч╕╛,LAG(SUM(B.?Сщ?)) OVER (ORDER BY YEAR(A.шиВхЦо?ец?) ASC) AS ф╕КхАЛц?ценч╕╛
	FROM шиВш▓иф╕╗ц? AS A JOIN 
	(SELECT шиВхЦо?Ячв╝,ROUND(SUM(?охГ╣*?╕щ?*(1+?ШцЙг)),0) AS ?Сщ? FROM шиВш▓и?Оч┤░ GROUP BY шиВхЦо?Ячв╝) AS B
	ON A.шиВхЦо?Ячв╝=B.шиВхЦо?Ячв╝
	WHERE A.шиВхЦо?ец? BETWEEN '2002-12-01' AND '2003-12-31' 
	GROUP BY YEAR(A.шиВхЦо?ец?),MONTH(A.шиВхЦо?ец?))
	AS C
WHERE C.?Чш? BETWEEN '2' AND '13';

2. цпПф?ховцИ╢?Дх╣│?Зш│╝ш▓╖щ??Фхдй??
SELECT ховцИ╢ч╖иш?, AVG(?╕х╖охдйцХ╕) AS х╣│х?ш│╝ш▓╖?Ущ?хдйцХ╕
FROM
	(SELECT ховцИ╢ч╖иш?, шиВхЦо?ец?, ф╕Кцмбш│╝ш▓╖, DATEDIFF(day, ф╕Кцмбш│╝ш▓╖,шиВхЦо?ец? )  AS ?╕х╖охдйцХ╕
	 FROM
		 (SELECT ховцИ╢ч╖иш?, шиВхЦо?ец?,LAG(шиВхЦо?ец?) OVER (PARTITION BY ховцИ╢ч╖иш? ORDER BY шиВхЦо?ец? ASC) AS ф╕Кцмбш│╝ш▓╖
		 FROM шиВш▓иф╕╗ц?
		 GROUP BY ховцИ╢ч╖иш?  , шиВхЦо?ец?) AS A) AS B
GROUP BY ховцИ╢ч╖иш? 
ORDER BY ховцИ╢ч╖иш? ASC

https://docs.microsoft.com/zh-tw/sql/t-sql/functions/percentile-cont-transact-sql?view=sql-server-ver16
3-1. ?ищ??Мф??ДшЦкш│Зф╕нф╜НцХ╕ (?╕хо╣?зш?хдзцЦ╝110)
--PERCENTILE_CONT ?Гц??ещБй?╢хА?(ш│Зц??Жф╕нф╕Нф?хоЪц??Йшй▓??я╝МшА?PERCENTILE_DISC ?Зф?х╛Лц??│х?ш│Зц??Жф╕н?Дхпж?ЫхА?
	SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ?кш?) OVER() AS MedianCont  
	,PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY ?кш?) OVER() AS MedianDisc  
	FROM ?бх╖е; 

3-2. ?┤щ??вх??ДхФо??25% ф╕нф???0% 75% 90%
SELECT DISTINCT 'ф╕нф????бхпж?ЫхА?' AS щбЮхИе,
	 PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ?охГ╣ ) OVER() AS [25%],
	 PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ?охГ╣) OVER() AS [50%],
	 PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ?охГ╣) OVER() AS [0.75%],
	 PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY ?охГ╣) OVER () AS [0.9%]
	 FROM ?вх?ш│Зц?
UNION ALL
SELECT DISTINCT 'ф╕нф????Йхпж?ЫхА?' AS щбЮхИе,
	 PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ?охГ╣ ) OVER() AS [25%],
	 PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY ?охГ╣) OVER() AS [50%],
	 PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ?охГ╣) OVER() AS [0.75%],
	 PERCENTILE_DISC(0.9) WITHIN GROUP (ORDER BY ?охГ╣) OVER () AS [0.9%]
	 FROM ?вх?ш│Зц?;
	 
3-3. ?Дщ??вх??ДхФо??25% ф╕нф???0% 75% 90%
SELECT DISTINCT 'ф╕нф????бхпж?ЫхА?' AS щбЮхИе, B.щбЮхИе?Нчи▒,
	PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY A.?охГ╣) OVER(PARTITION BY B.щбЮхИе?Нчи▒) AS [25%],
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY A.?охГ╣) OVER(PARTITION BY B.щбЮхИе?Нчи▒) AS [50%],
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY A.?охГ╣) OVER(PARTITION BY B.щбЮхИе?Нчи▒) AS [75%],
	PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY A.?охГ╣) OVER(PARTITION BY B.щбЮхИе?Нчи▒) AS [90%]
FROM ?вх?ш│Зц? AS A JOIN ?вх?щбЮхИе AS B ON A.щбЮхИеч╖иш?=B.щбЮхИеч╖иш?
UNION ALL
SELECT DISTINCT 'ф╕нф????Йхпж?ЫхА?' AS щбЮхИе, B.щбЮхИе?Нчи▒,
	PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY A.?охГ╣) OVER(PARTITION BY B.щбЮхИе?Нчи▒) AS [25%],
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY A.?охГ╣) OVER(PARTITION BY B.щбЮхИе?Нчи▒) AS [50%],
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY A.?охГ╣) OVER(PARTITION BY B.щбЮхИе?Нчи▒) AS [75%],
	PERCENTILE_DISC(0.9) WITHIN GROUP (ORDER BY A.?охГ╣) OVER(PARTITION BY B.щбЮхИе?Нчи▒) AS [90%]
FROM ?вх?ш│Зц? AS A JOIN ?вх?щбЮхИе AS B ON A.щбЮхИеч╖иш?=B.щбЮхИеч╖иш?

4-1. цпПф??бх╖е?ишй▓?╖ф?ч╛дф╕н?ДшЦкш│ЗчЩ╛?Жф? n*(?╛х?ф╜НцХ╕/100) ?▓ф?х╛?=х░Нц??╕хА?
SELECT ?╖чи▒,?бх╖еч╖иш?,хзУх?,?кш?,CASE WHEN ?╖ф?ч╛дф╕н?кш??Тх?>0 THEN ROUND(CONVERT(FLOAT,(?╖ф?ч╛дф╕н?кш??Тх?*100))/(?ох??╖ф?ч╛дщ??оцХ╕-1), 2) ELSE 0 END AS ?вх?щбЮхИеф╕нч??╣ца╝?╛х?ф╜?
FROM
	(SELECT ?╖чи▒,?бх╖еч╖иш?,хзУх?, ?кш?,(RANK() OVER(PARTITION BY ?╖чи▒ ORDER BY ?кш?))-1 AS ?╖ф?ч╛дф╕н?кш??Тх? ,COUNT(1) OVER(PARTITION BY ?╖чи▒) AS ?ох??╖ф?ч╛дщ??оцХ╕
	FROM ?бх╖е GROUP BY ?╖чи▒,?бх╖еч╖иш?,хзУх?,?кш?) AS A
	
4-2. цпПщ??вх??ишй▓щбЮчФв?Бч╛дф╕нч??╣ца╝?╛х?ф╜?
SELECT щбЮхИеч╖иш?,щбЮхИе?Нчи▒,?вх?,?охГ╣,CASE WHEN ?вх?щбЮхИеф╕нч??╣ца╝?Тх?>0 THEN ROUND(CONVERT(FLOAT,(?вх?щбЮхИеф╕нч??╣ца╝?Тх?*100))/(?ох?щбЮхИе?ЕчЫо??1), 2) ELSE 0 END AS ?вх?щбЮхИеф╕нч??╣ца╝?╛х?ф╜?
FROM
	(SELECT A.щбЮхИеч╖иш?,B.щбЮхИе?Нчи▒,A.?вх?,A.?охГ╣,(RANK() OVER(PARTITION BY B.щбЮхИе?Нчи▒ ORDER BY ?охГ╣))-1 AS ?вх?щбЮхИеф╕нч??╣ца╝?Тх? ,COUNT(1) OVER(PARTITION BY B.щбЮхИе?Нчи▒) AS ?ох?щбЮхИе?ЕчЫо??
	FROM ?вх?ш│Зц? AS A JOIN ?вх?щбЮхИе AS B ON A.щбЮхИеч╖иш?=B.щбЮхИеч╖иш?
	) AS A
ORDER BY щбЮхИеч╖иш?

5-1. ?Дщ??вх?(???Бх?х╣?цм? ???╖хФо?Сщ? циЮч??Жц?
SELECT *
FROM
	(SELECT шиВхЦох╣┤ф╗╜,щбЮхИе?Нчи▒,SUM(?Сщ?) AS щбЮхИеч╕╜щК╖?ощ?
	 FROM
		 (SELECT YEAR(B.шиВхЦо?ец?) AS шиВхЦох╣┤ф╗╜,D.щбЮхИе?Нчи▒,ROUND(SUM(A.?охГ╣*A.?╕щ?*(1+A.?ШцЙг)),0) AS ?Сщ? FROM шиВш▓и?Оч┤░ AS A
		  JOIN шиВш▓иф╕╗ц? AS B ON A.шиВхЦо?Ячв╝=B.шиВхЦо?Ячв╝ JOIN ?вх?ш│Зц? AS C ON A.?вх?ч╖иш?=C.?вх?ч╖иш? JOIN ?вх?щбЮхИе AS D ON C.щбЮхИеч╖иш?=D.щбЮхИеч╖иш?
		  GROUP BY A.?вх?ч╖иш?,B.шиВхЦо?ец?,D.щбЮхИе?Нчи▒) AS E
	 GROUP BY шиВхЦох╣┤ф╗╜,щбЮхИе?Нчи▒ ) AS F
PIVOT (
	-- шинх?х╜Щч╕╜цмДф??КцЦ╣х╝?
	MAX(щбЮхИеч╕╜щК╖?ощ?) 
	-- шинх?ш╜Йч╜оцмДф?я╝Мф╕ж?Зх?ш╜Йч╜оцмДф?ф╕нщ?х╜Щч╕╜?Дц?ф╗╢хА╝ф??║цЦ░цмДф?
	FOR шиВхЦох╣┤ф╗╜ IN ("2002","2003","2004")
) p;

5-2. ?Дч╕гх╕????Бх?щбЮчФв??цм? ???╖хФо?╕щ? циЮч??Жц?
SELECT ?Бш▓и?Ох?,щг▓ц?,шк┐хС│??ISNULL(щ╗Юх?,0) AS щ╗Юх?,?ечФи??[чйАщб?щ║еч?],[??хо╢чж╜],ISNULL(?╣шг╜??0) AS ?╣шг╜??ц╡╖щоо
FROM
	(SELECT *
	 FROM
		 (SELECT ?Бш▓и?Ох?,щбЮхИе?Нчи▒,SUM(?Сщ?) AS щбЮхИеч╕╜щК╖?ощ?
		  FROM
		 	  (SELECT B.?Бш▓и?Ох?,D.щбЮхИе?Нчи▒,ROUND(SUM(A.?охГ╣*A.?╕щ?*(1+A.?ШцЙг)),0) AS ?Сщ? FROM шиВш▓и?Оч┤░ AS A
		 	   JOIN шиВш▓иф╕╗ц? AS B ON A.шиВхЦо?Ячв╝=B.шиВхЦо?Ячв╝ JOIN ?вх?ш│Зц? AS C ON A.?вх?ч╖иш?=C.?вх?ч╖иш? JOIN ?вх?щбЮхИе AS D ON C.щбЮхИеч╖иш?=D.щбЮхИеч╖иш?
		 	   GROUP BY B.?Бш▓и?Ох?,A.?вх?ч╖иш?,B.шиВхЦо?ец?,D.щбЮхИе?Нчи▒) AS E
		  GROUP BY ?Бш▓и?Ох?,щбЮхИе?Нчи▒ ) AS F
	 PIVOT (
		 -- шинх?х╜Щч╕╜цмДф??КцЦ╣х╝?
		 MAX(щбЮхИеч╕╜щК╖?ощ?) 
		 -- шинх?ш╜Йч╜оцмДф?я╝Мф╕ж?Зх?ш╜Йч╜оцмДф?ф╕нщ?х╜Щч╕╜?Дц?ф╗╢хА╝ф??║цЦ░цмДф?
		 FOR щбЮхИе?Нчи▒ IN (щг▓ц?,шк┐хС│??щ╗Юх?,?ечФи??[чйАщб?щ║еч?],[??хо╢чж╜],?╣шг╜??ц╡╖щоо)
	 ) p) AS G
*/

USE ф╕нц??Чщви

SELECT *
FROM ( SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	   FROM ?бх╖е ORDER BY ?кш? DESC) AS A
ORDER BY ?кш? ASC


SELECT *
FROM ( SELECT TOP(10) ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	   FROM ?бх╖е ORDER BY ?кш? DESC) AS A
ORDER BY ?кш? ASC

--?пщ??Мф║д?? 6-10
SELECT *
FROM( SELECT TOP (10) ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	  FROM ?бх╖е ORDER BY ?кш? DESC) AS A

EXCEPT        --INTERSECT(ф║дщ?) , EXCEPT(??Щд) 
SELECT *
FROM( SELECT TOP (5) ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	  FROM ?бх╖е ORDER BY ?кш? DESC) AS B
ORDER BY ?кш? DESC;


SELECT  A.*
FROM( SELECT TOP (10) ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	  FROM ?бх╖е ORDER BY ?кш? DESC) AS A
	LEFT JOIN
 (SELECT TOP (5) ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	  FROM ?бх╖е ORDER BY ?кш? DESC) AS B 
  ON A.?бх╖еч╖иш?=B.?бх╖еч╖иш?
 WHERE B.?бх╖еч╖иш? IS NULL;

 --0.420
 SELECT TOP(5) ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
 FROM ?бх╖е
 WHERE ?бх╖еч╖иш? NOT IN (SELECT TOP(5) ?бх╖еч╖иш? FROM ?бх╖е ORDER BY ?кш? DESC)
 ORDER BY ?кш? DESC;

<<<<<<< HEAD
SELECT *
FROM (SELECT н√дu╜s╕╣,йmжW,║┘йI,┬╛║┘,┴~╕ъ,
		(SELECT COUNT(*) FROM н√дu AS B WHERE B.┴~╕ъ>A.┴~╕ъ) AS ▒╞жW FROM н√дu AS A) AS C
WHERE ▒╞жW>=25 AND ▒╞жW<=29
ORDER BY ┴~╕ъ DESC;
=======
 SELECT *
 FROM (SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?,
		(SELECT COUNT(*) FROM ?бх╖е AS B WHERE B.?кш?>A.?кш?) AS ?Тх? FROM ?бх╖е AS A) AS C
WHERE ?Тх?>=25 AND ?Тх?<=29
ORDER BY ?кш? DESC;
>>>>>>> 8c7ef2faa02690596d869de82293a396180f5362

--SQL 2005
--шжЦч??ЛхЗ╜??
SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	,ROW_NUMBER() OVER (ORDER BY ?кш? DESC) AS ?Чш?
FROM ?бх╖е AS A

SELECT * 
FROM ( SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	,ROW_NUMBER() OVER (ORDER BY ?кш? DESC) AS ?Чш?
FROM ?бх╖е AS A) AS B
WHERE ?Чш?>=26 AND ?Чш?<=30;


--шжЦч??Ля??Тх?хо╢ц?
--?Сщ??Нш??ДщГи?Жц??ЙчЫ╕?Мч??Тх?я╝Мф?х╛Мч??Дш??Щф╕жф╕Нц??еч??Тх?
SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	,RANK() OVER (ORDER BY ?кш? DESC) AS ?Тх?
FROM ?бх╖е AS A

--ф╕Нщ?шдЗц?х║Пх?я╝Мц??еч??Тх?
SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	,DENSE_RANK() OVER (ORDER BY ?кш? DESC) AS ?Тх?
FROM ?бх╖е AS A 

--ф╛ЭшЦкш│Зх?ч╡?
SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	,NTILE(4) OVER (ORDER BY ?кш? DESC) AS ч╛дч?
FROM ?бх╖е AS A

--ROW_NUMBER()  х╛Ющан?ТхИ░х░?PARTITION BY ч╛дч?  ORDER BY ?▒х??░хдз?Тх?
SELECT ховцИ╢ч╖иш?,шиВхЦо?Ячв╝
	,ROW_NUMBER() OVER (PARTITION BY ховцИ╢ч╖иш? ORDER BY шиВхЦо?Ячв╝) AS ц╡Бц░┤??
FROM шиВш▓иф╕╗ц?;

--SQL2012
--ф╕Лчз╗5?Чх??Тх?
SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
FROM ?бх╖е
ORDER BY ?кш? DESC OFFSET 5 ROWS;

--ф╕Лчз╗5?Чх??Тх?я╝Мх?????
SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
FROM ?бх╖е
ORDER BY ?кш? DESC OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;


SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	,LAG(?кш?) OVER (ORDER BY ?кш? ASC) AS ?Нф?ф╜НшЦкш│?
	,?кш?-LAG(?кш?) OVER(ORDER BY ?кш? ASC) AS ?кш?х╖?
	,LAG(?кш?,2) OVER(ORDER BY ?кш? ASC) AS ?НхЕйф╜НшЦкш│?
	,LAG(?кш?,2,0) OVER(ORDER BY ?кш? ASC) AS ?НхЕйф╜НшЦкш│?
FROM ?бх╖е AS A

SELECT ?бх╖еч╖иш?,хзУх?,чи▒хС╝,?╖чи▒,?кш?
	,LEAD(?кш?) OVER (ORDER BY ?кш? ASC) AS х╛Мф?ф╜НшЦкш│?
	,?кш?-LEAD(?кш?) OVER(ORDER BY ?кш? ASC) AS ?кш?х╖?
	,LEAD(?кш?,2) OVER(ORDER BY ?кш? ASC) AS х╛МхЕйф╜НшЦкш│?
	,LEAD(?кш?,2,0) OVER(ORDER BY ?кш? ASC) AS х╛МхЕйф╜НшЦкш│?
FROM ?бх╖е AS A

--циЮч?ш│Зц??ИчП╛
SELECT чи▒хС╝,?╖чи▒,COUNT(*) ф║║цХ╕
FROM ?бх╖е
GROUP BY чи▒хС╝,?╖чи▒;
--- ?Ут??Ут??Ут?
SELECT [?╖чи▒],ISNULL([х░Пх?],0) AS [х░Пх?],[?Ич?]
FROM (SELECT чи▒хС╝,?╖чи▒,COUNT(*) ф║║цХ╕
FROM ?бх╖е
GROUP BY чи▒хС╝,?╖чи▒) AS A
PIVOT (SUM(ф║║цХ╕) FOR чи▒хС╝ IN ([х░Пх?],[?Ич?])) AS P;
