USE ����_��
GO

SELECT * FROM ���u WHERE ¾�� = '�~�ȥD��'  --�n�@�r���t
SELECT * FROM ���u WHERE ¾�� = '�~�ȥD��' OR ¾�� = '�u�{�v'  --�d�ߥX�o���¾��
SELECT * FROM ���u WHERE ¾�� IN( '�~�ȥD��' ,'�u�{�v');  --�P�W��ۦP

/*
�ҽk�j�M �ݥΦr��
% �i�N�����N�r���A�t�ťզr���A�B�����r��
_ �i�N�����N�r���A���t�ťզr���A�B�@���@�r
*/
SELECT * FROM ���u WHERE �m�W LIKE '��%';
SELECT * FROM ���u WHERE �m�W LIKE '�i%'OR �m�W LIKE '��%'OR �m�W LIKE '�L%'; --�d�ߦh�Ӽҽk�r��
SELECT * FROM ���u WHERE �m�W LIKE '[�i���L]%'; --�P�W��ۦP�A��Ʈw�S��
SELECT * FROM �Ȥ� WHERE �Ȥ�s�� LIKE '[ADF][O-Z]%'; --��XADF�����s���A�qO��Z�ƦC

SELECT * FROM ���~��� WHERE ���~ LIKE '%��%';

SELECT LEN('���K�q���{�Ҥ���')
SELECT LEFT('���K�q���{�Ҥ���',4) --�q����4�Ӧr
SELECT RIGHT('���K�q���{�Ҥ���',4) --�q�k��4�Ӧr
SELECT SUBSTRING('���K�q���{�Ҥ���',5,2) --�^���r��
SELECT LOWER('Gjun Inc.')
SELECT UPPER('Gjun Inc.')
SELECT REPLACE('���K�q�����{�Ҥ���','���','�x�_') --���N��r
SELECT REVERSE('���K�q��')  --�A��
SELECT CHARINDEX('���','���K�q�����{�Ҥ���') --�d�ߦr��b�ĴX�Ӧr
SELECT QUOTENAME('���K�q��') --�[�W���A��

--SQL 2017
SELECT STRING_AGG (�m�W,',') FROM ���u; --�N�Ҧ��m�W�H�r�I���j

--SQL 2016
SELECT * FROM string_split('AA,BB,CC,DD,EE,FF',',');

--ISNULL(��,NULL���N��)
SELECT * FROM ���u
SELECT �m�W +':'+ISNULL(�q�ܸ��X,'����g') FROM ���u; --�p��NULL�A������������g
SELECT �m�W+',�D��'+CONVERT(nvarchar,ISNULL(�D��,0)) FROM ���u;  --�N�ƭ��ഫ����rnvarchar
SELECT '('+���u�s��+')'+�m�W+', '+�~��+'�G'+�q�ܸ��X FROM ���u;  --���~�A�L�k�૬
SELECT CONCAT('(',���u�s��,')',�m�W,', ',�~��,'�G',�q�ܸ��X) FROM ���u; --�X�֦r��A���૬

--NULLIF(��1,��2)
SELECT NULLIF (100,100) --�۵��A�^��NULL
SELECT NULLIF (100,200) --���۵��A�Ǧ^��1

--COALESCE(��1, ��2, ��3, .....)
SELECT COALESCE(NULL,NULL,NULL,NULL,NULL,100,NULL,NULL,NULL,NULL)
SELECT COALESCE(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)

CREATE TABLE �m�߭��u��
(
  ���u�s�� INT IDENTITY(1,1) PRIMARY KEY,
  �m�W NVARCHAR(10),
  ���u���� TINYINT,
  �~�� MONEY,
  ���~ MONEY,
  �u�@�ɼ� MONEY,
  �P����B MONEY,
  �Ī���v MONEY
)
GO

INSERT INTO �m�߭��u�� VALUES('���p��',1,35000,NULL,NULL,NULL,NULL)
INSERT INTO �m�߭��u�� VALUES('���p��',1,28000,NULL,NULL,NULL,NULL)
INSERT INTO �m�߭��u�� VALUES('�L�j��',2,NULL,110,275,NULL,NULL)
INSERT INTO �m�߭��u�� VALUES('���p��',2,NULL,125,346,NULL,NULL)
INSERT INTO �m�߭��u�� VALUES('�L���R',2,NULL,105,758,NULL,NULL)
INSERT INTO �m�߭��u�� VALUES('���ҤH',3,NULL,NULL,NULL,7567632,0.1)
INSERT INTO �m�߭��u�� VALUES('���g�B',3,NULL,NULL,NULL,543243,0.08)
INSERT INTO �m�߭��u�� VALUES('�Ԥӭ�',3,NULL,NULL,NULL,357654,0.12)
GO

SELECT * FROM �m�߭��u��
SELECT ���u�s��,�m�W,���u����
	, COALESCE(�~��*15,���~*�u�@�ɼ�,�P����B*�Ī���v) AS ���I���B --��ܲĤ@�ӵo�ͫDNULL����
FROM �m�߭��u��


--CONVERT (�ؼЫ��O,��[,�榡�Ѽ�])  CAST�ഫ���A
SELECT * FROM ���u
SELECT CONVERT (NVARCHAR,GETDATE());
SELECT CONVERT (NVARCHAR,GETDATE(),101); --�榡�ѼơG100,101,102,111
SELECT ���u�s��,�m�W,¾��,���Τ��,CONVERT(NVARCHAR,CAST(�~�� AS MONEY),1) AS �~�� FROM ���u;


--FORMAT(��,�榡��)
SELECT FORMAT(54000,'C')
SELECT FORMAT(0.8756,'X')
SELECT FORMAT(54000,'#.0')
SELECT FORMAT(0.8756,'#.0%')
SELECT FORMAT(GETDATE(),'D') --�~���
SELECT FORMAT(GETDATE(),'d') --///
SELECT FORMAT(GETDATE(),'F') --���+�ɤ�+��
SELECT FORMAT(GETDATE(),'f') --���+�ɤ�
SELECT FORMAT(GETDATE(),'T') --�ɤ���
SELECT FORMAT(GETDATE(),'t') --�ɤ�
SELECT FORMAT(GETDATE(),'yyyy-MM-dd dddd HH:mm:ss')

SELECT DATEPART (WEEKDAY,GETDATE()) --�@�g�����ĴX��
SELECT FORMAT (GETDATE(),'ddd') --��ܶg�O

SELECT FORMAT(54000.567,'C','fr-fr') --�����Ÿ��ഫ C# 






