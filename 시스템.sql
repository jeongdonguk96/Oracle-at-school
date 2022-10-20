-- ���̺� �����̽� ����
CREATE TABLESPACE myts DATAFILE 'd:\OracleDB\myts.dbf'
    SIZE 100M AUTOEXTEND on NEXT 5M;

-- ����� ����
-- XE���������� ����ڸ� �տ� c##�� ���� ����ڸ� ���� ����������
-- �Ʒ��� ��ũ��Ʈ�� �̿��ϸ� �Ϲ� ����ڸ� ������ �� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- CREATE USER : �����(ID) ����, IDENTIFIED BY : ��й�ȣ ����
CREATE USER test_user IDENTIFIED BY ora123
    DEFAULT TABLESPACE myts;

-- �Ϲ������� ����ڿ��� dba������ ���� ����(������ ���� �ο�)
GRANT dba TO test_user; -- ������ �ִ� ��ɹ�
GRANT select ON syn_channel TO test_user; -- syn_channel�� ���� select����� test_user���� �ִ� ��ɹ�
REVOKE dba FROM test_user; -- ������ ���� ��ɹ�
