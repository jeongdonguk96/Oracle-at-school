-- 테이블 스페이스 생성
CREATE TABLESPACE myts DATAFILE 'd:\OracleDB\myts.dbf'
    SIZE 100M AUTOEXTEND on NEXT 5M;

-- 사용자 생성
-- XE버전에서는 사용자명 앞에 c##이 붙은 사용자만 생성 가능하지만
-- 아래의 스크립트를 이용하면 일반 사용자를 생성할 수 있음
ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- CREATE USER : 사용자(ID) 생성, IDENTIFIED BY : 비밀번호 생성
CREATE USER test_user IDENTIFIED BY ora123
    DEFAULT TABLESPACE myts;

-- 일반적으로 사용자에게 dba권한을 주지 않음(연습을 위해 부여)
GRANT dba TO test_user; -- 권한을 주는 명령문
GRANT select ON syn_channel TO test_user; -- syn_channel에 대한 select기능을 test_user에게 주는 명령문
REVOKE dba FROM test_user; -- 권한을 뺏는 명령문
