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
order by 직급 desc;
 
-- 실습. emp테이블에서 그룹별 집계구하기
-- 1. 부서별 직급별 평균급여, 사원수
-- 2. 부서별        평균급여, 사원수
-- 3. 총계          평균급여, 사원수
select * from
(select deptno, job, round(avg(sal),0), count(*) from emp group by deptno, job
union all
select deptno, '부서합계',    round(avg(sal),0), count(*) from emp group by deptno
union all
select null, '총계',          round(avg(sal),0), count(*) from emp) t1
order by deptno, job;

-- roullup() : 자동으로 소계를 구해주는 함수
-- group by rollup(기준열...) -> n+1의 그룹
-- 기준열의 순서에 따라 집계가 달라진다. 기준열순서가 중요
select deptno
     , job
		 , count(*) 사원수
		 , round(avg(sal),0) 평균급여
  from emp
 group by rollup(deptno, job);

select deptno
     , job
		 , count(*) 사원수
		 , round(avg(sal),0) 평균급여
  from emp
 group by deptno, rollup(job);

select deptno
     , job
		 , count(*) 사원수
		 , round(avg(sal),0) 평균급여
  from emp
 group by rollup(job, deptno);

-- 실습. 
-- professor테이블에서 deptn, position별로 교수인원수, 급여합계구하기
-- rollup함수 이용
select deptno  담당학과
     , position 직급
		 , count(*) 인원수
		 , sum(pay) 급여합계
  from professor
 group by rollup(deptno, position);

-- cube()
-- 1. 부서별, 직급별, xxxm 사원수, 평균급여
-- 2. 부서별,          사원수, 평균급여
-- 3.         직급별, 사원수, 평균급여 -> roullup과 다른 점
-- 4. 전체합계,       사원수, 평균급여

select deptno
     , job
		 , count(*) 사원수
		 , round(avg(sal),0) 평균급여
  from emp
 group by rollup(deptno, job);
 
select deptno
     , job
		 , count(*) 사원수
		 , round(avg(sal),0) 평균급여
  from emp
 group by cube(deptno, job); 
 
/*
	E. 순위함수
	
	1. rank()       : 순위부여함수, 동일처리 1,2,2,4   
	2. dense_rank() : 순위부여함수, 동일처리 1,2,2,3
	3. row_number() : 행번호를 제공해 주는 함수, 동일처리, 1,2,3,4
	
	주의할 점 : 순위함수는 order by절과 함께 사용되야 한다.
*/ 

-- 1. rank()
-- 1) 특정자료기준 순위 : rank(조건값) within group(order by 조건값, 컬럼[asc|desc])
-- 2) 전체자료기준 순위 : rank() over(order by 조건값, 컬럼[asc|desc])


-- 실습. SMITH사원이 알파벳순으로 몇 번째인지?
select rownum, ename from emp;
select rownum, ename from emp order by ename;

select *
  from (select rownum, e.rn, e.ename 
          from (select rownum as rn, ename 
					        from emp order by ename) e)
 where ename = 'SMITH';

-- 1) 특정조건의 순위
select rank('SMITH') within group(order by ename) from emp;
select rank('SMITH') within group(order by ename asc) from emp;
select rank('SMITH') within group(order by ename desc) from emp;

-- 2) 전체자료기준 순위
-- emp에서 각 사원의 급여순위는
-- 급여가 작은순(asc), 급여가 많은순(desc)
select * from emp order by sal;

select ename
     , sal
		 , rank() over(order by sal)      -- 급여가 작은 순
		 , rank() over(order by sal desc) -- 급여가 많은 순
  from emp;
	
-- 2. dense_rank	
select ename
     , sal
		 , rank() over(order by sal)       -- rank()
		 , dense_rank() over(order by sal) -- dense_rank
  from emp;
	
-- 3. row_number() 행번호
select ename
     , sal
		 , rank() over(order by sal)       rank      
		 , dense_rank() over(order by sal) dense_rank 
		 , row_number() over(order by sal) row_number 
  from emp;	
	
/*
	E. 누적함수
	
	1. sum(컬럼) over([partition by 컬럼] order by 컬럼 [asc|desc]) - 누적을 구하는 함수
	2. ratio_to_report() : 비율구하는 함수
*/	

-- 1. sum() over()
select * from panmae;
select * from panmae where p_store = 1000 order by 1;

--  1000대리점의 판매일별 판매누계액 구하기
select p_date
     , p_code
		 , p_qty
		 , p_total
		 , sum(p_total)
  from panmae
 where p_store = 1000
 group by p_date, p_code, p_qty, p_total
 order by p_date;

select p_date
     , p_code
		 , p_qty
		 , p_total
		 , sum(p_total) over(order by p_date) 판매일자별누계액
  from panmae
 where p_store = 1000
 order by p_date;
 
--  판매일자/제품별 판매누계액
select p_date
     , p_code
		 , p_qty
		 , p_total
		 , sum(p_total) over(order by p_date, p_code) 판매일자별누계액
  from panmae
 where p_store = 1000
 order by p_date, p_code;
 
--  제품별/대리점별 기준 판매누계액 구하기(순서는 판매일자)
select *
  from panmae
 order by p_date, p_code, p_store; 
 
select p_date
     , p_code
		 , p_store
		 , p_qty
		 , p_total
		 , sum(p_total) over(partition by p_code, p_store order by p_date) 판매일자별누계액
  from panmae;
 
-- 2. ratio_to_report() 
-- 판매비율
select p_code
     , p_store
		 , p_qty
		 , sum(p_qty) over() 총판매량
		 , round(ratio_to_report(sum(p_qty)) over() * 100, 2) "수량(%)"
		 , p_total
		 , sum(p_total) over() 총판매금액
		 , round(ratio_to_report(sum(p_total)) over() * 100, 2) "금액(%)"
  from panmae
 where p_store = 1000
 group by p_code, p_qty, p_store, p_total;
 

/* 연습문제 */
-- 1. emp 테이블을 사용하여 사원 중에서 급여(sal)와 보너스(comm)를 합친 금액이 가장 많은 경우와 
--    가장 적은 경우 , 평균 금액을 구하세요. 단 보너스가 없을 경우는 보너스를 0 으로 계산하고 
--    출력 금액은 모두 소수점 첫째 자리까지만 나오게 하세요
-- MAX, MIN, AVG

-- 2. student 테이블의 birthday 컬럼을 참조해서 월별로 생일자수를 출력하세요
-- TOTAL, JAN, ...,  5 DEC
--  20EA   3EA ....

-- 3. Student 테이블의 tel 컬럼을 참고하여 아래와 같이 지역별 인원수를 출력하세요.
--    단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU, 055-GYEONGNAM
--    으로 출력하세요

-- 4. emp 테이블을 사용하여 직원들의 급여와 전체 급여의 누적 급여금액을 출력,
-- 단 급여를 오름차순으로 정렬해서 출력하세요.
-- sum() over()

-- 6. student 테이블의 Tel 컬럼을 사용하여 아래와 같이 지역별 인원수와 전체대비 차지하는 비율을 
--    출력하세요.(단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU,055-GYEONGNAM)
		 
-- 7. emp 테이블을 사용하여 부서별로 급여 누적 합계가 나오도록 출력하세요. 
-- ( 단 부서번호로 오름차순 출력하세요. )

-- 8. emp 테이블을 사용하여 각 사원의 급여액이 전체 직원 급여총액에서 몇 %의 비율을 
--    차지하는지 출력하세요. 단 급여 비중이 높은 사람이 먼저 출력되도록 하세요
	
-- 9. emp 테이블을 조회하여 각 직원들의 급여가 해당 부서 합계금액에서 몇 %의 비중을
--     차지하는지를 출력하세요. 단 부서번호를 기준으로 오름차순으로 출력하세요. 
 
 
 
 
 
 