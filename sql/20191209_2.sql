# JOIN: 두 테이블을 연결하는 것
# emp(100만건) => dept(4개) 이렇게 join해야 100만건만 스캔하는 것임
# primary key foreign key join을 해야 한다.
# DB설계할 때 join하지 않고 옆에 칼럼을 덧붙이는 경우가 있는데 절대 하지 말 것
# join해서 쓰면 본래 쓰지 못했던 데이터들도 사용 가능하다.
# join - inner, left join만 일단 알아두자.

# 1.
SELECT ename, job, sal, dname, hiredate #deptno를 추가하면 에러발생
FROM emp e, dept d
WHERE d.DEPTNO = e.deptno; 
# 한쪽은 상수가 되어야 한다.
# foreign key가 상수값이 되어야 한다.(e.deptno)
# primary key를 조건절로 걸면 풀스캔하지않고 한번에 찾는다.

# inner join
SELECT ename, e.deptno, dname # 어디 deptno인지 명확하게 표현해야한다.
FROM emp e, dept d
WHERE d.deptno = e.deptno; 
# dname을 가져오기 위해 join한 것임

# DB는 java 클래스의 맴버변수와 다르게 다른 테이블에서 같은 칼럼이름을 피한다.
# 절차 지향형으로 이름을 지어야 한다. 
# (member테이블의 이름: mem_name/ Customer의 테이블의 이름: cus_name)

# 2.
# 급여가 3000에서 5000사이의 사원이름과 부서명을 출력해보세요.
SELECT ename, dname
FROM emp e, dept d
WHERE sal BETWEEN 3000 AND 5000 AND d.DEPTNO = e.DEPTNO; # 이런식으로 움직이는 것이 좋다.
# 사실 DB에서 알아서 효율적으로 조건을 탐색한다. BETWEEN부터 실행하고 뒤에 join

# 3.
# 부서명이 'ACCOUNTING' 인 사원의 이름, 입사일, 부서번호, 부서명을 출력
SELECT ename, hiredate, e.deptno, dname
FROM emp e, dept d
WHERE d.DNAME = 'ACCOUNTING' AND d.DEPTNO = e.deptno;
# inner join은 join했는데 대상이 없으면 그 데이터는 결과에서 제외
# (예를 들어 deptno 50값을 dept 테이블에 넘길 때)
# left join으로 이를 극복하는 것 (없는 값도 출력되게끔) 

# 4.
# 커미션이 null이 아닌 사원의 이름, 입사일, 부서명을 출력해보세요.
SELECT ename, hiredate, dname
FROM emp e, dept d
WHERE d.DEPTNO = e.deptno and comm IS NOT NULL;
# comm != null은 안된다. (DB적인 마인드로 접근해야 한다.)

# 5.
UPDATE emp
SET deptno = null
WHERE empno = 7369;
# null값 만들기
# 이렇게 되면 deptno가지고 inner join할 때 해당 데이터는 결과 출력X
# left join하면 다 나온다.
SELECT ename, hiredate, dname
FROM emp e LEFT JOIN dept d
ON d.deptno = e.deptno;
# 하지만 left, outter, right join은 무조건 풀스캔이기 때문에 inner join으로 해주는 것이 좋다.
# default값을 넣어주는 것이 좋다.
# 시스템 상에서는 NULL을 허용하더라도 전처리를 통해 NULL값을 다른 것으로 바꿔주는 것이 좋다.
# 데이터가 비워져있지 않게 설계하자.

# 6.
# emp 테이블과 dept 테이블을 조인해서 부서번호, 부서명, 이름, 급여를 출력
SELECT e.deptno, d.dname, e.ename, e.sal
FROM emp e, dept d
WHERE d.DEPTNO = e.deptno;


# 사원의 이름이 'ALLEN'인 사원의 부서명을 출력
SELECT e.ename, d.dname
FROM emp e, dept d
WHERE d.DEPTNO = e.deptno AND e.ename = 'ALLEN';

# 모든 사원의 이름, 부서번호, 부서명 급여를 출력하세요.
# 단, emp테이블에 없는 부서도 출력해보세요.
SELECT e.ename, e.deptno, d.dname, e.sal
FROM emp e LEFT JOIN dept d
ON d.DEPTNO = e.DEPTNO;

# 사원의 이름과 급여, 급여의 등급을 출력해 보세요.
SELECT ename, sal, grade
FROM emp e, salgrade g
WHERE sal BETWEEN losal AND hisal;
# 이 두 테이블은 join을 할 수가 없다.
# index를 losal과 hisal에 둔다. (범위 값을 지정)

# 사원의 이름과, 부서명, 급여의 등급을 출력해 보세요.
# 15 x 5 만큼 돌아간다. 이걸 효과적으로 줄일 수는 없을까?
SELECT ename, d.dname, grade
FROM emp e, salgrade g, dept d
WHERE d.DEPTNO = e.deptno
AND sal BETWEEN losal AND hisal;