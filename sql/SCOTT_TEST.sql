select sysdate from dual;

alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';

select sysdate from dual;

--조건처리 함수: decode(컬럼, 비교값1, 리턴값1, 비교값2, 리턴값2, .., [리턴값n])
--Sql1999 표준 표현식:
--Case 컬럼 when 비교값 then 리턴값 [when 비교값 then 리턴값]
--…
--[else 리턴값] end

--Case when 조건표현식 then 리턴값
--[when 조건표현식 then 리턴값]
--…
--[else 리턴값] end



--그룹함수
--Count(), min(), max(): 
--sum(), avg(), stddev(), variance(): number type 변수에만

select min(ename), max(ename), min(hiredate), max(hiredate) from emp;

select count(*), count(comm)
from emp;
-- 그룹함수는 null을 무시하고, 연산에 포함시키지 않는다.

select count(*), count(comm), count(deptno), count(distinct deptno)
from emp;

-- 첫번째와 두번째가 값이 다르게 나온다.
select avg(comm), sum(comm)/count(*), sum(comm)/count(comm)
from emp;

select avg(nvl(comm, 0)), sum(comm)/count(*), sum(comm)/count(comm)
from emp;

--select        --- 4
--from          --- 1
--[where]       --- 2
--[group by]    --- 3 (only 컬럼명만)
--[order by]    --- 5

select deptno, avg(sal)
from emp
group by deptno;

-- select 절에 그룹함수와 그룹함수를 적용하지 않은 컬럼을 함께 선언하려면
-- 반드시 그룹함수를 적용하지 않은 컬럼을 group by절에 선언하거나, select절에서 제거한다.
select deptno, job, avg(sal)
from emp
group by deptno; -- error: deptno안에서도 job이 여러종류가 있다.

select deptno, job, avg(sal)
from emp
group by deptno, job;

-- Quiz > conn hr/oracle
-- 관리자가 없는 사원을 제외하고 부서별 최소 급여가 6,000이상인 부서번호와
-- 최소급여를 최소급여의 내림차순으로 정렬한 결과 생성하는 sql문

--select        --- 5
--from          --- 1
--[where]       --- 2
--[group by]    --- 3 (only 컬럼명만)
--[having 그룹함수 조건] -- 4
--[order by]    --- 6

select department_id, min(salary)
from employees
where manager_id is not null
group by department_id
having min(salary) > 6000
order by 2 desc;

---------------------------------------
-- # Join
-- dept: 부모 (deptno: pk)
-- emp: 자식  (deptno: fk)
-- dept --- emp

--deptno(pk) ---<-  emp(deptno:fk)
--10                10        
--20                20
--30                30
--40                40
--                  null (이 외의 다른 값들은 X)
--delete(삭제불가)    

-- 명시적으로 어느 칼럼이 어디 테이블에 속한 것인지 알지만
-- SQL은 하나하나 테이블을 지정해주는 것이 좋다.
select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d; --cartesian product
-- recursive sql 수행을 줄이면 성능개선에 도움이 된다.
-- e. (d.)처럼 어디 테이블에 속해있는 건지를 지정해주면 recursive sql을 줄일 수 있다.(alias 지정)
-- 조인 조건이 누락 되면 cartesian product(cross join/ rows*rows의 결과)

select e.empno, e.ename, e.deptno, d.dname
from emp e cross join dept d; -- 다른 방식

---------------------------------------
-- equi 조인
select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno;

select empno, ename, deptno, dname
from emp natural join dept;
-- natural join은 조인할 테이블에서 이름이 동일한 컬럼에 대해서 자동으로 equi 조인을 수행
-- alias를 사용하면 오히려 안된다. 동일한 이름의 컬럼은 소유자 테이블명, alias를 생략한다.

select e.empno, e.ename, deptno, d.dname
from emp e join dept d using(deptno);
-- 여러개 동일한 컬럼이 존재할 수 있기에 
-- using절을 통해 하나의 pk-fk 쌍을 기준 설정해줄 수 있다.

---------------------------------------
-- 모델링 잘못 설계한 경우
-- 동일한 속성의 컬럼이름을 다르게 설계
-- 컬럼타입을 다르게 설계

create table t_emp
as select empno, ename, deptno deptid
from emp; -- 테이블구조, 데이터 복제

desc t_emp;

-- 컬럼 이름이 다른 경우(fk(deptid)-pk(deptno))
select e.empno, e.ename, d.deptno, d.dname
from t_emp e join dept d on e.deptid = d.deptno;

select e.empno, e.ename, e.deptno, d.dname
from emp e inner join dept d on e.deptno = d.deptno;
-- 이런 방식으로 할 수도 있지만 inner join -> join으로 수행

---------------------------------------
-- emp(sal) - salgrade(grade)
desc salgrade;
desc emp;

select e.ename, e.sal, s.grade
from emp e join salgrade s
on e.sal between s.losal and s.hisal;

---------------------------------------
-- emp (empno: pk, mgr/관리자번호: fk)
-- mgr의 번호를 empno에서 찾아서 해당하는 사원이름을 매칭시킬 수 있다.
-- self join

select e.empno, e.ename, e.mgr, m.ename mgrname
from emp e, emp m
where e.mgr = m.empno;

select e.empno, e.ename, e.mgr, m.ename mgrname
from emp e join emp m on e.mgr = m.empno; -- 이것이 더 좋은 것 같다. 하지만 상황마다 다르다.

---------------------------------------
insert into emp(empno, ename) values(8000, 'Lee');

select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno; -- 부서번호 없는 사원 누락된다.

select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno(+); -- outer 연산자 지정(pk인 부모 영역에)

update emp set sal = 2000 where empno = 8000;

select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno(+)
and d.dname > ''; 
-- 조인 조건외에 다른 필터조건에 (+) 연산자를 넣지 않으면 equi조인으로 수행된다.
-- 그래서 outer 연산자는 비추천한다.

-- left outer join
select e.empno, e.ename, e.deptno, d.dname
from emp e left outer join dept d on e.deptno = d.deptno;

-- right outer join
-- 사원 없는 부서정보를 포함해서 부서별 부서 이름과 소속 사원을 검색

select d.deptno, d.dname, e.empno, e.ename
from emp e, dept d
where e.deptno(+) = d.deptno
order by d.deptno;

select d.deptno, d.dname, e.empno, e.ename
from emp e right outer join dept d on e.deptno = d.deptno
order by d.deptno;

-- full outer join
-- 아직 부서 배정 받지 못한 사원과 사원 없는 부서정보를 모두 포함해서 검색
select d.deptno, d.dname, e.empno, e.ename
from emp e, dept d
where e.deptno(+) = d.deptno(+)
order by d.deptno; -- error

select d.deptno, d.dname, e.empno, e.ename
from emp e full outer join dept d on e.deptno = d.deptno
order by d.deptno;

-- join 수행방식
-- nested loop join: OLTP (조인결과가 소량일 경우), 이중 for문이라 생각하면 된다.
-- 먼저 access되는 table의 row 개수가 적은 테이블을 선정하는 것이 좋다.
-- ex) 10 Rows(pk) - 1000 Rows(fk)

-- hash join(cost based optimizer mode)
-- 먼저 access하는 table의 fk를 해시함수를 통해 해시테이블을 만들고 그 해시테이블을 기준으로 참조되는 테이블의 데이터를 찾는다.
-- index가 중요하진 않다.
-- nested에서 성능개선이 힘들 때 사용하는 방법
-- 대용량Rows - 대용량Rows도 가능

-- sort merge join
-- pk, fk 정렬을 통해 같은 것끼리 지정


---------------------------------------
-- 집합연산자

-- union, union all, intersect, minus

select to_number(null), to_char(null), avg(sal)
from emp
union all
select deptno, to_char(null), avg(sal)
from emp
group by deptno
union all
select deptno, job, avg(sal)
from emp
group by deptno ,job;
-- 3번이나 같은 테이블을 full scan한다.

-- 여러번 full scan 방지하고자 새로운 문법 제공(roll up)
select deptno, job, avg(sal)
from emp
group by rollup(deptno, job);

-- 오른쪽부터 지우면서 조합을 만들어 간다.
-- group by rollup(a, b)
-- > group by a, b
-- > group by a
-- > group by ()

-- group by rollup(a, b, c)
-- > group by a, b, c
-- > group by a, b
-- > group by a
-- > group by ()

-- cube
select to_number(null), to_char(null), avg(sal)
from emp
union all
select deptno, to_char(null), avg(sal)
from emp
group by deptno
union all
select to_number(null), job, avg(sal)
from emp
group by job
union all
select deptno, job, avg(sal)
from emp
group by deptno ,job;

select deptno, job, avg(sal)
from emp
group by cube(deptno, job);

-- 모든 경우의 수를 다 따진다.
-- group by cube(a, b, c)
-- > group by a, b, c
-- > group by a, b
-- > group by b, c
-- > group by a, c
-- > group by a
-- > group by b
-- > group by c
-- > group by ()

-- Quiz
-- 관리자별 급여 평균과 부서와 직무별 급여 평균과 전체 평균을 단일 결과로
select * from emp;
select deptno, job, mgr, avg(sal)
from emp
group by grouping sets((mgr), (deptno, job), ());

select to_number(null), to_char(null), avg(sal)
from emp
union all
select deptno, to_char(null), avg(sal)
from emp
group by deptno
union all
select to_number(null), job, avg(sal)
from emp
group by job
union all
select deptno, job, avg(sal)
from emp
group by deptno ,job
order by 3 desc;

---------------------------
-- subquery
-- select : main query, outer query
-- from
-- where ...(select
--          from
--          where ...); : subquery, nested query, inner query

-- subquery: where, from, having, select, order by 에 정의 가능
-- where절에 많이 오는 편이다.
--select    (subquery)
--from      (subquery)
--[where]    (subquery)
--[group by]  
--[having]    (subquery)
--[order by]  (subquery)

--single row subquery는 single row subquery operator와 함께 ...
--multiple row subquery는 multiple row subquery operator와 함께...

--subquery가 where절에 선언될때 single row subquery는 =, >, >=, <, <=, <>, != 연산자와 함께 선언됩니다.
--multiple row subquery인 경우에는 in, any, all 연산자와 함께 선언됩니다.

-- single row subquery (하나의 행 결과만 가져오는 경우)
-- multiple row subquery (여러 개의 행 결과만 가져오는 경우) 
-- scalar subquery (하나의 열만 가져오는 경우)
-- multiple column subquery (pair-wise 비교)

-- co-related subquery (상관관계 subquery)
-- select
-- from table1 a
-- where ...(select
--          from table2
--          where a.col = col);
-- table1의 col의 개수만큼 반복 쿼리 수행하는 것이다.

-- Quiz
-- smith 사원과 동일한 직무를 담당하는 사원들의 급여 조회
select empno, ename, sal
from emp
where job = (select job 
from emp 
where ename = 'SMITH');

-- Q) 사원번호 7839번과 동일한 직무를 담당하는 사원정보 검색
select *
from emp
where job = (select job
            from emp
            where empno = 7839);

-- Q) emp 테이블에서 최소 월급을 받는 사원 정보 검색
-- subquery에 그룹함수 사용 가능
select *
from emp
where sal = (select min(sal)
            from emp);
            
-- Q) emp 테이블에서 전체 사원 평균 월급보다 급여가 적게 받는 사원 검색
select *
from emp
where sal < (select avg(sal)
from emp);

-- Q) EMP 테이블에서 사원번호가 7521인 사원과 업무가 같고
--급여가 7934인 사원보다 많은 사원의 사원번호, 이름, 담당업무, 입사일자, 급여를 조회하라.
--where절의 조건마다 subquery 사용 가능
select empno, ename, job, hiredate, sal
from emp
where job = (select job 
            from emp
            where empno = 7521) 
and sal > (select sal
            from emp
            where empno = 7934);

-- Q) EMP 테이블에서 부서별 최소 급여가 20번 부서의 최소 급여보다 많은 부서를 조회하라.
select deptno, min(sal)
from emp
group by deptno
having min(sal) > (select min(sal)
from emp
group by deptno
having deptno = 20);

-- Q) EMP 테이블에서 업무별로 가장 적은 급여를 받는 사원 조회하라
select *
from emp
where (job, sal) in (select job, min(sal)
                    from emp
                    group by job);
                    
-- multiple row subquery - in으로 접근해야 한다.

-- Q) 10번부서 사원의 월급과 동일한 월급을 받는 다른 부서의 사원을 검색하시오
select *
from emp
where sal in (select sal
from emp
where deptno = 10) and deptno <> 10;

-- Q) 업무가 SALESMAN인 사원중 최소 한명 이상의 사원보다 급여를 많이 받는 사원의 이름, 급여, 업무를 조회하라
-- any
select ename, sal, job
from emp
where sal > any(select sal 
from emp 
where job = 'SALESMAN') and
job <> 'SALESMAN';

-- Q) 업무가 SALESMAN인 모든 사원보다 급여를 많이 받는 사원의 이름, 급여, 업무를 조회하라
-- all
select ename, sal, job
from emp
where sal > all(select sal 
from emp 
where job = 'SALESMAN') and
job <> 'SALESMAN';

-- rowid 값이 같이 저장이 된다.(내장속성)
-- objectid(unique한) + fileid + blockid + row순서번호
select rowid, empno, ename
from emp;

-- rownum 내장컬럼, resultset의 레코드 순번 발행
select rownum, empno, ename, sal
from emp; 

-- 급여의 내림차순으로 레코드 순서번호
-- order by는 이미 순번을 발행한 다음에 실행되기에 순번이 꼬여버린다.
select rownum, empno, ename, sal
from emp
order by sal desc;

select rownum, empno, ename, sal --, deptno(job)은 error 발생
from (select empno, ename, sal 
        from emp
        order by sal desc); -- inline view(논리적인 테이블)

-- Q) 부서번호 30번 사원들중에서 월급이 높은 3사람을 조회하시오 (Top-N쿼리)
-- conn hr/oracle
select *
from (select *
        from emp
        where deptno = 30
        order by sal desc)
where rownum < 4;

-- Q) subquery를 사용해서 관리자인 사원들만 검색
select empno, ename
from emp
where empno in (select mgr from emp); -- 6 rows;

select empno, ename
from emp
where empno not in (select mgr from emp); -- 아무것도 안나온다.
-- mgr column을 보면 null이 포함되어 있다.
-- (=) or (=) or... => (<>) and (<>) and ... 이렇게 바뀐다.
-- <> null은 비교 연산자로 비교하는 것이 불가능하다. (항상 false로 나오게 된다.)

select empno, ename
from emp a
where exists (select '1' 
from emp
where a.empno = mgr); -- subquery에서 존재하는지 여부만 알려주면 된다.

select empno, ename
from emp a
where not exists (select '1' 
from emp
where a.empno = mgr);
-- subuery에서 null이포함되어 있는지 체크해서 main query에 영향을 주는지 여부도 체크해야 합니다.

-- Q) 각 부서별로 평균급여보다 급여를 많이 받는 사원 검색 (이름, 부서, 급여)
select ename, a.deptno, sal, b.avgsal
from emp a, (select deptno, avg(sal) avgsal
            from emp
            group by deptno) b
where a.deptno = b.deptno
and a.sal > b.avgsal;

select ename, a.deptno
from emp a
where sal > (select avg(sal)
            from emp
            where a.deptno = deptno);
            -- 이렇게 하면 where 절 subquery의 결과값을 cache에 저장해서 쓰기 때문에 반복io가 줄어들 수 있다.
-- conn kbdata/oracle

-- with절 - 먼저수행해야 하는 것들을 temp space에 저장해두었다가 사용하는 것
-- with 별칭1 as (select ~~), 별칭2 as (select ~~) : 별칭2 내용을 별칭1 내부 select문에 사용가능하다.

-------------------------
-- subquery를 사용할 수 있는 부분

-- create table ~
-- as select ~
--    from ~; 이것도 subquery

-- create view ~
-- as select ~
--    from ~ 

-- insert into ~ values ~
-- insert into 테이블명
-- select ~
-- from ~;

-- insert into [테이블명, 뷰, (select ~)]
-- values ~

-- update 테이블 set 컬럼 = (scalar subquery), ...
-- where 컬럼 연산자 (subquery)

-- delete from 테이블 where 컬럼 연산자 (subquery);


----------------------------------
-- window 함수

-- rank 함수
-- emp사원 데이터에서 전체 사원의 급여가 높은 순위와 JOB별로 급여가 높은 순위를 출력
select empno, ename, job, sal, rank() over(order by sal desc) "sal_rank"
from emp;
-- 동일한 순위는 같은 등수로 부여하고 그 다음은 명수에 맞게 다음 등수 부여

-- 직무별내 급여 등수도 포함시켜보자
select empno, ename, job, sal, rank() over(order by sal desc) "sal_rank",
rank() over(partition by job order by sal desc) "job_rank"
from emp;

-- dense_rank: 동일한 값의 레코드가 1개 이상이어도 하나의 순위로 취급
select empno, ename, job, sal, 
rank() over(order by sal desc) "sal_rank", -- 1 2 2 4 5
dense_rank() over(order by sal desc) "sal_drank", -- 1 2 2 3 4 5
rank() over(partition by job order by sal desc) "job_rank"
from emp;

-- row_number(): 동일한 값에 대해서 개별적인 순위값을 반환
select empno, ename, job, sal, 
rank() over(order by sal desc) "sal_rank", -- 1 2 2 4 5
dense_rank() over(order by sal desc) "sal_drank", -- 1 2 2 3 4 5
row_number() over(order by sal desc) "sal_rrank"
from emp;

-- sal에 대해서 누적된 값들을 보여준다. 누적분포도 같은 개념(rows unbounded preceding)
select empno, ename, deptno, sal, 
sum(sal) over(partition by deptno order by sal rows unbounded preceding) cum_sum_sal
from emp;
-- 위의 window함수가 없으면 아래와 같이 코드를 작성해야 한다.(실행에 있어서 상당한 비용 발생)
with order_sal as (select empno, ename, deptno, sal
                    from emp
                    order by sal),
    order_num as (select rownum rnum, empno, ename, deptno, sal from order_sal)
select empno, ename, deptno, sal, (select sum(sal) from order_num where rnum <= a.rnum) cum_sal
from order_num a;
-- 이런 window 함수들을 알아야 2번 이상 table을 scan할 것을 한 번으로 줄일 수 있다.

-- ROW(물리적 순서)/RANGE(논리적 순서) BETWEEN [하한선] PRECEDING AND [상한선] FOLLOWING
select empno, mgr, sal, 
    avg(sal) over(partition by mgr 
                order by sal
                ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) "win_avg"
from emp;

select empno, mgr, sal, 
    count(sal) over(order by sal
                    range BETWEEN 300 PRECEDING AND 300 FOLLOWING) "win_avg"
from emp;

-- FIRST_VALUE / LAST_VALUE
-- 파티션별로 가장 높은 급여를 가져올 때
select empno, deptno, mgr, sal, 
    first_value(sal) over(partition by deptno 
                    order by sal desc) "max_sal",
    last_value(sal) over(partition by deptno 
                    order by sal desc
                    rows between current row and unbounded following) "max_sal"
from emp;
-- last_value는 행이 추가가 될 때마다 가장 나중값을 기준으로 지정한다.
-- 그래서 범위를 그 이후까지 포함해주어야 한다. (unbounded following)

-- LAG
-- lag(sal) -> lag(sal, 1, null)
-- lag(기준칼럼, 앞에 몇칸, 없을시 대체)
select  ename, hiredate, sal, lag(sal, 1, null) over (order by hiredate) as prev_sal
from  emp
where job= 'SALESMAN';

select  ename, hiredate, sal, lag(sal, 2, 0) over (order by hiredate) as prev_sal
from  emp
where job= 'SALESMAN';

-- LEAD (LAG 반대)
select  ename, hiredate, sal, lead(sal, 1, null) over (order by hiredate) as next_sal
from  emp
where job= 'SALESMAN';

select  ename, hiredate, sal, lead(sal, 2, 0) over (order by hiredate) as next_sal
from  emp
where job= 'SALESMAN';

-- LISTAGG



-- Function
-- Procedure