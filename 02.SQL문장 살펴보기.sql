-- 1. SELECT��

-- 1-1 �⺻�����ڷ� EMPLOYEES���̺��� �޿��� 5000�� �Ѵ� ����� �����ȣ, �����, �޿� ��ȸ
SELECT employee_id, emp_name, salary FROM employees
  WHERE salary>5000 ORDER BY salary;
  
-- ������������ ���� (DESC)
SELECT employee_id, emp_name, salary FROM employees
  WHERE salary>5000 ORDER BY salary DESC;
  
-- EMPLOYEES���̺��� ��å�� st_clerk�� ����� ��ȸ �� ������� �������� ����
SELECT employee_id, emp_name FROM employees
  WHERE job_id = 'ST_CLERK' ORDER BY emp_name;
  
-- 1-2 �������� OR�� �̿��� EMPLOYEES���̺��� ��å�� st_clerk�̰ų� �޿��� 3000�ʰ��� ����� ��ȸ �� ������� �������� ����  
SELECT employee_id, emp_name FROM employees
  WHERE salary>3000 OR job_id = 'ST_CLERK' ORDER BY emp_name;
  
-- 1-3 �������� AND�� �̿��� EMPLOYEES���̺��� ��å�� st_clerk�̸鼭 �޿��� 3000�ʰ��� ����� ��ȸ �� ������� �������� ����  
SELECT employee_id, emp_name FROM employees
  WHERE salary>3000 AND job_id = 'ST_CLERK' ORDER BY emp_name;
  
-- sales���̺��� amount_sold�� 50�̻��� ����� �����ȣ, �Ǹž��� �����ȣ ������ ��ȸ
SELECT employee_id, amount_sold FROM sales
  WHERE amount_sold>50 ORDER BY employee_id;
  
-- 1-4 LIKE�����ڸ� �̿��� St�� �̸� ���� �տ� ���� ��� ��ȸ
SELECT employee_id, emp_name FROM employees
  WHERE emp_name LIKE 'St%';
  
  -- like�� �̿��� St�� �̸� �߰��� ���� ��� ��ȸ
SELECT employee_id, emp_name FROM employees
  WHERE emp_name LIKE '%St%';
  
-- like�� �̿��� King�� �̸� ���� �ڿ� ���� ��� ��ȸ
SELECT employee_id, emp_name FROM employees
  WHERE emp_name LIKE '%King';
  
-- employees���̺��� phone_number�� '1234'�� ���� ����� �����ȣ, �����, ��ȭ��ȣ�� ��ȸ
SELECT employee_id, emp_name, phone_number FROM employees
  WHERE phone_number LIKE '%1234%';
  
-- 1-5 IN�����ڸ� �̿��� �ҼӺμ��� 10, 20, 40�� ���ϴ� ����� �����, �μ���ȣ, ��ȭ��ȣ�� ��ȸ
SELECT emp_name, department_id, phone_number FROM employees
  WHERE department_id IN (10, 20, 40);
  
-- customers���̺��� year_of_birth�� 1970, 1975���̸鼭 �̸��� 'A'�� �����ϴ� ����
-- ����, �¾ ��, ����, ���ֵ��ø� �̸������� ��ȸ
SELECT cust_name, cust_year_of_birth, cust_gender, cust_city FROM customers
  WHERE cust_year_of_birth IN(1970, 1975) AND cust_name LIKE 'A%'
  ORDER BY cust_name;
  
-- 1-6 BETWEEN~AND�� �̿��� sales���̺��� 1998�� 1������ 12������ ����� �հ踦 ��ȸ
SELECT SUM(amount_sold) FROM sales
  WHERE sales_month BETWEEN '199801' AND '199812';
  
-- sales���̺��� 1999�� 1������ 6������ �� �Ǹż��� �հ踦 ��ȸ
SELECT SUM(quantity_sold) AS "�� �Ǹż���" FROM sales
  WHERE sales_month BETWEEN '199801' AND '199806'; 
  
-- 1-7 DISTINCT
-- (1) ALL�� �̿��� �����ο� �����ϴ� ������ ���ø�� ��ȸ
SELECT ALL cust_city FROM customers -- ALL�� �׻� ����Ʈ
  WHERE country_id='52778';
  
-- (2) DISTINCT�� �̿��� �����ο� �����ϴ� ������ ���ø�� ��ȸ (�ߺ��� ���� ����)
SELECT DISTINCT cust_city FROM customers -- ALL�� �׻� ����Ʈ
  WHERE country_id='52778';
  
-- DISTINCT�� �̿��� EMPLOYEES���̺��� �޿��� 6000�̻��� ������� �μ������ ��ȸ
SELECT DISTINCT department_id FROM employees
  WHERE salary>=6000 ORDER BY department_id;
  
-- 1-8 GROUP BY -- ���踦 ���� �� ���
-- customers���̺��� ���� �����ϴ� ���ú� ���� ��ȸ
SELECT cust_city, count(cust_city) FROM customers
  WHERE country_id='52778' GROUP BY cust_city;
  
-- employees���̺��� �μ����� �׷�ȭ�ؼ� �μ���ȣ�� ����� ��ȸ
SELECT department_id, count(department_id) FROM employees
  GROUP BY department_id ORDER BY department_id;
  
-- sales���̺��� �Ǹſ��� ����� �հ� ��ȸ
SELECT sales_month, SUM(amount_sold) FROM sales
  GROUP BY sales_month;
  
-- (1) GROUP BY ~ HAVING��
-- customers���̺��� ���� �����ϴ� ���ú� ���� ��ȸ �� ������ 500�� �̻��� ���ø�� �� �� ��ȸ
SELECT cust_city, count(cust_city) FROM customers
  GROUP BY cust_city HAVING count(cust_city)>=500 ORDER BY count(cust_city) desc;
  
-- EMPLOYEES���̺��� �μ����� �׷�ȭ �� �ο����� 20�� �̻��� �μ��� �μ���ȣ�� ����� ��ȸ
SELECT department_id, count(employee_id) FROM employees
  GROUP BY department_id HAVING count(employee_id)>=20;
  
-- (2) ROLLUP(�������� ������ ��ȯ)
-- ���� GROUP BY������ ���� ������Ȳ�� �Ⱓ��, ���ⱸ�к��� 2013�� ���� ���ܾ��� ����
SELECT period, gubun, SUM(loan_jan_amt) FROM kor_loan_status
 WHERE period LIKE '2013%' GROUP BY period, gubun ORDER BY period;
 
-- ROLLUP������ ���� ������Ȳ�� �Ⱓ��, ���ⱸ�к��� 2013�� ���� ���ܾ��� ����
SELECT period, gubun, SUM(loan_jan_amt) FROM kor_loan_status
 WHERE period LIKE '2013%' GROUP BY ROLLUP(period, gubun) ORDER BY period;
 
-- (3) CUBE(������ ��� ���պ��� ����)
-- CUBE������ ���� ������Ȳ�� �Ⱓ��, ���ⱸ�к��� 2013�� ���� ���ܾ��� ����
 SELECT period, gubun, SUM(loan_jan_amt) FROM kor_loan_status
 WHERE period LIKE '2013%' GROUP BY CUBE(period, gubun) ORDER BY period;
 
-- (4) GROUPING SETS
-- GROUPING SETS������ ���� ������Ȳ�� �Ⱓ��, ���ⱸ�к��� 2013�� ���� ���ܾ��� ����
 SELECT period, gubun, SUM(loan_jan_amt) FROM kor_loan_status
 WHERE period LIKE '2013%' GROUP BY GROUPING SETS(period, gubun) ORDER BY period;
 
 -- 2. INSERT
 CREATE TABLE ex2_1(
    col1 VARCHAR(20),
    col2 NUMBER,
    col3 DATE
 );
 
 -- �Ϲ����� INSERT��
 INSERT INTO ex2_1(col1, col2, col3) VALUES('ABC', 10, sysdate);
 
 -- �Ϻ� �÷��� �����͸� ������ ��
 INSERT INTO ex2_1(col1, col2) VALUES('DEF', 20);
 
 -- ��� �÷��� �����͸� ������ ��
 INSERT INTO ex2_1 VALUES('GHI', 30, sysdate);
 
CREATE TABLE ex2_2(
   emp_id NUMBER,
   emp_name VARCHAR2(80),
   salary NUMBER,
   manager_id NUMBER
 );
 
 -- EMPLOYEES���̺��� ���, �����, �޿�, ������ ����� ��ȸ �� ex2_2���̺� INSERT
INSERT INTO ex2_2(emp_id, emp_name, salary, manager_id)
SELECT employee_id, emp_name, salary, manager_id
FROM employees;

 -- ex2_2�� ���� ex2_3���̺� ���� �� EMPLOYEE���̺��� ������ ����� 124�̰�
 -- �޿��� 2000~3000�� ����� ��ȸ �� ex2_3���̺� INSERT
CREATE TABLE ex2_3(
   emp_id NUMBER,
   emp_name VARCHAR2(80),
   salary NUMBER,
   manager_id NUMBER
 );
 
INSERT INTO ex2_3(emp_id, emp_name, salary, manager_id)
SELECT employee_id, emp_name, salary, manager_id
FROM employees
WHERE salary BETWEEN 2000 AND 3000 AND manager_id=124;

-- 3. UPDATE

-- ex2_3���̺��� �����ȣ�� 198�� ����� �޿��� 3500���� ����
UPDATE ex2_3 SET salary=3500
WHERE emp_id=198;

-- ex2_3���̺��� �����ȣ�� 199�� ����� �̸��� ȫ�浿���� ����
UPDATE ex2_3 SET emp_name='ȫ�浿'
WHERE emp_id=199;
SELECT * FROM ex2_3;

-- 4. DELETE
-- ex2_3���̺��� �����ȣ�� 198�� ����� ����
DELETE ex2_3
WHERE emp_id=198;

-- 5. MERGE (�����ϴ� ������ ���� INSERT Ȥ�� UPDATE�� ����)
-- newjoin(�ű԰� ���̺�)�� cust(������ ���̺�)
-- newjoin�� �Էµ� ���� ���� cust���̺� �����ϸ� cust�� UPDATE ������ cust�� INSERT
CREATE TABLE newjoin( -- newjoin���̺� ����
  cust_id NUMBER PRIMARY KEY,
  cust_name VARCHAR(10),
  phone NUMBER
);

CREATE SEQUENCE cust_seq -- newjoin_id�� �������� ó��
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
NOCACHE;
INSERT INTO newjoin VALUES(cust_seq.NEXTVAL, 'ȫ�浿', 01080256181); -- newjoin�� ���� ����
INSERT INTO newjoin VALUES(cust_seq.NEXTVAL, '��̼�', 01012345678);
INSERT INTO newjoin VALUES(cust_seq.NEXTVAL, '�ڹο�', 01000000000);

CREATE TABLE cust( -- cust���̺� ����
  cust_id NUMBER,
  cust_name VARCHAR(10),
  phone NUMBER,
  visit_count NUMBER DEFAULT 0
);

CREATE SEQUENCE cust_seq2 -- cust_id�� �������� ó��
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
NOCACHE;
INSERT INTO cust VALUES(cust_seq2.NEXTVAL, 'ȫ�浿', 01080256181, 3); -- cust�� ���� ����

-- MERGE�� ���
MERGE INTO cust C-- ������ ���̺�, cust���̺��� ���� C
USING (SELECT cust_id, cust_name, phone FROM newjoin) N-- ���յ� ���̺�� �÷�, newjoin ���� N
ON (C.cust_id = N.cust_id) -- cust���̺� ������Ʈ �� ����
WHEN MATCHED THEN
     UPDATE SET C.visit_count = C.visit_count+1 -- ���� �湮�̷��� ������ +1 UPDATE
WHEN NOT MATCHED THEN
     INSERT (C.cust_id, C.cust_name, C.phone, C.visit_count) -- ������ ���� INSERT
     VALUES (N.cust_id, N.cust_name, N.phone, 1);
     
-- 6. COMMIT, ROLLBACK, SAVEPOINT
-- �׽�Ʈ���̺� ����
CREATE TABLE dept AS
SELECT department_id, department_name
  FROM departments;
  
-- dept���̺��� �μ���ȣ 10�� �ѹ��η� ����
UPDATE dept SET department_name='�ѹ���ȹ��'
WHERE department_id=10;
commit; -- �����͸� DB�� ���� �ݿ�
rollback; -- �����͸� ���� ���·� �ǵ�����

-- SAVEPOINT -- Ư�������� savepoint�� ���ϰ� ���߿� �ٽ� ���ƿ� �� �ְ� ��
             -- ���̺�� �����ϰ� �����ü���� ������ �ν���
             
-- (1) dept���̺��� �μ���ȣ�� 40�� �μ� ����
DELETE dept WHERE department_id=40;
commit;

-- (2) SAVEPOINT c1�� �����ϰ� �μ���ȣ�� 30�� �μ� ����
SAVEPOINT c1;
DELETE dept WHERE department_id=30;

-- (3) SAVEPOINT c2�� �����ϰ� �μ���ȣ�� 10�� �μ� ����
SAVEPOINT c2;
DELETE dept WHERE department_id=10;

-- (4) SAVEPOINT c2���� ROLLBACK
rollback to c2;

-- TRUNCATE ���� ����. DELETE�� �޸� �ѹ��� �ҿ� ����.
TRUNCATE TABLE dept;


-- 7. �ǻ��÷�

-- 7-1 ROWRUM (������ ���ڵ� ����ŭ ��ȸ�� �� ���)
SELECT ROWNUM, employee_id, emp_name
  FROM employees
  WHERE ROWNUM <=10;
  
-- 7-2 ROWID(�࿡ id�� �������ִµ� �� �ּҰ��� ��Ÿ��. ���� �ĺ��ϴ� ������ ��)
-- �ߺ��� �����͸� ���� ���̺��� ROWID�� �̿��� Ư�� �����͸� ����
CREATE TABLE emp(
  emp_name VARCHAR2(10),
  dept_no NUMBER
);

INSERT INTO emp VALUES('ȫ�浿', 30);
INSERT INTO emp VALUES('������', 30);
INSERT INTO emp VALUES('�̼���', 30);
INSERT INTO emp VALUES('���ع�', 30);
INSERT INTO emp VALUES('ȫ�浿', 30);
commit;
DELETE emp
WHERE emp_name='ȫ�浿' AND dept_no=30;
-- ���� ���߿� ����� 'ȫ�浿'���ڵ� ����. ��, �ּҰ��� ���� ū 'ȫ�浿' ����
-- ���� �ֱ��� �������ϼ��� rowid�� ū���� �Ҵ�
SELECT MAX(ROWID) ,emp_name, dept_no FROM emp 
  GROUP BY emp_name, dept_no;

-- �ߺ��� ������ ���� (subQUERY)
DELETE emp WHERE rowid IN
(SELECT MAX(ROWID) FROM emp 
  GROUP BY emp_name, dept_no);
SELECT * FROM emp;

-- 8. ������

-- 8-1 ���Ŀ����� *�� �̿��� EMPLOYEE���̺��� JOB_ID�� IT_PROG�� ����� ���, �޿�, ������ ��ȸ
SELECT employee_id, salary, salary*12 ���� FROM employees 
  WHERE job_id='IT_PROG';
  
-- 8-2 ���ڿ������� || (�ΰ� �̻��� �÷��� �ϳ��� �÷����� �̾� ���̴� ����) 
-- �̱� ������ ����� �ּҸ� ��ȸ
SELECT cust_name, cust_state_province || cust_city || cust_street_address �ּ�
  FROM customers WHERE country_id=52790 ORDER BY cust_state_province;
  
-- EMPLOYEE���̺��� �����ȣ||����� �������� ���� 10�Ǹ� ��ȸ
SELECT employee_id || ' : ' || emp_name "�����ȣ : �̸�" FROM employees
 WHERE ROWNUM <=10;
 
-- 8-3 ���ǿ�����
-- (1) CASE������(CASE ~ END�� ������ ��)
-- EMPLOYEE���̺��� �޿��� ����� ���� �����, �޿�, ����� ��ȸ
SELECT employee_id, salary,
CASE WHEN salary < 5000 THEN 'C���' -- CASE���� END������ �ϳ��� �÷�
WHEN salary BETWEEN 5000 AND 15000 THEN 'B���'
ELSE 'A���'
END
AS �޿���� -- CASE�����ڴ� ���ο� �÷��� ����� ���� ������ �̸��� �ο��ϴ� �� ����
FROM employees ORDER BY salary;

-- EMPLOYEE���̺��� �����ȣ, �����, job_id, �޿�, �λ�ȱ޿��� ��ȸ
-- CASE1 job_id�� ST_MAN�̸� �λ�� �޿��� �޿�1*1 ����
-- CASE2 SA_REP�� �޿�*1.05 ����
-- CASE3 FI_ACCOUNT�� �޿�*1 ����
-- ELSE �޿�*1.03 ����
SELECT employee_id, emp_name, job_id, salary,
CASE WHEN job_id='ST_MAN' THEN salary*1.1
WHEN job_id='SA_REP' THEN salary*1.05
WHEN job_id='FI_ACCOUNT' THEN salary*1
ELSE salary*1.03
END AS raisedsalary -- ������ ����� �÷��� �ƴ� �����ؼ� ���� �÷��̶� ����ϴ� �� ����
FROM employees ORDER BY job_id;

-- (2) ANY������(�⺻������ IN�� ��������� �񱳿����ڵ��� Ȱ���� �پ��� ������� �� ����
-- CUSTOMERS���̺��� ���ֵ��ð� CA, CO, AR�� �ϳ��� ���� ����, ���Ե��, �ָ� ��ȸ
SELECT cust_name, cust_income_level, cust_state_province FROM customers
  WHERE cust_state_province=ANY('CA', 'CO', 'AR');
  -- WHERE cust_state_province IN('CA', 'CO', 'AR'); IN�� ����� ��������� �پ��� �� ����
  
-- (3) ALL������ (��ȣ ���� ��� ���� �����ϴ� �����͸� ��ȸ)
-- EMPLOYEES���̺��� job_id�� 'SA_MAN'�� ������� �޿��� ���� �޴� ����� �����, job_id,salary ��ȸ
SELECT employee_id, emp_name, job_id, salary FROM employees
WHERE salary > ALL(select salary from employees where job_id='SA_MAN')
AND job_id <> 'SA_MAN';

-- (4) EXISTS (���ǿ� �����ϴ� �����Ͱ� ������ ��ȸ) 
-- skip
SELECT employee_id, salary FROM employees
  WHERE salary=ANY(2000, 3000, 4000) ORDER BY employee_Id;
SELECT employee_id, salary FROM employees
  WHERE salary!=ALL(2000, 3000, 4000) ORDER BY employee_Id;

CREATE TABLE ex3_3(
  employee_id NUMBER,
  sales NUMBER,
  sales_month NUMBER
);

MERGE INTO ex3_3 e-- ������ ���̺�, cust���̺��� ���� C
USING (SELECT e, cust_name, phone FROM newjoin) N-- ���յ� ���̺�� �÷�, newjoin ���� N
ON (C.cust_id = N.cust_id) -- cust���̺� ������Ʈ �� ����
WHEN MATCHED THEN
     UPDATE SET C.visit_count = C.visit_count+1 -- ���� �湮�̷��� ������ +1 UPDATE
WHEN NOT MATCHED THEN
     INSERT (C.cust_id, C.cust_name, C.phone, C.visit_count) -- ������ ���� INSERT
     VALUES (N.cust_id, N.cust_name, N.phone, 1);
     
-- SQL �������� (1)
-- IN�� �̿��ϴ� ������ 
SELECT employee_id, salary
FROM employees
WHERE salary IN (2000, 3000, 4000);

-- ANY�� �̿��ϴ� �������� �ٲٽÿ�
SELECT employee_id, salary
FROM employees
WHERE salary = ANY (2000, 3000, 4000);

-- SQL �������� (2)
-- IN�� �̿��ϴ� ������ 
SELECT employee_id, salary
FROM employees
WHERE salary NOT IN (2000, 3000, 4000);

-- ALL�� �̿��ϴ� �������� �ٲٽÿ�
SELECT employee_id, salary
FROM employees
WHERE salary != ALL (2000, 3000, 4000);
