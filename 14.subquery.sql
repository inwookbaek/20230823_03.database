/*
	subquery?
	
	1. Main Query와 반대되는 개념으로 이름을 부여한 것
	2. 메이쿼리를 구성하는 소단위의 쿼리(종속쿼리)
	3. sub query안에 select, insert, delete, update모두 사용이 가능하다.
	4. sub query의 결과값을 메인쿼리가 사용하는 중간값으로 사용할 수 있다.
	5. sub query 자체는 일반 쿼리와 다를 바가 없다.
	
	서브쿼리의 종류
	
	1. 연관성에 따른 분류
	
		 a. 연관성이 있는 쿼리
		 b. 연관성이 없는 쿼리
	
	2. 위치에 따른 분류
	
	   a. inline view : select절이나 from절안에 위치하는 쿼리
		 b. 중첩쿼리    : where절안에 위치한 쿼리
		 
		 
	제약사항
	
	1. where절에 연산자 오른 쪽에 위해해야 하며 반드시 소괄호()로 묶어야 한다.
	2. 특수한 경우를 제외하고는 sub query안에는 order by를 사용할 수 없다.
	3. 비교연산자에 따라서 단일행 sub query(<,>,=...) or 다중행 sub query(in, like...)를
	   사용할 수 있다.
*/
-- A. 다른 소유자의 객체(table, view....)에 접근하기
select * from hr.employees; -- 현재 권한이 없어서 접근불가

-- 1. 현재 scott은 hr의 객체에 접근할 수 있는 권항이 없다.
-- 2. hr사용자가 scott에 employees, departments만 조회할 수 있는 권한 부여
--    1) sysdba권한자 or 실제 소유자(hr)가 다른 사용자(scott)에 권한을 부여할 수 있다.
--    2) hr에서 scott에 권한을 부여
--    3) hr계정으로 사용자를 변경하거나 or hr로 새로운 탭을 열어서 작업
--    4) 문법
--       a. 권한 부여 : grant 부여할 명령 on 접근허용할객체 to 권한부여되는사용자
--       b. 권한 해제 : revoke 해제할 명령 on 해제할 객체 from 권한해제되는 사용자
--       c. 접근부여 명령은 select, insert, delete, update...

-- 1. 접근권한부여
grant select on hr.employees to scott;
grant select on hr.departments to scott;

select * from hr.employees;
select * from hr.departments;


-- 2. 접근권한해제
revoke select on hr.employees from scott;
revoke select on hr.departments from scott;

select * from hr.employees;
select * from hr.departments;

-- 3. scott에 select권한을 부여받은 테이블 조회하기
-- 다른 사용자(스키마)의 객체에 접근하려면 "스키마.객체이름"형식으로 접근해야 한다.
grant select on hr.employees to scott;
grant select on hr.departments to scott;

select * from hr.employees;
select * from hr.departments;

/* B. 단일행 서브쿼리 */
-- 실습1. 샤론스톤과 동일한 직급(instructor)인 교수들을 조회하기
-- professor에서 조회(sub query는 where절에 위치)
select * from professor;
select position from professor where name = 'Sharon Stone';
select * from professor where position = 'instructor';

select * from professor 
 where position = (select position from professor where name = 'Sharon Stone');

-- 실습2. hr에서 employees, departments를 join해서
-- 사원이름(first_name + last_name), 부서ID, 부서명(inline view)를 조회하기 
select * from hr.employees;
select first_name || '.' || last_name 사원이름
     , emp.department_id 부서코드
		 , (select department_name 
		      from hr.departments dpt
				 where dpt.department_id = emp.department_id) 부서명
  from hr.employees   emp;

-- 실습3. hr계정 사원테이블에서 평균급여(전체사원)보다 작은 사원만 출력
-- 단일행, 단일컬럼
select round(avg(salary), 0) from hr.employees;
select first_name || '.' || last_name 사원이름
		 , salary 급여
  from hr.employees   emp
 where salary < (select round(avg(salary), 0) from hr.employees);

/* C. 다중행, 다중열 sub query*/
-- 1. 다중행, 단일행
-- hr.locations, jobs에 접근권한을 부여
grant select on hr.locations to scott;
grant select on hr.jobs to scott;

select * from hr.locations;
select * from hr.jobs;

-- 실습1. 부서의 state_province가 null인 부서를 조회
-- 1) locations에서 state_province가 null인 자료 (다중행, 단일컬럼)
-- 2) deparments를 join해서 
-- 3) 부서번호, 부서명을 출력

-- 실습2. 급여가 가장 많은 사원의 이름, 직급을 출력
-- first_name.last_name, job_title;

-- 실습3. 급여가 평균급여보다 많은 사원
-- 미국내에서 근무하는 사원들에 대한 평균급여
-- 사원명, salary, job_title







