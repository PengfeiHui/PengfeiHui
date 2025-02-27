/*********************
学号：22009290063
姓名：惠鹏飞
*************************/
-- 创建 S 表
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
创建表
************************/
CREATE TABLE S (
    SNO CHAR(2) PRIMARY KEY,       
    SNAME VARCHAR(10),             
    STATUS INT,                    
    CITY VARCHAR(10)              
);
-- 创建 P 表
CREATE TABLE P (
    PNO CHAR(2) PRIMARY KEY,      
    PNAME VARCHAR(10),             
    COLOR VARCHAR(10),             
    WEIGHT INT                    
);

-- 创建 J 表
CREATE TABLE J (
    JNO CHAR(2) PRIMARY KEY,       
    JNAME VARCHAR(10),            
    CITY VARCHAR(10)             
);

-- 创建 SPJ 表
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
插入数据
**************************/
-- 插入 S 表
INSERT INTO S VALUES ('S1', '精益', 20, '天津');
INSERT INTO S VALUES ('S2', '盛锡', 10, '北京');
INSERT INTO S VALUES ('S3', '东方红', 30, '北京');
INSERT INTO S VALUES ('S4', '丰泰盛', 20, '天津');
INSERT INTO S VALUES ('S5', '为民', 30, '上海');

-- 插入 P 表
INSERT INTO P VALUES ('P1', '螺母', '红', 12);
INSERT INTO P VALUES ('P2', '螺栓', '绿', 17);
INSERT INTO P VALUES ('P3', '螺丝刀', '蓝', 14);
INSERT INTO P VALUES ('P4', '螺丝刀', '红', 14);
INSERT INTO P VALUES ('P5', '凸轮', '蓝', 40);
INSERT INTO P VALUES ('P6', '齿轮', '红', 30);

-- 插入 J 表
INSERT INTO J VALUES ('J1', '三建', '北京');
INSERT INTO J VALUES ('J2', '一汽', '长春');
INSERT INTO J VALUES ('J3', '弹簧厂', '天津');
INSERT INTO J VALUES ('J4', '造船厂', '天津');
INSERT INTO J VALUES ('J5', '机车厂', '唐山');
INSERT INTO J VALUES ('J6', '无线电厂', '常州');
INSERT INTO J VALUES ('J7', '半导体厂', '南京');

-- 插入 SPJ 表
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
查询
**************************/
--一，求供应工程J1零件的供应商号码SNO
--1，使用 SELECT DISTINCT
SELECT DISTINCT SNO
FROM SPJ
WHERE JNO = 'J1';
--2，使用 EXISTS
SELECT SNO
FROM S
WHERE EXISTS (
    SELECT 1
    FROM SPJ
    WHERE SPJ.SNO = S.SNO AND SPJ.JNO = 'J1'
);
--3，使用 IN
SELECT SNO
FROM S
WHERE SNO IN (
    SELECT SNO
    FROM SPJ
    WHERE JNO = 'J1'
);
--二，求供应工程J1零件P1的供应商号码SNO
--1，使用子查询

SELECT SNO
FROM SPJ
WHERE JNO = 'J1' AND PNO = 'P1'
GROUP BY SNO;
--2，使用 EXISTS
SELECT SNO
FROM S
WHERE EXISTS (
    SELECT 1
    FROM SPJ
    WHERE SPJ.SNO = S.SNO AND SPJ.JNO = 'J1' AND SPJ.PNO = 'P1'
);
--三，求供应工程J1零件为红色的供应商号码SNO
--1，使用 JOIN 查询
SELECT DISTINCT SPJ.SNO
FROM SPJ
JOIN P ON SPJ.PNO = P.PNO
WHERE SPJ.JNO = 'J1' AND P.COLOR = '红';
--2，使用嵌套子查询
SELECT DISTINCT SNO
FROM SPJ
WHERE JNO = 'J1' AND PNO IN (
    SELECT PNO
    FROM P
    WHERE COLOR = '红'
);
--3，使用 EXISTS
SELECT DISTINCT SNO
FROM SPJ AS SP
WHERE JNO = 'J1' AND EXISTS (
    SELECT 1
    FROM P
    WHERE P.PNO = SP.PNO AND P.COLOR = '红'
);
--四，求没有使用天津供应商生产的红色零件的工程号JNO
--1，使用 NOT IN 和子查询
SELECT DISTINCT JNO
FROM SPJ
WHERE JNO NOT IN (
    SELECT DISTINCT SPJ.JNO
    FROM SPJ
    JOIN S ON SPJ.SNO = S.SNO
    JOIN P ON SPJ.PNO = P.PNO
    WHERE S.CITY = '天津' AND P.COLOR = '红'
);
--2，使用 NOT EXISTS
SELECT DISTINCT JNO
FROM SPJ
WHERE NOT EXISTS (
    SELECT 1
    FROM SPJ AS SP
    JOIN S ON SP.SNO = S.SNO
    JOIN P ON SP.PNO = P.PNO
    WHERE SP.JNO = SPJ.JNO AND S.CITY = '天津' AND P.COLOR = '红'
);

--五，求至少使用了供应商S1所供应的全部零件的工程号JNO
--1，使用NOT EXISTS
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

--2，使用 IN 和子查询
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


--用SQL完成如下操作：
--一，找出所有供应商的姓名和所在城市：
--1，SELECT
SELECT Sname,CITY
FROM S


--二，找出所有零件的名称，颜色重量：
--1，SELECT
SELECT PNAME,COLOR,WEIGHT
FROM P
--2，
SELECT PNAME, COLOR, WEIGHT
FROM (SELECT PNAME, COLOR, WEIGHT FROM P) AS PartInfo;

--三，找出使用供应商S1所供应零件的工程号码：
--1，使用 SELECT 和 WHERE
SELECT JNO
FROM SPJ
WHERE SNO = 'S1'

--四，找出工程项目J2使用的各种零件的名称及数量：
--1，使用 JOIN 连接 SPJ 和 P 表
SELECT P.PNAME, SPJ.QTY
FROM SPJ
JOIN P ON SPJ.PNO = P.PNO
WHERE SPJ.JNO = 'J2';
--2，使用子查询与 JOIN 相结合
SELECT P.PNAME, SPJ.QTY
FROM P
JOIN (SELECT PNO, QTY FROM SPJ WHERE JNO = 'J2') AS SPJ
ON P.PNO = SPJ.PNO;

--五,找出上海厂商供应的所有零件号码
--1，使用 JOIN 查询 S 表和 SPJ 表
SELECT DISTINCT SPJ.PNO
FROM S
JOIN SPJ ON S.SNO = SPJ.SNO
WHERE S.CITY = '上海';
--2，使用子查询
SELECT DISTINCT PNO
FROM SPJ
WHERE SNO IN (SELECT SNO FROM S WHERE CITY = '上海');
--3，使用 EXISTS
SELECT DISTINCT PNO
FROM SPJ
WHERE EXISTS (
    SELECT 1
    FROM S
    WHERE S.SNO = SPJ.SNO AND S.CITY = '上海'
);


--六，找出使用上海产的零件的工程名称：
--1，使用多表 JOIN 查询
SELECT DISTINCT J.JNAME
FROM S
JOIN SPJ ON S.SNO = SPJ.SNO
JOIN J ON SPJ.JNO = J.JNO
WHERE S.CITY = '上海';

--2，使用 EXISTS
SELECT DISTINCT J.JNAME
FROM J
WHERE EXISTS (
    SELECT 1
    FROM SPJ
    JOIN S ON SPJ.SNO = S.SNO
    WHERE SPJ.JNO = J.JNO AND S.CITY = '上海'
);

--七，找出没有使用天津产的零件的工程号码：
--1，使用 NOT IN 子查询
SELECT DISTINCT JNO
FROM J
WHERE JNO NOT IN (
    SELECT DISTINCT SPJ.JNO
    FROM SPJ
    JOIN S ON SPJ.SNO = S.SNO
    WHERE S.CITY = '天津'
);
--2，使用 NOT EXISTS
SELECT DISTINCT J.JNO
FROM J
WHERE NOT EXISTS (
    SELECT 1
    FROM SPJ
    JOIN S ON SPJ.SNO = S.SNO
    WHERE SPJ.JNO = J.JNO AND S.CITY = '天津'
);
--八，把全部红色零件的颜色改成绿色
UPDATE P
SET COLOR = '绿'
WHERE COLOR = '红';
SELECT *
FROM P
--九，将由S5供给给J2的零件P6改为由S3供应
DELETE FROM SPJ WHERE SNO = 'S5' AND PNO = 'P6' AND JNO = 'J2';
INSERT INTO SPJ (SNO, PNO, JNO) VALUES ('S3', 'P6', 'J2');
--十，从供应商关系中删除S2记录，并从供应关系中删除相应记录
DELETE FROM SPJ WHERE SNO = 'S2';
DELETE FROM S WHERE SNO = 'S2';
SELECT *
FROM SPJ

ALTER TABLE SPJ NOCHECK CONSTRAINT FK__SPJ__SNO__51851410;

--十一，将（S2，J6,P4,200）插入供应关系中
INSERT INTO SPJ (SNO, PNO, JNO, QTY) 
VALUES ('S2', 'P4', 'J6', 200);



--DROP VIEW Supplier_Part_Supply;
--九
--创建视图
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
	


--1，找出使用的各种零件代码及数量
SELECT 
    Part_Code,
    SUM(Supply_Quantity) AS Total_Supply_Quantity
FROM 
    Supplier_Part_Supply
GROUP BY 
    Part_Code;

--2，找出供应商S1供应情况
SELECT 
    Part_Code,
    Supply_Quantity
FROM 
    Supplier_Part_Supply
WHERE 
    Supplier_NO = 'S1';
/******************************************
五、创建供应商零件供应表SP表、订单表Orders表
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
--输入测试样例，便于后面测试：
INSERT INTO SP VALUES ('S1', 'P1', 200);
INSERT INTO SP VALUES ('S1', 'P2', 100);
INSERT INTO SP VALUES ('S2', 'P3', 500);
INSERT INTO SP VALUES ('S4', 'P5', 100);
INSERT INTO SP VALUES ('S5', 'P6', 200);
/********************
查看数据
***********************/
SELECT *
FROM Orders
SELECT *
FROM SP
/******************************************
六、创建销售存储过程
*******************************************/
CREATE PROCEDURE SellPart
    @Ono CHAR(4),     -- 订单编号
    @Sno CHAR(2),     -- 供应商编号
    @Pno CHAR(2),     -- 零件编号
    @Jno CHAR(2),     -- 工程项目编号
    @quantity INT     -- 销售数量
AS
BEGIN
	DECLARE @ErrorVar INT;   --声明用户变量,用于存储SQL语句的错误编号
    -- 检查库存是否充足
    IF EXISTS (
        SELECT 1
        FROM SP
        WHERE Sno = @Sno AND Pno = @Pno AND balance >= @quantity
    )
    BEGIN
        -- 插入订单记录
        INSERT INTO Orders (Ono, Sno, Pno, Jno, Otime, quantity)
        VALUES (@Ono, @Sno, @Pno, @Jno, GETDATE(), @quantity);
		SELECT @ErrorVar = @@ERROR;	--系统变量，上一句SQL的执行状态，
							--会后被下一SQL语句重新赋值，故另存
			IF @ErrorVar != 0	--为0表示代码执行正确，非0值为系统定义的错误编号，
						--可在主调程序中查阅详细错误信息并处理
				BEGIN
					ROLLBACK;	--会重置@@ERROR，故前面用@ErrorVar另存
					RETURN @ErrorVar;
				END
        -- 更新库存量
        UPDATE SP
        SET balance = balance - @quantity
        WHERE Sno = @Sno AND Pno = @Pno;
		SELECT @ErrorVar = @@ERROR;	--系统变量，上一句SQL的执行状态，
							--会后被下一SQL语句重新赋值，故另存
			IF @ErrorVar != 0	--为0表示代码执行正确，非0值为系统定义的错误编号，
						--可在主调程序中查阅详细错误信息并处理
				BEGIN
					ROLLBACK;	--会重置@@ERROR，故前面用@ErrorVar另存
					RETURN @ErrorVar;
				END
        PRINT '订单已成功插入，库存已更新。';
    END
    ELSE
    BEGIN
        PRINT '库存不足!';
    END
END;

-- 示例：调用存储过程插入30条订单记录
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
七、删除SPJ表，创建视图SPJ（结构同SPJ表）
*******************************************/
DROP TABLE IF EXISTS SP;
GO
--创建视图
CREATE VIEW SPJ AS
SELECT 
    Sno,          -- 供应商编号
    Pno,          -- 零件编号
    Jno,          -- 工程项目编号
    SUM(quantity) AS QTY  -- 各供应商提供给工程的各种零件总数
FROM 
    Orders
GROUP BY 
    Sno, Pno, Jno;

--重新执行(注意不是改写，只是执行)之前（四中）你写的所有用到SPJ表的查询语句，验证这些查询语句是否能够正确执行，并说明原因。
/**************
可以正确执行
创建的视图名字也叫SPJ，此时数据库将SPJ视图当作表来处理
***************/
