/*�J�` �E�X��� (Aggreate Function)
SUM�BAVG�BMAX�BMIN�BCOUNT�BVAR�BVARP�BSTDEV�BSTDEVP
1.�i�i������s��
2.�i�Q�έp��Ψ�Ƶ��G�A�i�����
3.�`�NNULL�ȡA�J�`��Ʒ|���L �n��is null�ɭ�
4.�J�`��Ƥ��ACOUNT(*) �ҥ~�A�i����*
5.�έp VS ����
*/
USE ����_��
SELECT * FROM ���u

--���έp�p��,�Ҧ�GROUP BY���Ҷ��X�{�bSELECT���A�_�h�L�k�s�@
SELECT �٩I,COUNT(���u�s��) AS �H��
	,SUM(�~��) AS �~���`�M
	,AVG(�~��) AS �����~��
	,MAX(�~��) AS �̰��~��
	,MIN(�~��) AS �̧C�~��
FROM ���u
GROUP BY �٩I;

SELECT B.���O�W��
	,AVG(���) AS ��������
	,MAX(���) AS �̰�����
	,MIN(���) AS �̧C����
FROM ���~��� AS A JOIN ���~���O AS B ON A.���O�s�� = B.���O�s��
GROUP BY B.���O�W��;

SELECT �٩I,¾��,COUNT(���u�s��) AS �H��
FROM ���u
GROUP BY �٩I,¾��

SELECT SUBSTRING(�a�},1,3) AS ����,COUNT(���u�s��) AS �H��
FROM ���u
GROUP BY SUBSTRING(�a�},1,3) --�^���r��

--�έp
SELECT �٩I,¾��,COUNT(���u�s��) AS �H��
FROM ���u
GROUP BY �٩I,¾��
--����
SELECT * FROM ���u WHERE �٩I = '�p�j';

SELECT DISTINCT ¾�� FROM ���u; --������¾��

--SQL �S��
--���D�O�k�͡A�٩I�N����
--GROUP BY (ALL) �p��ALL�A�Y��¾�٤H�Ƭ�0�A�]�|�C�X
SELECT ¾��,COUNT(���u�s��) AS �H��
FROM ���u
WHERE �٩I='�p�j'
GROUP BY ALL ¾��

--�bGROUP BY�e�Q��WHERE�L�o�����n����ơAHAVING�o�ͦbGROUP BY��
--�n����GROUP��~�వ�έp�᪺�z��
SELECT �٩I,¾��,COUNT(���u�s��) AS �H��
FROM ���u
WHERE �٩I='�p�j'
GROUP BY �٩I,¾��
HAVING COUNT(���u�s��) >= 3

--HW 2003�~�P��ƶqTOP 10
--HW 2004�~���R�L���A�����Ȥ�A�åB�̷��ʶR�ɶ��Ƨ�