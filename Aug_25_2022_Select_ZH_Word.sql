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