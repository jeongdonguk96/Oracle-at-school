-- �������� - ���������� ���Ǵ� ����
-- 1. �Ϲ� ��������
-- 1.1 ������ ���� ����
-- (1) �������� ��ȯ�ϴ� �������� 
-- ��� ����� ��ձ޿����� ���� �޴� ����� �� ��ȸ
SELECT count(*)
  FROM employees
 WHERE salary > (SELECT AVG(salary) FROM employees);

-- orders_ex���̺��� �ֹ����ڰ� 2012-10-10�� ��� �ֹ��ݾ׺��� ū �ֹ��ݾ� ��ȸ
SELECT *
  FROM orders_Ex
 WHERE purch_amt > (SELECT AVG(purch_amt) FROM orders_ex 
                    WHERE ord_date = To_DATE('2012-10-10', 'YYYY-MM-DD'))
ORDER BY purch_amt;

-- (2) �������� ��ȯ�ϴ� �������� - IN�� ���
-- departments���̺��� parent_id�� ���� �μ��� ���ϴ� ������� ��ȸ
SELECT count(*)
  FROM departments
 WHERE department_id IN (SELECT department_id
                           FROM departments
                          WHERE parent_id IS NULL);
                        
-- �Ŵ����� �����ϴ� �μ��� ���ϴ� ����� �� ��ȸ
SELECT count(*)
  FROM employees
 WHERE department_id IN (SELECT department_id
                        FROM departments
                       WHERE manager_id IS NOT NULL);
                       
-- salesman, order_ex���̺��� �̿��� paris�� ����ϴ� ��������鿡 ���� ��� �ֹ������� ��ȸ
SELECT *
  FROM orders_ex
 WHERE salesman_id IN (SELECT salesman_id
                         FROM salesman
                        WHERE city = 'Paris');

-- salesman, orders_ex���̺��� �̿��� paul adam�� �Ǹ��� ��� �ֹ������� ��ȸ
SELECT *
  FROM orders_ex
 WHERE salesman_id IN (SELECT salesman_id
                         FROM salesman
                        WHERE name = 'Paul Adam');
                        
-- (3) ���ÿ� 2�� �̻��� �÷����� ��ȯ�ϴ� ��������
-- employees���̺��� job_history���̺� �����ϴ� �����ȣ, ��å��ȣ ���� ������ ����� ������ ��ȸ
SELECT employee_id, emp_name, job_id
  FROM employees
 WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
                                 FROM job_history);

-- �μ����� �ִ�޿��� �޴� ����� �����ȣ, �����, �޿� ��ȸ (�μ���ȣ, �μ��� �ִ�޿� ��ȸ)
SELECT employee_id, emp_name, department_id, salary
  FROM employees
 WHERE (NVL(department_id, 0), salary) IN (SELECT NVL(department_id, 0), max(salary)
                                             from employees
                                         group by department_id);
                                 
-- (4) SELECT�� �ƴ� �ٸ� �������� ���
-- ��� ����� �޿��� �� ����� ��ձ޿��� ����
UPDATE employees
   SET salary = (SELECT AVG(salary) FROM employees);
   
-- 1.2 ������ �ִ� ��������
-- job_history�� �����ϴ� ��� ���ڵ忡 ���� �μ���ȣ�� ������ department���̺��� �μ���ȣ, �μ��� ��ȸ
SELECT department_id, department_name
  FROM departments d
 WHERE EXISTS (SELECT department_id FROM job_history j
                WHERE j.department_id = d.department_id);

-- salesman, customer_ex���̺��� ������ 2�� �̻��� ���� ���� ��������� ���� ��ȸ
-- Ǯ�� 1
SELECT *
  FROM salesman s
 WHERE 1 < (SELECT count(*) FROM customer_ex c
                WHERE c.salesman_id = s.salesman_id
                GROUP BY salesman_id);
-- Ǯ�� 2
SELECT *
  FROM salesman s
 WHERE EXISTS (SELECT salesman_id, count(*) FROM customer_ex c
                WHERE c.salesman_id = s.salesman_id
                GROUP BY salesman_id
                HAVING COUNT(c.salesman_id)>1);

-- SELECT�� ���� ��������
-- job_history�� ��� �࿡ ���� �����ȣ, �����, �μ���ȣ, �μ��� ��ȸ
SELECT j.employee_id,
       (SELECT emp_name FROM employees e
         WHERE j.employee_id = e.employee_id) �����,
       j.department_id,
       (SELECT department_name FROM departments d
         WHERE j.department_id = d.department_id) �μ���
  FROM job_history j;

-- orders_ex���̺��� ��ü �ֹ��� ��ȸ�ϰ� �� �ֹ��� ����� ����������� �Բ� ��ȸ
SELECT ord_no, purch_amt, ord_date,
       (SELECT c.cust_name FROM customer_ex c
         WHERE c.customer_id = o.customer_id) ����,
       (SELECT s.name FROM salesman s
         WHERE s.salesman_id = o.salesman_id) ���������
  FROM orders_ex o;
  
-- ��ձ޿����� ���� �޴� ������ �ִ� �μ��� �μ���ȣ�� �μ��� ��ȸ
SELECT department_id, department_name
  FROM departments d
 WHERE EXISTS(SELECT employee_id, department_id
                FROM employees e
               WHERE e.department_id = d.department_id
                 AND salary > (SELECT AVG(salary) FROM employees));

-- UPDATE������ ������ �ִ� �������� ���
-- �����μ��� 90�� ������� �޿��� �� �μ��� ��ձ޿��� ����
-- (1) �����μ��� 90�� ������� ��ȸ
SELECT e.employee_id, e.emp_name, d.department_id, d.department_name, d.parent_id 
  FROM employees e, departments d
 WHERE e.department_id = d.department_id
   AND d.parent_id = 90;
-- (2) �����μ��� 90�� �μ��� ��ձ޿� ��ȸ
SELECT e.department_id, TRUNC(AVG(e.salary))
  FROM employees e, departments d
 WHERE e.department_id = d.department_id
   AND d.parent_id = 90
GROUP BY e.department_id;
-- (3) �����μ��� 90�� ������� �޿��� �� �μ��� ��ձ޿��� ����
UPDATE employees e
   SET e.salary = (SELECT sal FROM
                 (SELECT e.department_id, TRUNC(AVG(e.salary)) sal
                    FROM employees e, departments d
                   WHERE e.department_id = d.department_id
                     AND d.parent_id = 90
                GROUP BY e.department_id) v
                   WHERE v.department_id = e.department_id)
 WHERE e.department_id IN(SELECT department_id 
                            FROM departments WHERE parent_id = 90);
rollback;

-- parent_id�� 90�� �μ��� ���ϴ� �μ��� ��ձ޿����� ���� �޴�
-- ����� �����ȣ, �����, �μ���ȣ, �μ��� ��ȸ
-- (1) parent_id�� 90�� �μ��� ���ϴ� ��� ������� ��ձ޿� ��ȸ
SELECT TRUNC(AVG(salary)) avgsal
  FROM employees e, departments d
 WHERE d.parent_id = 90
   AND e.department_id = d.department_id;
-- (2) ���� SQL�� ��� ����   
CREATE OR REPLACE VIEW avg_view AS 
SELECT TRUNC(AVG(salary)) avgsal
  FROM employees e, departments d
 WHERE d.parent_id = 90
   AND e.department_id = d.department_id;
-- (3) ���� SQL �ۼ�
SELECT e.employee_id, e.emp_name, e.salary, d.department_id, d.department_name
  FROM employees e, departments d, avg_view v
 WHERE e.department_id = d.department_id
   AND e.salary > v.avgsal
ORDER BY e.department_id;

-- orders_ex, customer_ex �� ���� ���Ͽ� ���ڽ��� ��� �ֹ��ݾ׺��� ū �ֹ��ݾ��� ���� ��� �ֹ� ��ȸ
-- (1) �� ���� ����ֹ��ݾ� ��ȸ
SELECT customer_id, TRUNC(AVG(purch_amt))
  FROM orders_ex
GROUP BY customer_id;
-- (2) orders_ex, ����並 ������ ��ձݾ׺��� ū �ֹ��ݾ� ��ȸ
SELECT o.customer_id, o.purch_amt ���űݾ�
  FROM orders_ex o, (SELECT customer_id, TRUNC(AVG(purch_amt)) avgpurch
                       FROM orders_ex
                   GROUP BY customer_id) tmp
WHERE o.customer_id = tmp.customer_id
  AND o.purch_amt > tmp.avgpurch
ORDER BY o.customer_id;

-- customer_ex, salesman, orders_ex���̺��� �̿��� �ι� �̻� �ֹ��� ���� ����ϴ�
-- ��������� ���������ȣ, �����, ������ ��ȸ
-- (1) �ι� �̻� �ֹ��� �� ��ȸ
SELECT customer_id, count(customer_id) 
  FROM orders_ex
GROUP BY customer_id HAVING COUNT(customer_id) > 1;
-- (2) ���� ���� ����ϴ� ��������� ���� ��ȸ
SELECT s.salesman_id, s.name, s.commision
  FROM salesman s
 WHERE EXISTS(SELECT customer_id, COUNT(customer_id)
                FROM orders_ex o
               WHERE o.salesman_id = s.salesman_id
            GROUP BY customer_id HAVING COUNT(customer_id) > 1);

-- ������ NewYork�� �����ϴ� ���� ������� �̻��� ���� ������ ���� ��ȸ
-- �������̺� : customer_ex
-- (1) ���� ���� ������� ��ȸ
SELECT AVG(grade)
  FROM customer_ex
 WHERE city = 'New York';
-- (2) ���� ����������� ū ������ ���� ��ȸ
SELECT grade, count(*)
  FROM customer_ex
 WHERE grade > (SELECT AVG(grade)
                  FROM customer_ex
                 WHERE city = 'New York')
GROUP BY grade;

-- orders_ex���̺��� �����ᰡ ���� ū ��������� ���� ��� �ֹ����� ��ȸ
-- (1) ��������� �ִ� ������ ��ȸ
SELECT MAX(commision)
  FROM salesman;
-- (1-1) ���������� �̿��� �ִ� �����Ḧ �޴� ������� ��ȸ
SELECT salesman_id,commision maxcommision
  FROM salesman
 WHERE commision = (SELECT MAX(commision)
                      FROM salesman);
-- (2) orders_ex���̺��� �ִ� �����Ḧ �޴� ����������� ��� �ֹ����� ��ȸ
SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
  FROM orders_ex
 WHERE salesman_id IN (SELECT salesman_id
                         FROM salesman
                        WHERE commision = (SELECT MAX(commision)
                                             FROM salesman));