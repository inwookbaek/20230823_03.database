/* 
	A. 집합연산자
	
	1. union     : 두 집합의 결과를 합쳐서 출력, 단 중복이 있을 경우 중복자료 제외, 정렬(O)
	2. union all : 두 집합의 결과를 합쳐서 출력, 단 중복이 있을 경우 중복자료 포함, 정렬(X)
	3. intersect : 두 집합의 교집합을 출력, 정렬(O) 
	4. minus     : 두 집합의 차집합을 출력, 정렬(O), 선후가 중요 
	
	[집합연산자의 조건]
	1. 두 집합의 select절의 컬럼갯수가 동일해야 한다.
	2. 두 집합의 select절의 같은 위치의 컬럼은 자료형이 동일해야 한다.
	3. 두 집합의 열멸이 달라도 상관없다. 단, 먼저 정의된 컬럼명으로 정해진다.
*/
select * from professor;
select * from student;

select studno 학생번호 from student;
select profno 교수번호 from professor;

-- 1. 합집합 union : 학생번호와 교수번호 정보를 하나로 합치기
select studno 학생번호 from student
union
select profno 교수번호 from professor;

select profno 교수번호 from professor
union
select studno 학생번호 from student;

select name 교수명 from professor
union 
select name 학생명 from student;

-- 자료형이 틀릴 경우
-- ORA-01790: expression must have same datatype as corresponding expression
select name 교수명 from professor
union 
select studno 학생번호 from student; 

-- 컬럼갯수가 다를 경우
-- ORA-01789: query block has incorrect number of result columns
select profno 교수번호, name 교수명 from professor
union 
select studno 학생번호 from student; 

-- 2. union / union all
select count(*) from student; -- count함수(집계) - 조회 테이블의 row건수 
select count(profno) from professor; 

select studno, name, deptno1 from student
union 
select studno, name, deptno1 from student; -- 중복제외, 정렬

select studno, name, deptno1 from student
union all
select studno, name, deptno1 from student; -- 중복포함, 정렬(X)

-- 3. 교집합 - intersect
select studno, name, deptno1 from student where deptno1 = 101
intersect
select studno, name, deptno1 from student where deptno1 = 102;

-- 4. 차집합 : minus
select studno, name, deptno1, 1 from student where deptno1 = 101
minus
select studno, name, deptno1, 2 from student where deptno1 = 102;

select studno, name, deptno1, 2 from student where deptno1 = 102
minus
select studno, name, deptno1, 1 from student where deptno1 = 101;




