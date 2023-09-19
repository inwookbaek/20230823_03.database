/*
	A. where 조건절
	
	1. 비교연산자 :  =, !=, <>, >, >=, <. <=
	2. 기타연산자
		 a and b : 논리곱연산자
		 a or b  : 논리합연산자
		 not a   : 부정연산자
		 in(a,b,...) : a,b,...의 값을 가지고 있는 자료를 검샋
		 between a and b : a와 b사이의 데이터를 검색, 주의할 점 a는 b보다 항상 작은 값
		 like(%, _와 같이 사용) : 특정 패턴을 가지고 있는 데이터를 검색
		   -> '%A' : A로 끝나는 자료, 'A%': A로 시작되는 자료, '%A%': A를 포함하는 자료
	   is null / not is null : null값 여부의 자료를 검색
*/

/* A. 비교연산자 */
-- 1. 급여(sal)가 5000인 사원조회하기
select * from emp;
select * from emp
 where sal = 5000;
 
 select * from emp;
 
-- 2. 급여가 900보다 작은 사원 조회하기
select * from emp where sal < 900;
select * from emp where sal <= 900;
select * from emp where sal > 900;
select * from emp where sal >= 900;
select * from emp where sal <> 900;
select * from emp where sal != 900;

-- 3. 이름이 smith인 사원조회하기
select * from emp where ename= 'smith'; -- 문자열 대소문자구분
select * from emp where ename= 'SMITH';
select * from emp where ename= SMITH; -- (x) SMITH 이 의미는 컬럼(identifier)으로 인식

-- 대소문자함수 : upper() / lower()
select 'smith', upper('smith'), lower('SMITH')
	   , lower(upper('smith'))
  from dual; 
	
select * from emp where ename = upper('smith');	
select * from emp where ename= lower('SMITH');
select * from emp where lower(ename) = 'smith';

-- ename이 smith이거나 king이면 조회하기
-- hint) or조건
select * from emp
 where ename = upper('smith')
    or ename = upper('king');

select * from emp
 where ename = upper('smith')
   and ename = upper('king');
	 
-- ename k~s까지인 사원을 검색
-- 1) and
select * 
  from emp
 where ename >= 'K' and ename < 'T';  -- 'T'이름은 포함하지 않음
 
-- 2) between a and b
select * 
from emp
where ename between 'K' and 'T';   -- 이름이 'T' 포함.



-- 4. 입사일자 1980-12-17인 사원으로 조회
-- (hint) date타입 비교할 때 문자열로 간주
select * from emp where hiredate = '1980-12-17';
select * from emp where hiredate = '1980-12-17 00:00:00'; -- date형식에 따라 달라진다.

/* 연습문제 */
-- ex01) 급여가 1000보다 작은 사원만 출력하기(ename/sal/hiredate 만 출력)
select ename, sal, hiredate
  from emp
 where sal < 1000;
 
-- ex02) 부서(dept)테이블에서 부서번호와, 부서명을 별칭으로 한 sql문을 작성
select deptno 부서번호, dpt.dname 부서명
  from dept dpt;
	
-- ex03) 사원테이블에서 직급만 출력하는데 중복되지 않게 출력하는 sql문
select distinct job
  from emp;

-- ex04) 급여가 800인 사원만 조회
select * 
  from emp
 where sal = 800;

-- ex05) 사원명이 BLAKE인 사원만 출력
select * 
  from emp
 where ename = 'BLAKE';

-- ex06) 사원이름 JAMES~MARTIN사이의 사원을 사원번호, 사원명, 급여를 출력
-- and / between 두가지형태로 작성
-- 1) and
select empno 사원번호
     , ename 사원이름
		 , sal   급여
  from emp
 where ename >= 'JAMES'
	 and ename <= 'MARTIN';
		
-- 2) between
select empno 사원번호
     , ename 사원이름
		 , sal   급여
  from emp
 where ename between 'JAMES' and 'MARTIN';

select empno 사원번호
     , ename 사원이름
		 , sal   급여
  from emp
 where ename between 'MARTIN' and 'JAMES';

-- 3) like
select * from emp
 where ename like 'M%';  -- 시작
 
select * from emp
 where ename like '%M%'; -- 중간(포함)
 
select * from emp
 where ename like '%S'; -- 종료
 
 -- 날짜비교
select * from emp where hiredate = '1980-12-17';
select * from emp where hiredate = '1980.12.17';
select * from emp where hiredate = '1980/12/17';
-- select * from emp where hiredate = '1980-DEC-17';
-- select * from emp where hiredate = '80-DEC-17';

