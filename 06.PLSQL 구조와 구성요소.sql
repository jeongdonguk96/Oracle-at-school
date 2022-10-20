-- PLSQL
-- 1. �͸��� -- DECLARE : �����, BEGIN : �����, END : ��
DECLARE
   vi_num NUMBER;
   BEGIN
     vi_num := 100;
     DBMS_OUTPUT.PUT_LINE(vi_num);
   END;

-- 2. ������
DECLARE
  a INTEGER := 2**2*3**2; -- ��������
BEGIN
  DBMS_OUTPUT.PUT_LINE('a=' || TO_CHAR(a));
END;

-- 3.DML - select, insert, update, delete�� ���Ե� ������ ���۾�
DECLARE
  vs_emp_name VARCHAR2(100);
  vs_dept_name VARCHAR2(80);
BEGIN
  SELECT e.emp_name, d.department_name
    INTO vs_emp_name, vs_dept_name -- INTO�� ���� SELECT�� �÷��� ����ȭ�� �� ����
    FROM employees e, departments d
   WHERE e.department_id = d.department_id
     AND employee_id = 100;
     
     DBMS_OUTPUT.put_line(vs_emp_name || ' : ' || vs_dept_name); 
END;

-- DML ��������
-- �����ȣ�� 110�� ����� �μ�Ƽ�� ���, �μ�Ƽ������ 0.12(�޿�*�μ�Ƽ����)
-- ��³��� : ����� - �μ�Ƽ�� �ݾ�
DECLARE
  vs_emp_name VARCHAR2(10);
  vn_insenplus NUMBER;
BEGIN
  SELECT emp_name, salary+(salary*0.12) insenplus
    INTO vs_emp_name, vn_insenplus
    FROM employees
   WHERE employee_id = 110;
   
   DBMS_OUTPUT.put_line(vs_emp_name || ' - ' || vn_insenplus);
END;

-- 4. ������Ģ
-- (1) ������ ū ����ǥ�� ����� �� �ִ�.
-- (2) ��ҹ��� ������ �ִ�.
DECLARE
  "WELCOME" VARCHAR2(10) := 'WELCOME';
  "welcome" VARCHAR2(10) := 'welcome';
BEGIN
  DBMS_OUTPUT.put_line(WELCOME);
  DBMS_OUTPUT.put_line(welcome);
END;  

-- (3) ū ����ǥ�� ����ϸ� ���� ������ ��� ����.
DECLARE
  "DECLARE" VARCHAR2(20) := '�����';
  "Declare" VARCHAR2(20) := '�ٸ� ����';
BEGIN
  DBMS_OUTPUT.put_line("DECLARE");
  DBMS_OUTPUT.put_line("Declare");
END;

-- 5. %TYPEŰ���� ���
DECLARE
  vs_emp_name employees.emp_name%TYPE;
  vs_dept_name departments.department_name%TYPE;
BEGIN
  SELECT e.emp_name, d.department_name
    INTO vs_emp_name, vs_dept_name
    FROM employees e, departments d
   WHERE e.department_id = d.department_id
     AND employee_id = 100;
     
     DBMS_OUTPUT.put_line(vs_emp_name || ' : ' || vs_dept_name); 
END;

-- PLSQL ��������
-- employees���̺��� �����ȣ�� 201�� ����� �̸��� �̸����ּҸ� ����ϴ� �͸��� �ۼ�
-- ��³��� : �̸� : �̸����ּ�
DECLARE
  vs_emp_name employees.emp_name%TYPE;
  vs_email employees.email%TYPE;
BEGIN
  SELECT emp_name, email
    INTO vs_emp_name, vs_email
    FROM employees
   WHERE employee_id = 201;

    DBMS_OUTPUT.put_line(vs_emp_name || ' : ' || vs_email); 
END;   

-- employees���̺��� �ִ� �����ȣ�� �˻��ؼ�
-- �ִ�����ȣ+1�� �űԻ�� �߰�
-- �Է��׸� : �����ȣ, �����(�̼���), �̸���(SSLEE), �Ի�����(��������), �μ���ȣ(50)

DECLARE
  vn_max employees.employee_id%TYPE;
BEGIN
  SELECT MAX(employee_id)
    INTO vn_max
    FROM employees;
    
    INSERT INTO employees(employee_id, emp_name, email, hire_date, department_id)
         VALUES (vn_max+1, '�̼���', 'SSLEE', sysdate, 50);
    commit;
END;
   
-- 6. ���
-- 6-1. IF ���ǹ�
-- (1) ū ���� ����ϴ� IF��
DECLARE
  vn_num1 NUMBER := 10;
  vn_num2 NUMBER := 20;
BEGIN
  IF vn_num1 >= vn_num2 THEN
  DBMS_OUTPUT.put_line('ū ���� ' || vn_num1);
  ELSE DBMS_OUTPUT.put_line('ū ���� ' || vn_num2);
  END IF;
END;

-- (2) DBMS_RANDOM��Ű���� �̿��� 10~120������ ���ڸ� ������ �μ���ȣ�� ����
--     �� �μ��� ù��° ����� �޿��� ��ȸ�� (rownum = 1)
--     �޿��� 3000���� ������ '����'
--     3000~6000���̸� '�߰�'
--     6001~10000���̸� '����'
--     10001�̻��̸� '�ֻ���'
--     ������� : "�����, �޿��ݾ�, �޿�����:�߰�"
DECLARE
  vn_dept_id NUMBER := 0;
  vs_emp_name employees.emp_name%TYPE;
  vn_salary NUMBER := 0;
BEGIN
  -- ������ �μ���ȣ ����
  vn_dept_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
  DBMS_OUTPUT.put_line('�μ���ȣ = ' || vn_dept_id);
  -- ù��° ����� �޿� ��ȸ
  SELECT emp_name, salary
    INTO vs_emp_name, vn_salary
    FROM employees
   WHERE department_id = vn_dept_id
     AND rownum = 1;
    DBMS_OUTPUT.put_line('ù��° ����� �޿� = ' || vn_salary);
    -- IF���ǹ����� ���
    IF vn_salary < 3000 THEN
    DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '�޿����� : ����');
    ELSIF vn_salary BETWEEN 3000 AND 6000 THEN
    DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '�޿����� : �߰�');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
    DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '�޿����� : ����');
    ELSE DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '�޿����� : �ֻ���');
    END IF;
END;

-- 6.2 CASE ���ǹ�
-- (1) DBMS_RANDOM��Ű���� �̿��� 10~120������ ���ڸ� ������ �μ���ȣ�� ����
--     �� �μ��� ù��° ����� �޿��� ��ȸ�� (rownum = 1)
--     �޿��� 3000���� ������ '����'
--     3000~6000���̸� '�߰�'
--     6001~10000���̸� '����'
--     10001�̻��̸� '�ֻ���'
--     ������� : "�����, �޿��ݾ�, �޿�����:�߰�"
DECLARE
  vn_dept_id NUMBER := 0;
  vs_emp_name employees.emp_name%TYPE;
  vn_salary NUMBER := 0;
BEGIN
  -- ������ �μ���ȣ ����
  vn_dept_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
  DBMS_OUTPUT.put_line('�μ���ȣ = ' || vn_dept_id);
  -- ù��° ����� �޿� ��ȸ
  SELECT emp_name, salary
    INTO vs_emp_name, vn_salary
    FROM employees
   WHERE department_id = vn_dept_id
     AND rownum = 1;
    DBMS_OUTPUT.put_line('ù��° ����� �޿� = ' || vn_salary);
  -- CASE���ǹ��� 1��° �������� ���
    CASE
      WHEN vn_salary < 3000 THEN
        DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '�޿����� : ����');
      WHEN vn_salary BETWEEN 3000 AND 6000 THEN
        DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '�޿����� : �߰�');
      WHEN vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '�޿����� : ����');
      ELSE DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '�޿����� : �ֻ���');
    END CASE;
END;

-- (2) ���ó�¥�� �����Լ�(TO_CHAR())�� �̿��� ������ ���� ����
--     ������ ���� 1�̸� '������ �Ͽ����Դϴ�', 2�� '������ �������Դϴ�.'�� 7���� ���
DECLARE
  vn_day NUMBER := TO_CHAR(sysdate, 'D'); -- �����Լ��� ���� ȣ�� ����
BEGIN
  
  -- CASE���ǹ��� 2��° �������� ���
    CASE vn_day
      WHEN 1 THEN
        DBMS_OUTPUT.put_line('������ �Ͽ����Դϴ�.');
      WHEN 2 THEN
        DBMS_OUTPUT.put_line('������ �������Դϴ�.');
      WHEN 3 THEN
        DBMS_OUTPUT.put_line('������ ȭ�����Դϴ�.');
      WHEN 4 THEN
        DBMS_OUTPUT.put_line('������ �������Դϴ�.');
      WHEN 5 THEN
        DBMS_OUTPUT.put_line('������ ������Դϴ�.'); 
      WHEN 6 THEN
        DBMS_OUTPUT.put_line('������ �ݿ����Դϴ�.'); 
      ELSE DBMS_OUTPUT.put_line('������ ������Դϴ�.'); 
    END CASE;
END;

-- 6-3. LOOP �ݺ���
-- (1) ������ 3��
DECLARE
  vn_base_num NUMBER := 3;
  vn_cnt NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= '
                          || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt + 1;
    
    EXIT WHEN vn_cnt > 9;
  END LOOP;
END;

-- (2) 2~50������ ���� �� �Ҽ��� ���Ͻÿ�
-- ���� LOOP�� ���
DECLARE
  vn_cnt NUMBER := 2; -- 50���� �����ϴ� ��
  j NUMBER;
BEGIN
  LOOP
  
    j := 2;
    LOOP
      
      -- j�� ������ �������� 0�̸� LOOP�� EXIT�Ѵ�.
      EXIT WHEN (MOD(vn_cnt, j) = 0);
      j := j + 1;
    END LOOP;
    
    IF vn_cnt = j THEN
       DBMS_OUTPUT.put(vn_cnt || ', ');
    END IF;
    
    vn_cnt := vn_cnt + 1;
    EXIT WHEN vn_cnt > 50;
  END LOOP;
  DBMS_OUTPUT.put_line('');
END;

-- 6-4. WHILE LOOP
-- (1) ������ 3��
DECLARE
  vn_base_num NUMBER := 3;
  vn_cnt NUMBER := 0 ;
BEGIN
  WHILE vn_cnt <= 9
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= '
                          || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt + 1;
  END LOOP;
END;  

-- 6-5. FOR LOOP
-- (1) ������ 3��
DECLARE
  vn_base_num NUMBER := 3;
BEGIN
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= '
                          || vn_base_num * i);
  END LOOP;
END;

-- (2) employes���̺��� ��ü ����� ���� ��ȸ
--     FOR LOOP�� �̿��� ���� ��� �� ��ŭ emp_temp���̺� �����͸� insert
-- emp_temp���̺� ����
CREATE TABLE emp_temp(
    emp_id NUMBER,         -- index��
    emp_email VARCHAR2(30) -- anyone@email.com
);

DECLARE
  vn_rec_cnt NUMBER;
BEGIN
  SELECT count(*)
    INTO vn_rec_cnt
    FROM employees;
    
  FOR i IN 1..vn_rec_cnt
  LOOP
  
    INSERT INTO emp_temp(emp_id, emp_email) VALUES(i, 'anyone@email.com');
  END LOOP;
END;

-- 6-5. CONTINUE
-- (1) ������ 3��
DECLARE
  vn_base_num NUMBER := 3;
BEGIN
  FOR i IN 1..9
  LOOP
    CONTINUE WHEN i = 5;
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= '
                          || vn_base_num * i);
  END LOOP;
END;

-- 6-6. GOTO
-- (1) ������ 3�� �� i�� ������ ���ڰ� ���� �� 4������ �Ѿ��
DECLARE
  vn_base_num NUMBER := 3;
BEGIN
  <<third>>
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
    IF i=3 THEN GOTO fourth;
    END IF;
  END LOOP;
  <<fourth>>
    vn_base_num := 4;
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
  END LOOP;
END;