-- ����ó��
-- ���ν��� ȣ���� 2���� ���

-- 1. ����ó���� ���� �͸���
DECLARE
  vn_num NUMBER := 0;
BEGIN
  vn_num := vn_num / 0; -- ���� �߻�����
  DBMS_OUTPUT.PUT_LINE('DONE');
END;

-- 1-2. ���� ����ó���� �͸���
DECLARE
  vn_num NUMBER := 0;
BEGIN
  vn_num := vn_num / 0; -- ���� �߻�����
  DBMS_OUTPUT.PUT_LINE('DONE');
  
  EXCEPTION WHEN others THEN
  DBMS_OUTPUT.PUT_LINE('���ܰ� �߻��߽��ϴ�.');
END;
-----------------------------------------------------------------------------------------
-- 2. ����ó���� ���� ���ν���
CREATE OR REPLACE PROCEDURE no_exception_proc
IS
  vn_num NUMBER := 0;
BEGIN
  vn_num := vn_num / 0; -- ���� �߻�����
  DBMS_OUTPUT.PUT_LINE('DONE');
END;

-- ����ó���� ���� ���ν��� ȣ��
DECLARE

BEGIN
  no_exception_proc();
  DBMS_OUTPUT.PUT_LINE('DONE');
END;

-- 2-2. ���� ����ó���� ���ν���
CREATE OR REPLACE PROCEDURE exception_proc
IS
  vn_num NUMBER := 0;
BEGIN
  vn_num := vn_num / 0; -- ���� �߻�����
  DBMS_OUTPUT.PUT_LINE('DONE');
  
  EXCEPTION WHEN others THEN
  -- DBMS_OUTPUT.PUT_LINE('���ܰ� �߻��߽��ϴ�.');
  DBMS_OUTPUT.PUT_LINE('������ ���� �ڵ� = ' || SQLCODE ); -- SQLCODE : �����ڵ�
  DBMS_OUTPUT.PUT_LINE('������ ���� �޼��� = ' || SQLERRM ); -- SQLEERM : ���� ����
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- ���� �߻����� ǥ��
END;

-- ����ó���� ���ν��� ȣ��
DECLARE

BEGIN
  exception_proc();
  DBMS_OUTPUT.PUT_LINE('DONE');
END;
-----------------------------------------------------------------------------------------
-- ����ó�� �������� 1
-- �����ȣ�� ��å��ȣ�� �Ķ���ͷ� �޾� �ش� ����� ��å��ȣ�� �����ϴ� ���ν����� �ۼ�
-- �Է¹��� �����ȣ�� ���� �����ȣ��� ����ó���� �̿�
CREATE OR REPLACE PROCEDURE p_upd_jobid(vn_employee_id employees.employee_id%TYPE,
                                        vs_job_id jobs.job_id%TYPE)
IS
  v_job_id jobs.job_id%TYPE;
BEGIN
  SELECT job_id
    INTO v_job_id
    FROM jobs
   WHERE job_id = vs_job_id;
 
  UPDATE employees
     SET job_id = vs_job_id
   WHERE employee_id = vn_employee_id;
  commit;
  
  EXCEPTION
    WHEN no_data_found THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(vs_job_id || '�� �ش��ϴ� job_id�� �����ϴ�.');
    WHEN others THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- ����ó���� ���ν��� ȣ��
EXEC p_upd_jobid(207, 'ST_EMP');
-----------------------------------------------------------------------------------------
-- 3. ����� ���� ����
-- �Ű������� �μ���ȣ�� �߸� ������ ��� ���� ó��
-- �����, �μ���ȣ�� �Է¹޾� ������̺� insert, �μ���ȣ�� Ʋ���� ����ó��
CREATE OR REPLACE PROCEDURE ch07_ins_emp_proc (p_emp_name employees.emp_name%TYPE,
                                               p_department_id departments.department_id%TYPE )
IS
  vn_employee_id employees.employee_id%TYPE;
  vd_curr_date DATE := SYSDATE;
  vn_cnt NUMBER := 0;
  ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
BEGIN
  SELECT COUNT(*) -- �μ� ���̺��� �ش� �μ���ȣ �������� üũ
    INTO vn_cnt FROM departments
   WHERE department_id = p_department_id;
  
  IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid;
  END IF;

  SELECT MAX(employee_id) + 1 -- employee_id�� max���� +1
    INTO vn_employee_id
    FROM employees;
    
-- ����� ����ó�� �����̹Ƿ� �ּ����� �����͸� �Է�
  INSERT INTO employees (employee_id, emp_name, hire_date, department_id)
         VALUES (vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
  COMMIT;
  
  EXCEPTION
    WHEN ex_invalid_depid THEN
    DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
-- ����ó���� ���ν��� ȣ��
EXEC ch07_ins_emp_proc('ȫ�浿', 999);
-----------------------------------------------------------------------------------------
-- ����� ���� ����ó�� �������� 1
-- ���ν����� : grade_output_procp(p_grade char)
-- CASE���ǹ��� �̿��� ������ ���� A:�ſ� ���, B:���, C:����, D:����, F:������ ����ϴ� ���ν��� �ۼ�
-- ������ ���� �� ����� ���� ���ܸ� �߻���Ų�� - ���ܸ� : ex_grade_not_found
-- ��� �� : ����� ������ OO�Դϴ�. or �������� �ʴ� ����Դϴ�.
CREATE OR REPLACE PROCEDURE grade_output_proc(p_grade CHAR)

IS
  vs_grade VARCHAR2(20);
  ex_invalid_grade EXCEPTION;
BEGIN

  CASE
    WHEN p_grade = 'A' THEN
      vs_grade := '�ſ� ���';
    WHEN p_grade = 'B' THEN
      vs_grade := '���';
    WHEN p_grade = 'C' THEN
      vs_grade := '�߰�';
    WHEN p_grade = 'D' THEN
      vs_grade := '����';
    WHEN p_grade = 'F' THEN
      vs_grade := '����';
    ELSE
    RAISE ex_invalid_grade;
  END CASE;
  
  DBMS_OUTPUT.PUT_LINE('����� ������ ' || vs_grade || '�Դϴ�.');
  
  EXCEPTION
  WHEN ex_invalid_grade THEN
  DBMS_OUTPUT.PUT_LINE('�������� �ʴ� ����Դϴ�.');
  WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE(SQLERRM);
  
END;
-- ����ó���� ���ν��� ȣ��
EXEC grade_output_proc('F');
-----------------------------------------------------------------------------------------
-- 4.����׸� ���� - ����� ���� ���ܸ� ���� ���ܸ�� �����ڵ�� ���
-- ����׸� ���� �������� 1
-- �Ű������� �μ���ȣ�� �߸� ������ ��� ���� ó��
-- �����, �μ���ȣ, �Ի���� �Է¹޾� ������̺� insert
-- �Ի���� Ʋ���ų� �μ���ȣ�� Ʋ���� ����ó��
CREATE OR REPLACE PROCEDURE ch07_ins_emp_proc (p_emp_name employees.emp_name%TYPE,
                                               p_department_id departments.department_id%TYPE,
                                               p_hire_month VARCHAR2)
IS
  vn_employee_id employees.employee_id%TYPE;
  vd_curr_date DATE := SYSDATE;
  vn_cnt NUMBER := 0;
  ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
  ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
  PRAGMA EXCEPTION_INIT(ex_invalid_month, -20001); -- ���ܸ� ������ ����(���ܸ�� �����ڵ� ����)
BEGIN
  SELECT COUNT(*) -- �μ� ���̺��� �ش� �μ���ȣ �������� üũ
    INTO vn_cnt FROM departments
   WHERE department_id = p_department_id;
  
  IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid;
  END IF;
  
  IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month;
  END IF;
    
  SELECT MAX(employee_id) + 1 -- employee_id�� max���� +1
    INTO vn_employee_id
    FROM employees;
    
-- ����� ����ó�� �����̹Ƿ� �ּ����� �����͸� �Է�
  INSERT INTO employees (employee_id, emp_name, hire_date, department_id)
         VALUES (vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
  COMMIT;
  
  EXCEPTION
    WHEN ex_invalid_depid THEN
      DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�.');
    WHEN ex_invalid_month THEN
      DBMS_OUTPUT.PUT_LINE(SQLCODE);
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE('���� ������ �ƴմϴ�.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
    
END;
-- ����ó���� ���ν��� ȣ��
EXEC ch07_ins_emp_proc('ȫ�浿', 110, '202214');
-----------------------------------------------------------------------------------------
-- 5. RAISE APPLICATION ERROR - ����� ���� ���ܸ� ���ܹ߻� ������ ���� �Ű������� �ۼ�
-- RAISE APPLICATION ERROR �������� 1
-- �Ű������� ����� �Է¹޾� ó���ϴ� ���ν���
CREATE OR REPLACE PROCEDURE ch07_raise_test_proc(p_num NUMBER)
IS
BEGIN
  IF p_num < 0 THEN
    RAISE_APPLICATION_ERROR (-20000, '����� �Է¹��� �� �ֽ��ϴ�!'); -- ���ܹ߻� �� �����ڵ�, �޼��� ���
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(p_num);

  EXCEPTION
  WHEN INVALID_NUMBER THEN
    DBMS_OUTPUT.PUT_LINE('����� �Է� �����մϴ�!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLCODE);
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

EXEC ch07_raise_test_proc(-1);
-----------------------------------------------------------------------------------------
-- 6. ȿ������ ���� ó��
-- ���� �α� ���̺� ���� - ����ó�� ���� ���̺�
CREATE TABLE error_log (
error_seq NUMBER, -- ���� ������
prog_name VARCHAR2(80), -- ���α׷���
error_code NUMBER, -- ���� �ڵ�
error_message VARCHAR2(300), -- ���� �޽���
error_line VARCHAR2(100), -- ���� ����
error_date DATE DEFAULT SYSDATE -- ���� �߻� ����
);

-- ���� �α� ���ν���
CREATE OR REPLACE PROCEDURE error_log_proc ( p_prog_name error_log.prog_name%TYPE,
                                             p_error_code error_log.error_code%TYPE,
                                             p_error_message error_log.error_message%TYPE,
                                             p_error_line error_log.error_line%TYPE )
IS
BEGIN
  INSERT INTO error_log (error_seq, prog_name, error_code, error_message, error_line)
  VALUES (error_seq.NEXTVAL, p_prog_name, p_error_code, p_error_message, p_error_line);

  COMMIT;
END;

-- (1) �������̺� �������� 1
CREATE OR REPLACE PROCEDURE ch07_ins_emp_proc (p_emp_name employees.emp_name%TYPE,
                                               p_department_id departments.department_id%TYPE,
                                               p_hire_month VARCHAR2)
IS
  vs_proc_name VARCHAR2(100) := 'ch07_ins_emp_proc';
  vn_employee_id employees.employee_id%TYPE;
  vd_curr_date DATE := SYSDATE;
  vn_cnt NUMBER := 0;
  ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
  PRAGMA EXCEPTION_INIT(ex_invalid_depid, -20000);
  ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
  PRAGMA EXCEPTION_INIT(ex_invalid_month, -20001);
  v_error_code error_log.error_code%TYPE; -- ���ܰ������̺��� ������ ���� ����
  v_error_message error_log.error_message%TYPE; -- ���ܰ������̺��� ������ ���� ����
  v_error_line error_log.error_line%TYPE; -- ���ܰ������̺��� ������ ���� ����
BEGIN
  SELECT COUNT(*) -- �μ� ���̺��� �ش� �μ���ȣ �������� üũ
    INTO vn_cnt FROM departments
   WHERE department_id = p_department_id;
  
  IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid;
  END IF;
  
  IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month;
  END IF;
    
  SELECT MAX(employee_id) + 1 -- employee_id�� max���� +1
    INTO vn_employee_id
    FROM employees;
    
    INSERT INTO employees (employee_id, emp_name, hire_date, department_id)
         VALUES (vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
  COMMIT;
  
  EXCEPTION
    WHEN ex_invalid_depid THEN
      v_error_code := SQLCODE;
      v_error_message := '�ش� �μ���ȣ�� �����ϴ�.';
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    WHEN ex_invalid_month THEN
      v_error_code := SQLCODE;
      v_error_message := SQLERRM;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    WHEN OTHERS THEN
      v_error_code := SQLCODE;
      v_error_message := SQLERRM;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    
END;
-- ch07_ins_emp_proc() ����
EXEC ch07_ins_emp_proc('ȫ�浿', 350, '202210'); -- �μ���ȣ�� Ʋ�� ����
EXEC ch07_ins_emp_proc('ȫ�浿', 110, '202215'); -- �Ի���� Ʋ�� ����

-- ����� ���� ���� ���̺� ����
CREATE TABLE app_user_define_error (
  error_code NUMBER, -- ���� �ڵ�
  error_message VARCHAR2(300), -- ���� �޽���
  create_date DATE DEFAULT SYSDATE, -- ���� �߻� ����
  PRIMARY KEY (error_code)
);

INSERT INTO app_user_define_error (error_code, error_message)
VALUES (-20001, '������ ���� �������մϴ�.');
INSERT INTO app_user_define_error (error_code, error_message)
VALUES (-20000, '�ش� �μ��� �����ϴ�.');

COMMIT;

-- APP_USER_DEFINE_ERROR(����� ���� ����)���̺��� �̿��� ����ó�� ����
CREATE OR REPLACE PROCEDURE error_log_proc ( p_prog_name error_log.prog_name%TYPE,
                                             p_error_code error_log.error_code%TYPE,
                                             p_error_message error_log.error_message%TYPE,
                                             p_error_line error_log.error_line%TYPE )
IS
  vs_error_message error_log.error_message%TYPE;
BEGIN
  
  BEGIN
    -- �����ڵ带 �������� app_user_define_error���̺� ��ȸ
    SELECT error_message
      INTO vs_error_message
      FROM app_user_define_error
     WHERE error_code = p_error_code;
  
    -- �����ڵ尡 �������� ������ ���� ó��
    EXCEPTION
      WHEN no_data_found THEN
        vs_error_message := p_error_message;
  END;
  
  INSERT INTO error_log (error_seq, prog_name, error_code, error_message, error_line)
       VALUES (error_seq.NEXTVAL, p_prog_name, p_error_code, vs_error_message, p_error_line);

  COMMIT;
END;

-- APP_USER_DEFINE_ERROR���̺��� ����� ���� �Է�ó�� �������� 1
CREATE OR REPLACE PROCEDURE ch07_ins_emp_proc (p_emp_name employees.emp_name%TYPE,
                                               p_department_id departments.department_id%TYPE,
                                               p_hire_month VARCHAR2)
IS
  vs_proc_name VARCHAR2(100) := 'ch07_ins_emp_proc';
  vn_employee_id employees.employee_id%TYPE;
  vd_curr_date DATE := SYSDATE;
  vn_cnt NUMBER := 0;
  ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
  PRAGMA EXCEPTION_INIT(ex_invalid_depid, -20000);
  ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
  PRAGMA EXCEPTION_INIT(ex_invalid_month, -20001);
  v_error_code error_log.error_code%TYPE; -- ���ܰ������̺��� ������ ���� ����
  v_error_message error_log.error_message%TYPE; -- ���ܰ������̺��� ������ ���� ����
  v_error_line error_log.error_line%TYPE; -- ���ܰ������̺��� ������ ���� ����
BEGIN
  SELECT COUNT(*) -- �μ� ���̺��� �ش� �μ���ȣ �������� üũ
    INTO vn_cnt FROM departments
   WHERE department_id = p_department_id;
  
  IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid;
  END IF;
  
  IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month;
  END IF;
    
  SELECT MAX(employee_id) + 1 -- employee_id�� max���� +1
    INTO vn_employee_id
    FROM employees;
    
    INSERT INTO employees (employee_id, emp_name, hire_date, department_id)
         VALUES (vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
  COMMIT;
  
  EXCEPTION
    WHEN ex_invalid_depid THEN
      v_error_code := SQLCODE;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    WHEN ex_invalid_month THEN
      v_error_code := SQLCODE;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    WHEN OTHERS THEN
      v_error_code := SQLCODE;
      v_error_message := SQLERRM;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    
END;
delete ERROR_LOG;
COMMIT;

-- ch07_ins_emp_proc() ����
EXEC ch07_ins_emp_proc('ȫ�浿', 400, '202210'); -- �μ���ȣ�� Ʋ�� ����
EXEC ch07_ins_emp_proc('ȫ�浿', 110, '202215'); -- �Ի���� Ʋ�� ����
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------