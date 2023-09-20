/* 그룹함수 */
-- 1. count
select count(*) from emp;
select count(ename) from emp;
select count(comm) from emp;
select count(nvl(comm, 0)) from emp;

select count(sal), count(comm), count(nvl(comm, 0)) from emp
select count(sal), count(comm), count(nvl(comm, 0)) from emp where comm is not null;

-- 2. sum
select sum(sal) from emp;
select sum(comm) from emp;
select sum(ename) from emp; -- (x) ORA-01722: invalid number

-- 실습. 총사원수와 총급여와 평균급여를 출력하기
select count(ename) 총사원수
     , sum(sal) 총급여
		 , sum(sal)/count(ename) 평균급여
		 , round(sum(sal)/count(ename), 0) 평균급여
	from emp;

-- 3. avg
select count(ename) 총사원수
     , sum(sal) 총급여
		 , sum(sal)/count(ename) 평균급여
		 , round(sum(sal)/count(ename), 0) 평균급여
	from emp
union all	
select count(ename) 총사원수
     , sum(sal) 총급여
		 , avg(sal) 평균급여
		 , round(avg(sal), 0) 평균급여
	from emp;
	
-- 4. max/min
select min(sal + nvl(comm, 0)) 최저급여
     , max(sal + nvl(comm, 0)) 최대급여
  from emp;
	
-- 실습. 최초입사자, 최후입사자를 출력하기
select min(hiredate), max(hiredate) from emp;

select '최초입사자', ename, hiredate from emp where hiredate = '1980-12-17'
union all
select '최후입사자', ename, hiredate from emp where hiredate = '1987-04-19';

select '최후입사자', ename, hiredate from emp where hiredate = '19870419';
select '최후입사자', ename, hiredate from emp where hiredate = '1987.04.19';

select '최초입사자', ename, hiredate 
  from emp 
 where hiredate = (select min(hiredate) from emp);
 
select '최후입사자', ename, hiredate 
  from emp 
 where hiredate = (select max(hiredate) from emp);

-- 실습. 최소급여자, 최대급여자를 출력하기(sal + comm)
select '최소급여자', ename, sal+nvl(comm,0) 급여 
  from emp 
where sal+nvl(comm,0) = (select min(sal+nvl(comm,0)) from emp)
union all
select '최대급여자', ename, sal+nvl(comm,0) 급여 
  from emp 
  where sal+nvl(comm,0) = (select max(sal+nvl(comm,0)) from emp);

/* 그룹화하기 
	
	1. select절에 그룹함수 이외의 컬럼이나 표현식을 사용할 경우
	   반드시 group by절에 포함되어야 한다.
  2. group by절에 선언된 컬럼은 select절에 선언하지 않아도 된다.
	3. group by절에는 컬럼명이나 표현식을 사용할 수 있지만 별칭은 사용할 수 없다.
	4. group by절에 사용한 열기준으로 정렬을 할 경우에는 order by절은 group by절
	   보다 반드시 뒤에 선언되어야 한다.
  5. order by절에는 컬럼순서, 별칭, 컬럼명으로도 선언할 수 있다.

*/
-- 실습. 부서별로 부서급여합계(sal)

select 10 부서번호, sum(sal) from emp where deptno = 10
union all
select 20 부서번호, sum(sal) from emp where deptno = 20
union all
select 30 부서번호, sum(sal) from emp where deptno = 30
union all
select 40 부서번호, sum(sal) from emp where deptno = 40;

select deptno, sum(sal) 
  from emp 
 group by deptno
 order by deptno;

select deptno, job, sum(sal) as "부서/직급별합계"
  from emp 
 group by deptno, job
 order by deptno, job;

select deptno 부서번호, job, sum(sal) as "부서/직급별합계"
  from emp 
 group by deptno, job
 order by 부서번호, job;

select deptno, sum(sal) from emp where deptno = 10 group by deptno;

select deptno 부서번호, job, sum(sal) as "부서/직급별합계"
  from emp 
 group by deptno, job
 order by 부서번호, 2;
 
select deptno 부서번호, job, sum(sal) as "부서/직급별합계"
  from emp 
 group by deptno, job
 order by sum(sal) desc; 

-- 실습. emp테이블에서
-- ex01) 부서별로 사원수와 급여평균, 급여합계를 구하기, 정렬은 부서(deptno)
select deptno 부서
     , count(*) 사원수
		 , sum(sal) 급여합계
		 , round(avg(sal), 0) 부서평균
  from emp
 group by deptno
 order by 1;
 
-- ex02) 직급별로 인원수, 평균급여, 최고급여, 최소급여, 급여합계, 정렬은 직급(job) 
select job 직급
     , count(*)
		 , round(avg(sal)) 평균급여
		 , max(sal) 최대급여
		 , min(sal) 최소급여
		 , sum(sal) 급여합계
  from emp
 group by job
 order by 직급
 
/* 그룹화자료를 조건절
	 having 절 - 그룹결과를 조건별로 조회
	 
	 단일행함수에서의 조건절은 where을 사용하지만
	 그룹함수에서의 조건절은 having을 사용한다.
	 
	 having절에는 집계함수를 가지고 조건을 비교할 경우에
	 사용되며 having절과 group by절은 사용할 수 있지만
	 group by절없이는 having절을 사용할 수 없다.
	 
	 having절이 있으면 order by절은 having절 앞에 올 수 없다.
*/
-- 직급별 평균급여가 3000 이상인 직급만 조회하기
select * 
from 
(select job 직급
     , count(*)
		 , round(avg(sal)) 평균급여
		 , max(sal) 최대급여
		 , min(sal) 최소급여
		 , sum(sal) 급여합계
  from emp
 group by job
having round(avg(sal)) >= 3000) t1
 order by 직급 desc


 


