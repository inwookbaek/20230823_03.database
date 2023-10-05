/*
	1. cursor(커서)
	
	   오라클 서버는 SQL문을 실행하고 처리한 정보를 저장하기 위해 'Private SQL Area'라는
		 메모리에 작업공간을 이용한다. 이 영역에 이름을 부여하고 저장정보를 처리할 할 수 있게
		 해주는 것이 커서(cursor)이라고 한다.
		 
		 cursor는 DML문과 select문에 의해 내부적으로 선언되는 묵시적커서와 명시적커서가 있다.
		 
		 pl/sql에서 select문은 한 개의 row만 검색할 수 있기 때문에 하나 이상의 row를 검색하기
		 위해서는 명시적커서가 필요하다.
		 
		 묵시적커서의 경우 pl/sql 블럭의 begin ... end에 sql문이 있다면 pl/sql은 "SQL"이라는
		 이름의 커서를 자동으로 생성한다.
	
	2. cursor종류
	
	   1) 묵시적커서
		 
		    묵시적커서는 오라클이나 pl/sql실행 매커니즘에 의해 처리되는 SQL문장이 처리되는 곳에
				대한 익명의 메모리주소이다. 오라클데이터베이스에서 실행되는 모든 SQL문장은 묵시적커서가
				생성이 되면 커서속성을 사용할 수 있다.
				묵시적커서는 SQL문이 실행되는 순간 자동으로 open과 close를 실행한다.
				
				묵시적커서의 속성
				
				a. sql%rowcount : 해당 sql문이 실행된 결과 총 행의 건수
				b. sql%found    : 해당 sql문 실행결과 행의 수가 1개 이상일 경우 true를 리턴
				c. sql%notfound : 해당 sql문 실행결과 행의 수가 없을 경우 true를 리턴
				d. sql%isopen   : 기본값 false, 묵시적커서가 오픈여부를 리턴				
		 
		 2) 명시적커서
		 
		    개발자에 의해 선언되고 이름이 부여된 커서를 말한다.
			  명시적커서의 진행순서는 "선언 -> open -> fetch -> close"의 순서로 진행된다.
				
				a. 문법 : cursor 커서명 is 서브쿼리
				b. 커서명령
				   a) 커서열기(open)
					     
							... 커서열기는 open문을 사용
							... 커서안의 검색이 실형결과 데이터가 추출되지 않아도 에러는 발생하지 않는다.
							... 문법 : open 커서명;
							... open 명령을 만나면 커서의 subquery가 실행되어 그 결과가 Private SQL Area에 저장
					 
					 b) 커서읽기(fetch)
					 
						  ... 커서의 fetch는 현재 데이터행을 output변수에 반환
							... 커서의 select문의 컬럼수와 output변수의 수가 동일해야 한다.
							... 커서컬럼데이타타입과 output변수의 데이터타입이 동일해야 한다.
							... 커서는 한 행씩만 데이터를 fetch한다.
							... 문법 : fetch 커서명 into 변수1,..., 변수n
					 
					 c) 커서닫기(close)
					 
					    ... 사용이 끝난 커서는 반드시 닫아 주어야 한다.
							... 필요한 경우 커서를 재 오픈할 수 있다.
							... 커서가 close가 된 경우 fetch를 할 수 없다.
							... 문법 : close 커서명;
							
*/

-- 1. 묵시적커서
create or replace procedure pro_19(p_empno in emp.empno%type) is
	v_ename       emp.ename%type;
	v_sal         emp.sal%type;
	v_update_row  number;
begin

	select ename, sal into v_ename, v_sal
	  from emp
	 where empno = p_empno;
	 
  -- 1. 검색자료가 있는 경우 update 수행
	if sql%found
		then dbms_output.put_line('자료가 있습니다!! ' || v_ename || '의 급여는 ' || v_sal || '원 입니다!');
	end if;
	
	update emp
	   set sal = 0
	 where empno between 100 and 110;
	 
	-- 수정된 행의 갯수
	v_update_row := sql%rowcount;
	dbms_output.put_line('급여가 수정된 사원의 건수 = ' || v_update_row);
	
	-- 2. 검색자료가 없는 경우 exception처리	 
exception 
	when no_data_found then dbms_output.put_line(p_empno || '의 자료가 없습니다!!');

end pro_19;

call pro_19(9999);
call pro_19(7369);

-- 2. 명시적커서
-- 1) 한건 : 특정수의 평균급여와 사원수를 출력
create or replace procedure pro_20(p_deptno in dept.deptno%type) is
	
	-- a) 커서선언
	cursor dept_avg is
	select dpt.dname               부서명
	     , count(emp.empno)        부서총인원수
			 , round(avg(emp.sal), 2)  부사평균급여
	  from emp emp, dept dpt
	 where emp.deptno = p_deptno
	   and emp.deptno = dpt.deptno
	 group by dpt.dname;
	
	
	-- b) 변수선언
	v_dname        dept.dname%type;
	v_emp_count    number;
	v_sal_avg      number;
begin

	-- 1. 커서오픈
	open dept_avg;
	
	-- 2. 커서읽기
	fetch dept_avg into v_dname, v_emp_count, v_sal_avg;
	dbms_output.put_line('부서이름 = ' || v_dname);
	dbms_output.put_line('부서인원 = ' || v_emp_count);
	dbms_output.put_line('부서평균 = ' || v_sal_avg);
	
	-- 3. 커서닫기
	close dept_avg;
	
exception
		when others then dbms_output.put_line('에러가 발생했습니다!');

end pro_20;

call pro_20(10);
call pro_20(20);
call pro_20(30);
call pro_20(40);


-- 2) 여러건 : for문안에 커서를 사용하기\
-- for문을 사용하면 open, fetch, close가 자동으로 진행되기 때문에
-- 별도로 기술할 필요가 없고 레코드이름도 자동으로 선언되기 때문에 별도로
-- 선언할 필요가 없다.
-- for 레코드드명 in 커서명 loop
-- end loop;
-- 부서별 인원수와 급여합계 출력
create or replace procedure pro_21 is
	
	cursor dept_sum is
	select dpt.dname 
	     , count(emp.empno)  총사원수
			 , sum(emp.sal)      총급여
	  from emp emp, dept dpt
	 where emp.deptno = dpt.deptno
	 group by dpt.dname;

begin

	for l_emp in dept_sum loop
		dbms_output.put_line('부서이름 = ' || l_emp.dname || ', 부서인원 = ' || l_emp.총사원수 || ', 부서평균 = ' || l_emp.총급여);		
	end loop;

exception
		when others then dbms_output.put_line(sqlerrm || ' 에러가 발생했습니다!');
	  -- ORA-9999 에러메시지
end pro_21;

call pro_21();

-- 3. 커서사용
-- 커서명%isopen, 커서명%notfound, 커서명%found, 커서명%rowcount
create or replace procedure pro_22 is

	v_empno  emp.empno%type;
	v_ename  emp.ename%type;
	v_sal    emp.sal%type;
	
	cursor emp_list is select empno, ename, sal from emp;

begin

	open emp_list;
	
	loop
		fetch emp_list into v_empno, v_ename, v_sal;
		dbms_output.put_line('사번 = ' || v_empno || ', 이름 = ' || v_ename || ', 급여 = ' || v_sal); 
		exit when emp_list%notfound;
	end loop;

	dbms_output.put_line('총처리건수 = ' || emp_list%rowcount);
	
	close emp_list;
	
exception
		when others then dbms_output.put_line(sqlerrm || ' 에러가 발생했습니다!');
		
end pro_22;

call pro_22();

-- 4. 파라미터가 있는 커서 사용하기
-- 커서가 오픈되고 질의가 실행되면 매개변수 값을 커서에 전달할 수 있다.
-- 다른 커서를 원할 경우에는 별도의 커서를 따로 선언해야 한다.
-- 부서번호를 전달받아서 해당 부서의 사원명을 출력하기
create or replace procedure pro_23(p_deptno dept.deptno%type) is

	v_ename    emp.ename%type;
	cursor emp_list(c_deptno emp.deptno%type) is 
	select ename from emp where deptno = c_deptno;
begin
	
	dbms_output.put_line('--- [ 선택된 부서소속의 사원명부 ] ---');
	
	-- 매개변수가 있는 커서를 for문안에 사용
	for l_emp in emp_list(p_deptno) loop
		dbms_output.put_line('사원이름 = ' || l_emp.ename);
	end loop;
	
exception
		when others then dbms_output.put_line(sqlerrm || ' 에러가 발생했습니다!');
		
end pro_23;

call pro_23(10);
call pro_23(20);
call pro_23(30);
call pro_23(40);


-- 5. 커서를 이용한 참조된 데이터를 수정하거나 삭제하기
-- where current of 명령
-- 1) 특정조건을 사용하지 않고도 현재 참조된 자료의 행을 수정, 삭제할 수가 있다.
-- 2) fetch문으로 최근에 사용된 행을 참조하기 위해서 사용하는 명령
-- 3) delete, update를 사용할 수 있다.
-- 4) where current of절을 사용할 때 참조하는 커서가 있어야 되고 for update절이 
--    커서선언절안에 있어야 한다. 만약에 없다면 에러가 발생한다.
create or replace procedure pro_24 is
	cursor emp_list is
	select empno, ename from emp
	 where empno = 7934 -- job -> CLERK
	   for update; -- for update는 커서가 오픈될때 행삭제, 수정하기전에 행을 lock
begin
	
	for l_emp in emp_list loop
		update emp
		   set job = '부장'
		 where current of emp_list;
		 dbms_output.put_line('성공적으로 자료가 수정되었습니다!!');
	end loop;
	
exception
		when others then dbms_output.put_line(sqlerrm || ' 에러가 발생했습니다!');

end pro_24;

call pro_24();

	select * from emp
	 where empno = 7934
	 
-- 실습) 성적관리를 위한 프로시저만들기(with cursor)
-- 성적테이블
create table sungjuk (
			hakbun   varchar2(10)
		, name     varchar2(10)
		, kor      number(3)
		, eng      number(3)
		, mat      number(3)
);
insert into sungjuk values(1001, '홍길동',90,80,70);
insert into sungjuk values(1002, '홍길순',100,100,100);
insert into sungjuk values(1003, '홍길자',90,80,70);
insert into sungjuk values(1004, '홍길녀',70,60,50);
insert into sungjuk values(1005, '홍길영',70,70,70);
select * from sungjuk;

-- 성적결과테이블
create table sungresult(
			hakbun   varchar2(10)
		, name     varchar2(10)
		, kor      number(3)
		, eng      number(3)
		, mat      number(3)		
		, tot      number(3)
		, avg      number(4,1)
		, hak      varchar2(2)	-- A+, ~ F
	  , pass     varchar2(10)
	  , rank     number	
);
haknun
-- 1. sungjuk파일을    커서 c_sungjuk    로 정의
-- 2. sungresult파일을 커서 c_sungresult
-- 3. >=95 A+, >=90 A0, >=85 B+ 5점단위... >= 60 D0 else 'F'
-- 4. 성적의 평균이 >= 70 pass= 'pass' else pass='fail';
-- 5. insert into sungresult() value()
-- 6. update sungresult rank = 순위를 update	 
select * from sungjuk;
select * from sungresult;

create or replace procedure pro_25 is
begin
end pro_25;


/* 연습문제 */
-- ex01) 두 숫자를 제공하면 덧셈을 해서 결과값을 반환하는 함수를 정의
-- 함수명은 add_num

-- ex02) 부서번호를 입력하면 해당 부서에서 근무하는 사원 수를 반환하는 함수를 정의
-- 함수명은 get_emp_count

-- ex03) emp에서 사원번호를 입력하면 해당 사원의 관리자 이름을 구하는 함수
-- 함수명 get_mgr_name

-- ex04) emp테이블을 이용해서 사원번호를 입력하면 급여 등급을 구하는 함수
-- 4000~5000 A, 3000~4000미만 B, 2000~3000미만 C, 1000~200미만 D, 1000미만 F 
-- 함수명 get_sal_grade

