/* sql 기본문법 
	1. 명령(identifier, 키워드)들은 대소문자를 구분하지 않는다.
	2. 문자열은 반드시 작은 따옴표만 가능, 큰 따옴표는 테이블명, 열명등을 정의할 때 사용
	3. 문자열(값)은 대소문자를 구분한다.
*/

-- 1. oracle 사용자 조회
-- show user : SQL*Plus명령으로 오라클에서만 사용가능한 명령
-- 1) dba유저만 조회
select * from dba_users;
select username, user_id, lock_date from dba_users;

-- 2) 전체사용자 조회
select * from all_users;
select username, user_id, created from all_users;

-- 2. 사용자 role조회
-- 1) 전체조회
select * from dba_role_privs;
-- 2) 특정 사용자만 조회 - where 조건절
-- where 컬럼명 = 값
select * from dba_role_privs where grantee = 'SYS';
select * from dba_role_privs where grantee = 'HR';

-- 3. 사용자 권한조회
select * from dba_sys_privs;
-- 실습. SYS, DBA, HR, SCOTT을 권한조회
select * from dba_sys_privs where grantee = 'SYS';
select * from dba_sys_privs where grantee = 'DBA';
select * from dba_sys_privs where grantee = 'HR';
select * from dba_sys_privs where grantee = 'SCOTT';
-- select * from dba_sys_privs where grantee = "SCOTT"; 에러
-- select * from dba_sys_privs where "grantee" = 'SCOTT'; 에러
select * from dba_sys_privs where "GRANTEE" = 'HR';
-- select * from "dba_sys_privs" where GRANTEE = 'HR'; identifier에 큰 따옴표 -> 대소문자구분
select * from "DBA_SYS_PRIVS" where GRANTEE = 'HR';

-- 4. 사용자 lock, unlock
select * from dba_users where username = 'HR';
select username, account_status, lock_date from dba_users where username = 'HR';
-- 잠금명령
alter user hr account lock;
-- 해제명령
alter user hr account unlock;

-- 5. 사용자비밀번호 변경하기
-- alter user 사용자 IDENTIFIED by 비밀번호
alter user hr identified by hr;
select * from dba_users where username = 'HR';
select username, account_status, lock_date, password
  from dba_users 
 where username = 'HR';

-- 6. 사용자가 소유한 테이블(table)
select * from tabs;

/* 사용자생성하기 */
select username, account_status, lock_date from dba_users where username = 'SYS';
select username, account_status, lock_date from dba_users where username = 'HR';
select username, account_status, lock_date from dba_users where username = 'SCOTT';

select username, account_status, lock_date 
  from dba_users 
 where username = 'SYS'
    or username = 'HR'
    or username = 'SCOTT';

-- 1. 사용자계정생성하기
create user scott identified by tiger;

-- 실습. hr/scott의 role/권한 확인하기
select * from dba_role_privs 
 where grantee = 'SCOTT' 
   or grantee = 'HR';

select * from dba_sys_privs 
 where grantee = 'HR'
    or grantee = 'SCOTT';
		
-- 2. 권한/role부여하기
-- grant : 권한 or role을 부여하는 명령		
grant connect to scott;

-- 3. 작업장소(tablespace) 부여하기 
alter user scott default tablespace users;
alter user scott temporary tablespace temp;

-- 4. 실습용데이터(table)생성하기
-- a. connect  - db접속권한만
-- b. resource - 테이블등 생성,삭제수정 권한 
grant connect, resource to scott;

CREATE TABLE DEPT
   (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
    DNAME VARCHAR2(14) ,
    LOC VARCHAR2(13) ) ;

CREATE TABLE EMP  
   (EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,  
    ENAME VARCHAR2(10),  
    JOB VARCHAR2(9),  
    MGR NUMBER(4),  
    HIREDATE DATE,  
    SAL NUMBER(7,2),  
    COMM NUMBER(7,2),  
    DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);

INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');   
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO');  
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON');

INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-7-1987','dd-mm-yyyy')-85,3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-7-1987','dd-mm-yyyy')-51,1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);

CREATE TABLE BONUS
    (
    ENAME VARCHAR2(10)  ,
    JOB VARCHAR2(9)  ,
    SAL NUMBER,
    COMM NUMBER
    ) ;
		
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
    LOSAL NUMBER,
    HISAL NUMBER );
	
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);