CREATE TABLE salesman (
salesman_id   number(8)  primary key,
name           varchar(30),
city             varchar2(20),
commision     number(5,2));

CREATE TABLE customer_ex (
customer_id   number(8) primary key,
cust_name    varchar2(30),
city             varchar2(20),
grade           number(5),
salesman_id   number(8));

insert into salesman VALUES(5001 , 'James Hoog' , 'New York' ,       0.15);
insert into salesman VALUES(5002 , 'Nail Knite' , 'Paris'    ,       0.13);
insert into salesman VALUES(5005 , 'Pit Alex'   , 'London'   ,       0.11);
insert into salesman VALUES(5006 , 'Mc Lyon'    , 'Paris'    ,       0.14);
insert into salesman VALUES(5007 , 'Paul Adam'  , 'Rome'     ,       0.13);
insert into salesman VALUES(5003 , 'Lauson Hen' , 'San Jose' ,       0.12);
insert into salesman VALUES(5008 , 'ȫ�浿' , 'Busan' ,       0.12);
commit;

insert into customer_ex VALUES(3002 , 'Nick Rimando'   , 'New York'   ,   100 ,        5001);
insert into customer_ex VALUES(3007 , 'Brad Davis'     , 'New York'   ,   200 ,        5001);
insert into customer_ex VALUES( 3005 , 'Graham Zusi'    , 'California' ,   200 ,        5002);
insert into customer_ex VALUES(3008 , 'Julian Green'   , 'London'     ,   300 ,        5002);
insert into customer_ex VALUES(3004 , 'Fabian Johnson' , 'Paris'      ,   300 ,        5006);
insert into customer_ex VALUES(3009 , 'Geoff Cameron'  , 'Berlin'     ,   100 ,        5003);
insert into customer_ex VALUES( 3003 , 'Jozy Altidor'   , 'Moscow'     ,   200 ,        5007);
insert into customer_ex VALUES(3001 , 'Brad Guzan'     , 'London'     ,     0  ,        5005);
insert into customer_ex VALUES(3010 , '�̼���'     , 'Seoul'     ,     0  ,        '');
commit;

create table ORDERS_EX(
ord_no      number(8)  primary key,
purch_amt  number(7,2),
ord_date    date,
customer_id  number(8),
salesman_id  number(8));

INSERT INTO orders_ex VALUES(70001,       150.5,       '2012-10-05',  3005 ,        5002);
INSERT INTO orders_ex VALUES(70009,       270.65,      '2012-09-10',  3001,         5005);
INSERT INTO orders_ex VALUES(70002,       65.26,       '2012-10-05',  3002,         5001);
INSERT INTO orders_ex VALUES(70004,       110.5,       '2012-08-17',  3009,         5003);
INSERT INTO orders_ex VALUES(70007,       948.5,       '2012-09-10',  3005,         5002);
INSERT INTO orders_ex VALUES(70005,       2400.6,      '2012-07-27',  3007,         5001);
INSERT INTO orders_ex VALUES(70008,       5760 ,       '2012-09-10',  3002 ,        5001);
INSERT INTO orders_ex VALUES(70010,       1983.43 ,    '2012-10-10',  3004,         5006);
INSERT INTO orders_ex VALUES(70003,       2480.4 ,     '2012-10-10',  3009 ,        5003);
INSERT INTO orders_ex VALUES(70012,       250.45,      '2012-06-27',  3008 ,        5002);
INSERT INTO orders_ex VALUES(70011,       75.29 ,      '2012-08-17',  3003 ,        5007);
INSERT INTO orders_ex VALUES(70013,       3045.6,      '2012-04-25',  3002,         5001);
commit;

--------------------------------------------------------------------------------------------

CREATE  TABLE cust_ex (
    custid      varchar2(10)  primary key,
    name      varchar2(30),
    birthyear number,
    addr  varchar2(30),
    mobile varchar2(15),
    regdate date);

CREATE  TABLE  buy (
    num  number primary key,
    custid  varchar2(10),
    prodid number,
    price  number,
    quantity  number);

CREATE  TABLE prod (
    prodid  number  primary key,
    prod_name  varchar2(30),
    groupname  varchar2(30)
);

INSERT  INTO  prod  VALUES(1, '��Ʈ��', '����');
INSERT  INTO  prod  VALUES(2, '�����', '����');
INSERT  INTO  prod  VALUES(3, '�޸�', '����');
INSERT  INTO  prod  VALUES(4, 'û����', '�Ƿ�');
INSERT  INTO  prod  VALUES(5, 'å', '����');
INSERT  INTO  prod  VALUES(6, '�����', '����');
INSERT  INTO  prod  VALUES(7, 'TV', '����');
INSERT  INTO  prod VALUES(8, '�ȭ', '�Ƿ�');

INSERT  INTO  cust_ex  values('LSS', '�̼���', 1960, '���', '010-1234-2234', '2017-04-04');
INSERT  INTO  cust_ex  values('YKS', '������', 1971, '�泲', '010-3556-2234', '2017-06-04');
INSERT  INTO  cust_ex  values('KKC', '������', 1965, '����', '010-6453-2234', '2017-08-10');
INSERT  INTO  cust_ex  values('JMJ', '������', 1967, '����', '010-2345-2234', '2017-04-04');
INSERT  INTO  cust_ex  values('JYS', '�念��', 1971, '���', '010-5673-2234', '2017-07-13');
INSERT  INTO  cust_ex  values('JBK', '�庸��', 1970, '�泲', '010-3423-2234', '2017-05-03');
INSERT  INTO  cust_ex  values('LYK', '������', 1972, '�泲', '010-7876-2234', '2017-03-02');
INSERT  INTO  cust_ex  values('LH', '��Ȳ', 1983, '�泲', '010-9832-2234', '2017-06-08');
INSERT  INTO  cust_ex  values('HKD', 'ȫ�浿', 1990, '����', '010-7682-2234', '2017-05-01');
INSERT  INTO  cust_ex  values('SSJ', '�ż���', 1992, '���', '010-4567-2234', '2017-05-08');

INSERT  INTO  buy VALUES(buy_seq.nextval, 'LSS', 8, 30000, 2);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'LSS', 1, 1000000, 1);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'JMJ', 2, 200000, 1);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'LH', 2, 210000, 2);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'LSS', 4, 50000, 5);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'YKS', 3, 30000, 3);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'JYS',5, 25000, 10);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'JYS', 5, 33000, 2);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'LH', 4, 55000, 2);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'SSJ', 8, 23000, 3);
commit;

CREATE SEQUENCE buy_seq START WITH 1 INCREMENT BY 1;

--------------------------------------------------------------------------

-- ī�׽þ�(CROSS) ���� ����
CREATE TABLE regions(
    region_id   NUMBER,
    region_name VARCHAR2(20)
);

CREATE TABLE countries_ex(
    country_id    CHAR(2),
    country_name  VARCHAR2(20),
    region_id    NUMBER
);

INSERT INTO regions VALUES(1, 'Europe');
INSERT INTO regions VALUES(2, 'America');
INSERT INTO regions VALUES(3, 'Asia');
INSERT INTO regions VALUES(4, 'Middle East');
INSERT INTO regions VALUES(5, 'Africa');
 
INSERT INTO countries_ex VALUES('AR', 'Argentina', 2);
INSERT INTO countries_ex VALUES('AU', 'Australia', 3);
INSERT INTO countries_ex VALUES('BE', 'Belgium', 1);
INSERT INTO countries_ex VALUES('BR', 'Brazil', 2);
INSERT INTO countries_ex VALUES('CA', 'Canada', 2);
INSERT INTO countries_ex VALUES('CH', 'Switzerland', 1);
INSERT INTO countries_ex VALUES('KR', 'South Korea', 3);
INSERT INTO countries_ex VALUES('CN', 'China', 3);
INSERT INTO countries_ex VALUES('DE', 'Germany', 1);
INSERT INTO countries_ex VALUES('DK', 'Denmark', 1);
INSERT INTO countries_ex VALUES('EG', 'Egypt', 4);
INSERT INTO countries_ex VALUES('FR', 'France', 1);
INSERT INTO countries_ex VALUES('IL', 'Israel', 4);
INSERT INTO countries_ex VALUES('IN', 'India', 3);
INSERT INTO countries_ex VALUES('IT', 'Italy', 1);
INSERT INTO countries_ex VALUES('JP', 'Japan', 3);
INSERT INTO countries_ex VALUES('KW', 'Kuwait', 4);
INSERT INTO countries_ex VALUES('MX', 'Mexico', 2);
INSERT INTO countries_ex VALUES('NG', 'Nigeria', 5);
INSERT INTO countries_ex VALUES('NL', 'Netherlands', 1);
INSERT INTO countries_ex VALUES('SG', 'Singapore', 3);
INSERT INTO countries_ex VALUES('US', 'United States', 2);
INSERT INTO countries_ex VALUES('ZM', 'Zambia', 5);
INSERT INTO countries_ex VALUES('ZW', 'Zimbabwe', 5);

commit;

-- 1. INNER JOIN
-- 1.1 EQUI JOIN (��������) - �⺻Ű�� �ܷ�Ű�� �Ű��� ����
-- ��ü ������ �����ȣ, �����, �μ���ȣ, �μ����� ��ȸ
SELECT employee_id, emp_name, e.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id
ORDER BY employee_id;

-- SQL �������� 1
-- ���� ���ÿ� ���ϴ� ���� ��������� ����, ���ø�, �����ȣ, ����� ��ȸ
SELECT c.cust_name, c.city, s.salesman_id, s.name
FROM customer_ex c, salesman s
WHERE c. city = s. city
ORDER BY city;

-- SQL �������� 2
-- �ֹ��ݾ��� 500~2000������ �ֹ��� ���ؼ� �ֹ���ȣ, �ֹ��ݾ�, ����ȣ, �ֹ����� ��ȸ
SELECT o.ord_no, o.purch_amt, c.cust_name, c.city
FROM orders_ex o, customer_ex c
WHERE purch_amt BETWEEN 500 AND 2000 AND o.customer_id = c.customer_id;

-- SQL �������� 3
-- �����Ḧ 12%�̻� �޴� ��������� ����ϴ� ���� �����ȣ, �����, ������, ����, ���ø� ��ȸ
SELECT s.salesman_id, s.name, s.commision, c.cust_name, c.city
FROM salesman s, customer_ex c
WHERE s.commision>=0.12 AND s.salesman_id=c.salesman_id;

-- 1.2 SEMI JOIN 
-- EXISTS�� �̿��� �޿��� 3000�̻��� ����� �μ���ȣ, �μ��� ��ȸ
SELECT department_id, department_name
FROM departments d
WHERE EXISTS (SELECT * FROM employees e
              WHERE d.department_id = e.department_id
              AND e.salary>=3000)
ORDER BY d.department_name;

-- IN�� ����� �޿��� 3000�̻��� ����� �μ���ȣ, �μ��� ��ȸ
SELECT department_id, department_name
FROM departments
WHERE department_id IN (SELECT department_id FROM employees WHERE salary>=3000)
ORDER BY department_name;

-- 1.3 ANTI JOIN - SEMI JOIN�� �ݴ�
-- NOT IN�� ����� departments���̺��� managet_id�� �ִ� �μ��� �����ȣ, �����, �μ���ȣ, �μ��� ��ȸ
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id
      AND e.department_id NOT IN(SELECT department_id
                                 FROM departments WHERE manager_id IS NULL)
ORDER BY department_id;

-- NOT EXISTS�� �̿��� managet_id�� �ִ� �μ��� ���ϴ� ����� ��ȸ
SELECT count(*)
  FROM employees e
  WHERE NOT EXISTS (SELECT department_id
                      FROM departments d WHERE manager_id IS NULL
                       AND e.department_id = d.department_id)
ORDER BY department_id;

-- 1.4 SELF JOIN - ������ ���̺��� ����� ����
-- �μ���ȣ�� 20�� ����� �����ȣ, �����, �μ��� ��ȸ
SELECT a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
  FROM employees a, employees b
 WHERE a.department_id = b.department_id
   AND a.department_id = 20
   AND a.employee_id < b.employee_id;

-- SQL �������� 4
-- employees���̺��� �����ȣ, �����, �μ����ȣ, �μ���� ��ȸ
SELECT a.employee_id, a.emp_name, b.employee_id manager_id, b.emp_name manager_name
  FROM employees a, employees b
 WHERE a.manager_id = b.employee_id
ORDER BY manager_id;

-- SQL �������� 5
-- customer_ex���̺��� ���� ���ÿ� �����ϴ� ���� ����, ����, ���ø� ��ȸ
SELECT a.cust_name, b.cust_name, a.city
  FROM customer_ex a, customer_ex b
 WHERE a.city = b.city
   AND a.customer_id < b.customer_id;
-- �ߺ��� ���� a�� b���� ���� �ѹ��� �� �ι� ������ �ǵ� 
-- id��ȣ�� �ٸ��� ������ ũ�ų� Ȥ�� ���� �ϳ��� ���ǿ� �����ϵ��� �ؼ� �ߺ��� �����ϸ� ��

-- 2. OUTER JOIN
-- SQL �������� 5
-- cust_ex, buy���̺��� �̿��� ����ȣ, ����, ��ǰ��ȣ, �ݾ� ��ȸ
SELECT c.custid, c.name, b.prodid, b.price
  FROM cust_ex c, buy b
 WHERE c.custid = b.custid(+);

-- SQL �������� 6
-- employees���̺��� ��� ����� ���� �����ȣ, �����, ��å��ȣ, ������, ������ ��ȸ
SELECT e.employee_id, e.emp_name, j.job_id, j.start_date, j.end_date
  FROM employees e, job_history j
 WHERE e.employee_id = j.employee_id(+)
ORDER BY employee_id;

-- SQL �������� 7
-- prod, buy���̺��� ��ǰ��ȣ, �ݾ�, ����, ��ǰ�� ��ȸ
SELECT p.prodid, b.price, b.quantity, b.custid
  FROM buy b, prod p
 WHERE b.prodid(+) = p.prodid
ORDER BY prodid;

-- 2.1 CARTESIAN JOIN - WHERE(����)�� ���� ����
SELECT r.region_id, r.region_name, c.country_id, c.country_name
  FROM regions r, countries_ex c
 WHERE r.region_id=3
   AND r.region_id > c.region_id;
 
-- 3. ANSI JOIN
-- 3.1 ANSI INNER JOIN
-- 2003�� 1�� 1�� ���Ŀ� �Ի��� ����� ���, �̸�, �μ���ȣ, �μ��� ��ȸ
-- (1) ���� ����Ŭ ���� ���
SELECT e.employee_id, e.emp_name, d.department_id, d.department_name
  FROM employees e, departments d
 WHERE e.department_id = d.department_id
   AND hire_date>TO_DATE('2003-01-01', 'YYYY-MM-DD');
-- (2) ANSI JOIN���� ���
SELECT e.employee_id, e.emp_name, d.department_id, d.department_name
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
 WHERE hire_date > TO_DATE('2003-01-01', 'YYYY-MM-DD');
 
-- ANSI������ LEFT JOIN�� �̿��� ��� ������ �߷ɳ��� ��ȸ
SELECT e.employee_id, e.emp_name, j.job_id, j.start_date, j.end_date
  FROM employees e
LEFT OUTER JOIN job_history j
    ON e.employee_id = j.employee_id;
    
-- ANSI LEFT JOIN�� �̿��� ��� ��������� �������� ��ȸ�Ͽ� ���������� ��ȸ
SELECT s.name, s.salesman_id, c.customer_id, c.cust_name, c.city, c.grade
  FROM salesman s
LEFT OUTER JOIN customer_ex c
    ON s.salesman_id = c.salesman_id
ORDER BY s.name;

-- ANSI RIGHT JOIN�� �̿��� ��� ������ �߷ɳ��� ��ȸ
SELECT e.employee_id, e.emp_name, j.job_id, j.start_date, j.end_date
  FROM job_history j
RIGHT OUTER JOIN employees e
    ON e.employee_id = j.employee_id;

-- 4. FULL JOIN - ������
CREATE TABLE TAB_A(col_1 NUMBER);
CREATE TABLE TAB_B(col_1 NUMBER);

INSERT INTO TAB_A VALUES(10);
INSERT INTO TAB_A VALUES(20);
INSERT INTO TAB_A VALUES(40);

INSERT INTO TAB_B VALUES(10);
INSERT INTO TAB_B VALUES(20);
INSERT INTO TAB_B VALUES(30);
commit;

-- ANSI������ FULL OUTER JOIN
SELECT a.col_1, b.col_1
  FROM tab_a a
FULL OUTER JOIN tab_b b
    ON a.col_1 = b.col_1;
    
-- SQL �������� 8
-- FULL OUTER JOIN�� �̿��� ��� ��������� ���� ����, �� ���ֵ���, ���������, �������, ���� ��ȸ
SELECT c.cust_name, c.city, s.name, s.city, s.commision
  FROM customer_ex c
FULL OUTER JOIN salesman s
    ON (c.salesman_id = s.salesman_id);