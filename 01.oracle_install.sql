select * from dba_users;
select * from all_users;

/* 블럭주석 */
-- 한줄주석 

-- HR계정(사용자, DB) unlock & lock
alter user hr account unlock;
alter user hr account lock;

-- HR계정 비밀번호 변경하기
alter user hr identified by hr;

/* Oracle 환경설정 */
-- 1. oracle 환경변수 조회하기
select * from v$nls_parameters;

-- 2. 날짜형식 변경하기
-- alter [session | system] set 시스템변수 = 변경할 값
-- 1) session - db접속동안만 적용
alter session set nls_date_format = 'YYYY.MM.DD'; -- RR/MM/DD를 변경
alter session set NLS_TIMESTAMP_FORMAT = 'YYYY.MM.DD HH:MI:SS'; -- RR/MM/DD HH24:MI:SSXFF

-- 2) system - 영구적으로 적용
-- scope= [both | spfile]
-- a. both   : 바로 적용 or 재시작(에러확율)
-- b. spfile : 재시작 (stop database, start databse)
alter system set nls_date_format = 'YYYY.MM.DD' scope=spfile; -- RR/MM/DD를 변경
alter system set NLS_TIMESTAMP_FORMAT = 'YYYY.MM.DD HH:MI:SS' scope=spfile; -- RR/MM/DD HH24:MI:SSXFF










































