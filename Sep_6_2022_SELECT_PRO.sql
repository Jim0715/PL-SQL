/* �l�d�� (SubQuery)
1.�쥻�ݭn�h���d�ߤ�i�����A�Ʊ�@���d�w
2.���g�W������ı
3.��@�l�d�ߡA�̦h32�h
4.�W�ߤl�d�� vs. ���p�l�d��
*/

/* �l�d�ߪ��ϥΦ�m
�q�`�j�������l�d�ߡA�i�H�Φb��L�覡�ѨM�A�קK�l�d��
WHERE�G�q�`�@��Ө��A�Ĳv�_�t
	1. ��������@�ȡA�i�ϥ��ܼƨӧ�g
	2.���M��G���M���ɤ����ı�A���q�`�i�H��JOIN�Ө��N�A�Ĳv����
	3.���զs�b�G�q�`�Ĳv���ΡA���_��
FROM�G�ϥ��W�v�D�`���A�����d�߮Ĳv�X�G���v�T
*/

USE �m�m
--��������@��
SELECT MAX(����) FROM �K�K
SELECT * FROM ���� WHERE ����>=123.79;
--�X�֦p�U�A���Ĳv�C
SELECT * FROM ����
	WHERE ����>=(SELECT MAX(����) FROM �K�K);
--�Ĳv��
DECLARE @VV MONEY=(SELECT MAX(����) FROM �K�K);
SELECT * FROM ���� WHERE ����>= @VV ;


--���M��
SELECT �~�W FROM �K�K
SELECT * FROM ���� WHERE �~�W IN (SELECT �~�W FROM �K�K);
SELECT * FROM ���� WHERE �~�W NOT IN (SELECT �~�W FROM �K�K);

USE ����_��
--HW �S��L�F�誺�Ȥ�
--0.0644
SELECT * FROM �Ȥ� WHERE �Ȥ�s�� NOT IN (SELECT �Ȥ�s�� FROM �q�f�D��);
SELECT A.* FROM �Ȥ� AS A LEFT JOIN �q�f�D�� AS B ON A.�Ȥ�s��=B.�Ȥ�s�� WHERE B.�q�渹�X IS NULL
--HW 2004�~���R�X�����~
SELECT * FROM ���~���  WHERE ���~�s��
	NOT IN (SELECT ���~�s�� FROM �q�f���� AS A JOIN �q�f�D�� AS B ON A.�q�渹�X=B.�q�渹�X WHERE B.�q���� BETWEEN '2002-01-01' AND '2002-12-31' );


--���լO�_�s�b,���p�l�d��
--0.0296
SELECT * FROM �Ȥ� WHERE NOT EXISTS (SELECT * FROM �q�f�D�� WHERE �Ȥ�s��=�Ȥ�.�Ȥ�s��)

USE �m�m
SELECT * FROM ���� AS A
	WHERE EXISTS(SELECT * FROM �K�K AS B WHERE B.�~�W=A.�~�W);

SELECT * FROM ���� AS A
	WHERE NOT EXISTS(SELECT * FROM �K�K AS B WHERE B.�~�W=A.�~�W);

--1.
SELECT * FROM �q�f����
--2.
SELECT �q�渹�X,���~�s��,���*�ƶq*(1-�馩) AS ���B FROM �q�f����
--3.
SELECT �q�渹�X,ROUND(SUM(���*�ƶq*(1-�馩)),0) AS ���B 
FROM �q�f���� GROUP BY �q�渹�X
--4.
SELECT A.�q�渹�X,A.�Ȥ�s��,A.�q����,B.���B,A.�B�O,B.���B+A.�B�O AS �`���B
FROM �q�f�D�� AS A JOIN (SELECT �q�渹�X,ROUND(SUM(���*�ƶq*(1-�馩)),0) AS ���B 
FROM �q�f���� GROUP BY �q�渹�X) AS B ON A.�q�渹�X=B.�q�渹�X

--�U¾�쪺�k�ͤH�� (�����GROUP BY) 
--�C�X�U���~���O������Ӳ��~���������~
--�C�X2002�~�|�u���禬
--2003��X�Ȥ�֭p���B�W�X13000
--�C��Ȥ�̫�@���U��ɶ�
--���R�L���A���Ȥ�A�̷ӳ̪�q���ʶR�ɶ��Ƨ�










