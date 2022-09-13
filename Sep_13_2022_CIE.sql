/*ISO SQL 2003
--CTE (Common Table Expression)
  �{�ɩʡB�@���ʪ��d�� VIEW

 1. ²�Ƥl�d�߼��g��������
 2. �i�H���j�d��(�l�d��)
 3. �W�i �u�����l�d�� ���d�߮į�
*/

SELECT ���~�s�� ,�~�W ,����
FROM (SELECT * FROM ����) AS A
--������������������������������������
WITH TEMP(�f��,�f�~�W,���)
AS 
(
	SELECT * FROM ����
)
SELECT * FROM TEMP ORDER BY ��� DESC;

USE ����_��


WITH T1
AS
( SELECT TOP(10) ���u�s��,�m�W,�٩I,¾��,�~��
  FROM ���u ORDER BY �~�� DESC )
, T2
AS
( SELECT TOP(5) ���u�s��,�m�W,�٩I,¾��,�~��
  FROM ���u ORDER BY �~�� DESC )

SELECT * FROM T1 LEFT JOIN T2 ON T1.���u�s��=T2.���u�s��;


WITH T1
AS
( SELECT �٩I,¾��,COUNT(*) �H��
  FROM ���u
  GROUP BY �٩I,¾��
 )

SELECT [¾��],[�p�j],[����]
FROM T1 
PIVOT (SUM(�H��) FOR �٩I IN([�p�j],[����])) AS P;

/* CTE ���j
1. �̦h�i���j32767��
2. �w�]�u�|����100��
3. �i�Q�� �d�ߴ��� �ӽվ㻼�j����
*/
--�ۤv�d�ۤv
--����X���Y�W�q
WITH EE(���u��,�m�W,¾��,���h)
AS 
(
	SELECT ���u�s��,�m�W,¾��,1 
	FROM ���u
	WHERE �D�� IS NULL
	UNION ALL
	SELECT A.���u�s��,A.�m�W,A.¾��,B.���h+1
	FROM ���u AS A JOIN EE AS B ON A.�D��=B.���u��
)
SELECT * FROM EE;

--OPTION (MAXRECURSION 5);  ����j����
WITH EE(���u��,�m�W,¾��,���h)
AS 
(
	SELECT ���u�s��,�m�W,¾��,1 
	FROM ���u
	WHERE �D�� IS NULL
	UNION ALL
	SELECT A.���u�s��,A.�m�W,A.¾��,B.���h+1
	FROM ���u AS A JOIN EE AS B ON A.�D��=B.���u��
)
SELECT * FROM EE OPTION (MAXRECURSION 5);  --����j����


/*HomeWork
1. CTE ���u�����ɶ��h (�ҡG(2)���u�a��(1)�i�Զ���(4)�L���R)
2.��X�S�ӤW�Z�� (�D�ئp�U)
*/

/*
���@���u��.���c�p�U
EmployeeID Name 
------------------
1001 �i�T
1002 ���|
1003 ����
�t���@�i���u�X�Ԩ�d��
EmployeeID Date
----------------------
1001 2007/03/24
1002 2007/03/24
1003 2007/03/24
1001 2007/03/25
1002 2007/03/25
1001 2007/03/26
1003 2007/03/26

�q�W���i�H�ݥX..���u�����b2007/03/25�S����d.���|�b2007/03/26�S����d.
�ҥH�ڷQ�o�X�p�U����T:
EmployeeID Date
-----------------------
1003 2007/03/25
1002 2007/03/26


-----------------------------------------------------------------------
-----------------------------------------------------------------------

CREATE TABLE #���u
(
  ���u�s�� VARCHAR(4),
  �m�W NVARCHAR(10)
)
go
CREATE TABLE #�X�ʶ�
(
  ���u�s�� VARCHAR(4),
  �W�Z�� DATE
)
go

INSERT INTO #���u VALUES('1001','�i�T')
INSERT INTO #���u VALUES('1002','���|')
INSERT INTO #���u VALUES('1003','����')

INSERT INTO #�X�ʶ� VALUES('1001','2007/03/24')
INSERT INTO #�X�ʶ� VALUES('1002','2007/03/24')
INSERT INTO #�X�ʶ� VALUES('1003','2007/03/24')
INSERT INTO #�X�ʶ� VALUES('1001','2007/03/25')
INSERT INTO #�X�ʶ� VALUES('1002','2007/03/25')
INSERT INTO #�X�ʶ� VALUES('1001','2007/03/26')
INSERT INTO #�X�ʶ� VALUES('1003','2007/03/26')
*/