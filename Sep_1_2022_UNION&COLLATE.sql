USE �m��;
GO

/* UNION
1.UNION�̵M�ݭn��O �ɶ��B�B�⦨��
2.UNION���ӷ�������ƥ����ۦP
3.UNION���ӷ������쫬�O�����ۦP
4.UNION�����G���W�١A�|�H�Ĥ@���d�ߵ��G����쬰�̫ᵲ�G���W��
*/

SELECT �~�W FROM ����
UNION  --�X�֡A�h�����ƭ�
SELECT �~�W FROM �K�K;

SELECT �~�W FROM ����
UNION ALL  --�X�֡A�����X�A�@�_
SELECT �~�W FROM �K�K;

--�w�� Collation
--�|�y����Ʈw�����u��r��ơv �j�M�B�Ƨ� �X���D

SELECT * FROM fn_helpcollations();
SELECT * FROM fn_helpcollations() WHERE [name] LIKE '%taiwan%' ;
SELECT * FROM fn_helpcollations() WHERE [name] LIKE '%taiwan%' COLLATE Chinese_Taiwan_Bopomofo_CI_AI;
SELECT * FROM fn_helpcollations() WHERE [name] LIKE '%japan%';
SELECT * FROM fn_helpcollations() WHERE [name] LIKE '%korean%';



SELECT * FROM ���u ORDER BY �m�W;

USE �s�s;
CREATE TABLE �s����
(
    ���~�s�� INT,
	���~�W NVARCHAR(20),
	��� MONEY
)

INSERT INTO �s���� SELECT * FROM �m�m.dbo.����;

SELECT * FROM �s����;

SELECT A.*,B.*
FROM �s�s.dbo.�s���� AS A JOIN ����_��.dbo.���~��� AS B ON A.���~�W=B.���~ COLLATE Chinese_Taiwan_Stroke_CI_AI;


USE ����_��;
SELECT * FROM ���u ORDER BY �m�W;
SELECT * FROM ���u ORDER BY �m�W COLLATE Chinese_Taiwan_Bopomofo_CI_AI; --���Ӫ`���Ƨ�


--�إ߸�Ʈw�A���w�w��
CREATE DATABASE �V�m
ON PRIMARY
(
	NAME='�m��Data',FILENAME='C:\�m�߮a\�m�߸��.mdf',
	SIZE=20MB,MAXSIZE=UNLIMITED,FILEGROWTH=30MB
)

LOG ON
(
	NAME='�m��Log',FILENAME='C:\�m�߮a\�m�߰O��.ldf',
	SIZE=30MB,MAXSIZE=UNLIMITED,FILEGROWTH=50%
)
COLLATE Japanese_CI_AI
GO


--�إ߸�ƪ�A��r���w��
CREATE TABLE �m�ߪ�
(
    ��r���1 NVARCHAR(30) COLLATE Japanese_CI_AI,
	��r���2 NVARCHAR(30) COLLATE Chinese_Taiwan_Bopomofo_CI_AI,
	��r���3 NVARCHAR(30) COLLATE Korean_90_CI_AI_KS,
	�ƭ�1 INT
)

--�d�߸�Ʈw���w��
SELECT * FROM sys.databases;
SELECT [database_id],[name],[collation_name] FROM sys.databases;

USE ����_��
EXEC sp_help '���~���'
