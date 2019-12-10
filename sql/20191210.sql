# 개발자들은 Primary key, Foreign key, Not null만 주로 사용
# default도 많이 사용, 데이터 안 넣으면 지정값으로 넣겠다.
CREATE TABLE dept2
(deptno INT PRIMARY KEY,
dname VARCHAR(15) DEFAULT '영업부',
loc CHAR(1) CHECK(loc IN('1','2'))); # 1,2값만 들어가도록

INSERT INTO dept2(deptno, dname, loc) VALUES(10, '개발부', '1');
# dname에 아무것도 안넣으면 default로 영업부가 들어간다.
INSERT INTO dept2(deptno, loc) VALUES(20,'1');
# 원래는 안들어간다 (loc은 1,2값만)
INSERT INTO dept2(deptno, dname, loc) VALUES(30,'총무부','3');

# 테이블 전체 삭제
DROP TABLE dept2;


# 외래키
# dept2(deptno, primary key) --< emp2(deptno, foreign key)
# 교차 entity 발생 : history 이력관리(dept2, emp2가 N:N관계일 때 따로 테이블을 빼준다.)
# 하나의 부서에 emp2에서 여러 구성원이 있을 수 있고 (1:N관계)
# emp2의 구성원 한 명당 과거 부서이력들이 존재할 수 있기에 (1:N관계)
# dept2(deptno) --< histroy >-- emp2(empno)

CREATE TABLE dept2(
deptno TINYINT PRIMARY KEY,
dname VARCHAR(15) NOT NULL);

CREATE TABLE emp2(
empno SMALLINT PRIMARY KEY,
ename VARCHAR(15) NOT NULL,
deptno TINYINT,
FOREIGN KEY(deptno) REFERENCES dept2(deptno));

INSERT INTO dept2(deptno, dname) VALUES(10,'aaa');
INSERT INTO dept2(deptno, dname) VALUES(20, 'bbb');
SELECT *
FROM emp2

INSERT INTO emp2(empno,ename,deptno) VALUES(1,'a',10);
INSERT INTO emp2(empno,ename,deptno) VALUES(2,'b',20);
INSERT INTO emp2(empno,ename,deptno) VALUES(3,'c',30); # 실패, dept2에 정보가 없어서
INSERT INTO emp2(empno,ename) VALUES(4,'d'); # foreign key가 없어도 들어가짐

SELECT empno, ename, dname, e.deptno
FROM emp2 e, dept2 d
WHERE d.deptno = e.deptno;


# 복사하는 방법 중 하나
CREATE TABLE dept4(
deptno TINYINT,
dname VARCHAR(14),
loc VARCHAR(13));

INSERT INTO dept4 SELECT*FROM dept;
SELECT *
FROM dept4;

# 테이블 복사 (제약조건은 복사 X)
CREATE TABLE dept5 AS SELECT * FROM dept;
# 테이블 구조만 복사(데이터는 복사X, 조건 항상 false를 이용)
CREATE TABLE dept6 AS SELECT * FROM dept WHERE 1=2;

#####################################
# DATE, DATETIME 투개의 타입이 존재 #
# CHAR는 고정 문자, VARCHAR는 가변 문자(이걸 많이 사용)
# VARCHAR(N)에 들어가는 N은 자리수(한글, 영어 상관X)
CREATE TABLE test3(
NAME VARCHAR(3));
DELETE FROM test3 WHERE NAME = '성';
INSERT INTO test3 VALUES('이한빈');

UPDATE dept SET dname = 'a', loc ='b'
WHERE deptno='60';

acornDROP TABLE bonus;


