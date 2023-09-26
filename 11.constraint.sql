/*
	제약조건(Constraint)
	
	테이블에 정확한 데이터만 입력될 수 있도록 사전에 정의(제약)하는 조건을 말한다.
	데이터가 추가될 때 사전에 정의된 제약조건에 맞지 않는 자료는 DB엔진에서 사전에
	방지할 수 있게 한다.
	
	제약조건의 종류
	1. not null    (NN) : null값이 입력되지 않도록 하는 조건
	2. unique      (UK) : UK로 설정된 컬러메는 중복된 값을 허용하지 않는 제약조건
	3. primary key (PK) : not null + unique인 컬럼, PK는 테이블당 한 개의 PK만 정의가능
	                      PK는 한 개이상의 컬럼을 묶어서 한 개의 PK로 지정할 수 있다.
	4. forign key  (FK) : 참조테이블의 PK인 컬럼을 참조(reference)하도록 하는 조건
	                      참조(부모)테이블에 PK에 없는 값이 자식테이블에 입력되지 않도록 하는 조건
	5. check       (CK) : 설정된 값만 입력이 되도록 하는 조건
*/
-- 1. 테이블생성시에 지정
-- 1) 정식문법
create table new_emp_1 (
		no 			number(4)
	, name 		varchar2(20)
	, ssn			varchar2(13)
	, loc 		number(1)
	, deptno 	varchar2(6)
);
select * from new_emp_1;
insert into new_emp_1(no, name, ssn, loc, deptno) 
		 values(null, 'honggildong', '9911181234567', -9, 100);
insert into new_emp_1(no, name, ssn, loc, deptno) 
		 values(10, null, '9911181234567', -9, 100);	
		
drop table new_emp_2;		
create table new_emp_2 (
		no 			number(4)  		constraint emp_no_pk   primary key
	, name 		varchar2(20)  constraint emp_name_nn not null
	, ssn			varchar2(13)  constraint emp_ssn_uk  unique
	, loc 		number(1)     constraint emp_loc_ck  check(loc>0 and loc<5)
	, deptno 	varchar2(6)   constraint emp_dept_fk references dept2(dcode)
);
select * from new_emp_2;
-- a. 사원번호 not null
insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(null, 'honggildong', '9911181234567', -9, 100);	-- cannot insert NULL
		 
-- b. 사원이름 not null		 
insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(10, null, '9911181234567', -9, 100);	-- cannot insert NULL	 
		 
-- c. 사원번호 uk / 주민번호 중복
insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(10, 'honggildong', '9911181234567', -9, 100);
		 
insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(10, 'sohyang', '9911181234567', -9, 100);	-- unique constraint violated		
			
insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(20, 'sohyang', '9911181234567', -9, 100); -- unique constraint violated		
		
insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(20, 'sohyang', '9911182234567', -9, 100);
		 
-- d. location check
insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(10, 'honggildong', '9911181234567', -9, 100); --check constraint violated

insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(10, 'honggildong', '9911181234567', 5, 100);  --check constraint violate


insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(10, 'honggildong', '9911181234567', 1, 100);
insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(20, 'sohyang', '9911182234567', 2, 100);

-- e. forign key
select * from dept2; 
select * from new_emp_2;

insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(10, 'honggildong', '9911181234567', 1, 100); -- integrity constraint violated

insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(10, 'honggildong', '9911181234567', 1, 1000);
insert into new_emp_2(no, name, ssn, loc, deptno) 
		 values(20, 'sohyang', '9911182234567', 2, 1001);
	 
-- 2) 약식문법
drop table new_emp_3;		
create table new_emp_3 (
		no 			number(4)  		primary key
	, name 		varchar2(20)  not null
	, ssn			varchar2(13)  unique
	, loc 		number(1)     check(loc>0 and loc<5)
	, deptno 	varchar2(6)   references dept2(dcode)
);
select * from new_emp_3;

insert into new_emp_3(no, name, ssn, loc, deptno) 
		 values(10, 'honggildong', '9911181234567', 1, 1000);
insert into new_emp_3(no, name, ssn, loc, deptno) 
		 values(20, 'sohyang', '9911181234567', 2, 1001);

-- 2. 테이블에 설정된 제약조건 조회하기
-- data dictionary : xxx_constraints
select * from all_constraints;
select * from user_constraints;
select * from user_constraints where table_name like 'NEW_EMP%';

-- 실습. professor/student로 제약조건 실습하기
-- 1. table은 new_student, reference table은 professor
-- 2. new_student에 다양한 제약조건에 맞는 데이타 입력해 보기
select * from student;

create table new_student (
		  stdno			number(4)     primary key
		, name      varchar2(20)  not null
		, id        varchar2(20)  not null
		, grade     number(1)     check(grade>0 and grade<5)
		, jumin     varchar2(13)  unique not null
		, birthday  date          default sysdate
		, tel			  varchar2(20)
		, height    number        default 0
		, weight    number        default 0
		, deptno1   number(3)
		, deptno2   number(3)
		, profno    number(4)     references professor(profno)
);

select * from user_constraints where table_name like 'NEW_STU%';
select * from new_student;
select * from professor;

-- 정상데이터
insert into new_student 
		 values(1, '홍길동', 'hong', 4, '991181234567', sysdate, '010-9999-8888', 0, 0, 100, 101, 1001);
insert into new_student 
		 values(2, '소향', 'sohyang', 3, '991182234567', sysdate, '011-9999-8888', 0, 0, 100, 101, 1002); 
insert into new_student 
		 values(3, '이강인', 'kangin', 3, '991183234567', sysdate, '012-9999-8888', 0, 0, 100, 101, 1003); 

select * from new_student;

-- 비정상적인 데이터
-- 1) stdno : unique constraint violated
insert into new_student 
		 values(1, '홍길순', 'hong', 4, '991181234567', sysdate, '010-9999-8888', 0, 0, 100, 101, 1001);

-- 2) jumin : unique constraint violated     
insert into new_student 
		 values(4, '홍길순', 'hong', 4, '991181234567', sysdate, '010-9999-8888', 0, 0, 100, 101, 1001);

-- 3) jumin : too large for column 
insert into new_student 
		 values(5, '홍길순', 'hong', 4, '99118923456700000', sysdate, '010-9999-8888', 0, 0, 100, 101, 1001);

-- 4) grade : check constraint violated
insert into new_student 
		 values(6, '손흥민', 'hong', 5, '991187234567', sysdate, '010-9999-8888', 0, 0, 100, 101, 1001);

-- 5) FK(profno) : parent key not found
insert into new_student 
		 values(7, '김민재', 'minjae', 3, '991177234567', sysdate, '010-9999-8888', 0, 0, 100, 101, 9979);

select * from new_student;

-- 2. 제약조건수정하기
-- 1) new_emp_3.name에 unique조건 수정(추가)하기
select * from new_emp_3;
select * from user_constraints where table_name = 'NEW_EMP_3';

alter table new_emp_3 add constraint emp_name_uk unique(name);

insert into new_emp_3 values(30, 'sohyang', '9911183234567', 3, 1002); -- unique constraint
insert into new_emp_3 values(30, 'sohyang1', '9911183234567', 3, 1002);

-- 2) new_emp_3.loc에 not null 추가(수정)하기
-- a. 이미 데이터에 null값이 있을 경우 제약조건 추가불가, 단 null값이 없는 경우에는 제약조건 추가 가능
-- b. 이미 loc에는 check제약조건이 있기 떄문에 추가불가, 따라서 수정(modify)로 해야 한다.
update new_emp_3 set loc = 1;
alter table new_emp_3 add constraint emp_loc_nn not null(loc); -- invalid identifier
alter table new_emp_3 modify(loc constraint emp_loc_nn not null);
select * from new_emp_3;

-- 3. FK설정하기
create table c_test1(
		no 			number
	, name  	varchar2(10)
	, deptno 	number
);
create table c_test2(
		no 			number
	, name  	varchar2(10)
	, deptno 	number
);

select * from c_test1; -- child 
select * from c_test2; -- parent

-- primary key / foreign key
-- FK 참조테이블의 컬럼이 PK or UK인 컬러만 FK로 정의할 수 있다.
alter table c_test1 add constraint fk_c_test1_deptno foreign key(deptno) references c_test2(deptno); --(x)

alter table c_test2 add constraint uk_c_test2_deptno unique(deptno);
alter table c_test1 add constraint fk_c_test1_deptno foreign key(deptno) references c_test2(deptno);

-- FK제약사항 테스트하기
insert into c_test2 values(1, '총무부', 10);
insert into c_test1 values(100, '손흥민', 100); -- integrity constraint 
insert into c_test1 values(100, '손흥민', 10);

-- 실습. FK관계에서 부모자료를 삭제할 경우?
delete from c_test2 where deptno = 10;

-- 부모관계에서 부모자료를 삭제할 수 있도록 정의하는 옵션
-- cascade옵션
-- 1) 부모와 자식을 동시에 삭제하는 옵션
-- 2) 부모는 삭제하고 자식의 FK컬럼을 null로 업데이트하는 옵션
select * from user_constraints where table_name = 'NEW_EMP_3';

drop table c_test1;
drop table c_test2;

create table c_test1(
		no 			number
	, name  	varchar2(10)
	, deptno 	number
);
create table c_test2(
		no 			number
	, name  	varchar2(10)
	, deptno 	number
);

insert into c_test2 values(1, '총무부', 10);
insert into c_test1 values(100, '손흥민', 10);
select * from c_test1;
select * from c_test2;
select * from user_constraints where table_name like 'C_%';

alter table c_test2 add constraint uk_c_test2_deptno unique(deptno);
alter table c_test1 add constraint fk_c_test1_deptno foreign key(deptno) references c_test2(deptno)
      on delete cascade;

-- a. on delete cascade : 부모/자식 자료 동시삭제
delete from c_test2 where deptno=10;

-- b. on delete set null: 부모자료삭제후 자식의 FK컬럼을 null값으로 수정
drop table c_test1;
drop table c_test2;

create table c_test1(
		no 			number
	, name  	varchar2(10)
	, deptno 	number
);
create table c_test2(
		no 			number
	, name  	varchar2(10)
	, deptno 	number
);
insert into c_test2 values(1, '총무부', 10);
insert into c_test1 values(100, '손흥민', 10);
select * from c_test1;
select * from c_test2;
select * from user_constraints where table_name like 'C_%';

alter table c_test2 add constraint uk_c_test2_deptno unique(deptno);
alter table c_test1 add constraint fk_c_test1_deptno foreign key(deptno) references c_test2(deptno)
      on delete set null;

delete from c_test2 where deptno=10;

select * from c_test1;
select * from c_test2;