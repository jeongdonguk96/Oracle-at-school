-- 1. ����� ���� �Լ�
-- 1-1. �Ű������� �ִ� �Լ� 
-- (1)�������� ��ȯ�ϴ� �Լ� ���� : my_mod()
CREATE OR REPLACE FUNCTION my_mod(num1 NUMBER, num2 NUMBER)
  RETURN NUMBER
IS -- ���������
  vn_quotient NUMBER; -- �� ����
  vn_remainder NUMBER; -- ������ ����
BEGIN
  vn_quotient := TRUNC(num1 / num2);
  vn_remainder := num1 - (num2 * vn_quotient);
  
  RETURN vn_remainder;
END;

-- (*)����� ���� �Լ� �����
-- (1) SELECT������ ���
SELECT my_mod(14,3) FROM dual;
-- (2) �͸����ν������� ȣ��
DECLARE
  num1 NUMBER := 10;
  num2 NUMBER := 3;
BEGIN
  
  DBMS_OUTPUT.put_line('10�� 3���� ���� ������ = ' || my_mod(num1, num2));
END;

-- (2) ������ȣ�� �Ű������� �޾� countrie���̺��� ��ȸ��
--      �������� ��ȯ�ϴ� �Լ�
--      �Լ��� : fn_get_country_name(p.country_id NUMBER)
CREATE OR REPLACE FUNCTION fn_get_country_name(p_country_id NUMBER)
  RETURN VARCHAR2
IS
  vs_country_name VARCHAR2(40);
BEGIN
  SELECT country_name
    INTO vs_country_name
    FROM countries
   WHERE country_id = p_country_id;
  
  RETURN vs_country_name;
END;

-- SELECTG������ ����
SELECT fn_get_country_name(52776) FROM dual;
-- �͸����ν������� ����
DECLARE
  vn_country_id countries.country_id%TYPE;
BEGIN
  vn_country_id := 52778;
  
  DBMS_OUTPUT.PUT_line(vn_country_id || ' : ' || fn_get_country_name(vn_country_id));
END;

-- fn_get_country_name() �Լ� ����
-- �����ڵ尡 ���� ��� '�ش� ���� ����'���� ǥ��
CREATE OR REPLACE FUNCTION fn_get_country_name(p_country_id NUMBER)
  RETURN VARCHAR2
IS
  vs_country_name VARCHAR2(40);
  vn_count NUMBER;
BEGIN
  SELECT COUNT(*) -- �����ڵ� ���翩�� Ȯ��
    INTO vn_count
    FROM countries
   WHERE country_id = p_country_id;

  IF vn_count = 0 THEN
     vs_country_name := '�ش� ���� ����';
  ELSE
    SELECT country_name
      INTO vs_country_name
      FROM countries
     WHERE country_id = p_country_id;
  END IF;
   
  RETURN vs_country_name;
END;

-- (3) ����� ���� �Լ� ��������
-- �Լ���: fn_get_max_sales(p_country_id NUMBER)
-- ����id�� �Է� �޾� �� ������ ���� ���� �ִ� �Ǹž��� ���ϴ� �Լ� �ۼ�
-- �Ű������� ����id�� ������ �ִ� �Ǹž��� 0�� ��ȯ
-- ���� ���̺�: CUSTOMERS, SALES
CREATE OR REPLACE FUNCTION fn_get_max_sales(p_country_id NUMBER)
RETURN NUMBER
IS
    vn_count     NUMBER;
    vn_max_sales NUMBER;
BEGIN
    -- �����ڵ� ���翩�� Ȯ��
    SELECT COUNT(*)
        INTO  vn_count
       FROM countries
     WHERE country_id = p_country_id;
     
    IF vn_count=0 THEN
        vn_max_sales := 0;
    ELSE
        SELECT MAX(AMOUNT_SOLD)
            INTO  vn_max_sales
           FROM customers c, sales s
         WHERE c.cust_id=s.cust_id
              AND c.country_id = p_country_id;
    END IF;
    
    return vn_max_sales;
END;

-- fn_get_max_sales() �׽�Ʈ
SELECT fn_get_max_sales(10000) FROM dual;


-- 2.���ν���
-- (1) jobs���̺� �ű� ��å�� insert�ϴ� ���ν���
CREATE OR REPLACE PROCEDURE my_new_job_proc
  (p_job_id IN jobs.job_id%TYPE,
   p_job_title IN jobs.job_title%TYPE,
   p_min_salary IN jobs.min_salary%TYPE,
   p_max_salary IN jobs.max_salary%TYPE)
IS
BEGIN
  INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
  VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
  commit;
END;
-- ���ν��� ����
EXEC my_new_job_proc('SM_JOB1', 'SAMPLE JOB1', 1000, 5000);

-- (2) my_new_job_proc()�� ������ job_id�� �����Ͱ� ������ update ������ insert�ϵ��� ����
CREATE OR REPLACE PROCEDURE my_new_job_proc
  (p_job_id IN jobs.job_id%TYPE,
   p_job_title IN jobs.job_title%TYPE,
   p_min_salary IN jobs.min_salary%TYPE,
   p_max_salary IN jobs.max_salary%TYPE)
IS
  vn_cnt NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO vn_cnt
    FROM jobs
   WHERE job_id = p_job_id;
   
  IF vn_cnt = 0 THEN
    INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
    VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
  ELSE
    UPDATE jobs
       SET job_title = p_job_title, min_salary = p_min_salary,
           max_salary = p_max_salary, update_date = sysdate
     WHERE job_id = p_job_id;
  END IF;
  
  commit;
END;  
-- ���ν��� ����
EXEC my_new_job_proc('SM_JOB1', 'SAMPLE ��å', 2000, 4000);
EXEC my_new_job_proc('SM_JOB2', '��å2', 3000, 5000);
-- ���ν��� ������ 2 - =>���
EXEC my_new_job_proc(p_job_id => 'SM_JOB3', p_job_title => 'SAMPLE ��å3', p_min_salary => 5000, p_max_salary => 8000);

-- 2-1. ���ν��� �Ű������� �⺻�� ����
CREATE OR REPLACE PROCEDURE my_new_job_proc
  (p_job_id IN jobs.job_id%TYPE,
   p_job_title IN jobs.job_title%TYPE,
   p_min_salary IN jobs.min_salary%TYPE := 1000,
   p_max_salary IN jobs.max_salary%TYPE := 5000)
IS
BEGIN
  INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
  VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
  commit;
END;
-- ���ν��� Ȯ��
EXEC my_new_job_proc('SM_JOB4', '��å4');

-- 2-2. OUT�Ű�����
CREATE OR REPLACE PROCEDURE my_new_job_proc
  (p_job_id IN jobs.job_id%TYPE,
   p_job_title IN jobs.job_title%TYPE,
   p_min_salary IN jobs.min_salary%TYPE := 1000,
   p_max_salary IN jobs.max_salary%TYPE := 5000,
   p_upd_date OUT jobs.update_date%TYPE)
IS
  vn_cnt NUMBER := 0;
  vd_cur_date jobs.update_date%TYPE := sysdate;
BEGIN
  SELECT COUNT(*) INTO vn_cnt
    FROM jobs
   WHERE job_id = p_job_id;
   
  IF vn_cnt = 0 THEN
    INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
    VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
  ELSE
    UPDATE jobs
       SET job_title = p_job_title, min_salary = p_min_salary,
           max_salary = p_max_salary, update_date = vd_cur_date
     WHERE job_id = p_job_id;
  END IF;
  
  p_upd_date := vd_cur_date; -- ������Ʈ�� ����� ���� out�Ű������� ����
  commit;
END;
-- OUT�Ű����� �׽�Ʈ
DECLARE
  vd_upd_date jobs.update_date%TYPE;
BEGIN
  my_new_job_proc('TEST JOB6', '��å 7', 3000, 7000, vd_upd_date);
  
  DBMS_OUTPUT.PUT_LINE('������Ʈ ���� : ' || vd_upd_date);
END;

-- 2-3. IN, OUT, IN OUT�Ű����� ���
CREATE OR REPLACE PROCEDURE my_param_test_proc(
  p_var1 VARCHAR2, -- IN�Ű�����
  p_var2 OUT VARCHAR2, -- OUT�Ű����� (���� �־����� ����)
  p_var3 IN OUT VARCHAR2) -- IN OUT�Ű�����
IS

BEGIN
  -- �Է� �Ű������� ���
  DBMS_OUTPUT.PUT_LINE('p_var1 = ' || p_var1);
  DBMS_OUTPUT.PUT_LINE('p_var2 = ' || p_var2);
  DBMS_OUTPUT.PUT_LINE('p_var3 = ' || p_var3);
  
  -- ��� �Ű������� ���� ����
  p_var2 := 'B2';
  p_var3 := 'C2';
END;
-- my_param_test_proc() �׽�Ʈ
DECLARE
  v_var1 VARCHAR2(10) := 'A';
  v_var2 VARCHAR2(10) := 'B';
  v_var3 VARCHAR2(10) := 'C';
BEGIN
  my_param_test_proc(v_var1, v_var2, v_var3);
  
  DBMS_OUTPUT.PUT_LINE('v_var1 = ' || v_var1);
  DBMS_OUTPUT.PUT_LINE('v_var2 = ' || v_var2);
  DBMS_OUTPUT.PUT_LINE('v_var3 = ' || v_var3);
END;

-- (1) ���������̺� dept_temp ����
--     departments���̺��� �μ���ȣ, �μ���, parent_id�÷��� �����ؼ� ����
CREATE TABLE dept_temp AS
SELECT department_id, department_name, parent_id
  FROM departments;
  
-- ���� ���̺�� ���ν��� �ۼ� : my_dept_manager_proc()
-- �Ű����� : p_dept_id, p_dept_name, p_parent_id, p_flag
-- p_flag : ���� 'upsert'�̸� ���̺� ������ update�ϰų� insert ����
--          ���� 'delete'�̸� �ش� �μ��� ���� -> �μ��� ������ '�μ��� �����ϴ�.' ���
--          update�� ��� ������Ʈ�� ������ �����ϴ��� Ȯ��
CREATE OR REPLACE PROCEDURE my_dept_manager_proc
  (p_dept_id IN dept_temp.department_id%TYPE,
   p_dept_name IN dept_temp.department_name%TYPE,
   p_parent_id IN dept_temp.parent_id%TYPE,
   p_flag IN VARCHAR2)
IS
   vn_count NUMBER := 0;
BEGIN
  SELECT COUNT(*)
    INTO vn_count
    FROM dept_temp
   WHERE department_id = p_dept_id;
  IF p_flag = 'upsert' THEN -- update Ȥ�� insert
    IF vn_count = 0 THEN
      INSERT INTO dept_temp VALUES(p_dept_id, p_dept_name, p_parent_id);
    ELSE 
      UPDATE dept_temp
         SET department_name = p_dept_name, parent_id = p_parent_id
       WHERE department_id = p_dept_id;
    END IF;
  ELSIF p_flag = 'delete' THEN -- �μ� ���� ����
    IF vn_count = 0 THEN
         DBMS_OUTPUT.PUT_LINE('������ �μ��� �������� �ʽ��ϴ�.');
    ELSE
      DELETE dept_temp
       WHERE department_id = p_dept_id;
    END IF;
  END IF;

commit;
END;

-- my_dept_managet_proc �׽�Ʈ
EXEC my_dept_manager_proc(300, '�׽�Ʈ�μ�77', 100, 'upsert');
EXEC my_dept_manager_proc(270, '�׽�Ʈ�μ�2', 110, 'update');