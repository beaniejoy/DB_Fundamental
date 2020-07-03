-- �÷����� ���ڿ��̰ų� ��¥�� ���� ''���� ���ξ� �Ѵ�.
-- "": ��ҹ��� �����ϰ� ���� ��, ���ڸ� ���ڿ��� ó���� ��


-- Quiz
--��ü �����, 1995, 1996, 1997, 1998�⵵�� �Ի��� ������� ����Ͻÿ�
--�÷� Ÿ��Ʋ�� total,  1995, 1996, 1997, 1998 �� ����Ͻÿ�

select count(employee_id) total,
count(decode(to_char(hire_date, 'YYYY'),'1995',1)) "1995",
count(decode(to_char(hire_date, 'YYYY'),'1996',1)) "1996",
count(decode(to_char(hire_date, 'YYYY'),'1997',1)) "1997",
count(decode(to_char(hire_date, 'YYYY'),'1998',1)) "1998"
from employees;

-- Quiz
--�������� ������ �հ��   �� �μ����� ������ ������ �հ踦 �Ʒ� ����� ���� ����Ͻÿ�
--�÷� Ÿ��Ʋ�� Job, Dept 20, Dept 50, Dept 80, Dept 90�� ����Ͻÿ�

select job_id, 
sum(decode(department_id, 20, salary, 0)) Dept20,
sum(decode(department_id, 50, salary, 0)) Dept50,
sum(decode(department_id, 80, salary, 0)) Dept80,
sum(decode(department_id, 90, salary, 0)) Dept90,
sum(salary) total
from employees
group by job_id;

-- Quiz
--�μ��� ��� �޿��� �ְ� ��� �޿��� �˻�
--�׷��Լ� ���ο� �׷��Լ� nested ����
--�ְ� ��� �޿��� ���� �μ�id�� ���������� �׳� dept_id�� �������� error����.
--dept_id�� group by�� ���� �������� �����ϴ� ���̴�. �ᱹ �̰͵� having���� ���� �ϳ��� Ư�������־�� �Ѵ�.
select department_id, avg(salary) average
from employees
group by department_id
having avg(salary) = 
(select max(avg(salary))
from employees
group by department_id);

-- # Data ���� ���
-- 1�� table �̻�
-- 1�� ResultSet �̻�
-- join
-- SubQuery
-- ���տ�����

--Projection: Į�� �������� �˻�/ select from����
--Selection: row �������� �˻�/ select from where����
--join: Parent(pk) - Child(fk), 2�� �̻��� table ���� �Ӽ��� ����

--where �������� ���� <-- n-1 �ּ� �������� ���� �� 1���� �����̵Ǹ� cartesian product�� �߻�(��û �������� ����)
--join�� where�������� �и��ϴ� ���� ���ٶ�� �ؼ� from �������Ǽ����� ����

-- # Join�� ����
--equi join(inner join): PK - FK�� ����� �������� ����
--not equi join
--�ڱ����������� ���̺�(pk, fk�� �ϳ��� ���̺� ���� ����, �ڱ⸦ ����, self join)
--outer join
--cartesian product (cross join)


---------------------------------------
-- ���տ�����

-- ���� �ٹ� �������(20rows)
-- ���� �ٹ� �̷�(10rows)
desc employees;
desc job_history;

-- Quiz
-- ���� �ٹ� ������ ���� �ٹ� ������ �˻� ���
select employee_id, job_id, department_id
from employees
union all
select employee_id, job_id, department_id
from job_history; --append

-- Quiz
-- ���� �ٹ� ������ ���� �ٹ� ������ �˻� ���(���Ϻμ�, ������ �ѹ��� ��� ����)
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
-- �Ի����� �ѹ��� ������, ������ ������ ���� ���� �����ȣ �˻�
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
-- order by ���� ������ select�������� ��� �����ϴ�
-- �� select������ �����ϴ� �÷������� Ÿ�� ��ġ�ؾ� �Ѵ�.

-- Quiz (scott�� �̾)
-- ��ü����� �޿� ��հ� �μ��� ����� �޿� ��հ� �μ��� ������ ������� �޿� ����� ���� �˻� �����
select avg(salary)
from employees;

select department_id, avg(salary)
from employees
group by department_id;

select job_id, avg(salary)
from employees
group by job_id;

-- Q) desc job_history (���ſ� ��� �ٹ� �̷� )
-- �ι� �̻� �μ� �Ǵ� ������ ������ �̷��� �ִ� ����� �˻� (employees)

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
                        having count(employee_id) > 1); -- ���� ����� �ƴϴ�.
                        
SELECT job_id, last_name, salary, CUME_DIST() 
  OVER (PARTITION BY job_id ORDER BY salary) AS cume_dist
  FROM employees;
