
/*	
	View?
	
	1. view란 가상의 테이블이다.
	2. view에는 실제 데이터가 존재하지 않고 view를 통해서만 데이터를 조회할 수 있다.
	3. view는 복잡한 쿼리를 통해 조회할 수 있는 결과를 사전에 정의한 view를 통해 간단히 조회할 수 있게 한다.
	4. 한 개의 view로 여러 개의 table데이터를 검색할 수 있게 한다.
	5. 특정 기준에 따라 사용자별로 다른 조회결과를 얻을 수 있게 한다.
	
	view 제한조건
	
	1. 테이블에 not null로 만든 컬럼들이 view에 포함 되어야 한다.
	2. view를 통해서도 테이블에 데이터를 insert할 수 있다. 단, rowid, rownum, nextval, curval등과
	   같은 가상의 컬럼에 대해 참조하고 있을 때 가능하다.
  3. with read only옵션으로 설정된 view는 어떠한 데이터를 갱신할 수 없다.
	4. wite check option을 설정한 view는 view조건에 해당되는 데이터를 insert, update, delete할 수 있다.
	
	view 문법
	
	create [or replace]	[force|noforce] view 뷰이름 as
	subquery...
	with read only
	with check option	 
	
	1. or replace : 동일이름의 view객체가 있다면 삭제후에 다시 생성(덥어쓰기)
	2. force|noforce : 테이블의 존재유무와 상관없이 view를 생성할지 여부 force옵션은 테이블이 없어도 강제로 생성
	3. with read only : 조회만 가능한 view
	4. with check option : 주어진 check옵션 즉, 제약조건에 맞는 데이터만 insert, update드이 가능
	
	view조회방법
	
	테이블 조회와 동일한 문법을 사용
	
	view를 생성할 수 있는 권한 부여하기
  ... view를 생성하기 위해서는 권한이 있어야 한다.
	
	1. 사용자권한조회 : select * from user_role_privs;
	2. 권한을 부여하는 방법(sysdba권한으로 실행)
     grant create view to scott;
*/

-- 권한부여하기
grant create view to scott;

-- 1. 권한조회하기
select * from user_role_privs;

-- 3. 단순 view생성하기
create or replace view v_emp as
select empno, ename, job, deptno from emp
with read only;

select * from v_emp;

-- 4. 사용자가 소유한 view목록 조회하기
select * from user_views;

-- 5. 복합view
select * from emp;
select * from dept;

create or replace view v_emp_dname as
select e.empno  사원번호
     , e.ename  사원이름
		 , e.deptno 부서번호
		 , d.dname  부서이름
  from emp e, dept d
 where e.deptno = d.deptno;

select * from v_emp_dname;
select * from v_emp_dname where deptno = 10; (x)
select * from v_emp_dname where 부서번호 = 10; (O)

-- 실습. 급여(sal, comm)가 포함된 view : v_emp_sal
-- 예) 급여조회권한이 있는 담당자만 사용할 수 있는 view
create or replace view v_emp_sal as
select empno 사원번호
     , ename "사원 이름"
		 , job   직급
		 , sal   급여
		 , nvl(comm, 0) 커미션
  from emp;
	
select * from v_emp_sal;
select * from v_emp_sal where job = 'CLERK'; -- "JOB": invalid identifier
select * from v_emp_sal where 직급 = 'CLERK';
select * from v_emp_sal where "사원 이름" = 'SMITH';

-- sub query
select * from
( select empno 사원번호
			 , ename "사원 이름"
			 , job   직급
			 , sal   급여
			 , nvl(comm, 0) 커미션
		from emp
) 
 where 직급 = 'CLERK';

-- table과 view를 join?
select v.*
		 , e.hiredate 입사일자
  from emp e, v_emp_sal v
 where e.empno = v.사원번호;
 
create or replace view v_hiredate as
select v.*
		 , e.hiredate 입사일자
  from emp e, v_emp_sal v
 where e.empno = v.사원번호;

select * from v_hiredate;

-- 실습. emp에서 부서번호, dept에서 dname, v_emp_sal와 join
-- 사원번호, 사원이름, 부서명, 직급, 급여 출력할 수 있는 join query를 작성하기
-- 뷰이름 : v_test
create or replace view v_test as
select emp.empno
     , dpt.dname
		 , sal.*
  from emp       emp
	   , dept      dpt
		 , v_emp_sal sal
 where emp.deptno = dpt.deptno
   and emp.empno  = sal.사원번호;

select * from v_test;

-- 7. inline view
-- 제약사항 : 한 개의 컬럼/한 개의 row만 지정할 수 있다.
-- 사원명과 부서명을 조회하기

-- 1) where조건절
select emp.ename
     , dpt.dname
  from emp emp, dept dpt
 where emp.deptno = dpt.deptno;

-- 2) inline view
select emp.ename
     , (select dname from dept dpt where emp.deptno = dpt.deptno)
  from emp emp;
	
select emp.ename
     , (select dname, deptno from dept dpt where emp.deptno = dpt.deptno)
  from emp emp; -- > ORA-00913: too many values
	
select emp.ename
     , (select dname from dept dpt)
  from emp emp; --> ORA-01427: single-row subquery returns more than one row

-- 3) from 절에 subquery
select emp.ename
     , dpt.dname
  from emp emp
	   , (select dname, deptno from dept) dpt
 where emp.deptno = dpt.deptno;

-- 8. view삭제하기
drop view v_test;

-- 실습. emp와 dept를 조회 : 부서번호와 부서별최대급여 및 부서명을 조회
-- 1) view를 생성
-- 2) inline view로 작성
-- deptno, dname, max_sal :
-- view이름 : v_max_sal_01
create or replace view v_max_sal_01 as
select deptno
		 , max(sal) 최대급여
  from emp
 group by deptno
 order by deptno;
 
select dpt.deptno
     , dpt.dname
		 , sal.최대급여	
  from dept dpt
     , v_max_sal_01 sal
 where dpt.deptno = sal.deptno;
	

-- 1) view 생성
create or replace view v_max_sal_02 as
select emp.deptno 부서번호
     , dpt.dname  부서이름
		 , max(sal)   최대급여
  from emp  
		 , dept dpt
 where emp.deptno = dpt.deptno
 group by emp.deptno, dpt.dname
 order by emp.deptno;

select * from v_max_sal_02;

-- 2) inline view(subquey, inline view에 group by를 정의)
-- a. from절
create or replace view v_max_sal_03 as
select dpt.deptno
     , dpt.dname
		 , sal.max_sal
	from dept dpt
	   , (select deptno, max(sal) as max_sal from emp group by deptno) sal
 where dpt.deptno = sal.deptno;

select * from v_max_sal_03;

-- b. select절
create or replace view v_max_sal_04 as
select dpt.deptno
     , dpt.dname
		 , nvl((select max(sal) from emp where dpt.deptno = emp.deptno group by deptno), 0)  부서별최대급여
  from dept dpt;

select * from v_max_sal_04;

/* 연습문제 */
-- ex01) professor, department을 join 교수번호, 교수이름, 소속학과이름 조회 View

-- ex02) inline view를 사용, student, department를 사용 학과별로 
-- 학생들의 최대키, 최대몸무게, 학과명을 출력

-- ex03) inline view를 사용, 학과명, 학과별최대키, 학과별로 가장 키가 큰 학생들의
-- 이름과 키를 출력

-- ex04) student에서 학생키가 동일학년의 평균키보다 큰 학생들의 학년과 이름과 키
-- 해당 학년의 평균키를 출력 단, inline view로

-- ex05) professor에서 교수들의 급여순위와 이름, 급여출력 단, 급여순위 1~5위까지
-- rownum

-- ex06) 교수번호정렬후 3건씩해서 급여합계와 급여평균을 출력
-- hint) 
select rownum, profno, pay, ceil(rownum/3) from professor; -- rollup
