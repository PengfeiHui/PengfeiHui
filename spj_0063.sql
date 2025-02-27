/*********************
ѧ�ţ�22009290063
������������
*************************/
-- ���� S ��
USE master;
GO

CREATE DATABASE SPJ_mng 
ON
PRIMARY  
    (NAME = spj,
    FILENAME = 'D:\SPJData\SPJdat1.mdf',
    SIZE = 100MB,
    MAXSIZE = 200,
    FILEGROWTH = 20)
    
LOG ON 
   (NAME = spjlog,
    FILENAME = 'D:\SPJData\SPJlog1.ldf',
    SIZE = 100MB,
    MAXSIZE = 200,
    FILEGROWTH = 20)
    ;
GO

USE SPJ_mng;
GO
/************************
������
************************/
CREATE TABLE S (
    SNO CHAR(2) PRIMARY KEY,       
    SNAME VARCHAR(10),             
    STATUS INT,                    
    CITY VARCHAR(10)              
);
-- ���� P ��
CREATE TABLE P (
    PNO CHAR(2) PRIMARY KEY,      
    PNAME VARCHAR(10),             
    COLOR VARCHAR(10),             
    WEIGHT INT                    
);

-- ���� J ��
CREATE TABLE J (
    JNO CHAR(2) PRIMARY KEY,       
    JNAME VARCHAR(10),            
    CITY VARCHAR(10)             
);

-- ���� SPJ ��
CREATE TABLE SPJ (
    SNO CHAR(2),                  
    PNO CHAR(2),                   
    JNO CHAR(2),                
    QTY INT,                       
    PRIMARY KEY (SNO, PNO, JNO),   
    FOREIGN KEY (SNO) REFERENCES S(SNO),
    FOREIGN KEY (PNO) REFERENCES P(PNO),
    FOREIGN KEY (JNO) REFERENCES J(JNO)
);
/**************************
��������
**************************/
-- ���� S ��
INSERT INTO S VALUES ('S1', '����', 20, '���');
INSERT INTO S VALUES ('S2', 'ʢ��', 10, '����');
INSERT INTO S VALUES ('S3', '������', 30, '����');
INSERT INTO S VALUES ('S4', '��̩ʢ', 20, '���');
INSERT INTO S VALUES ('S5', 'Ϊ��', 30, '�Ϻ�');

-- ���� P ��
INSERT INTO P VALUES ('P1', '��ĸ', '��', 12);
INSERT INTO P VALUES ('P2', '��˨', '��', 17);
INSERT INTO P VALUES ('P3', '��˿��', '��', 14);
INSERT INTO P VALUES ('P4', '��˿��', '��', 14);
INSERT INTO P VALUES ('P5', '͹��', '��', 40);
INSERT INTO P VALUES ('P6', '����', '��', 30);

-- ���� J ��
INSERT INTO J VALUES ('J1', '����', '����');
INSERT INTO J VALUES ('J2', 'һ��', '����');
INSERT INTO J VALUES ('J3', '���ɳ�', '���');
INSERT INTO J VALUES ('J4', '�촬��', '���');
INSERT INTO J VALUES ('J5', '������', '��ɽ');
INSERT INTO J VALUES ('J6', '���ߵ糧', '����');
INSERT INTO J VALUES ('J7', '�뵼�峧', '�Ͼ�');

-- ���� SPJ ��
INSERT INTO SPJ VALUES ('S1', 'P1', 'J1', 200);
INSERT INTO SPJ VALUES ('S1', 'P1', 'J3', 100);
INSERT INTO SPJ VALUES ('S1', 'P1', 'J4', 700);
INSERT INTO SPJ VALUES ('S1', 'P2', 'J2', 100);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J1', 400);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J2', 200);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J4', 500);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J5', 400);
INSERT INTO SPJ VALUES ('S2', 'P5', 'J1', 400);
INSERT INTO SPJ VALUES ('S2', 'P5', 'J2', 100);
INSERT INTO SPJ VALUES ('S3', 'P1', 'J1', 200);
INSERT INTO SPJ VALUES ('S3', 'P3', 'J1', 200);
INSERT INTO SPJ VALUES ('S4', 'P5', 'J1', 100);
INSERT INTO SPJ VALUES ('S4', 'P6', 'J3', 300);
INSERT INTO SPJ VALUES ('S4', 'P6', 'J4', 200);
INSERT INTO SPJ VALUES ('S5', 'P2', 'J4', 100);
INSERT INTO SPJ VALUES ('S5', 'P3', 'J1', 200);
INSERT INTO SPJ VALUES ('S5', 'P6', 'J2', 200);
INSERT INTO SPJ VALUES ('S5', 'P6', 'J4', 500);
/*************************
��ѯ
**************************/
--һ����Ӧ����J1����Ĺ�Ӧ�̺���SNO
--1��ʹ�� SELECT DISTINCT
SELECT DISTINCT SNO
FROM SPJ
WHERE JNO = 'J1';
--2��ʹ�� EXISTS
SELECT SNO
FROM S
WHERE EXISTS (
    SELECT 1
    FROM SPJ
    WHERE SPJ.SNO = S.SNO AND SPJ.JNO = 'J1'
);
--3��ʹ�� IN
SELECT SNO
FROM S
WHERE SNO IN (
    SELECT SNO
    FROM SPJ
    WHERE JNO = 'J1'
);
--������Ӧ����J1���P1�Ĺ�Ӧ�̺���SNO
--1��ʹ���Ӳ�ѯ

SELECT SNO
FROM SPJ
WHERE JNO = 'J1' AND PNO = 'P1'
GROUP BY SNO;
--2��ʹ�� EXISTS
SELECT SNO
FROM S
WHERE EXISTS (
    SELECT 1
    FROM SPJ
    WHERE SPJ.SNO = S.SNO AND SPJ.JNO = 'J1' AND SPJ.PNO = 'P1'
);
--������Ӧ����J1���Ϊ��ɫ�Ĺ�Ӧ�̺���SNO
--1��ʹ�� JOIN ��ѯ
SELECT DISTINCT SPJ.SNO
FROM SPJ
JOIN P ON SPJ.PNO = P.PNO
WHERE SPJ.JNO = 'J1' AND P.COLOR = '��';
--2��ʹ��Ƕ���Ӳ�ѯ
SELECT DISTINCT SNO
FROM SPJ
WHERE JNO = 'J1' AND PNO IN (
    SELECT PNO
    FROM P
    WHERE COLOR = '��'
);
--3��ʹ�� EXISTS
SELECT DISTINCT SNO
FROM SPJ AS SP
WHERE JNO = 'J1' AND EXISTS (
    SELECT 1
    FROM P
    WHERE P.PNO = SP.PNO AND P.COLOR = '��'
);
--�ģ���û��ʹ�����Ӧ�������ĺ�ɫ����Ĺ��̺�JNO
--1��ʹ�� NOT IN ���Ӳ�ѯ
SELECT DISTINCT JNO
FROM SPJ
WHERE JNO NOT IN (
    SELECT DISTINCT SPJ.JNO
    FROM SPJ
    JOIN S ON SPJ.SNO = S.SNO
    JOIN P ON SPJ.PNO = P.PNO
    WHERE S.CITY = '���' AND P.COLOR = '��'
);
--2��ʹ�� NOT EXISTS
SELECT DISTINCT JNO
FROM SPJ
WHERE NOT EXISTS (
    SELECT 1
    FROM SPJ AS SP
    JOIN S ON SP.SNO = S.SNO
    JOIN P ON SP.PNO = P.PNO
    WHERE SP.JNO = SPJ.JNO AND S.CITY = '���' AND P.COLOR = '��'
);

--�壬������ʹ���˹�Ӧ��S1����Ӧ��ȫ������Ĺ��̺�JNO
--1��ʹ��NOT EXISTS
SELECT DISTINCT JNO
FROM SPJ AS SPJ1
WHERE NOT EXISTS (
    SELECT PNO
    FROM SPJ AS SPJ_S1
    WHERE SPJ_S1.SNO = 'S1'
    AND SPJ_S1.PNO NOT IN (
        SELECT SPJ2.PNO
        FROM SPJ AS SPJ2
        WHERE SPJ2.JNO = SPJ1.JNO
    )
);

--2��ʹ�� IN ���Ӳ�ѯ
SELECT DISTINCT JNO
FROM SPJ
WHERE JNO IN (
    SELECT JNO
    FROM SPJ
    WHERE PNO IN (
        SELECT PNO
        FROM SPJ
        WHERE SNO = 'S1'
    )
    GROUP BY JNO
    HAVING COUNT(DISTINCT PNO) = (SELECT COUNT(DISTINCT PNO) FROM SPJ WHERE SNO = 'S1')
);


--��SQL������²�����
--һ���ҳ����й�Ӧ�̵����������ڳ��У�
--1��SELECT
SELECT Sname,CITY
FROM S


--�����ҳ�������������ƣ���ɫ������
--1��SELECT
SELECT PNAME,COLOR,WEIGHT
FROM P
--2��
SELECT PNAME, COLOR, WEIGHT
FROM (SELECT PNAME, COLOR, WEIGHT FROM P) AS PartInfo;

--�����ҳ�ʹ�ù�Ӧ��S1����Ӧ����Ĺ��̺��룺
--1��ʹ�� SELECT �� WHERE
SELECT JNO
FROM SPJ
WHERE SNO = 'S1'

--�ģ��ҳ�������ĿJ2ʹ�õĸ�����������Ƽ�������
--1��ʹ�� JOIN ���� SPJ �� P ��
SELECT P.PNAME, SPJ.QTY
FROM SPJ
JOIN P ON SPJ.PNO = P.PNO
WHERE SPJ.JNO = 'J2';
--2��ʹ���Ӳ�ѯ�� JOIN ����
SELECT P.PNAME, SPJ.QTY
FROM P
JOIN (SELECT PNO, QTY FROM SPJ WHERE JNO = 'J2') AS SPJ
ON P.PNO = SPJ.PNO;

--��,�ҳ��Ϻ����̹�Ӧ�������������
--1��ʹ�� JOIN ��ѯ S ��� SPJ ��
SELECT DISTINCT SPJ.PNO
FROM S
JOIN SPJ ON S.SNO = SPJ.SNO
WHERE S.CITY = '�Ϻ�';
--2��ʹ���Ӳ�ѯ
SELECT DISTINCT PNO
FROM SPJ
WHERE SNO IN (SELECT SNO FROM S WHERE CITY = '�Ϻ�');
--3��ʹ�� EXISTS
SELECT DISTINCT PNO
FROM SPJ
WHERE EXISTS (
    SELECT 1
    FROM S
    WHERE S.SNO = SPJ.SNO AND S.CITY = '�Ϻ�'
);


--�����ҳ�ʹ���Ϻ���������Ĺ������ƣ�
--1��ʹ�ö�� JOIN ��ѯ
SELECT DISTINCT J.JNAME
FROM S
JOIN SPJ ON S.SNO = SPJ.SNO
JOIN J ON SPJ.JNO = J.JNO
WHERE S.CITY = '�Ϻ�';

--2��ʹ�� EXISTS
SELECT DISTINCT J.JNAME
FROM J
WHERE EXISTS (
    SELECT 1
    FROM SPJ
    JOIN S ON SPJ.SNO = S.SNO
    WHERE SPJ.JNO = J.JNO AND S.CITY = '�Ϻ�'
);

--�ߣ��ҳ�û��ʹ������������Ĺ��̺��룺
--1��ʹ�� NOT IN �Ӳ�ѯ
SELECT DISTINCT JNO
FROM J
WHERE JNO NOT IN (
    SELECT DISTINCT SPJ.JNO
    FROM SPJ
    JOIN S ON SPJ.SNO = S.SNO
    WHERE S.CITY = '���'
);
--2��ʹ�� NOT EXISTS
SELECT DISTINCT J.JNO
FROM J
WHERE NOT EXISTS (
    SELECT 1
    FROM SPJ
    JOIN S ON SPJ.SNO = S.SNO
    WHERE SPJ.JNO = J.JNO AND S.CITY = '���'
);
--�ˣ���ȫ����ɫ�������ɫ�ĳ���ɫ
UPDATE P
SET COLOR = '��'
WHERE COLOR = '��';
SELECT *
FROM P
--�ţ�����S5������J2�����P6��Ϊ��S3��Ӧ
DELETE FROM SPJ WHERE SNO = 'S5' AND PNO = 'P6' AND JNO = 'J2';
INSERT INTO SPJ (SNO, PNO, JNO) VALUES ('S3', 'P6', 'J2');
--ʮ���ӹ�Ӧ�̹�ϵ��ɾ��S2��¼�����ӹ�Ӧ��ϵ��ɾ����Ӧ��¼
DELETE FROM SPJ WHERE SNO = 'S2';
DELETE FROM S WHERE SNO = 'S2';
SELECT *
FROM SPJ

ALTER TABLE SPJ NOCHECK CONSTRAINT FK__SPJ__SNO__51851410;

--ʮһ������S2��J6,P4,200�����빩Ӧ��ϵ��
INSERT INTO SPJ (SNO, PNO, JNO, QTY) 
VALUES ('S2', 'P4', 'J6', 200);



--DROP VIEW Supplier_Part_Supply;
--��
--������ͼ
CREATE VIEW Supplier_Part_Supply AS
SELECT 
	S.SNO  AS  Supplier_NO,
    P.PNO AS Part_Code,
    SPJ.QTY AS Supply_Quantity
FROM 
    SPJ
JOIN 
    S ON SPJ.SNO = S.SNO
JOIN 
    P ON SPJ.PNO = P.PNO;
	


--1���ҳ�ʹ�õĸ���������뼰����
SELECT 
    Part_Code,
    SUM(Supply_Quantity) AS Total_Supply_Quantity
FROM 
    Supplier_Part_Supply
GROUP BY 
    Part_Code;

--2���ҳ���Ӧ��S1��Ӧ���
SELECT 
    Part_Code,
    Supply_Quantity
FROM 
    Supplier_Part_Supply
WHERE 
    Supplier_NO = 'S1';
/******************************************
�塢������Ӧ�������Ӧ��SP��������Orders��
*******************************************/
CREATE TABLE SP(
	Sno CHAR(2),	
	Pno CHAR(2),
	balance int CHECK(balance >= 0),
	PRIMARY KEY (Sno,Pno),
	FOREIGN KEY (Sno) REFERENCES S(Sno),
	FOREIGN KEY (Pno) REFERENCES P(Pno),
);

CREATE TABLE Orders(
	Ono CHAR(4),
	Sno CHAR(2),
	Pno CHAR(2),
	Jno CHAR(2),
	Otime DATETIME,  
	quantity int CHECK(quantity >= 0),
	PRIMARY KEY (Ono),
	FOREIGN KEY (Sno) REFERENCES S(Sno),
	FOREIGN KEY (Pno) REFERENCES P(Pno),
	FOREIGN KEY (Jno) REFERENCES J(Jno),
);
--����������������ں�����ԣ�
INSERT INTO SP VALUES ('S1', 'P1', 200);
INSERT INTO SP VALUES ('S1', 'P2', 100);
INSERT INTO SP VALUES ('S2', 'P3', 500);
INSERT INTO SP VALUES ('S4', 'P5', 100);
INSERT INTO SP VALUES ('S5', 'P6', 200);
/********************
�鿴����
***********************/
SELECT *
FROM Orders
SELECT *
FROM SP
/******************************************
�����������۴洢����
*******************************************/
CREATE PROCEDURE SellPart
    @Ono CHAR(4),     -- �������
    @Sno CHAR(2),     -- ��Ӧ�̱��
    @Pno CHAR(2),     -- ������
    @Jno CHAR(2),     -- ������Ŀ���
    @quantity INT     -- ��������
AS
BEGIN
	DECLARE @ErrorVar INT;   --�����û�����,���ڴ洢SQL���Ĵ�����
    -- ������Ƿ����
    IF EXISTS (
        SELECT 1
        FROM SP
        WHERE Sno = @Sno AND Pno = @Pno AND balance >= @quantity
    )
    BEGIN
        -- ���붩����¼
        INSERT INTO Orders (Ono, Sno, Pno, Jno, Otime, quantity)
        VALUES (@Ono, @Sno, @Pno, @Jno, GETDATE(), @quantity);
		SELECT @ErrorVar = @@ERROR;	--ϵͳ��������һ��SQL��ִ��״̬��
							--�����һSQL������¸�ֵ�������
			IF @ErrorVar != 0	--Ϊ0��ʾ����ִ����ȷ����0ֵΪϵͳ����Ĵ����ţ�
						--�������������в�����ϸ������Ϣ������
				BEGIN
					ROLLBACK;	--������@@ERROR����ǰ����@ErrorVar���
					RETURN @ErrorVar;
				END
        -- ���¿����
        UPDATE SP
        SET balance = balance - @quantity
        WHERE Sno = @Sno AND Pno = @Pno;
		SELECT @ErrorVar = @@ERROR;	--ϵͳ��������һ��SQL��ִ��״̬��
							--�����һSQL������¸�ֵ�������
			IF @ErrorVar != 0	--Ϊ0��ʾ����ִ����ȷ����0ֵΪϵͳ����Ĵ����ţ�
						--�������������в�����ϸ������Ϣ������
				BEGIN
					ROLLBACK;	--������@@ERROR����ǰ����@ErrorVar���
					RETURN @ErrorVar;
				END
        PRINT '�����ѳɹ����룬����Ѹ��¡�';
    END
    ELSE
    BEGIN
        PRINT '��治��!';
    END
END;

-- ʾ�������ô洢���̲���30��������¼
EXEC SellPart 'O001', 'S1', 'P1', 'J1', 10;
EXEC SellPart 'O002', 'S1', 'P1', 'J1', 10;
EXEC SellPart 'O003', 'S1', 'P2', 'J2', 10;
EXEC SellPart 'O004', 'S2', 'P3', 'J4', 10;
EXEC SellPart 'O005', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O006', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O007', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O008', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O009', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O010', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O011', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O012', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O013', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O014', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O015', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O016', 'S1', 'P1', 'J1', 10;
EXEC SellPart 'O017', 'S1', 'P2', 'J2', 10;
EXEC SellPart 'O018', 'S2', 'P3', 'J4', 10;
EXEC SellPart 'O019', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O020', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O021', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O022', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O023', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O024', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O025', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O026', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O027', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O028', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O029', 'S4', 'P5', 'J1', 10;
EXEC SellPart 'O030', 'S4', 'P5', 'J1', 10;



/******************************************
�ߡ�ɾ��SPJ��������ͼSPJ���ṹͬSPJ��
*******************************************/
DROP TABLE IF EXISTS SP;
GO
--������ͼ
CREATE VIEW SPJ AS
SELECT 
    Sno,          -- ��Ӧ�̱��
    Pno,          -- ������
    Jno,          -- ������Ŀ���
    SUM(quantity) AS QTY  -- ����Ӧ���ṩ�����̵ĸ����������
FROM 
    Orders
GROUP BY 
    Sno, Pno, Jno;

--����ִ��(ע�ⲻ�Ǹ�д��ֻ��ִ��)֮ǰ�����У���д�������õ�SPJ��Ĳ�ѯ��䣬��֤��Щ��ѯ����Ƿ��ܹ���ȷִ�У���˵��ԭ��
/**************
������ȷִ��
��������ͼ����Ҳ��SPJ����ʱ���ݿ⽫SPJ��ͼ������������
***************/
