/*HomeWork
3-1 �C�X�C�����~�ʶR�̦h���e���Ȥ�
3-2 �C�X�C��Ȥ��ʶR�̦h��3�����~
*/

--�ܼƫŧi�u���@���ʡA�ӥB�����@�_�A������}����
DECLARE @aa NVARCHAR(10);
SET @aa='���K�q��';
PRINT @aa;

DECLARE @bb INT;
SET @bb=100;
SET @bb=@bb+200;
PRINT @bb;

--���t���ܼƤ���ŧi
SELECT @@VERSION;
SELECT @@SERVERNAME;
SELECT @@SERVICENAME;
SELECT @@ROWCOUNT;
SELECT @@ERROR;
SELECT @@SPID;

--�ܼƪ� vs. �Ȧs�� vs. CTE vs. View

--�ܼƪ�
DECLARE @TT TABLE 
(
	�s�� INT,
	�m�W NCHAR(10),
	�~�� INT
)

INSERT INTO @TT VALUES(1,'AAA',100);
INSERT INTO @TT VALUES(2,'BBB',200);
INSERT INTO @TT VALUES(3,'CCC',300);
UPDATE @TT SET �m�W=RTRIM(�m�W)+'ZZ' WHERE �s��=2;
INSERT INTO @TT VALUES(4,'DDD',400);
DELETE FROM @TT WHERE �s��=3;

SELECT * FROM @TT;

--SELECT�����i�@��d�@�䵹
USE ����_��
--�ϥΤ@���ܼ� 
DECLARE @vv MONEY=(SELECT ��� FROM ���~��� WHERE ���~�s��=10);
SET @vv=@vv+10;
PRINT @vv;
--�p�S�UWHERE����ɡA�|�������̫�@��
DECLARE @name NVARCHAR(10);
SELECT @name=���~ FROM ���~���;
PRINT @name;

--�ϥΦh���ܼ�
DECLARE @name NVARCHAR(10);
DECLARE @price MONEY;
SELECT @name=���~,@price=��� FROM ���~��� WHERE ���~�s��=10;
SET @price=@price+10;
PRINT @name;
PRINT @price;

--if...else
DECLARE @price MONEY;
SELECT @price=��� FROM ���~��� WHERE ���~�s��=20;
IF @price<=50
	BEGIN
		PRINT '@price';
		PRINT '�n�K�y�I';
	END
ELSE
	BEGIN
		PRINT '@price';
		PRINT '�n�Q��I';
	END

SELECT * FROM sys.tables;
SELECT COUNT(*) FROM sys.tables WHERE [name]='AAA';
SELECT COUNT(*) FROM sys.tables WHERE [name]='���u';

--�Q��IF...ELSE �ت�
IF (SELECT COUNT(*) FROM sys.tables WHERE [name]='AAA')>0
	TRUNCATE TABLE [AAA];
ELSE
	CREATE TABLE [AAA]
	(
		�s�� INT,
		��� NVARCHAR(10)
	)

--db �u�� WHILE �j�� 
DECLARE @cc INT =1;
WHILE @cc<=10
	BEGIN
		PRINT @cc;
		SET @cc=@cc+1;
	END


DECLARE @maxId INT=(SELECT MAX(���~�s��) FROM ���~���);
DECLARE @id INT=1;
DECLARE @name NVARCHAR(10);
DECLARE @price MONEY;
--����A�q�`id���|�s���A�ӥBSELECT�i�d�����A�L���Ψ�WHILE 
WHILE @id<=@maxId
  BEGIN
	SELECT @name=���~,@price=��� FROM ���~��� WHERE ���~�s��=@id;	
	PRINT CONCAT(@id,', ',@name,', ',@price);
	SET @id=@id+1;
  END

SELECT ���u�s��,�m�W,¾��,�٩I FROM ���u

--�N�r�i����� ���n�d�⦸
SELECT ���u�s��,�m�W,¾��,'��' FROM ���u WHERE �٩I='�p�j'
UNION ALL
SELECT ���u�s��,�m�W,¾��,'��' FROM ���u WHERE �٩I='����'
--��������������������������������������������������������
SELECT ���u�s��,�m�W,¾��,
	CASE �٩I
		WHEN '�p�j' THEN '��'
		WHEN '����' THEN '��'
	END AS �ʧO
FROM ���u


SELECT ���~�s��,���~,���,
	CASE 
		WHEN ���>=100 THEN '������'
		WHEN ���>=50 THEN '������'
		WHEN ���>=20 THEN '�C����'
		ELSE '�W�K�y' END AS ���浥��
FROM ���~���

/*
CASE 
	WHEN 1 THEN INSERT INTO...
	WHEN 2 THEN UPDATA...
	WHEN 3 THEN DELECT FROM...
	ELSE SELECT * FROM ...
END
*/

--IIF(�޿�P�_, ���߭�, �����߭�)
SELECT ���u�s��,�m�W,¾��,IIF(�٩I='�p�j','��','��') AS �ʧO
FROM ���u

SELECT ���~�s��,���~,���
	,IIF(���>=100,'������',IIF(���>=50,'������',IIF(���>=20,'�C����','�W�K�y'))) AS ���쵥��
FROM ���~���

--CHOOSE(�ﶵ,��1,��2,��3,...)
SELECT �q�渹�X,�Ȥ�s��,�q����,B.�f�B���q�W��
FROM �q�f�D�� AS A JOIN �f�B���q AS B ON A.�e�f�覡=B.�f�B���q�s��;
--����������������������������������������������������������������
SELECT �q�渹�X,�Ȥ�s��,�q����
	,CHOOSE(�e�f�覡,'�ֻ�','�l�H','�˰e') AS �B�e�覡
FROM �q�f�D��;

--�º�show�X���~�T��
--RAISERROR(���~���ο��~�T���A���~����1~25�A���A1~127)
--1~10���L(�|�������L�~�����)  11~16 ���� 17~25�Y��
RAISERROR('�o�O�ۭq�����~�T��',16,10);

UPDATE ���~��� SET ���=500 WHERE ���~�s��=500;
IF @@ROWCOUNT=0 RAISERROR('�å���s�����ơI�I',16,10)

--THROW ���~��, ���~�T��, ���A1~127  �@�߿��~����16
--��SQL�ۤv�{���ۤv���F�A�������U
THROW 50010,'�o�O�ۭq�����~�T��',10;

--�i���� ��r���A��SQL�R�O
EXECUTE ('SELECT * FROM ���~�s��');

DECLARE @name NVARCHAR(10);
SET @name='���~���';
SELECT * FROM @name;

EXECUTE(@sql+@name);


DECLARE @sql NVARCHAR(100);
SET @sql='SELECT * FROM ';
DECLARE @name NVARCHAR(10);
SET @name='���~���';
EXECUTE(@sql+@name);

SET @name='���~���O';
EXECUTE(@sql+@name);

SET @name='�Ȥ�';
EXECUTE(@sql+@name);

--CROSS APPLY (INNER JOIN)

SELECT A.�Ȥ�s��,A.���q�W��,B.�q�渹�X
FROM �Ȥ� AS A JOIN �q�f�D�� AS B ON A.�Ȥ�s��=B.�Ȥ�s��

SELECT A.�Ȥ�s��,A.���q�W��,B.�q�渹�X
FROM �Ȥ� AS A CROSS APPLY ( SELECT �q�渹�X FROM �q�f�D�� WHERE �Ȥ�s��=A.�Ȥ�s��) AS B

--OUTER APPLY (LEFT JOIN)
SELECT A.�Ȥ�s��,A.���q�W��,B.�q�渹�X
FROM �Ȥ� AS A JOIN �q�f�D�� AS B ON A.�Ȥ�s��=B.�Ȥ�s��

SELECT A.�Ȥ�s��,A.���q�W��,B.�q�渹�X
FROM �Ȥ� AS A OUTER APPLY ( SELECT �q�渹�X FROM �q�f�D�� WHERE �Ȥ�s��=A.�Ȥ�s��) AS B


--��r�� SQL�R�O
SELECT ���O�W�� FROM ���~���O
SELECT STRING_AGG(���O�W��,',') FROM ���~���O
SELECT STRING_AGG(QUOTENAME(���O�W��),',') FROM ���~���O

DECLARE @aa NVARCHAR(100) = (SELECT STRING_AGG(QUOTENAME(���O�W��),',') FROM ���~���O);
EXECUTE 'SELECT ����,' +@aa