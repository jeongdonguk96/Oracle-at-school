-- 1. Ŀ�� -- ������ �ٱ���
-- Ŀ����� ������ �ٱ��Ͽ� �������̺� �ִ� ������ ���, �ݺ����� ���� �ٽ� �ϳ��� ������ ������� ���
-- 1-1. �Ͻ��� Ŀ��(implicit)
-- (1) 80�� �μ��� ����̸��� �ڽ��� �̸����� ����
DECLARE
  vn_department_id employees.employee_id%TYPE := 80;
BEGIN
  
  UPDATE employees
     SET emp_name = emp_name
   WHERE department_id = vn_department_id;
   
   -- �� ���� �����Ͱ� �����Ǿ����� Ȯ��
   DBMS_OUTPUT.PUT_LINE('������Ʈ�� ���� �� : ' || SQL%ROWCOUNT);
   
   commit;   
END;

-- (2) �ӽ����̺� emp_temp ����
-- employees���̺��� employee_id, emp_name, email�� ��ȸ�Ͽ� ����
CREATE TABLE emp_temp AS
SELECT employee_id, emp_name, email
  FROM employees;

-- (2-1) �͸��� �ۼ�
-- ������� 'B'�� �����ϴ� ����� ������ '�̸��� ����'���� �����ϰ�
-- ������Ʈ�� ���� ���� ���
DECLARE
BEGIN
  UPDATE emp_temp
     SET email = '�̸��� ����'
   WHERE emp_name LIKE 'B%';
   
   DBMS_OUTPUT.PUT_LINE('������Ʈ�� ���� �� : ' || SQL%ROWCOUNT);
END;

-- 1-2. ����� Ŀ��(explicit)
-- (1) �μ���ȣ�� 90���� �μ��� ���� ����� �̸��� ����ϴ� �͸���
DECLARE
  -- ����� �޾ƿ��� ���� ���� ����
  vs_emp_name employees.emp_name%TYPE;
  -- Ŀ�� ����, �Ű������� �μ���ȣ �ޱ�
  CURSOR cur_emp_dep(cp_department_id employees.department_id%TYPE)
  IS
  SELECT emp_name
    FROM employees
   WHERE department_id = cp_department_id;
BEGIN
  -- Ŀ�� ����(�Ű������� 90�� �μ��� ����)
  OPEN cur_emp_dep(90);
  
  LOOP
    FETCH cur_emp_dep -- Ŀ�� ����� ���� ���� ��ġ��(����� ������ �Ҵ�)
     INTO vs_emp_name; -- ��ġ�� �������� ������ LOOP Ż��
EXIT WHEN cur_emp_dep%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
  
  CLOSE cur_emp_dep;
END;

-- (2) cd_parent_id�� �Է¹޾� ���� �μ��� ���ϴ� ������ �μ��� ����ϴ� �͸��� �ۼ�
-- parent_id�� �ش��ϴ� �����Ͱ� ���� ��� '~�μ��� ���ϴ� ����� �����ϴ�.' ��� (SQL%ROWCOUNT�̿�)
-- ��� �� - ȫ�浿 : �����
DECLARE
    CURSOR cur_emp_dep_name(cp_parent_id  departments.parent_id%TYPE)
    IS
    SELECT e.emp_name, d.department_name
    FROM employees e,  departments d
     WHERE d.parent_id = cp_parent_id
          AND e.department_id=d.department_id;

    -- ���� ����
    vn_parent_id    departments.parent_id%TYPE;
    vs_emp_name  employees.emp_name%TYPE;
    vs_dept_name  departments.department_name%TYPE;
BEGIN
    vn_parent_id := 200;
    OPEN cur_emp_dep_name(vn_parent_id);
    
    LOOP
        FETCH cur_emp_dep_name INTO vs_emp_name, vs_dept_name;
        EXIT WHEN cur_emp_dep_name%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' : ' || vs_dept_name);
    END LOOP;
    
    IF cur_emp_dep_name%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE(vn_parent_id || '�� �μ��� ���ϴ� ���� �����ϴ�.');
    END IF;
    
    CLOSE cur_emp_dep_name;
END;

-- ���� ������ FOR LOOP�� ����Ͽ� ����
DECLARE
    CURSOR cur_emp_dep_name(cp_parent_id  departments.parent_id%TYPE)
    IS
    SELECT e.emp_name, d.department_name
      FROM employees e, departments d
     WHERE d.parent_id = cp_parent_id
       AND e.department_id = d.department_id;
    -- ���� ����
    vn_parent_id departments.parent_id%TYPE;
BEGIN
    vn_parent_id := 10;
    OPEN cur_emp_dep_name(vn_parent_id);
   -- FOR ���ڵ庯�� IN Ŀ��(�Ķ����) 
    FOR emp_rec IN cur_emp_dep_name(vn_parent_id)
    LOOP

        DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name || ' : ' || emp_rec.department_name);
    END LOOP;    
    -- �ڵ����� Ŀ���� close��
END;

-- 1-3 ���� Ŀ�� Ÿ�� - %ROWTYPE�� �ٿ������ν� �� �÷��� �ƴ� ��� �÷����� ��Ÿ���� Ÿ���� ��
DECLARE
  TYPE test_curtype IS REF CURSOR RETURN departmentsA%ROWTYPE; -- Ŀ�� Ÿ���� ����
  test_curvar test_curtype; -- curtype�̶�� Ÿ���� ���� curvar��� Ŀ������ ����
BEGIN
  OPEN test_curvar FOR SELECT * FROM departments;
  
END;

-- 1-4 ���� Ŀ�� Ÿ�� - Ÿ���� ���� �������� �������ν� ������ ��� ����
-- 90�� �μ��� ���ϴ� ����� ����� ��ȸ
DECLARE
  test_cursor SYS_REFCURSOR;
  vs_emp_name employees.emp_name%TYPE;
BEGIN
  OPEN test_cursor FOR
SELECT emp_name
  FROM employees
 WHERE department_id = 90;
  
  LOOP 
    FETCH test_cursor INTO vs_emp_name;
    EXIT WHEN test_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
END;

-- departments���̺��� �μ���� employees���̺��� �����ڸ��� ����ϴ� �͸� ���ν��� �ۼ�
-- ���� ���̺� : departments, employees / ���� Ŀ��Ÿ�� ���
-- ��¿� : �μ��� - �����ڸ�
DECLARE
  dep_mng_cur sys_refcursor; -- Ŀ������ ����
  vs_dept_name departments.department_name%TYPE; -- �μ����� ���� ���� ����
  vs_mng_name employees.emp_name%TYPE; -- �����ڸ��� ���� ���� ����
BEGIN
  OPEN dep_mng_cur FOR -- Ŀ������ ����, FOR�� ������ ���� ������ Ŀ���� ��´ٴ� �ǹ�
    SELECT d.department_name, e.emp_name  -- SELECT ������ ������ Ŀ���� ����
      FROM departments d, employees e 
     WHERE d.manager_id = e.employee_id;
  
  LOOP -- Ŀ���� ������ ���� �ٱ��϶� �ݺ��� ���� �ϳ��� �������� ������� ����ؾ� ��
    FETCH dep_mng_cur INTO vs_dept_name, vs_mng_name; -- Ŀ���� �����鿡 �ݺ��� ���� ����
    EXIT WHEN dep_mng_cur%NOTFOUND; -- Ŀ���� �ƹ��� ������ ���� ���� �� �ݺ��� ����
    
    DBMS_OUTPUT.PUT_LINE(vs_dept_name || ' - ' || vs_mng_name);
  END LOOP;
END;

-- 1-5. Ŀ�������� �Ű����� ����
-- 90�� �μ��� ���� ������� ���
DECLARE
  emp_dept_curvar sys_refcursor; -- emp_dept_curvar��� Ŀ�� ����
  vs_emp_name employees.emp_name%TYPE; -- vs_emp_name��� ���� ����
  -- ���⼭����
  PROCEDURE test_cursor_argument(p_curvar IN OUT sys_refcursor) -- 90�� �μ��� ����� ��ȸ
  IS
    c_temp_curvar sys_refcursor;
  BEGIN
    OPEN c_temp_curvar FOR -- c_temp_curvar��� Ŀ���� 90�� �μ��� ������� ����
      SELECT emp_name FROM employees WHERE department_id = 90;
      
    p_curvar := c_temp_curvar;
  END;
  -- ��������� �ϳ��� ���ν���
BEGIN
  test_cursor_argument(emp_dept_curvar); -- ���ν������� ��ȸ�� ����� emp_dept_curvar�� ���
  
  LOOP
    FETCH emp_dept_curvar INTO vs_emp_name;
    EXIT WHEN emp_dept_curvar%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
END;

-- �͸��� ��Ͽ� ���ν��� �ۼ�
-- ���ν����� ���޿����� �Ű������� �����ϰ� �� �ݾ׺��� ���� �޴� ����� �̸��� �޿��� ���
-- ���ν��� : cur_sal_proc(p_salary, p_curvar)
DECLARE
  emp_sal_curvar SYS_REFCURSOR;
  vs_empname employees.emp_name%TYPE;
  vn_salary employees.salary%TYPE;
  -- ���ν���(����, Ŀ��)�� ���·� ����p_salary�� �Է¹ް� p_curvar�� ���� �����ϰ� var�� ���ÿ� ���
  PROCEDURE cur_sal_proc(p_salary employees.salary%TYPE, p_curvar IN OUT sys_refcursor)
  IS
    c_temp_curvar SYS_REFCURSOR;
  BEGIN
    OPEN c_temp_curvar FOR
      SELECT emp_name, salary
        FROM employees
       WHERE salary < p_salary;
    
    p_curvar := c_temp_curvar;
  END;

BEGIN
  cur_sal_proc(5000, emp_sal_curvar);
  LOOP
    FETCH emp_sal_curvar INTO vs_empname, vn_salary;
    EXIT WHEN emp_sal_curvar%NOTFOUND;
  
    DBMS_OUTPUT.PUT_LINE(vs_empname || ' : ' || vn_salary);  
  END LOOP;
END;
------------------------------------------------------------------------------------------
-- �� Ǯ��
DECLARE
  whatcur SYS_REFCURSOR;
  thiscur SYS_REFCURSOR;
  vs_emp_name employees.employee_name%TYPE;
  vn_salary employees.salary%TYPE;
  
  PROCEDURE cur_sal_proc(p_salary IN OUT sys_refcursor, p_curvar IN OUT sys_refcursor)
  IS
    somecur SYS_REFCURSOR;
    othercur SYS_REFCURSOR;
  BEGIN
    OPEN somecur FOR
      SELECT salary FROM employees;
    OPEN othercur FOR 
      SELECT emp_name, salary FROM employees;
    p_salary := somecur;      
    p_curvar := othercur;
  END;

BEGIN
  cur_sal_proc(whatcur, thiscur);
  LOOP
    FETCH whatcur INTO vn_salary;
    EXIT WHEN whatcur%NOTFOUND;
    
    FETCH thiscur INTO vs_emp_name;
    EXIT WHEN thiscur%NOTFOUND;
     
    DBMS.OUTPUT.PUT_LINE(vs_emp_name || ' : ' || vn_salary);
  END LOOP;
  
END;
------------------------------------------------------------------------------------------
-- 1-6. Ŀ�� ǥ����
-- 90�� �μ��� ���� ������� �μ���� ����� ��ȸ
-- (1) ������̺��� �������� ��ȸ��
SELECT ( SELECT d.department_name
           FROM departments d
          WHERE d.department_id = e.department_id) department_name, emp_name
  FROM employees e
 WHERE e.department_id = 90;
-- (2) �μ����̺��� �������� ��ȸ��
SELECT department_name, ( SELECT emp_name
                            FROM employees e
                           WHERE e.department_id = d.department_id ) emp_name
  FROM departments d
 WHERE d.department_id = 90;
-- (2)�� ��쿡�� �μ����� 1���ε� 3���� ������� 3������ ��ȸ�Ϸ��� ������ ��
-- (3) Ŀ�� ǥ������ ����� (2) ��ȸ
SELECT department_name,
       CURSOR( SELECT emp_name
                 FROM employees e
                WHERE e.department_id = d.department_id ) emp_name
  FROM departments d
 WHERE d.department_id = 90;
-- (4) Ŀ�� ǥ����(3)�� ����� FETCH
DECLARE
  CURSOR my_cursor -- (3)�� ������ my_cursor��� Ŀ���� ����
  IS
  SELECT department_name,
         CURSOR( SELECT emp_name
                   FROM employees e
                  WHERE e.department_id = d.department_id ) emp_name
    FROM departments d
   WHERE d.department_id = 90;
   
   vs_dept_name departments.department_name%TYPE; -- �μ����� ���� ����
   cur_emp_name SYS_REFCURSOR; -- Ŀ�� ǥ������ ���� Ŀ������ (�����Ÿ���� ���� �� �¾� ��������
                               -- Ŀ�� ǥ������ ���� ������ Ŀ��Ÿ������ �����ؾ���)
   vs_emp_name employees.emp_name%TYPE; -- cur_emp_nameĿ������ ���� ����
BEGIN
  OPEN my_cursor;
  LOOP
    FETCH my_cursor INTO vs_dept_name, cur_emp_name;
    EXIT WHEN my_cursor%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE('�μ���' || ' : ' || vs_dept_name); -- �μ��� ���
    
    LOOP -- cur_emp_name�� Ŀ��ǥ���� �̱� ������ cur_emp_name�� �ٽ� ��� �ٸ� ���� ���� ��ƾ���
      FETCH cur_emp_name INTO vs_emp_name;
      EXIT WHEN cur_emp_name%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('�����' || ' : ' || vs_emp_name); -- ����� ���
    END LOOP;
    
  END LOOP;
  CLOSE my_cursor;
END;

-- �����ȣ�� 176���� ����� ������ �߷ɳ����� Ŀ�� ǥ������ �̿��ϰ� �͸����� ������
-- emp_name, job_id, start_date, end_date�� ��ȸ
DECLARE
  CURSOR me_cursor -- me_cursor��� Ŀ�� ǥ����
  IS
    SELECT job_id, start_date, end_date,
           CURSOR ( SELECT emp_name
                      FROM employees e
                     WHERE e.employee_id = j.employee_id) emp_name
      FROM job_history j
     WHERE j.employee_id = 176;
  cur_emp_name SYS_REFCURSOR; -- Ŀ��ǥ���� emp_name�� Ŀ�� cur_emp_name�� ����
  vn_job_id job_history.job_id%TYPE; -- job_id�� ���� ����
  vd_start_date job_history.start_date%TYPE; -- start_date�� ���� ����
  vd_end_date job_history.end_date%TYPE; -- end_date�� ���� ����
  vs_emp_name employees.emp_name%TYPE; -- Ŀ��cur_emp_name�� ���� ����

BEGIN
  OPEN me_cursor;
  LOOP
    FETCH me_cursor INTO vn_job_id, vd_start_date, vd_end_date, cur_emp_name;
    EXIT WHEN me_cursor%NOTFOUND;
    
    LOOP -- Ŀ�� ǥ������ cur_emp_name�� ��� ���� vs_emp_name�� ����ֱ� ���� �ݺ���
      FETCH cur_emp_name INTO vs_emp_name;
      EXIT WHEN cur_emp_name%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('����� : ' || vs_emp_name);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('�߷ɳ��� : ' || vn_job_id || ' (' || vd_start_date || 
                          ' ~ ' || vd_end_date || ')');
  END LOOP;
  CLOSE me_cursor;
END;