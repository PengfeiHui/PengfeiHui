/********************************************
学号：22009290063
姓名：惠鹏飞
********************************************/

/********************************************
创建数据库
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
二、创建表
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
三、数据更新
********************************************/
INSERT INTO Student (Sno, Sname, Ssex, Sage, Sdept) VALUES
('201215121', '李勇', 'M', 20, 'CS'),
('201215122', '刘晨', 'F', 19, 'CS'),
('201215123', '王敏', 'M', 18, 'MA'),
('201215125', '张立', 'F', 19, 'IS');
INSERT INTO Course (Cno, Cname, Cpno, Ccredit) VALUES
(1, '数据库', 5, 4),
(2, '数学', NULL, 2),
(3, '信息系统', 1, 4),
(4, '操作系统', 6, 3),
(5, '数据结构', 7, 4),
(6, '数据处理', NULL, 2),
(7, 'PASCAL语言', 6, 4);
INSERT INTO SC (Sno, Cno, Grade) VALUES
('201215121', 1, 92),
('201215121', 2, 85),
('201215121', 3, 88),
('201215122', 2, 90),
('201215122', 3, 80);
SELECT*
FROM SC

/********************************************
四、查询
********************************************/
--一，查询选修c2课程且成绩在90分以上的所有学生的学号、姓名。
--1，使用JOIN
SELECT Student.Sno, Student.Sname
FROM Student
JOIN SC ON Student.Sno = SC.Sno
WHERE SC.Cno = 2 AND SC.Grade >= 90;
--2，使用子查询IN
SELECT Sno, Sname
FROM Student
WHERE Sno IN (
    SELECT Sno
    FROM SC
    WHERE Cno = 2 AND Grade >= 90
);
--3，使用子查询 (EXISTS)
SELECT Sno, Sname
FROM Student
WHERE EXISTS (
    SELECT 1
    FROM SC
    WHERE SC.Sno = Student.Sno AND SC.Cno = 2 AND SC.Grade > =90
);
--二，查询选修c1号课程的学生最高分数
--1，使用 MAX
SELECT MAX(Grade) AS HighestGrade
FROM SC
WHERE Cno = 1;
--2，使用 (= ANY)
SELECT Grade AS HighestGrade
FROM SC
WHERE Grade = ANY (SELECT MAX(Grade) FROM SC WHERE Cno = 1)
  AND Cno = 1;

 --三，查询有3门以上课程是90分以上的学生学号及其(90分以上的)课程数。
 --1，使用 GROUP BY 和 HAVING
 SELECT Sno, COUNT(*) AS HighScoreCount
FROM SC
WHERE Grade >= 90
GROUP BY Sno
HAVING COUNT(*) > 3;
--2，
SELECT Sno, HighScoreCount
FROM (
    SELECT Sno, COUNT(*) AS HighScoreCount
    FROM SC
    WHERE Grade > =90
    GROUP BY Sno
) AS Subquery
WHERE HighScoreCount > 3;
--3，使用 JOIN 和 GROUP BY
SELECT SC.Sno, COUNT(SC.Cno) AS HighScoreCount
FROM SC
JOIN Student ON SC.Sno = Student.Sno
WHERE SC.Grade > =90
GROUP BY SC.Sno
HAVING COUNT(SC.Cno) > 3;

--四，查询与“刘晨”在同一个系学习的学生
--1，使用子查询
SELECT Sno, Sname
FROM Student
WHERE Sdept = (SELECT Sdept FROM Student WHERE Sname = '刘晨')
  AND Sname != '刘晨';

 --五，查询选修了课程名为“数据库”的学生学号和姓名。
 --1，使用 JOIN
SELECT Student.Sno, Student.Sname
FROM Student
JOIN SC ON Student.Sno = SC.Sno
JOIN Course ON SC.Cno = Course.Cno
WHERE Course.Cname = '数据库';
--2，使用IN
SELECT Sno, Sname
FROM Student
WHERE Sno IN (
    SELECT Sno
    FROM SC
    WHERE Cno = (SELECT Cno FROM Course WHERE Cname = '数据库')
);
--3，使用EXISTS
SELECT Sno, Sname
FROM Student AS S
WHERE EXISTS (
    SELECT 1
    FROM SC
    JOIN Course ON SC.Cno = Course.Cno
    WHERE SC.Sno = S.Sno AND Course.Cname = '数据库'
);


