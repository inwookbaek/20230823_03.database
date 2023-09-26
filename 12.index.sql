/*
	인덱스란?
	
	인덱스는 특정 데이터가 HDD의 어느 위치(메모리)에 저장되어 있는지에 대한 정보를 가진 주소와
	같은 개념이다. 인덱스는 데이터와 위치주소(rowid)정보를 key와 value의 형태의 한쌍으로 저장
	되어 관리된다. 인덱스의 가장 큰 묵적은 데이터를 보다 빠르게 검색 or 조회할 수 있게 하기 
	위함이다.
	
	1. rowid구조
	
	   rowid는 데이터의 위치정보 즉, HDD에 저장되어 있는 메모리주소로서 Oracle에서는 총 18bytes
		 길이의 정보이다. rowid는 예를 들어 AAAE5nAAEAAAAFdAAA의 형태이다.
		 1) 6byte 데이터오브젝트번호: AAAE5n
		 2) 3byte 파일번호          : AAE
		 3) 6byte 블럭번호          : AAAAFd
		 4) 3byte row번호           : AAA
						
	2. index를 사용하는 이유
	
	   1) 데이터를 보다 신속하게 검색할 수 있게 하도록 사용(검색속도를 향상)
		 2) 보통 index테이블의 특정 컬럼에 한 개이상 주게 되면 index table이 별도로 생성된다.
		    이 인덱스테이블에는 인덱스컬럼의 row값과 rowid가 저장되고 row값은 정렬된 b-tree
				구조로 저장시켜서 검색시에 보다 빠르게 데이터를 검색할 수 있게 한다.
		 3) 하지만, update, delete, insert시에는 속도가 느려지는 단점이 있다.
	
	3. index를 필요한 이유
	
	   1) 데이터가 대용량일 때
		 2) where 조건에 자주 사용되는 컬럼일 경우 
		 3) 조회결과 전체 데이터베이스의 3~5%미만일 경우 인덱스 검색이 효율적이고
		    보다 적은 비용으로 빠르게 검색할 수 있다.
	
	4. index가 필요하지 않은 경우
	
	   1) 데이터가 적을 경우(수 천건 미만)에는 인덱스를 설정하지 않는 것이 오히려 성능에 좋다.
		 2) 검색보다 update, insert, delete가 빈번하게 일어나는 테이블에는 인덱스가 없는 게 
			  오히려 성능이 좋을 수가 있다.
		 3) 조회결과가 전체 행의 15%이상인 경우에는 사용하지 않는 것이 좋다. 
			
	5. index가 자동생성되는 경우
	
	   인덱스가 자동생성되는 경우는 테이블정의시에 PK, UK의 제약조건으로 정의된 컬럼은 index가
		 자동으로 생성된다.
		 
	6. 문법
	
	   1) 생성방법 : create [unique] index 인덱스명 on 테이블명(컬럼1,...컬럼n)
		 2) 삭제문법 : drop index 인덱스명
			 -> index는 테이블에 종속되어 있기 때문에 테이블이 삭제가 될 때 자동으로 삭제가 된다.
*/

-- 1. rowid는 오라클에서만 사용하는 개념으로 rowid정보를 검색할 수 있다.
-- 만약, rowid를 지원하지 않는 프로그램에서는 rowidtochar(rowid)함수를 이용해서 조회할 수 있다.
select rowid, ename from emp;
select rowidtochar(rowid), ename from emp;
select length(rowid) from emp;

select rowid -- 7521사원의 데이터가 저장되어 있는 메모리 주소
     , empno
		 , ename
  from emp
 where empno = 7521
union all 
select rowid -- 7521사원의 데이터가 저장되어 있는 메모리 주소
     , empno
		 , ename
  from emp
 where ename = 'WARD';
 
-- 2. index 조회 : data dictionary
-- xxx_indexes / xxx_ind_columns
select * from all_indexes;
select * from user_indexes where table_name like 'C_%';
select * from user_indexes where table_name = 'DEPT2';
select * from user_indexes where table_name = 'EMP';
select * from user_ind_columns where table_name = 'EMP';

-- 1) index 생성(1) - unique index
select * from dept2;
select * from user_indexes where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'DEPT2';
update dept2 set dname = '테스트부서_3' where dcode=9002;

create unique index idx_dept_dname on dept2(dname);
-- cannot CREATE UNIQUE INDEX; duplicate keys found

-- 2) index 생성(2) - non unique index
create index idx_dept_area on dept2(area);
select * from user_indexes where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'DEPT2';

select t1.table_name
		 , t2.column_name
     , t1.uniqueness
		 , t2.descend
  from user_indexes      t1
	   , user_ind_columns  t2
 where t1.table_name = 'DEPT2'
   and t1.index_name = t2.index_name;

-- 3) index 생성(3) - 결합 index
select ename, job, sal from emp where ename='SMITH' and job='CLERK';
select ename, job, sal from emp where job='CLERK' and ename='SMITH';
select count(*) from emp where ename='SMITH'
union all
select count(*) from emp where job='CLERK';

select t1.table_name
		 , t2.column_name
     , t1.uniqueness
		 , t2.descend
  from user_indexes      t1
	   , user_ind_columns  t2
 where t1.table_name = 'EMP'
   and t1.index_name = t2.index_name;

create index idx_ename_job on emp(ename, job);

select * from user_indexes where table_name = 'EMP';
select * from user_ind_columns where table_name = 'EMP';

-- 6. index rebuilding하기
drop table idx_test;
create table idx_test(no number);
select * from idx_test;

-- sql로 프로그램 -> pl/sql
-- 익명/일반 sql 프로그램
-- 1) index 테스트테이블 생성
begin
	for i in 1..100000 loop
		insert into idx_test values(i);
	end loop;
	commit;
end;

-- a. index없이 조회하기
select * from idx_test order by no; -- 0.136s
select * from idx_test where no = 90000; -- 0.023s

-- b. index생성후 조회하기
create unique index idx_test_no on idx_test(no);

select * from idx_test order by no; -- 0.134s
select * from idx_test where no = 100000; -- 0.004s

/* 연습문제 */
-- ex01) new_emp4를 생성, no(number), name(), sal(number)

-- ex02) 데이터를 insert
--    1000, 'SMITH', 300
--    1001, 'ALLEN', 250
--    1002, 'KING', 430
--    1003, 'BLAKE', 220
--    1004, 'JAMES', 620
--    1005, 'MILLER', 810

-- ex03) name컬럼에 인덱스 생성

-- ex04) 인덱스를 사용하지 않는 일반적인 SQL



















