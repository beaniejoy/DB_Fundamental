-- full scan
select *
from employees
where first_name = 'James';

-- index scan
select *
from employees
where employee_id = 200;
-- <>(!=, ^=) �ϰų� function�� �̿��� ������ �Ǹ� index scan�� ���Ѵ�.

select sysdate, sysdate+1, sysdate-1, sysdate+1/24
from dual;
select sysdate-hire_date
from employees;

@C:\Users\kds\Desktop\KBDS����\sql��������\creobjects.sql;

conn kbdata/oracle;
select tname from tab;

select last_name, job_id, salary AS sal
FROM employees;

-- 6.
DESC departments;

SELECT * 
FROM departments
WHERE department_id IN(10, 20, 50, 60, 80, 90, 110, 190);

-- 7.
DESC employees;

SELECT employee_id, last_name, job_id, hire_date AS STARTDATE  
FROM employees
WHERE employee_id >= 100;

conn scott/oracle;
select table_name from user_tables;

conn hr/oracle;

desc employees;

select department_id, min(salary)
from employees
where manager_id is not null
group by department_id
having min(salary) > 6000
order by 2 desc;

---------------------------------------
-- join
-- n�� ���̺��� ������ �� �ּ� ���������� n-1��
-- Quiz
-- ����̸�(last_name), �μ��̸�, ���ø�

select e.last_name, d.department_id, l.city
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id;

select e.last_name, d.department_id, l.city
from employees e join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id;

---------------------------------------

desc employees;

-- Q) �μ���ȣ 50�� ������߿��� ������ ���� 3����� ��ȸ�Ͻÿ� (Top-N����)
select rownum, employee_id, last_name, salary, department_id
from (select  employee_id, last_name, salary, department_id
        from employees
        where department_id = 50
        order by salary desc )
where rownum < 4; 
-- conn scott/oracle;

