USE ����_��

SELECT * FROM ���u;               -- 0.004 s
SELECT * FROM ���u ORDER BY �~��; --�w�] ASC ���W�Ƨ�  0.016s
SELECT * FROM ���u ORDER BY �~�� DESC; --����Ƨ�
SELECT * FROM ���u ORDER BY �٩I ASC,�~�� DESC;  --�h�� ���w�S�w�ƧǤ覡
SELECT * FROM ���u ORDER BY 4,8 DESC;    --�w��S�w���i��Ƨ�

SELECT ���u�s��,�m�W,�٩I,���Τ��,�~�� FROM ���u  --����ݭn�����d��


--�l����� (Derived column)  []�i�ιH�ϳW�h���W�r
SELECT ���u�s��,�m�W,�٩I AS [�ʧO],�٩I
	,���Τ��
	,YEAR(GETDATE())-YEAR(���Τ��) AS [�~��]  --�O�W
	,�~��
	,�~��*15 AS [�~�~]
FROM ���u;

SELECT * FROM �q�f�D��
SELECT ALL �Ȥ�s�� FROM �q�f�D��        --0.0138 ALL���w�]��
SELECT DISTINCT �Ȥ�s�� FROM �q�f�D��   --0.0377 ���۲� �Q�ε��G�i����

--SQL Server TOP
SELECT TOP(5) ���u�s��,�m�W,�٩I,���Τ��,�~�� FROM ���u  --���e5����Ƭd��
SELECT TOP(5) ���u�s��,�m�W,�٩I,���Τ��,�~�� FROM ���u ORDER BY �~�� DESC;--���e5����ƨñƧ�
SELECT TOP(10) PERCENT ���u�s��,�m�W,�٩I,���Τ��,�~�� FROM ���u ORDER BY �~�� DESC;-- �N��^���㵲�G�����e 10%

SELECT TOP(11) WITH TIES ���u�s��,�m�W,�٩I,���Τ��,�~�� FROM ���u ORDER BY �~�� DESC;
--WITH TIES���\�z��^��h��A��ȻP�������G�������̫�@��ǰt(�ۦP��)
SELECT TOP(11) WITH TIES ���u�s��,�m�W,�٩I,���Τ��,�~�� FROM ���u;  --�ݱ�ORDER BY


--Updata Delect Top
UPDATE [���u]
SET [�a�}]='�x'+[�a�}]
WHERE [���u�s��]<=3;

UPDATE TOP(3) [���u]
SET [�a�}]='�x'+[�a�}];

--DELECT TOP(50) PERCENT FROM [���u];






