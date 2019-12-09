# SubQuery
# 1. 
# 'ALLEN'과 같은 부서에서 근무하는 사원의 이름과 부서의 번호를 출력\
SELECT ename
FROM emp
WHERE deptno = (SELECT deptno
FROM emp
WHERE ename = 'ALLEN');

# 2.
# 'ALLEN'과 동일한 직책(job)을 가진 사원의 사번과 이름, 직책을 출력
SELECT empno, ename, job
FROM emp
WHERE job = (SELECT job
FROM emp
WHERE ename = 'ALLEN');
# subquery작성시 아래 select 문의 결과가 하나가 나와야 한다.

# 3.
# 'ALLEN'의 급여와 동일하거나 더많이 받는 사원의 이름과 급여를 출력
SELECT ename, sal
FROM emp
WHERE sal >= (SELECT sal
FROM emp
WHERE ename = 'ALLEN');

# 4.
# emp테이블에서 'DALLAS'에서 근무하는 사원의 이름, 부서번호를 출력
SELECT ename, deptno
FROM emp
WHERE deptno = (SELECT deptno
FROM dept
WHERE loc = 'DALLAS'); 
# join으로도 작성가능하다.
SELECT ename, e.deptno
FROM emp e, dept d
WHERE d.deptno = e.deptno 
AND loc = 'DALLAS';

# 5.
# 'SALES' 부서에서 근무하는 모든 사원의 이름과 급여를 출력
SELECT ename, sal
FROM emp
WHERE deptno = (SELECT deptno
FROM dept
WHERE dname = 'SALES');
# join
SELECT ename, sal
FROM emp e, dept d
WHERE d.deptno = e.deptno 
AND d.DNAME = 'SALES'; 

# 6.
# 자신의 직속 상관이 'KING'인 사원의 이름과 급여를 출력
SELECT ename, sal, job
FROM emp
WHERE mgr = (SELECT empno
FROM emp
WHERE ename = 'KING');
# self-join 이런 경우도 많다.
SELECT e2.ename, e2.sal
FROM emp e1, emp e2
WHERE e1.empno = e2. mgr # 이 때에도 primary key로 접근한다.
AND e1.ename ='KING';

# 7. (7 ~ 10)
# subquery의 결과가 여러 행이 나올 경우 IN, ANY, ALL 등을 사용해서 처리)
# IN ALL ANY를 사용하게 되지만 되도록 안쓰고 하는 것이 좋다.
# 급여를 3000이상 받는 사원이 소속된 부서와 동일한 부서에서 근무하는 사원들의
# 이름과 급여, 부서번호를 출력
SELECT ename, sal, deptno
FROM emp
WHERE deptno IN(SELECT deptno 
FROM emp 
WHERE sal >= 3000);

# 이렇게는 쓰지말자, subquery는 조건절 아래에다 쓰자.
SELECT ename, sal, dname
FROM (SELECT ename, sal, deptno FROM emp WHERE job = 'MANAGER') e, dept d
WHERE d.deptno = e.deptno;

#8.
SELECT empno, MAX(sal), deptno
FROM emp
GROUP BY deptno;
##
SELECT empno, sal, deptno
FROM emp
WHERE sal IN(SELECT MAX(sal)
FROM emp
GROUP BY deptno);

# 9.
# 직책이 MANAGER인 사원이 속한 부서의 부서번호, 부서명, 위치를 출력
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN(SELECT deptno 
FROM emp
where job='MANAGER');

# 10.
# 직책이 'SALESMAN'보다 급여를 많이 받는 사원들의 이름과 급여를 출력
SELECT ename, sal
FROM emp
WHERE sal > (SELECT MIN(sal)
FROM emp
WHERE job = 'SALESMAN');
# saleman중에서 급여가 가장 낮은 사람을 기준으로 그거보다 크기만 하면 되기에
# MIN(sal)로 표현
SELECT ename, sal
FROM emp
WHERE sal > any(SELECT sal # MIN(sal)과 같은 표현
FROM emp
WHERE job = 'SALESMAN');
# any로 표현함으로써 어느 값이든(sal이) 그거 보다 급여가 많은 것들을 출력
SELECT ename, sal
FROM emp
WHERE sal > (SELECT MAX(sal) # all은 MAX와 같다. 전부다 만족을 해야 하는 것이기에
FROM emp
WHERE job = 'SALESMAN');

# select에서 DB속도가 판가름 난다. 나머지 update, delete, insert는 DB속도 차이가 없다.
# join한다고 느려지지 않는다. primary key를 상속받아 사용하는 테이블과 같이 한 테이블로 생각한다.
# 함수는 다 외워야하고 subquery와 join을 잘 사용하자!!

