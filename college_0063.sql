/********************************************
ѧ�ţ�22009290063
������������
********************************************/

/********************************************
�������ݿ�
********************************************/
USE master;
GO

CREATE DATABASE stut_mng 
ON
PRIMARY  
    (NAME = stud,
    FILENAME = 'D:\StuData\Studdat1.mdf',
    SIZE = 100MB,
    MAXSIZE = 200,
    FILEGROWTH = 20)
    
LOG ON 
   (NAME = Studlog,
    FILENAME = 'D:\StuData\Studlog1.ldf',
    SIZE = 100MB,
    MAXSIZE = 200,
    FILEGROWTH = 20)
    ;
GO

USE stut_mng;
GO
/********************************************
����������
********************************************/
CREATE TABLE Student (
    Sno CHAR(9) PRIMARY KEY,      
    Sname VARCHAR(10),             
    Ssex CHAR(1),                  
    Sage INT,                      
    Sdept VARCHAR(10)             
);


CREATE TABLE Course (
    Cno INT PRIMARY KEY,          
    Cname VARCHAR(20),             
    Cpno INT,                     
    Ccredit INT                    
);
CREATE TABLE SC (
    Sno CHAR(9),                   
    Cno INT,                      
    Grade INT,                    
    PRIMARY KEY (Sno, Cno),        
    FOREIGN KEY (Sno) REFERENCES Student(Sno),
    FOREIGN KEY (Cno) REFERENCES Course(Cno)
);



/********************************************
�������ݸ���
********************************************/
INSERT INTO Student (Sno, Sname, Ssex, Sage, Sdept) VALUES
('201215121', '����', 'M', 20, 'CS'),
('201215122', '����', 'F', 19, 'CS'),
('201215123', '����', 'M', 18, 'MA'),
('201215125', '����', 'F', 19, 'IS');
INSERT INTO Course (Cno, Cname, Cpno, Ccredit) VALUES
(1, '���ݿ�', 5, 4),
(2, '��ѧ', NULL, 2),
(3, '��Ϣϵͳ', 1, 4),
(4, '����ϵͳ', 6, 3),
(5, '���ݽṹ', 7, 4),
(6, '���ݴ���', NULL, 2),
(7, 'PASCAL����', 6, 4);
INSERT INTO SC (Sno, Cno, Grade) VALUES
('201215121', 1, 92),
('201215121', 2, 85),
('201215121', 3, 88),
('201215122', 2, 90),
('201215122', 3, 80);
SELECT*
FROM SC

/********************************************
�ġ���ѯ
********************************************/
--һ����ѯѡ��c2�γ��ҳɼ���90�����ϵ�����ѧ����ѧ�š�������
--1��ʹ��JOIN
SELECT Student.Sno, Student.Sname
FROM Student
JOIN SC ON Student.Sno = SC.Sno
WHERE SC.Cno = 2 AND SC.Grade >= 90;
--2��ʹ���Ӳ�ѯIN
SELECT Sno, Sname
FROM Student
WHERE Sno IN (
    SELECT Sno
    FROM SC
    WHERE Cno = 2 AND Grade >= 90
);
--3��ʹ���Ӳ�ѯ (EXISTS)
SELECT Sno, Sname
FROM Student
WHERE EXISTS (
    SELECT 1
    FROM SC
    WHERE SC.Sno = Student.Sno AND SC.Cno = 2 AND SC.Grade > =90
);
--������ѯѡ��c1�ſγ̵�ѧ����߷���
--1��ʹ�� MAX
SELECT MAX(Grade) AS HighestGrade
FROM SC
WHERE Cno = 1;
--2��ʹ�� (= ANY)
SELECT Grade AS HighestGrade
FROM SC
WHERE Grade = ANY (SELECT MAX(Grade) FROM SC WHERE Cno = 1)
  AND Cno = 1;

 --������ѯ��3�����Ͽγ���90�����ϵ�ѧ��ѧ�ż���(90�����ϵ�)�γ�����
 --1��ʹ�� GROUP BY �� HAVING
 SELECT Sno, COUNT(*) AS HighScoreCount
FROM SC
WHERE Grade >= 90
GROUP BY Sno
HAVING COUNT(*) > 3;
--2��
SELECT Sno, HighScoreCount
FROM (
    SELECT Sno, COUNT(*) AS HighScoreCount
    FROM SC
    WHERE Grade > =90
    GROUP BY Sno
) AS Subquery
WHERE HighScoreCount > 3;
--3��ʹ�� JOIN �� GROUP BY
SELECT SC.Sno, COUNT(SC.Cno) AS HighScoreCount
FROM SC
JOIN Student ON SC.Sno = Student.Sno
WHERE SC.Grade > =90
GROUP BY SC.Sno
HAVING COUNT(SC.Cno) > 3;

--�ģ���ѯ�롰��������ͬһ��ϵѧϰ��ѧ��
--1��ʹ���Ӳ�ѯ
SELECT Sno, Sname
FROM Student
WHERE Sdept = (SELECT Sdept FROM Student WHERE Sname = '����')
  AND Sname != '����';

 --�壬��ѯѡ���˿γ���Ϊ�����ݿ⡱��ѧ��ѧ�ź�������
 --1��ʹ�� JOIN
SELECT Student.Sno, Student.Sname
FROM Student
JOIN SC ON Student.Sno = SC.Sno
JOIN Course ON SC.Cno = Course.Cno
WHERE Course.Cname = '���ݿ�';
--2��ʹ��IN
SELECT Sno, Sname
FROM Student
WHERE Sno IN (
    SELECT Sno
    FROM SC
    WHERE Cno = (SELECT Cno FROM Course WHERE Cname = '���ݿ�')
);
--3��ʹ��EXISTS
SELECT Sno, Sname
FROM Student AS S
WHERE EXISTS (
    SELECT 1
    FROM SC
    JOIN Course ON SC.Cno = Course.Cno
    WHERE SC.Sno = S.Sno AND Course.Cname = '���ݿ�'
);


