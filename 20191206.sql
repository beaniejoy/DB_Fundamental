# select는 항상 정렬을 중요시하자.

SELECT empno, ename, job
FROM emp

# 1. emp테이블에서 급여가 많은 순서대로 출력

SELECT empno, ename, job, sal, deptno
FROM emp
ORDER BY sal DESC;

# 2. emp테이블에서 사원번호(empno), 급여(sal), 입사일(hiredate)을 출력해보세요.
# 단, 급여가 적은 순서대로.

SELECT empno, sal, hiredate
FROM emp
ORDER BY sal;

# 3. emp테이블에서 직업(job), 급여(sal)을 출력해보세요.
#단, 직업명으로 오름차순, 금여로 내림차순 정렬

SELECT job, sal
FROM emp
ORDER BY job, sal DESC

# 4. 칼럼명이 길 경우 display를 고려해 이름바꿔서 출력가능
SELECT empno eno, ename en
FROM emp;
# AS를 붙여도된다.
SELECT empno AS eno, ename AS en
FROM emp;

# 5. emp테이블에서 부서번호가 10번인 사원들의 급여를 출력하되 10% 인상된
#금액으로 출력하기(칼럼에 연산도 가능하다)
SELECT sal, sal*1.1
FROM emp
WHERE deptno = 10;

# 6. emp테이블에서 급여가 3000이상인 사원들의 모든 정보를 출력하세요.
SELECT *
FROM emp
WHERE sal >= 3000;

# 7. emp테이블에서 부서번호가 30번이 아닌 사람들의 이름과 부서번호를 출력하세요.
SELECT ename, deptno
FROM emp
#WHERE deptno != 30;
WHERE deptno <> 30; # DB전문가는 이걸 많이 쓴다.

# 8. emp테이블에서 부서번호가 10번이고 급여가 3000이상인 사원들의 이름과 급여를 출력.
SELECT ename, sal
FROM emp
WHERE deptno = 10 AND sal >= 3000;

# 9. emp테이블에서 직업이 SALESMAN 사람하고 MANAGER인 사원의 사원번호와 부서번호 출력
# or와 and 말의 늬앙스를 잘 캐치하자.
SELECT empno, deptno, job
FROM emp
WHERE job = 'SALESMAN' OR job ='MANAGER';

# IN 연산자도 잘 사용하진 않는다.
# OR 연산자를 잘 안쓴다.
# 둘다 풀스캔 2번을 하기때문에
SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10,20);
# => 10, 20, 30, 40 밖에 없으면 아래같이 쓰는 것이 훨씬 좋다.
# 풀스캔 한번만 가능
SELECT empno, ename, deptno
FROM emp
WHERE deptno <> 30 AND deptno <> 40;

# 10. emp 테이블에서 급여가 1000과 2000 사이인 사원들의 사원번호, 이름, 급여를 출력
SELECT empno, ename, sal
FROM emp
WHERE sal BETWEEN 1000 AND 2000;
#WHERE sal >= 1000 AND sal <= 2000; 와 같다.

# 11. 사원이름이 'FORD'와 'SCOTT' 사이의 사원들의 사원번호, 이름을 출력
SELECT empno, ename, hiredate
FROM emp
WHERE ename BETWEEN 'FORD' AND 'SCOTT'
ORDER BY hiredate DESC;

# 12. LIKE 
# emp테이블에서 사원이름이 'J'로 시작하는 사원의 사원이름과 부서번호를 출력
# => LIKE 연산자 이용('A%','%A%','%A')
SELECT ename, deptno
FROM emp
WHERE ename LIKE 'J%'
ORDER BY ename;

SELECT ename, deptno
FROM emp
WHERE ename LIKE '%A%'
ORDER BY ename;

SELECT ename, deptno
FROM emp
WHERE ename LIKE '%B'
ORDER BY ename;

SELECT hiredate, empno
FROM emp
WHERE hiredate LIKE '__81%'
ORDER BY hiredate;