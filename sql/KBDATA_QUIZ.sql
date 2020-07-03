-- 컬럼값이 문자열이거나 날짜의 값은 ''으로 감싸야 한다.
-- "": 대소문자 구별하고 싶을 때, 숫자를 문자열로 처리할 때


-- Quiz
--전체 사원수, 1995, 1996, 1997, 1998년도에 입사한 사원수를 출력하시오
--컬럼 타이틀은 total,  1995, 1996, 1997, 1998 로 출력하시오

select count(employee_id) total,
count(decode(to_char(hire_date, 'YYYY'),'1995',1)) "1995",
count(decode(to_char(hire_date, 'YYYY'),'1996',1)) "1996",
count(decode(to_char(hire_date, 'YYYY'),'1997',1)) "1997",
count(decode(to_char(hire_date, 'YYYY'),'1998',1)) "1998"
from employees;

-- Quiz
--직무별로 월급의 합계와   각 부서내에 직무별 월급의 합계를 아래 보기와 같이 출력하시오
--컬럼 타이틀은 Job, Dept 20, Dept 50, Dept 80, Dept 90로 출력하시오

select job_id, 
sum(decode(department_id, 20, salary, 0)) Dept20,
sum(decode(department_id, 50, salary, 0)) Dept50,
sum(decode(department_id, 80, salary, 0)) Dept80,
sum(decode(department_id, 90, salary, 0)) Dept90,
sum(salary) total
from employees
group by job_id;

-- Quiz
--부서별 평균 급여중 최고 평균 급여를 검색
--그룹함수 내부에 그룹함수 nested 가능
--최고 평균 급여를 가진 부서id를 가져오려면 그냥 dept_id를 가져오면 error난다.
--dept_id는 group by한 순간 여러개가 존재하는 것이다. 결국 이것도 having절을 통해 하나로 특정지어주어야 한다.
select department_id, avg(salary) average
from employees
group by department_id
having avg(salary) = 
(select max(avg(salary))
from employees
group by department_id);

-- # Data 연결 방법
-- 1개 table 이상
-- 1개 ResultSet 이상
-- join
-- SubQuery
-- 집합연산자

--Projection: 칼럼 기준으로 검색/ select from까지
--Selection: row 기준으로 검색/ select from where까지
--join: Parent(pk) - Child(fk), 2개 이상의 table 동일 속성값 기준

--where 조인조건 선언 <-- n-1 최소 조인조건 선언 중 1개라도 누락이되면 cartesian product가 발생(엄청 느려지기 시작)
--join과 where선언절을 분리하는 것이 좋다라고 해서 from 조인조건선언이 생김

-- # Join의 종류
--equi join(inner join): PK - FK를 사용해 조인조건 선언
--not equi join
--자기참조관계의 테이블(pk, fk가 하나의 테이블에 같이 존재, 자기를 참조, self join)
--outer join
--cartesian product (cross join)


---------------------------------------
-- 집합연산자

-- 현재 근무 사원정보(20rows)
-- 과거 근무 이력(10rows)
desc employees;
desc job_history;

-- Quiz
-- 현재 근무 정보와 과거 근무 정보를 검색 출력
select employee_id, job_id, department_id
from employees
union all
select employee_id, job_id, department_id
from job_history; --append

-- Quiz
-- 현재 근무 정보와 과거 근무 정보를 검색 출력(동일부서, 직무는 한번만 결과 포함)
select employee_id, job_id, department_id
from employees
union
select employee_id, job_id, department_id
from job_history;

select employee_id, job_id, department_id
from employees
intersect
select employee_id, job_id, department_id
from job_history;

-- Quiz
-- 입사이후 한번도 직무나, 업무를 변경한 적이 없는 사원번호 검색
select employee_id, job_id, department_id
from employees
minus
select employee_id, job_id, department_id
from job_history;

select employee_id
from employees
minus
select employee_id
from job_history;
-- order by 절은 마지막 select문에서만 사용 가능하다
-- 각 select문에서 선언하는 컬럼개수와 타입 일치해야 한다.

-- Quiz (scott에 이어서)
-- 전체사원의 급여 평균과 부서별 사원의 급여 평균과 부서와 직무별 사원들의 급여 평균을 단일 검색 결과로
select avg(salary)
from employees;

select department_id, avg(salary)
from employees
group by department_id;

select job_id, avg(salary)
from employees
group by job_id;

-- Q) desc job_history (과거에 사원 근무 이력 )
-- 두번 이상 부서 또는 직무를 변경한 이력이 있는 사원을 검색 (employees)

select *
from employees a, (select employee_id, count(employee_id) cnt
                    from job_history 
                    group by employee_id) b
where a.employee_id = b.employee_id
and b.cnt >= 2;

select *
from employees a
where 2 <= (select count(employee_id)
            from job_history
            where a.employee_id = employee_id);

select * 
from employees
where employee_id in (select employee_id
                        from job_history
                        group by employee_id
                        having count(employee_id) > 1); -- 좋은 방법은 아니다.
                        
SELECT job_id, last_name, salary, CUME_DIST() 
  OVER (PARTITION BY job_id ORDER BY salary) AS cume_dist
  FROM employees;
