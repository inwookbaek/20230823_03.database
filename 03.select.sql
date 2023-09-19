/* 
	select 명령
	1. 문법 : select [*|col명...] from [table | view] 
				     where [컬럼등 비교연산자 [값|열]
						   [and|or] 조건절...
  2. 데이터를 조회하는 명령
	3. 실습
		 1) scott의 dept, emp 테이블의 자료를 조회하기
		 2) emp 테이블의 모든 컬럼 조회하기
		 3) emp에서 사원명, 사원번호(ename, empno) 만 조회하가
		 4) 사용자생성하기 : scott대신에 your_name, 비번 12345
		 5) 생성된 사용자에게 권한(connect, resource)권한 부여하기
		 6) 생성된 db접속하기	
*/
select * from emp;
select * from dept;
select empno, ENAME from emp;

create user gilbaek identified by 12345;
grant connect, resource to gilbaek;

/*
	A. SQL문의 종류
	
	1. DML(Data Manipulatin Language, 데이터조작어)
	
		 1) select : 자료를 조회
		 2) insert : 자료를 추가
		 3) delete : 자료를 삭제
		 4) update : 자료를 수정
		 5) commit : CUD의 작업을 최종적으로 확정하는 명령
		 6) rollback: CUD 작업을 취소하는 명령
		 
		 * CRUD : Create(insert), Read(Select), Update, Delete
		 * Transction : 일련의 데이터처리작업(commit, rollback)
		 
	2. DDL(Data Definition Language, 데이터정의어)
		 - oracle에서 객체와 관련된 명령
		 - 객체(object)의 종류 : user, role, table, view, index, sequence, trigger...
		 
	   1) create : 오라클 DB의 객체를 생성
		 2) drop   : 오라클 DB의 객체를 삭제(완전삭제)
		 3) alter  : 오라클 DB의 객체를 수정
		 4) truncate: 오라클 DB의 객체를 삭제(데이터만 삭제)
	
	
	3. DCL(Data Control Language, 데이터관리어)
	
		 1) grant  : 사용자에게 권한(or Role)을 부여(connect, resource, ...)
		 2) revoke : 사용자의 권한(or Role)을 해제
	
	B. select 문법 
	
	   select [distint] [* | col [as] 별칭 ....]
			 from [스키마].테이블명[view명, [select ...]] 별칭
			where 조건절 [and, or, like, between...]
		 [order by col(or 표현식) [asc/desc]. ...]	
		 
		 1. distinct : 중복을 제거하고 한 개의 행만 조회
		               컬럼명 맨 앞에 위치해야 한다. 아니면 에러
     2. * : 객체의 모든 커럼(열)을 선택
		        *가 정의가 되면 다른 열을 정의할 수 없다.
		 3. alias(별칭) : 객체명 or 컬럼명을 다른 이름으로 정의
		 4. where : 조건에 맞는 자료만 조회
		 5. 조건절 : 컬럼, 표현식, 상수 및 비교연산(>, <, =, <=, >, like....)
		 6. order by : 질의(query)결과를 정렬(asc 오름차순(기본값), desc 내림차순) 
*/
select deptno from emp;
select distinct deptno from emp;
--select deptno distinct from emp; 에러
select distinct deptno, mgr from emp;

-- select *, empno from emp; 에러

select deptno 부서번호 from emp;
select deptno as 부서번호 from emp;
select deptno as "부서번호" from emp;
-- select deptno as 부서 번호 from emp; 에러
select deptno as "부서 번호" from emp;
select deptno from emp 사원테이블; 
select * from dept dpt; 

select emp.deptno 부서번호 from emp;
select emp.deptno 부서번호 from scott.emp;
-- select emp.deptno 부서번호 from emp t1; 에러
select t1.deptno 부서번호 from emp t1;

-- 1. 특정 테이블의 자료를 조회하기
select * from tabs; -- 현 사용자가 소유하고 있는 모든 테이블 조회
select * from emp;
select * from scott.emp;
select * from hr.emp;       -- 부존재
select * from hr.employees; -- 부존재, 접근 권한이 없다.
select empno, ename, sal, comm from emp;

-- 2. 별칭부여하기
select empno as 사원번호
     , ename 사원이름
		 , sal 사원급여
		 , sal "사원 급여"
		 , sal 사원_급여
		 , comm 보너스
		 , comm 보너스
		 , ename
		 , ename
		 , ename		 
  from emp;
		 
-- 3. 표현식 : literal, 상수, 문자열, 표현식은 작은 따옴표로 정의해야 한다.
select ename from emp;
select '사원이름 = ', ename from emp;
select "사원이름 = ", ename from emp; -- (x) 큰 따옴표는 identifier로 인식
select '사원이름 = ', "ename" from emp; -- (x) 컬럼을 큰 따옴표정의할 경우 대소문자구분
select '사원이름 = ', "ENAME" from emp; 
select '사원이름 = ', "ENAME" from "emp"; -- (x)
select '사원이름 = ', "ENAME" from "EMP";

-- 4. disctinct 중복제거
select * from emp;
select deptno from emp;
select distinct deptno from emp;
select deptno distinct from emp; -- (x)
select distinct deptno, mgr from emp;
select distinct deptno, distinct mgr from emp; -- (x) distinct선언은 한번만 선언가능

-- 5. 정렬 order by
select * from emp;

-- 내림차순
select * from emp order by ename;
select * from emp order by ename asc;
select * from emp order by 2; -- 번호는 select절안에 컬럼순서
select ename, empno from emp order by 2; 
select ename, empno from emp order by 3; -- (x) 컬럼순서 부존재

-- 내림차순
select * from emp order by ename;
select * from emp order by ename desc;

-- 실습. 입사일순서로 정렬
select * from emp order by hiredate asc;
select * from emp order by hiredate desc;

-- 복합순서정렬
-- 이름순, 입사일(내림), 부서번호
select * from emp order by ename, hiredate desc, 8;

-- 실습1. emp테이블에서 deptno, job를 조회하는데 중복제거
--     2. 중복제거후 deptno, job으로 정렬(asc, desc)
--     3. deptno를 부서번호, job을 직급으로 별칭으로 정의
select distinct deptno, job from emp;
select distinct deptno, job from emp order by deptno asc, job desc;

select distinct deptno 부서번호, job "직급" 
  from emp order by deptno asc, job desc;

select distinct deptno 부서번호, job "직급" 
  from emp order by 1 asc, 2 desc;
	
-- 6. literal
select '1111', empno from emp;
select * from dual; -- 오라클에서만 제공하는 dummy테이블 행1갱, 열1개만 존재
select '1111' from dual;

-- 7. 별칭으로 열이름 부여하기
select '사원의 이름 = ', ename from emp;
-- 사원's -> 표현은?
-- select '사원's', ename from emp; -- (x)
select '사원''s', ename from emp; -- 작은 따옴표안에 작은 따옴표표현은 2개로 선언

-- 8. 컬럼 or 문자열 연결함수
-- concat(concat(a, b), c) : 함ㅅ수
--  or || -> 연산자
-- '사원''s 이름' ename 
-- 1) concat(a, b) : 매개변수가 2개만 정의 가능
select concat('사원''s ', ename) from emp;
select concat('사원''s ', ename) 사원이름 from emp;


-- 2) || 연결연산자
select '사원''s ' || ename 사원이름 from emp;

-- 실습
-- SMITH(20) "사원명과 부서번호" 형식으로 출력
-- concat와 || 각각 실습하기
-- 1) concat
select ename, '(', deptno, ')' from emp;
select concat(concat(concat(ename, '('), deptno), ')') "사원명과 부서번호"
  from emp;

-- 2) || 연결연산자
select ename || '(' || deptno || ')' "사원명과 부서번호"
  from emp;

/* C. 연습문제 */
-- 1. Student 에서 학생들의 정보를 이용해서 "Id and Weight" 형식으로 출력하세요
select * from student;
select id, weight from student;
select id || weight as "Id and Weight" from student;

-- 2. emp에서 "Name and Job"형식으로 출력
select ename || job as "Name and Job" from emp;

-- 3. emp에서 "Name and Sal"
select ename || sal as "Name and Sal" from emp;



