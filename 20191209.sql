# 주로 NOW를 많이 사용한다.
SELECT NOW();

SELECT ADDDATE(NOW(), INTERVAL 2 DAY); 

# 결제할 때 ADDDATE를 사용한다.
SELECT ADDDATE(hiredate, INTERVAL 2 DAY), hiredate
FROM emp;
# 날짜 뺄 때
SELECT SUBDATE(NOW(), INTERVAL 2 HOUR);

# 날짜간 차이, 날짜 형식은 중간에 char만 넣어주면 된다.
SELECT DATEDIFF('2018!04!02', '2018-03-01');

SELECT DATEDIFF(NOW(), hiredate)
FROM emp;

# 중요!! 외우자.
# DATE를 String으로 바꿔주는 역할
# String은 초록색, DATE는 붉은색
SELECT DATE_FORMAT(hiredate, '%Y/%m/%d %p %h:%i:%s %W'), hiredate
FROM emp;

DESC member;

SELECT num, NAME, addr
FROM member;
# primary key(int)에 string으로 해서 넣어도 들어가진다.
# 자동으로 Integer.parseInt()하는 것과 같다.
INSERT INTO member(num, NAME, addr) VALUES('3', '베조스','미국');
INSERT INTO member(num, NAME, addr) VALUES('4', '조이','서울');
# String자리에 숫자를 넣으면 자동으로 문자열로 바꾼다.
# String.valueOf(4)를 자동으로 해주는 것과 같다.
INSERT INTO member(num, NAME, addr) VALUES(5, '손흥민',4);
# 그래도 정확하게 넣는 것이 좋다.(DB에서 함수를 사용하는 것이므로)

# 이 두개는 사용할 일이 별로 없다.
SELECT CONVERT('1234', UNSIGNED) + 1234; # 내부적으로 쓰임
SELECT STR_TO_DATE('2000-01-31', '%Y-%m-%d'); # 내부적으로 쓰임

# NULL은 count에서 제외
SELECT COUNT(ename), COUNT(comm), COUNT(sal)
FROM emp;
# * 넣지 않고 primary key를 이용해 count하자(NULL을 허용하지 않기에)
SELECT COUNT(*)
FROM emp;

SELECT SUM(sal), SUM(comm), deptno
FROM emp
GROUP BY deptno;

# AVG(comm)하면 NULL값인 사람들은 제외하고 있는 사람들로만 평균
# 부정확한 평균값이 나올 수도 있다.
SELECT AVG(sal), AVG(comm), job
FROM emp
GROUP BY job;

# 정확한 평균값을 위해 NULL 값을 0으로 지정하고 평균함
SELECT AVG(NVL(comm, 0))
FROM emp;

# MAX는 이렇게는 안쓰고 auto_incrument할 때 중간에 오류값들이
# 비는 것을 방지하고자 1,2,3,4,5....순차적 정렬을 위해 사용
SELECT MAX(sal)
FROM emp;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;

# 부서별 평균 급여
SELECT deptno , AVG(sal)
FROM emp
GROUP BY deptno;

#부서별 평균 급여(소수 첫째짜리까지 반올림해서 표현)
SELECT deptno, ROUND(AVG(sal),1)
FROM emp
GROUP BY deptno;

SELECT job, MAX(sal)
FROM emp
GROUP BY job;

# 급여가 1000 이상인 사원들의 부서별 평균 급여의 반올림 값을
# 부서번호로 내림차순 정렬해서 출력해보세요
SELECT deptno, ROUND(AVG(sal))
FROM emp
WHERE sal >= 1000
GROUP BY deptno
ORDER BY deptno DESC;
# 순서가 상당히 중요하다.

# 급여가 2000 이상인 사원들의 부서별 평균 급여의 반올림 값을
# 평균 급여의 반올림 값으로 오름차순 정렬해서 출력
SELECT deptno, ROUND(AVG(sal)) AS avgsal
FROM emp
WHERE sal >= 2000
GROUP BY deptno
ORDER BY avgsal;

# 각 부서별 같은 업무(job)를 하는 사람의 인원수를 구해서
# 부서번호, 업무(job), 인원수를 부서번호에 대해서 오름차순 정렬해서
# 출력해보세요.

SELECT deptno, job, COUNT(empno) countno
FROM emp
GROUP BY deptno, job
ORDER BY countno;

# WHERE은 전체 table의 조건절이고
# HAVING BY는 GROUP BY로 집계된 값에 적용되는 조건
SELECT deptno, AVG(sal)
FROM emp
WHERE sal >= 1000
GROUP BY deptno
HAVING AVG(sal) >= 2000;