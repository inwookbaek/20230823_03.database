/*
	테이블생성하기
	
	1. 문법
	
	   create 오라클객체 객체명 (
				 col1   데이터타입(크기) default 기본값
			 , coln   데이터타입(크기) default 기본값
		 )
		 ... create명령은 오라클의 객체를 생성하는 명령
		 ... 오라클객체 : table, view, index, sequence ...
		 ... 객체명     : 사용자 정의 객체이름
		 
	2. 데이터타입
	   1) 문자형 
		    a. char(크기)     : 고정길이 / 최대 2KB / 기본 1KB 
				b. varchar2(크기) : 가변길이 / 최대 4KB / 기본 1KB
				c. long           : 가변길이 / 최대 2GB
				
		 2) 숫자형 
		 
			  a. number(p, s) : 가변숫자 / p(1~38, 기본값=38), s(-84~127, 기본=0) / 최대 22byte
				b. float(s)     : number하위타입 / p(1~128, 기본갑=128) / 최대 22byte
		 
		 3) 날짜형
		 
		    a. date      : bc 4712.01.01 ~ 9999.12.31까지 년월시분초까지 표현
				b. timestamp : 년월시분초밀리초까지 표현
		 
		 4) lob타입 - LOB타입이란 Large Object의 약자로 대용량의 데이터를 저장할 수 있는
		              데이터 타입, 일반적으로 그래프, 이미지, 동영상, 음악파일등 비정형
									데이터를 저장할 때 사용하다. 
									문자형 대용량 데이터는 CLOB or NLOB를 사용하고 이미지, 동용상등의
									데이터는 BLOB or BFILE타입을 사용한다.
		 
		    a. clob : 문자형 대용량 객체, 고정기와 가변길 문자형을 지원
				b. blob : 이진형 대용량 객체, 주로 멀티미디어 자료를 저장
				c. bfile: 대용량 이진파일에 대한 파일위치와 이름을 저장
*/

/* A. 테이블 생성하기 */
create table mytable(
		no       number(5,1)  default 0
	, name     varchar2(10) 
	, hiredate date         default sysdate
);

select * from mytable;

create table 마이테이블(
		번호  number(5,1) default 0
	, 이름  varchar2(10)
	, 입사일 date default sysdate
);
select * from 마이테이블;

/* 테이블생성시 주의사항

	1. 테이블이름은 반드시 문자로 시작해야 한다. 중간에 숫자가 포함되는 것은 가능하다.
	2. 특수문자도 가능하지만 단, 테이블생성시 큰 따옴표로 감싸야 한다. 하지만 권장하지는 않는다.
	3. 테이블이름이나 컬럼명은 최대 30바이트까지 가능(즉, 한글은 문자셋에 딸 euc-kr이면 15자
		 utf-8이면 10자리만 가능)
	4. 동일사용자(스키마)안에서는 테이블명을 중복정의할 수 없다.
	5. 테이블명이나 컬럼명은 오라클키워드를 사용하지 않을 것을 권장(하지만 절대로 사용하지 말것)	
*/
select * from mytable;

-- 1. insert : 테이블에 자료를 추가하기
-- a. 문법
--    insert into 테이블명(컬럼1,....컬럼n) values(값1,...값n)
-- b. 제약사항
--    1) 컬럼갯수와 값의 갯수는 동일해야 한다.
--    2) 컬럼의 데이터타입과 값의 데이터타입은 동일해야 한다.
--       단, 형변환(자동형변환)이 가능하다면 사용할 수 있지만 변환이 불가능하다면 에러발생
insert into mytable(name) values('홍길동');
insert into mytable(name) values(1, '홍길순');   --> ORA-00913: too many values
insert into mytable(no, name) values('홍길순');  --> ORA-00947: not enough values
insert into mytable(no, name) values(1, '손흥민');
insert into mytable(no, name) values(2, '이강인');
insert into mytable(no, name) values(3, '김민재');
insert into mytable(no, name) values(4, '황희찬');
insert into mytable(no, name) values(5, '소향');
insert into mytable(no, name) values(1, '손흥민'); -- 중복제약사항 미지정으로 자료추가가 된다.

insert into mytable(no, name, hiredate) values(6, '류현진', sysdate);
insert into mytable(no, name, hiredate) values(7, 1000, sysdate); -- 자동형변환되기 때문에 에러(x)
insert into mytable(no, name, hiredate) values('황의조', 1000, sysdate); -- 자동형변환불가 
insert into mytable(no, name, hiredate) values('1001', '황의조', sysdate); 
insert into mytable(no, name, hiredate) values(1002, '나얼', '20230922');
insert into mytable(no, name, hiredate) values(1003, '박효신', '2023.09.22');
insert into mytable(no, name, hiredate) values(1004, '소향', 10); --> ORA-00932: inconsistent datatypes: expected DATE got NUMBER
insert into mytable(no, name, hiredate) values('2023-09-21', '소향', sysdate);
insert into mytable(no, name, hiredate) values(10000, '소향', sysdate); --> ORA-01438: value larger than specified precision allowed for this column

select * from mytable;

-- 2. 테이블 복사하기
-- emp테이블을 temptable로 복사
-- 1) create table temptable(empno, ename, .....)
-- 2) select 명령으로도 복사할 수 있다.
--    create table 테이블명 as select * from 테이블
select * from emp;

-- 1) 테이블구조와 데이터를 복사할 경우
create table temptable as select * from emp;
select * from temptable;

-- 2) 테이블구조만 복사하기
-- 테이블이 이미 있는 경우 에러 
-- 테이블이 있다면 기존 테이블을 삭제후 생성
-- 오라클에서 객체를 삭제하는 명령
-- drop 객체타입 객체명
create table temptable as select * from emp; --> ORA-00955: name is already used by an existing object

drop table 마이테이블;
drop table temptable;

create table temptable as select * from emp;

create table temptable as select * from emp where 1=2;
select * from temptable;

-- 3) 테이블구조와 특정자료(deptno = 10)만 복사하기
-- 테이블명은 temptable로 생성, 이미 있다면 삭제(drop)후 생성
drop table temptable;
create table temptable as select * from emp where deptno=10;
select * from temptable;

/*
	B. 테이블(컬럼)수정하기 - 컬럼
	   
	오라클객체를 수정하는 명령
	alter 객체유형 객체명 ...
	
	1. 컬럼추가       : alter table 테이블명 add(추가컬럼명  데이터타입)
	2. 컬럼명변경     : alter table 테이블명 rename column 변경전이름 to 변경후이름
	3. 데이터타입변경 : alter table 테이블명 modify(변경힐칼럼 변경할데이터타입)
	4. 컬럼삭제       : alter table 테이블명 drop column 삭제할컬럼명
*/
-- 실습. dept2테이블을 dept6로 복사
create table dept6 as 
select * from dept2;
select * from dept6;

-- 1. dept6에 컬럼(location varchar2 10)추가 
alter table dept6 add(location varchar2(10));
select * from dept6;

-- 2. location을 loc로 컬럼명변경
alter table dept6 rename column location to loc;
select * from dept6;

-- 3. 데이터타입변경 dname -> number, loc -> number타입으로 변경
alter table dept6 modify(dname number); --> must be empty to change datatype
alter table dept6 modify(loc number); --> 값이 하나도 없기 때문에 변경가능
select * from dept6;

-- 4. 오라클객체 정보보기(테이블) 
-- 오라클 딕셔너리 정보 : all_tab_columns, user_tab_columns
select * from all_tab_columns;
select * from user_tab_columns;
select * from user_tab_columns where table_name = 'DEPT';
select * from user_tab_columns where table_name = 'DEPT6';
select * from user_tab_columns where table_name = 'MYEMP';

-- 5. 컬럼추가시에 기본값 설정하기
create table dept7 as select * from dept2;
select * from dept7;

alter table dept7 add(location varchar2(10) default '서울');
alter table dept7 add(xxx number default 0);
alter table dept7 add(crtdate date default sysdate);

select * from user_tab_columns where table_name = 'DEPT7';
select * from dept7;
select * from dept7 where yyy = '몰라'; --> ORA-00904: "YYY": invalid identifier
select * from dept7 where "yyy" = '몰라';

-- 6. 컬럼크기변경하기
-- location 10자리를 1자로 수정하기
alter table dept7 modify(location varchar2(1)); --> ORA-01441: cannot decrease column length because some value is too big
alter table dept7 modify(location varchar2(7));
select * from user_tab_columns where table_name = 'DEPT7';

-- 7. 컬럼삭제하기
-- yyy컬럼삭제하기
alter table dept7 drop column yyy; --> 대소문자문제
alter table dept7 drop column "yyy";
select * from user_tab_columns where table_name = 'DEPT7';
select * from dept7;

/*
	C. 테이블수정하기
	
	1. 테이블이름변경     : alter table 테이블명 rename to 변경할테이블명
	2. 테이블삭제(자료만) : trunctate table 테이블명
	3. 테이블삭제(완전)   : drop 테이블 테이블명
*/

-- 1. 테이블명변경하기
-- dept7 -> dept777
alter table dept7 rename to dept777;
select * from user_tab_columns where table_name = 'DEPT888';
select * from dept888;

-- 2. 테이블삭제하기(자료만)
truncate table dept888;
select * from user_tab_columns where table_name = 'DEPT888';
select * from dept888;

-- 3. 테이블삭제하기(영구적)
drop table dept888;
select * from user_tab_columns where table_name = 'DEPT888';
select * from dept888;

/*
	D. 읽기 전용 테이블생성하기
	alter table 테이블명 read only
*/
create table tbl_read_only(
		no 		number
	, name 	varchar2(10)
);
insert into tbl_read_only(no, name) values(1, '손흥민');
insert into tbl_read_only values(2, '이강인');
select * from tbl_read_only;

-- 읽기전용테이블로 변경하기
alter table tbl_read_only read only; 
insert into tbl_read_only values(3, '김민재');

alter table tbl_read_only read write; 
insert into tbl_read_only values(3, '김민재');
select * from tbl_read_only;

/*
	E. Data Dictionary
	
	오라클은 데이터베이스의 메모리구조와 테이블에 대한 구조 정보를 가지고 있다.
	각 객체(table, view, index...)가 사용하고 있는 공간정보, 제약조건, 사용자정보 및 권한,
	프로파일, Role, 감사(Audit)등의 정보를 제공한다.
	
	1. 데이터딕셔너리
	
	   1) 데이터베이스 자원을 효율적으로 관리하기 위해서 다양한 정보를 저장하고 있는 시스템이다.
		 2) 사용자가 테이블을 생성하거나 변경하는 등의 작업을 할 때 데이터베이스 서버(엔진)에 의해
			  자동을 갱신되는 테이블이다.
		 3) 사용자가 데이터딕셔너리의 내용을 수정하거나 삭제할 수 없다.
		 4) 사용자가 데이터딕셔너리를 조회할 경우에 시스템이 직접관리하는 테이블은 암호화가 되어
		    있기 때문에 내용을 볼 수가 없다.		
		 
		 
	2. 데이터딕셔너리뷰 - 오라클은 데이터딕셔너리의 내용을 사용자가 이해할 수 있는 내용으로
	   변환해서 제공하는 것이 데이터딕셔너리뷰이다. 뷰에는 사용자뷰, 전체뷰, dba권한만 볼 수 
		 있는 dba뷰가 있다.	   
	
	   1) user_xxx 
		 
				a. 자신의 계정이 소유한 객체에 대한 정보를 조회할 수 있다.
				b. user라는 접두어가 붙은 데이터딕셔너리중에서 자신이 생성한 테이블, 뷰, 인덱스등과
				   같이 자신이 소유한 객체의 정보를 저장하는 user_tables가 있다.
					 예를 들어 select * from user_tables;

		 2) all_xxx
		 
		    a. 자신계정소유와 권한을 부여 받은 객체등에 대한 정보를 조회할 수가 있다.
				b. 타 계정의 객체는 원칙으로는 접근이 불가능하지만 그 객체의 소유자가 접근할 수
				   있도록 권한을 부여한 경우에는 타 계정의 객체도 접근할 수가 있다.
				   ... select * from all_tables;
					 ... select * from all_tables where owner = 'HR';
		 
		 3) dba_xxx
		 
		    a. 데이터베이스관리자만 접근이 가능한 객체들의 정보를 조회할 수 있다.
				b. dba딕셔너리는 DBA권한을 가진 사용자는 모두 접근이 가능하다. 즉, DB에 있는 모든
				   객체들에 대한 정보를 조회할 수가 있다.
			  c. 따라서, dba권한을 가진 sys, system계정으로 접속하면 dba_xxx등의 내용을 조회할 수 있다.
				
	
*/

select * from user_tables;
select * from all_tables;
select * from dba_tables;

select * from all_tables where owner = 'SCOTT';

-- 딕셔너리의 정보
select * from dictionary;
select * from ALL_TAB_COLUMNS where owner='SCOTT' and table_name = 'EMP';

select * from USER_CONS_COLUMNS;

-- http://www.gurubee.net

