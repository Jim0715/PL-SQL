/*
1. 2003�~ �U���禬���B(�]�t�W��~�Z�B�릨��(Format�ʤ���))

2. �C��Ȥ᪺�����ʶR���j�Ѽ�


https://docs.microsoft.com/zh-tw/sql/t-sql/functions/percentile-cont-transact-sql?view=sql-server-ver16
3-1. ����P�����~�ꤤ���
3-2. ���鲣�~����� 25% �����50% 75% 90%
3-3. �U�����~����� 25% �����50% 75% 90%

4-1. �C����u�b��¾��s�����~��ʤ���
4-2. �C�����~�b�������~�s��������ʤ���

5-1. �U�����~(�C)�B�U�~(��) �� �P����B �ϯä��R
5-2. �U����(�C)�B�U�����~(��) �� �P��ƶq �ϯä��R

*/

USE ����_��

SELECT *
FROM ( SELECT ���u�s��,�m�W,�٩I,¾��,�~��
	   FROM ���u ORDER BY �~�� DESC) AS A
ORDER BY �~�� ASC


SELECT *
FROM ( SELECT TOP(10) ���u�s��,�m�W,�٩I,¾��,�~��
	   FROM ���u ORDER BY �~�� DESC) AS A
ORDER BY �~�� ASC

--�p���M�涰  6-10
SELECT *
FROM( SELECT TOP (10) ���u�s��,�m�W,�٩I,¾��,�~��
	  FROM ���u ORDER BY �~�� DESC) AS A

EXCEPT        --INTERSECT(�涰) , EXCEPT(����) 
SELECT *
FROM( SELECT TOP (5) ���u�s��,�m�W,�٩I,¾��,�~��
	  FROM ���u ORDER BY �~�� DESC) AS B
ORDER BY �~�� DESC;


SELECT  A.*
FROM( SELECT TOP (10) ���u�s��,�m�W,�٩I,¾��,�~��
	  FROM ���u ORDER BY �~�� DESC) AS A
	LEFT JOIN
 (SELECT TOP (5) ���u�s��,�m�W,�٩I,¾��,�~��
	  FROM ���u ORDER BY �~�� DESC) AS B 
  ON A.���u�s��=B.���u�s��
 WHERE B.���u�s�� IS NULL;

 --0.420
 SELECT TOP(5) ���u�s��,�m�W,�٩I,¾��,�~��
 FROM ���u
 WHERE ���u�s�� NOT IN (SELECT TOP(5) ���u�s�� FROM ���u ORDER BY �~�� DESC)
 ORDER BY �~�� DESC;

 SELECT *
 FROM (SELECT ���u�s��,�m�W,�٩I,¾��,�~��,
		(SELECT COUNT(*) FROM ���u AS B WHERE B.�~��>A.�~��) AS �ƦW FROM ���u AS A) AS C
WHERE �ƦW>=25 AND �ƦW<=29
ORDER BY �~�� DESC;

--SQL 2005
--���������
SELECT ���u�s��,�m�W,�٩I,¾��,�~��
	,ROW_NUMBER() OVER (ORDER BY �~�� DESC) AS �C��
FROM ���u AS A

SELECT * 
FROM ( SELECT ���u�s��,�m�W,�٩I,¾��,�~��
	,ROW_NUMBER() OVER (ORDER BY �~�� DESC) AS �C��
FROM ���u AS A) AS B
WHERE �C��>=26 AND �C��<=30;


--�������A�ƧǮa��
--���B���ƪ������|���ۦP���ƧǡA�����򪺸�ƨä��|����Ƨ�
SELECT ���u�s��,�m�W,�٩I,¾��,�~��
	,RANK() OVER (ORDER BY �~�� DESC) AS �ƦW
FROM ���u AS A

--�����ƱƧǫ�A�|����Ƨ�
SELECT ���u�s��,�m�W,�٩I,¾��,�~��
	,DENSE_RANK() OVER (ORDER BY �~�� DESC) AS �ƦW
FROM ���u AS A 

--���~�����
SELECT ���u�s��,�m�W,�٩I,¾��,�~��
	,NTILE(4) OVER (ORDER BY �~�� DESC) AS �s��
FROM ���u AS A

--ROW_NUMBER()  �q�Y�ƨ�� PARTITION BY �s��  ORDER BY �Ѥp��j�Ƨ�
SELECT �Ȥ�s��,�q�渹�X
	,ROW_NUMBER() OVER (PARTITION BY �Ȥ�s�� ORDER BY �q�渹�X) AS �y����
FROM �q�f�D��;

--SQL2012
--�U��5�C���Ƨ�
SELECT ���u�s��,�m�W,�٩I,¾��,�~��
FROM ���u
ORDER BY �~�� DESC OFFSET 5 ROWS;

--�U��5�C���ƧǡA���e5�C
SELECT ���u�s��,�m�W,�٩I,¾��,�~��
FROM ���u
ORDER BY �~�� DESC OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;


SELECT ���u�s��,�m�W,�٩I,¾��,�~��
	,LAG(�~��) OVER (ORDER BY �~�� ASC) AS �e�@���~��
	,�~��-LAG(�~��) OVER(ORDER BY �~�� ASC) AS �~��t
	,LAG(�~��,2) OVER(ORDER BY �~�� ASC) AS �e����~��
	,LAG(�~��,2,0) OVER(ORDER BY �~�� ASC) AS �e����~��
FROM ���u AS A

SELECT ���u�s��,�m�W,�٩I,¾��,�~��
	,LEAD(�~��) OVER (ORDER BY �~�� ASC) AS ��@���~��
	,�~��-LEAD(�~��) OVER(ORDER BY �~�� ASC) AS �~��t
	,LEAD(�~��,2) OVER(ORDER BY �~�� ASC) AS �����~��
	,LEAD(�~��,2,0) OVER(ORDER BY �~�� ASC) AS �����~��
FROM ���u AS A

--�ϯø�Ƨe�{
SELECT �٩I,¾��,COUNT(*) �H��
FROM ���u
GROUP BY �٩I,¾��;
--- ������������
SELECT [¾��],ISNULL([�p�j],0) AS [�p�j],[����]
FROM (SELECT �٩I,¾��,COUNT(*) �H��
FROM ���u
GROUP BY �٩I,¾��) AS A
PIVOT (SUM(�H��) FOR �٩I IN ([�p�j],[����])) AS P;
