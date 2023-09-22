/*
	Join
	
	1. oracle 문법
		
		 select e.ename
		      , d.deptno
					, d.dname
		   from emp e, dept d
		  where e.deptno = d.deptno
			
	2. ANSI Join(표준)

		 select e.ename
		      , d.deptno
					, d.dname
			 from emp e [inner|outer|full] join dept d
				 on e.deptno = d.deptno 
				 
	 [관례]
	 join할 떄 table명칭은 별칭(직관적으로 알아보기 쉬운 약자)로 선언
*/

select * from emp;
select * from dept;

-- 사원명, 부서명출력
-- 1) oracle문법
select e.ename
     , e.deptno
		 , d.dname
  from emp e, dept d
 where e.deptno = d.deptno;

-- 2) ANSI 문법
select e.ename
     , e.deptno
		 , d.dname
  from emp e join dept d  -- inner join에서 inner가 생략
    on e.deptno = d.deptno;

-- 테이블명 별칭으로 정의
select emp.ename
     , emp.deptno
		 , dpt.dname
  from emp emp join dept dpt  
    on emp.deptno = dpt.deptno;

/*
	Join의 종류
	
	1. equi-join(동기조인), inner join
	2. outer-join
	3. full-join
*/

-- A. equi-join(inner join)
-- 실습1. student, professor에서 지도교수의 이름과 학생이름을 출력
-- oracle, ansi문법 각각 작성
-- 학생명과 교수명을 출력
select * from student;
select * from professor;

select count(*) from student;

select std.name 학생명
     , pro.name 교수명
  from student std, professor pro
 where std.profno = pro.profno;
 
select std.name 학생명
     , pro.name 교수명
  from student std inner join professor pro
    on std.profno = pro.profno;

select std.name 학생명
     , pro.name 교수명
  from professor pro inner join student std
    on std.profno = pro.profno;
		
-- 실습2. student, professor, department에서 교수명, 학생명, 학과명을 출력
-- 표준문법(where and), ansi(inner join)
select * from student;
select * from professor;
select * from department;		

select std.name
     , pro.name
		 , dpt.dname	
  from student    std
	   , professor  pro
	   , department dpt
 where std.deptno1 = pro.deptno
   and std.deptno1 = dpt.deptno;
	 
select std.name  학생명
     , pro.name  교수명
		 , dpt.dname 학과명
  from student    std 
				 inner join professor  pro on std.deptno1 = pro.deptno
	       inner join department dpt on std.deptno1 = dpt.deptno;
    
-- B. outter join(left/right)
select count(*) from student;
select count(*) from student where profno is null;		
    
-- inner join은 등가조인으로 조건에 맞는 자료만 출력
-- 지도교수가 정해져 있지 않은 학생도 출력될 수 있도록
select count(*)
  from student std, professor pro
 where std.profno = pro.profno(+); 

-- 1) 오라클에서만 사용되는 문법		
select std.name 학생명
     , pro.name 교수명
  from student std, professor pro
 where std.profno = pro.profno(+);
 
select std.name 학생명
     , pro.name 교수명
  from student std, professor pro
 where std.profno(+) = pro.profno; 
 
--2) ansi outter join
select std.name
     , pro.name
  from student std inner join professor pro on std.profno = pro.profno;

select std.name
     , pro.name
  from student std left outer join professor pro on std.profno = pro.profno;

select std.name
     , pro.name
  from student std right outer join professor pro on std.profno = pro.profno;

-- C. self join 
select empno from emp emp;
select mgr from emp mgr;
select emp.empno, emp.mgr from emp;

select emp.empno
     , emp.ename -- 사원
		 , mgr.empno
		 , mgr.ename -- 상사
  from emp emp, emp mgr
 where emp.mgr = mgr.empno;
	
/* 연습문제 */
-- ex01) student, department에서 학생이름, 학과번호, 1전공학과명출력	 
-- ex02) emp2, p_grade에서 현재 직급의 사원명, 직급, 현재 년봉, 해당직급의 하한
--       상한금액 출력 (천단위 ,로 구분)
-- ex03) emp2, p_grade에서 사원명, 나이, 직급, 예상직급(나이로 계산후 해당 나이의
--       직급), 나이는 오늘날자기준 trunc로 소수점이하 절삭 
-- ex04) customer, gift 고객포인트보다 낮은 포인트의 상품중에 Notebook을 선택할
--       수 있는 고객명, 포인트, 상품명을 출력	 
-- ex05) professor에서 교수번호, 교수명, 입사일, 자신보다 빠른 사람의 인원수
--       단, 입사일이 빠른 사람수를 오름차순으로
-- ex06) emp에서 사원번호, 사원명, 입사일 자신보다 먼저 입사한 인원수를 출력
--       단, 입사일이 빠른 사람수를 오름차순 정렬