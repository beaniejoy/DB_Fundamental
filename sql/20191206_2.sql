# 13. emp테이블에서 커미션이 NULL인 사원의 사원이름과 커미션을 출력.
SELECT ename, comm
FROM emp
WHERE comm IS NULL; # NOT NULL은 반대

# 14. concat 문자열을 이어줌
SELECT CONCAT(ename, '의 직업은 ', job, '입니다.')
FROM emp;


SELECT CONCAT(ename, ' 님') AS NAME
FROM emp;

SELECT LOWER(ename)
FROM emp;

# 잘 알아두자. RPAD도 있다.(오른쪽)
SELECT LPAD( 'HI',10,'*');

SELECT LPAD(empno, 10, '0')
FROM emp;

# substring 개념이 java와 다르다.
# 여기서는 얼마만큼 뽑아낼 것인지의 개념이다.
SELECT SUBSTRING('abcde', 2, 3);
SELECT LEFT('abcde',3);
SELECT RIGHT('abcde',3);

# 익명으로 처리할 때
SELECT CONCAT(SUBSTRING(ename,1,1),'***')
FROM emp;
SELECT RPAD(SUBSTRING(ename,1,1),5,'*') AS NAME
FROM emp;

# 문자열로 반환
SELECT FORMAT(12345.2345678, 2); # 12345.23 

# 문자열은 초록색으로, 숫자는 보라색으로 구분
SELECT FORMAT(sal, 1), sal
FROM emp;

SELECT ename, nvl(comm,0)
FROM emp;

SELECT ABS(-10); # 10
SELECT ROUND(3.22645, 2); # 3.23
SELECT CEIL(3.1234); # 4
SELECT FLOOR(4.5463); # 4
SELECT MOD(10,3); # 1 나머지 출력

#  숫자로 반환, FORMAT 함수와 구별하자
SELECT TRUNCATE(11111.23456789, 3); # 11111.234

