/* View (�˵�) �T�w�x�s�_�Ӫ��@�qSQL SELECT �d�߻y�k�A�u�O�ӥN�W��
�Ӧ~�N�ɥN�������A�����S�����ɬd�߮į઺�@��
1. ²��(����)������SQL�y�k
2. ��K�v���t�m�α���
3. �]�O�t�����l�d��
4. ���వORDER BY
*/
USE ����_��

SELECT * FROM �q�f�D��

CREATE VIEW �Բӭq���˵�
AS
	SELECT A.�q�渹�X,B.���q�W��,B.�s���H,B.�s���H¾��,B.�q��,C.�m�W AS �t�d���u
		,D.�f�B���q�W�� AS �B�e�覡,A.�B�O
	FROM �q�f�D�� AS A JOIN �Ȥ� AS B ON A.�Ȥ�s��=B.�Ȥ�s��
	JOIN ���u AS C ON A.���u�s�� = C.���u�s��
	JOIN �f�B���q AS D ON A.�e�f�覡=D.�f�B���q�s��
GO

SELECT * FROM �Բӭq���˵�;
--����������������������������������������������������������������������������
SELECT * FROM (
	SELECT A.�q�渹�X,B.���q�W��,B.�s���H,B.�s���H¾��,B.�q��,C.�m�W AS �t�d���u
		,D.�f�B���q�W�� AS �B�e�覡,A.�B�O
	FROM �q�f�D�� AS A JOIN �Ȥ� AS B ON A.�Ȥ�s��=B.�Ȥ�s��
	JOIN ���u AS C ON A.���u�s�� = C.���u�s��
	JOIN �f�B���q AS D ON A.�e�f�覡=D.�f�B���q�s��) AS [�Բӭq���˵�]

--�إߨ��View �F���v��������
CREATE VIEW ���u������˵�
AS
	SELECT [���u�s��], [�m�W], [¾��], [�٩I], [�X�ͤ��], [���Τ��], [�a�}], [�~��], [�q�ܸ��X], [�����������X], [�ۤ�], [����], [�D��]
GO

CREATE VIEW ���u�@�����˵�
AS
	SELECT [���u�s��], [�m�W], [¾��], [�٩I],[���Τ��], [�����������X], [�ۤ�], [�D��]
GO

SELECT * FROM ���u������˵�;
SELECT * FROM ���u�@�����˵�;

/* SCHEMABINDING �ϥΪ��e��
1. ���o�ϥ� * ��
2. ����һݨϥΨ�q���g�k
*/

USE �m�m

CREATE VIEW �������~�˵�
WITH SCHEMABINDING /*���w �T����ΧR��*/
AS
	SELECT ����.���~�s��,����.�~�W
	FROM dbo.����
GO

SELECT * FROM �������~�˵�;

ALTER TABLE ���� DROP COLUMN ����;
DROP VIEW �������~�˵�


CREATE VIEW ����40���H�W���~�˵�
AS 
	SELECT ���~�˵�,�~�W,����
	FROM ����
	WHERE ����>=40
GO

SELECT * FROM ����40���H�W���~�˵�;
SELECT * FROM sys.tables; --�d�ݦ����Ǫ�
SELECT * FROM sys.views;  --�d�ݦ����ǬO���[��


/*�Q��VIEW �ӽs�� (INSERT�BUPDATE�BDELECT)��ƪ��e��
1. �ӷ������ߤ@�iTABLE (����o��JOIN)
2. �ӷ�TABLE���঳�l�����
3.VIEW���e���ର�J�`���G(����GROUP BY)
*/
INSERT INTO ����40���H�W���~�˵� VALUES (26,'�i��',30) --�i�ۥѷs�W���

--���VIEW �����e
ALTER VIEW ����40���H�W���~�˵�
AS
	SELECT ���~�˵�,�~�W,����
	FROM ����
	WHERE ����>=40
	WITH CHECK OPTION  --�s�W�e�|�ˬd�W�誺����A�ŦX�~�|�s�W
GO

INSERT INTO ����40���H�W���~�˵� VALUES (27,'�֨�',30)