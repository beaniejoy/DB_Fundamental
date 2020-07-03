select sysdate from dual;

alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';

select sysdate from dual;

--����ó�� �Լ�: decode(�÷�, �񱳰�1, ���ϰ�1, �񱳰�2, ���ϰ�2, .., [���ϰ�n])
--Sql1999 ǥ�� ǥ����:
--Case �÷� when �񱳰� then ���ϰ� [when �񱳰� then ���ϰ�]
--��
--[else ���ϰ�] end

--Case when ����ǥ���� then ���ϰ�
--[when ����ǥ���� then ���ϰ�]
--��
--[else ���ϰ�] end



--�׷��Լ�
--Count(), min(), max(): 
--sum(), avg(), stddev(), variance(): number type ��������

select min(ename), max(ename), min(hiredate), max(hiredate) from emp;

select count(*), count(comm)
from emp;
-- �׷��Լ��� null�� �����ϰ�, ���꿡 ���Խ�Ű�� �ʴ´�.

select count(*), count(comm), count(deptno), count(distinct deptno)
from emp;

-- ù��°�� �ι�°�� ���� �ٸ��� ���´�.
select avg(comm), sum(comm)/count(*), sum(comm)/count(comm)
from emp;

select avg(nvl(comm, 0)), sum(comm)/count(*), sum(comm)/count(comm)
from emp;

--select        --- 4
--from          --- 1
--[where]       --- 2
--[group by]    --- 3 (only �÷���)
--[order by]    --- 5

select deptno, avg(sal)
from emp
group by deptno;

-- select ���� �׷��Լ��� �׷��Լ��� �������� ���� �÷��� �Բ� �����Ϸ���
-- �ݵ�� �׷��Լ��� �������� ���� �÷��� group by���� �����ϰų�, select������ �����Ѵ�.
select deptno, job, avg(sal)
from emp
group by deptno; -- error: deptno�ȿ����� job�� ���������� �ִ�.

select deptno, job, avg(sal)
from emp
group by deptno, job;

-- Quiz > conn hr/oracle
-- �����ڰ� ���� ����� �����ϰ� �μ��� �ּ� �޿��� 6,000�̻��� �μ���ȣ��
-- �ּұ޿��� �ּұ޿��� ������������ ������ ��� �����ϴ� sql��

--select        --- 5
--from          --- 1
--[where]       --- 2
--[group by]    --- 3 (only �÷���)
--[having �׷��Լ� ����] -- 4
--[order by]    --- 6

select department_id, min(salary)
from employees
where manager_id is not null
group by department_id
having min(salary) > 6000
order by 2 desc;

---------------------------------------
-- # Join
-- dept: �θ� (deptno: pk)
-- emp: �ڽ�  (deptno: fk)
-- dept --- emp

--deptno(pk) ---<-  emp(deptno:fk)
--10                10        
--20                20
--30                30
--40                40
--                  null (�� ���� �ٸ� ������ X)
--delete(�����Ұ�)    

-- ��������� ��� Į���� ��� ���̺� ���� ������ ������
-- SQL�� �ϳ��ϳ� ���̺��� �������ִ� ���� ����.
select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d; --cartesian product
-- recursive sql ������ ���̸� ���ɰ����� ������ �ȴ�.
-- e. (d.)ó�� ��� ���̺� �����ִ� ������ �������ָ� recursive sql�� ���� �� �ִ�.(alias ����)
-- ���� ������ ���� �Ǹ� cartesian product(cross join/ rows*rows�� ���)

select e.empno, e.ename, e.deptno, d.dname
from emp e cross join dept d; -- �ٸ� ���

---------------------------------------
-- equi ����
select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno;

select empno, ename, deptno, dname
from emp natural join dept;
-- natural join�� ������ ���̺��� �̸��� ������ �÷��� ���ؼ� �ڵ����� equi ������ ����
-- alias�� ����ϸ� ������ �ȵȴ�. ������ �̸��� �÷��� ������ ���̺��, alias�� �����Ѵ�.

select e.empno, e.ename, deptno, d.dname
from emp e join dept d using(deptno);
-- ������ ������ �÷��� ������ �� �ֱ⿡ 
-- using���� ���� �ϳ��� pk-fk ���� ���� �������� �� �ִ�.

---------------------------------------
-- �𵨸� �߸� ������ ���
-- ������ �Ӽ��� �÷��̸��� �ٸ��� ����
-- �÷�Ÿ���� �ٸ��� ����

create table t_emp
as select empno, ename, deptno deptid
from emp; -- ���̺���, ������ ����

desc t_emp;

-- �÷� �̸��� �ٸ� ���(fk(deptid)-pk(deptno))
select e.empno, e.ename, d.deptno, d.dname
from t_emp e join dept d on e.deptid = d.deptno;

select e.empno, e.ename, e.deptno, d.dname
from emp e inner join dept d on e.deptno = d.deptno;
-- �̷� ������� �� ���� ������ inner join -> join���� ����

---------------------------------------
-- emp(sal) - salgrade(grade)
desc salgrade;
desc emp;

select e.ename, e.sal, s.grade
from emp e join salgrade s
on e.sal between s.losal and s.hisal;

---------------------------------------
-- emp (empno: pk, mgr/�����ڹ�ȣ: fk)
-- mgr�� ��ȣ�� empno���� ã�Ƽ� �ش��ϴ� ����̸��� ��Ī��ų �� �ִ�.
-- self join

select e.empno, e.ename, e.mgr, m.ename mgrname
from emp e, emp m
where e.mgr = m.empno;

select e.empno, e.ename, e.mgr, m.ename mgrname
from emp e join emp m on e.mgr = m.empno; -- �̰��� �� ���� �� ����. ������ ��Ȳ���� �ٸ���.

---------------------------------------
insert into emp(empno, ename) values(8000, 'Lee');

select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno; -- �μ���ȣ ���� ��� �����ȴ�.

select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno(+); -- outer ������ ����(pk�� �θ� ������)

update emp set sal = 2000 where empno = 8000;

select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno(+)
and d.dname > ''; 
-- ���� ���ǿܿ� �ٸ� �������ǿ� (+) �����ڸ� ���� ������ equi�������� ����ȴ�.
-- �׷��� outer �����ڴ� ����õ�Ѵ�.

-- left outer join
select e.empno, e.ename, e.deptno, d.dname
from emp e left outer join dept d on e.deptno = d.deptno;

-- right outer join
-- ��� ���� �μ������� �����ؼ� �μ��� �μ� �̸��� �Ҽ� ����� �˻�

select d.deptno, d.dname, e.empno, e.ename
from emp e, dept d
where e.deptno(+) = d.deptno
order by d.deptno;

select d.deptno, d.dname, e.empno, e.ename
from emp e right outer join dept d on e.deptno = d.deptno
order by d.deptno;

-- full outer join
-- ���� �μ� ���� ���� ���� ����� ��� ���� �μ������� ��� �����ؼ� �˻�
select d.deptno, d.dname, e.empno, e.ename
from emp e, dept d
where e.deptno(+) = d.deptno(+)
order by d.deptno; -- error

select d.deptno, d.dname, e.empno, e.ename
from emp e full outer join dept d on e.deptno = d.deptno
order by d.deptno;

-- join ������
-- nested loop join: OLTP (���ΰ���� �ҷ��� ���), ���� for���̶� �����ϸ� �ȴ�.
-- ���� access�Ǵ� table�� row ������ ���� ���̺��� �����ϴ� ���� ����.
-- ex) 10 Rows(pk) - 1000 Rows(fk)

-- hash join(cost based optimizer mode)
-- ���� access�ϴ� table�� fk�� �ؽ��Լ��� ���� �ؽ����̺��� ����� �� �ؽ����̺��� �������� �����Ǵ� ���̺��� �����͸� ã�´�.
-- index�� �߿����� �ʴ�.
-- nested���� ���ɰ����� ���� �� ����ϴ� ���
-- ��뷮Rows - ��뷮Rows�� ����

-- sort merge join
-- pk, fk ������ ���� ���� �ͳ��� ����


---------------------------------------
-- ���տ�����

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
-- 3���̳� ���� ���̺��� full scan�Ѵ�.

-- ������ full scan �����ϰ��� ���ο� ���� ����(roll up)
select deptno, job, avg(sal)
from emp
group by rollup(deptno, job);

-- �����ʺ��� ����鼭 ������ ����� ����.
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

-- ��� ����� ���� �� ������.
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
-- �����ں� �޿� ��հ� �μ��� ������ �޿� ��հ� ��ü ����� ���� �����
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

-- subquery: where, from, having, select, order by �� ���� ����
-- where���� ���� ���� ���̴�.
--select    (subquery)
--from      (subquery)
--[where]    (subquery)
--[group by]  
--[having]    (subquery)
--[order by]  (subquery)

--single row subquery�� single row subquery operator�� �Բ� ...
--multiple row subquery�� multiple row subquery operator�� �Բ�...

--subquery�� where���� ����ɶ� single row subquery�� =, >, >=, <, <=, <>, != �����ڿ� �Բ� ����˴ϴ�.
--multiple row subquery�� ��쿡�� in, any, all �����ڿ� �Բ� ����˴ϴ�.

-- single row subquery (�ϳ��� �� ����� �������� ���)
-- multiple row subquery (���� ���� �� ����� �������� ���) 
-- scalar subquery (�ϳ��� ���� �������� ���)
-- multiple column subquery (pair-wise ��)

-- co-related subquery (������� subquery)
-- select
-- from table1 a
-- where ...(select
--          from table2
--          where a.col = col);
-- table1�� col�� ������ŭ �ݺ� ���� �����ϴ� ���̴�.

-- Quiz
-- smith ����� ������ ������ ����ϴ� ������� �޿� ��ȸ
select empno, ename, sal
from emp
where job = (select job 
from emp 
where ename = 'SMITH');

-- Q) �����ȣ 7839���� ������ ������ ����ϴ� ������� �˻�
select *
from emp
where job = (select job
            from emp
            where empno = 7839);

-- Q) emp ���̺��� �ּ� ������ �޴� ��� ���� �˻�
-- subquery�� �׷��Լ� ��� ����
select *
from emp
where sal = (select min(sal)
            from emp);
            
-- Q) emp ���̺��� ��ü ��� ��� ���޺��� �޿��� ���� �޴� ��� �˻�
select *
from emp
where sal < (select avg(sal)
from emp);

-- Q) EMP ���̺��� �����ȣ�� 7521�� ����� ������ ����
--�޿��� 7934�� ������� ���� ����� �����ȣ, �̸�, ������, �Ի�����, �޿��� ��ȸ�϶�.
--where���� ���Ǹ��� subquery ��� ����
select empno, ename, job, hiredate, sal
from emp
where job = (select job 
            from emp
            where empno = 7521) 
and sal > (select sal
            from emp
            where empno = 7934);

-- Q) EMP ���̺��� �μ��� �ּ� �޿��� 20�� �μ��� �ּ� �޿����� ���� �μ��� ��ȸ�϶�.
select deptno, min(sal)
from emp
group by deptno
having min(sal) > (select min(sal)
from emp
group by deptno
having deptno = 20);

-- Q) EMP ���̺��� �������� ���� ���� �޿��� �޴� ��� ��ȸ�϶�
select *
from emp
where (job, sal) in (select job, min(sal)
                    from emp
                    group by job);
                    
-- multiple row subquery - in���� �����ؾ� �Ѵ�.

-- Q) 10���μ� ����� ���ް� ������ ������ �޴� �ٸ� �μ��� ����� �˻��Ͻÿ�
select *
from emp
where sal in (select sal
from emp
where deptno = 10) and deptno <> 10;

-- Q) ������ SALESMAN�� ����� �ּ� �Ѹ� �̻��� ������� �޿��� ���� �޴� ����� �̸�, �޿�, ������ ��ȸ�϶�
-- any
select ename, sal, job
from emp
where sal > any(select sal 
from emp 
where job = 'SALESMAN') and
job <> 'SALESMAN';

-- Q) ������ SALESMAN�� ��� ������� �޿��� ���� �޴� ����� �̸�, �޿�, ������ ��ȸ�϶�
-- all
select ename, sal, job
from emp
where sal > all(select sal 
from emp 
where job = 'SALESMAN') and
job <> 'SALESMAN';

-- rowid ���� ���� ������ �ȴ�.(����Ӽ�)
-- objectid(unique��) + fileid + blockid + row������ȣ
select rowid, empno, ename
from emp;

-- rownum �����÷�, resultset�� ���ڵ� ���� ����
select rownum, empno, ename, sal
from emp; 

-- �޿��� ������������ ���ڵ� ������ȣ
-- order by�� �̹� ������ ������ ������ ����Ǳ⿡ ������ ����������.
select rownum, empno, ename, sal
from emp
order by sal desc;

select rownum, empno, ename, sal --, deptno(job)�� error �߻�
from (select empno, ename, sal 
        from emp
        order by sal desc); -- inline view(������ ���̺�)

-- Q) �μ���ȣ 30�� ������߿��� ������ ���� 3����� ��ȸ�Ͻÿ� (Top-N����)
-- conn hr/oracle
select *
from (select *
        from emp
        where deptno = 30
        order by sal desc)
where rownum < 4;

-- Q) subquery�� ����ؼ� �������� ����鸸 �˻�
select empno, ename
from emp
where empno in (select mgr from emp); -- 6 rows;

select empno, ename
from emp
where empno not in (select mgr from emp); -- �ƹ��͵� �ȳ��´�.
-- mgr column�� ���� null�� ���ԵǾ� �ִ�.
-- (=) or (=) or... => (<>) and (<>) and ... �̷��� �ٲ��.
-- <> null�� �� �����ڷ� ���ϴ� ���� �Ұ����ϴ�. (�׻� false�� ������ �ȴ�.)

select empno, ename
from emp a
where exists (select '1' 
from emp
where a.empno = mgr); -- subquery���� �����ϴ��� ���θ� �˷��ָ� �ȴ�.

select empno, ename
from emp a
where not exists (select '1' 
from emp
where a.empno = mgr);
-- subuery���� null�����ԵǾ� �ִ��� üũ�ؼ� main query�� ������ �ִ��� ���ε� üũ�ؾ� �մϴ�.

-- Q) �� �μ����� ��ձ޿����� �޿��� ���� �޴� ��� �˻� (�̸�, �μ�, �޿�)
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
            -- �̷��� �ϸ� where �� subquery�� ������� cache�� �����ؼ� ���� ������ �ݺ�io�� �پ�� �� �ִ�.
-- conn kbdata/oracle

-- with�� - ���������ؾ� �ϴ� �͵��� temp space�� �����صξ��ٰ� ����ϴ� ��
-- with ��Ī1 as (select ~~), ��Ī2 as (select ~~) : ��Ī2 ������ ��Ī1 ���� select���� ��밡���ϴ�.

-------------------------
-- subquery�� ����� �� �ִ� �κ�

-- create table ~
-- as select ~
--    from ~; �̰͵� subquery

-- create view ~
-- as select ~
--    from ~ 

-- insert into ~ values ~
-- insert into ���̺��
-- select ~
-- from ~;

-- insert into [���̺��, ��, (select ~)]
-- values ~

-- update ���̺� set �÷� = (scalar subquery), ...
-- where �÷� ������ (subquery)

-- delete from ���̺� where �÷� ������ (subquery);


----------------------------------
-- window �Լ�

-- rank �Լ�
-- emp��� �����Ϳ��� ��ü ����� �޿��� ���� ������ JOB���� �޿��� ���� ������ ���
select empno, ename, job, sal, rank() over(order by sal desc) "sal_rank"
from emp;
-- ������ ������ ���� ����� �ο��ϰ� �� ������ ����� �°� ���� ��� �ο�

-- �������� �޿� ����� ���Խ��Ѻ���
select empno, ename, job, sal, rank() over(order by sal desc) "sal_rank",
rank() over(partition by job order by sal desc) "job_rank"
from emp;

-- dense_rank: ������ ���� ���ڵ尡 1�� �̻��̾ �ϳ��� ������ ���
select empno, ename, job, sal, 
rank() over(order by sal desc) "sal_rank", -- 1 2 2 4 5
dense_rank() over(order by sal desc) "sal_drank", -- 1 2 2 3 4 5
rank() over(partition by job order by sal desc) "job_rank"
from emp;

-- row_number(): ������ ���� ���ؼ� �������� �������� ��ȯ
select empno, ename, job, sal, 
rank() over(order by sal desc) "sal_rank", -- 1 2 2 4 5
dense_rank() over(order by sal desc) "sal_drank", -- 1 2 2 3 4 5
row_number() over(order by sal desc) "sal_rrank"
from emp;

-- sal�� ���ؼ� ������ ������ �����ش�. ���������� ���� ����(rows unbounded preceding)
select empno, ename, deptno, sal, 
sum(sal) over(partition by deptno order by sal rows unbounded preceding) cum_sum_sal
from emp;
-- ���� window�Լ��� ������ �Ʒ��� ���� �ڵ带 �ۼ��ؾ� �Ѵ�.(���࿡ �־ ����� ��� �߻�)
with order_sal as (select empno, ename, deptno, sal
                    from emp
                    order by sal),
    order_num as (select rownum rnum, empno, ename, deptno, sal from order_sal)
select empno, ename, deptno, sal, (select sum(sal) from order_num where rnum <= a.rnum) cum_sal
from order_num a;
-- �̷� window �Լ����� �˾ƾ� 2�� �̻� table�� scan�� ���� �� ������ ���� �� �ִ�.

-- ROW(������ ����)/RANGE(���� ����) BETWEEN [���Ѽ�] PRECEDING AND [���Ѽ�] FOLLOWING
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
-- ��Ƽ�Ǻ��� ���� ���� �޿��� ������ ��
select empno, deptno, mgr, sal, 
    first_value(sal) over(partition by deptno 
                    order by sal desc) "max_sal",
    last_value(sal) over(partition by deptno 
                    order by sal desc
                    rows between current row and unbounded following) "max_sal"
from emp;
-- last_value�� ���� �߰��� �� ������ ���� ���߰��� �������� �����Ѵ�.
-- �׷��� ������ �� ���ı��� �������־�� �Ѵ�. (unbounded following)

-- LAG
-- lag(sal) -> lag(sal, 1, null)
-- lag(����Į��, �տ� ��ĭ, ������ ��ü)
select  ename, hiredate, sal, lag(sal, 1, null) over (order by hiredate) as prev_sal
from  emp
where job= 'SALESMAN';

select  ename, hiredate, sal, lag(sal, 2, 0) over (order by hiredate) as prev_sal
from  emp
where job= 'SALESMAN';

-- LEAD (LAG �ݴ�)
select  ename, hiredate, sal, lead(sal, 1, null) over (order by hiredate) as next_sal
from  emp
where job= 'SALESMAN';

select  ename, hiredate, sal, lead(sal, 2, 0) over (order by hiredate) as next_sal
from  emp
where job= 'SALESMAN';

-- LISTAGG



-- Function
-- Procedure