/*
	PL/SQL
	
	오라클의 Procedural Language extension to SQL의 약자이다.
	SQL문장에서 변수정의, 조건처리(if), 반복처리(for, while, loop)등을 지원하며
	절차형 언어(Procedural Language)한다.
	
	declare문을 이용하여 정의하고 선언문은 사용자 정의한다. PL/SQL문은 블럭구조로
	되어 있고 PL/SQL에서 자체 compile엔진을 가지고 있다.
	
	1. PL/SQL의 장점
	
	1) block구조로 다수의 SQL문을 한번에 Oracle DB서버로 전송해서 처리하기 때문에 처리속도가 빠르다.
	2) PL/SQL의 모든 요소는 하나 또는 두 개이상의 블럭으로 구성하여 모듈화가 가능하다.
	3) 보다 강력한 프로그램을 작성하기 위해 큰 블럭(pacakge)안에 소블럭(package body)을 위치 시킬 수가 있다.
	4) variable(변수), constant(상수), cursor(커서), exception(예외처리)등을 정의할 수 있고 SQL문장과
	   procedural문장에서 사용할 수 있다.
  5) 변수선언은 테이블의 데이터구조와 컬럼명을 이용해서 동적으로 변수선언을 할 수가 있다.
	6) exception처리를 이용하여 oracle servr error처리를 할 수 있다. (ORA-9999 에러코드)
	7) 사용자가 에러를 정의할 수도 있고 exception처리를 할 수 있다.

  2. PL/SQL의 구조
	
	1) PL/SQL은 프로그램을 논리적인 블럭으로 나눈 구조화된 언어이다.
	2) 선언부(declare, 선택사항), 실행부(begin ... end, 필수), 예외(exception, 선택)로 구성되어 있다.
	   특히, 실행부는 반드시 기술을 해야 한다.
	3) 문법
	   
		 declare
		   -- 선택부분
			 -- 변수, 상수, 커서, 사용자예외처리
		 begin
			 -- 필수부분
			 -- PL/SQL문장을 기술(select, if, for....)
		 exception
			 -- 선택부분
			 -- 예외처리로직을 기술 
		 end;
		 
	3. PL/SQL의 종류
	
	   1) anonymous block(익명블럭) : 이름이 없는 블럭으로 보통 1회성으로 실행되는 블럭이다.
		 2) stored procedure : 매개변수를 전달 받을 수 있고 재사용이 가능하며 보통은 연속실행하거나
		    구현이 복잡한 트랜잭션을 수행하는 PL/SQL블럭으로 "데이터베이스 서버안에 저장"된다.
				처리속도가 빠르다. 저장되어있다는 의미로 stored procedure라고 한다.
		 3) function : procedure와 유사하지만 다른 점은 처리결과를 호출한 곳으로 반환해주는 값이 
		    있다는 것이다. 다만 in 파라미터만 사용할 수 있고 반드시 반환될 값의 데이터타입을 return문
				안에 선언해야 한다. 또한, PL/SQL블럭내에서 반드시 return문을 사용하여 값을 반환해야 한다.
		 4) package : 패키지는 오라트레 데이터베이스 서버에 저장되어 있는 procedure와 fuction의 집합이다.
		    패키지는 선언부(package)와 본문(package body) 두 부분으로 나누어 관리한다.
		 5) trigger: insert, update, delete등이 특정 테이블에서 실행될 때 자동으로 수행하도록 정의한
		    프로시저이다. 트리거는 테이블과 별도로 database에 저장(객체)된다. trigger는 table에 대해서만
			  정의할 수 있다.
		 
  4. 생성문법
	 
	   create or replace procedure[function] 프로시저명(펑션명) is[as]
		 begin
		 end 프로시저명;
*/
-- 1. procedure/function 생성 및 실행
create or replace procedure pro_01 is
begin
	dbms_output.put_line('Hello World!!!');
end pro_01;

-- 실행방법
-- exec pro_01       : SQL*Plus 에서 사용되는 오라클의 명령 즉, 표준명령이 아니다.
-- call 프로시저명() : 일반적인 방법 

-- 2. exception
create or replace procedure pro_02 is
	-- 선언부 :	변수선언
	v_counter    integer;  -- 변수선언방법 : 변수명   데이터타입, 선언된 변수는 실행부에서 사용가능
begin
	-- 실행부
	v_counter := 10;  -- 대입연산자(:=)로 변수초기화
	v_counter := v_counter + 10;	
	dbms_output.put_line('변수의 값은 ' || v_counter);
	v_counter := v_counter / 0;	
exception when others then
	-- 예외처리
	dbms_output.put_line('예외발생 : 0으로 나눌 수가 없습니다!');
	
end pro_02;

-- 3. if
create or replace procedure pro_03 is
	isSuccess boolean;
begin

	isSuccess := true; -- true or false
	
	if isSuccess
		then dbms_output.put_line('성공했습니다!!');
		else dbms_output.put_line('실패했습니다!!');
	end if;

end pro_03;

-- 4. 반복문 : for, while, loop
-- 1) for i in 1..10 loop .... end loop;
-- 2) while 조건 loop ... end loop;
-- 3) do ... while 조건;
create or replace procedure pro_04 is
begin

	for i in 1..10 loop
		dbms_output.put_line('i = ' || i);
	end loop;
	
end pro_04;

/*
	B. pl/sql의 데이터타입
	
	1. 스칼라 : scalar 데이터타입은 '일반데이터타입과 데이터변수 %type'이 있다.
	
	   1) 일반데이터타입
	
	      a. 선언방법 : 변수명 [constant] 데이터타입 [not null] [:= 상수값 or 표현식]
				   예) counter constant integer not null := 10 + 10;
			  b. 변수명(variable or identifier)의 이름은 SQL명명규칙을 따른다.
				c. identifier를 상수로 지정하고 싶을 경우에는 constant라는 키워드로 명시적으로 선언하고
				   반드시 초기값을 할당해야 한다.
					 예) counter constant integer := 10;
			  d. not null로 정의 되어 있다면 반드시 초기값을 지정, not null로 정의되어 있지 않다면 
				   초기값을 생략할 수도 있다.
			  e. 초기값은 할당연산자(:=)를 사용하여 지정
				f. 일반적으로 한 줄에 한 개의 identifier를 정의한다.
				g. 일반변수의 선언 방법
				
				   v_pi    constant  number(7,6) := 3.141592;
					 v_price constant  number(4,2) := 12.34;
					 v_name            varchar2(10);
					 v_flag            boolean not null := true;    
	
	   2) %type
		 
			  a. DB테이블의 컬럼 데이터타입을 모를 경우에도 사용할 수도 있고 테이블컴럼의 데이터타입정보가
				   변경이 될 경우에도 수정할 필요 없이 사용할 수가 있다.
				b. 이미 선언된 다른 변수나 테이블의 컬럼을 이요하여 선언(참조)할 수가 있다.	 
				c. DB테이블과 컬럼 그리고 이미 선언한 변수명이 %type앞에 올 수 있다.
			  d. %type속성을 이용하는 장점은
				   ... table의 column속성을 정확히 알지 못하는 경우에도 사용할 수가 있다.
					 ... table의 column속성이 변경되어도 pl/sql을 수정할 필요가 없다.
			  e. 선언방법
			     ... v_empno    emp.empno%type;
								
	2. %rowtype
	
		 하나 이상의 데이터값을 갖는 데이터타입으로 배열과 비슷한 역할을 하며 재사용이 가능하다.
		 %rowtype 데이터타입과 pl/sql의 table타입과 record타입은 복합데이터테입이다.
		 
		 a. 테이블이나 뷰의 내부컬럼의 데이터형, 크기, 속성등을 그대로 사용할 수 있다. 
		 b. %rowtype앞에는 테이블명이나 뷰명이 온다.
		 c. 지정된 테이블의 동일한 구조를 갖는 변수를 선언할 수 있다.
		 d. 데이터베이스 테이블컬럼의 갯수나 datatype을 알지 못할 경우에 사용하면 편리하다.
		 e. 테이블컬럼의 데이터타입이 변경되어도 pl/sql을 수정할 필요가 없다.
		 f. 선언방법
		    v_emp   emp%rowtype
				... 사용방법 : v_emp.empno, v_emp.ename...
			  
	3. record타입
	
		 1) record데이터타입은 여러 개의 데이터타입을 갖는 변수들의 집합
		 2) 스칼라, 테이블 or 레코드타입중 하나 이상의 요소로 구성할 수 있다.
		 3) 논리적 단위로 컬럼들의 집합을 처리할 수 있다.
		 4) pl/sql의 table타입과는 다르게 개별 필드의 이름을 부여, 선언시에 초기화가 가능하다.
		 5) 선언방법
		    type 레코드타입명 is record(
					컬럼1   데이터타입  [not null {:= 값 or 표현식}]
					...
					컬럼n   데이터타입  [not null {:= 값 or 표현식}]					
				);
	
	4. table타입
	
	   pl/sql에서 table타입은 db에서의 table과 성격이 다르다. pl/sql에서 table타입은 1차원 배열이다.
		 table타입은 크기에 제한이 없으며 row의 수는 데이터가 추가되면 자동으로 증가된다.
		 
		 binary_integer타입의 index번호가 순번으로 매겨진다. 하나의 테이블타입에는 한개의 컬럼데이터 및
		 여러개의 컬럼을 저장할 수 있다.
		 
		 선언방법
		 
		 1) 데이터타입(테이블타입)선언
		 
			  type 테이블타입명 is table of varchar2(20) index by binary_integer; -> 사용자가 새로운 타입을 정의
		 
		 2) 변수선언
		 
		    v_emp_ename_tab   테이블타입명; -> 사용자가 정의한 테이블타입(데이타타입)을 변수로 선언
				즉, 변선선언을 테이블타입의 변수로 선언한다는 의미이다.
				
		 3) %rowtype으로 table타입 선언
	
	      type 테이블타입명 is table of emp%rowtype index by binary_integer;
	      v_emp_tab   테이블타입명;

*/

-- pl/sql에서 사용되는 select문법은 일반 select문법과 다르다.
-- 1) 일반 SQL
select * from emp;

-- 2) pl/sql에서의 select 문법
select 컬럼1...컬럼n into 변수1...변수n
  from emp

-- 1. 스칼라데이터타입
-- 1) 일반데이터타입 vs %type
create or replace procedure pro_05 is
	v_empno   number;            -- 일반데이터타입
	v_ename   emp.ename%type;    -- 참조타입 %type
	v_sal     emp.sal%type;      -- 참조타입 %type 
begin

	select emp.empno, emp.ename, emp.sal
	  into v_empno, v_ename, v_sal
	  from emp
	 where ename = 'SMITH';
	 
	 dbms_output.put_line(v_ename || '의 사번은 '|| v_empno || ', 급여는 ' || v_sal || '원 입니다.');
		
end pro_05;

-- 2. %rowtypd
create or replace procedure pro_06 is
	v_emp   emp%rowtype;
begin

	select *
	  into v_emp
	  from emp
	 where emp.empno = 7499;
	 
	  dbms_output.put_line('사원번호 = ' || v_emp.empno);
	  dbms_output.put_line('사원이름 = ' || v_emp.ename);
	  dbms_output.put_line('사원급여 = ' || v_emp.sal);
	  dbms_output.put_line('커미션   = ' || v_emp.comm);
	  dbms_output.put_line('입사일자 = ' || v_emp.hiredate);
	  dbms_output.put_line('부서번호 = ' || v_emp.deptno);

end pro_06;

-- 3. record타입
-- record : empno, ename, sal, hiredate를 저장할 데이터타입을 선언
-- type 레코드명 is record(col1 데이터타입, ... coln 데이터타입);
create or replace procedure pro_07 is

	-- 	1st step : 사용자가 새로운 데이터타입을 작성
	type emp_rec is record(
		  v_empno     number
		, v_ename     varchar2(30)
		, v_sal       number
		, v_hiredate  date
	);
	
	-- 2nd step : 선언된 recoder타입을 사용할 변수선언
	v_emp_rec   emp_rec;
begin

	select empno, ename, sal, hiredate
	  into v_emp_rec.v_empno, v_emp_rec.v_ename, v_emp_rec.v_sal, v_emp_rec.v_hiredate
    from emp
	 where emp.ename = 'KING';
	 
	  dbms_output.put_line('사원번호 = ' || v_emp_rec.v_empno);
	  dbms_output.put_line('사원이름 = ' || v_emp_rec.v_ename);
	  dbms_output.put_line('사원급여 = ' || v_emp_rec.v_sal);
	  dbms_output.put_line('입사일자 = ' || v_emp_rec.v_hiredate);
		dbms_output.put_line('-----------------------------------');
 
 
	select empno, ename, sal, hiredate
	  into v_emp_rec
    from emp
	 where emp.ename = 'SMITH'; 
	 
	  dbms_output.put_line('사원번호 = ' || v_emp_rec.v_empno);
	  dbms_output.put_line('사원이름 = ' || v_emp_rec.v_ename);
	  dbms_output.put_line('사원급여 = ' || v_emp_rec.v_sal);
	  dbms_output.put_line('입사일자 = ' || v_emp_rec.v_hiredate);
			 
end pro_07;

-- 4. table타입

-- 1) 한건, 한개의 컬럼정의
-- 1차원배열과 유사한 데이터타입
-- type 테이블타입명 is table of 테이블한개의 컬럼 index by binary_integer;
create or replace procedure pro_08 is
	-- 1st step : table데이터타입을 정의
	type tbl_emp_name is table of hr.employees.first_name%type index by binary_integer;
	
	-- 2nd step : 새롭게 정의한 데이터타입 즉, 테이블타입으로 변수를 선언
	v_name   tbl_emp_name;  -- VARCHAR2(20)으로 선언
	v_name_1 varchar2(20);
	
begin

	select first_name
	  into v_name_1
		from hr.employees
	 where employee_id = 100;
	 
	 dbms_output.put_line('사원이름 = ' || v_name_1);
	 dbms_output.put_line('---------------------------');
	 
	 v_name(0) := v_name_1;
	 v_name(1) := '손흥민';
	 v_name(2) := '이강인';
	 
	 dbms_output.put_line('사원이름 = ' || v_name(0));
	 dbms_output.put_line('사원이름 = ' || v_name(1));
	 dbms_output.put_line('사원이름 = ' || v_name(2));

end pro_08;

-- 2) 여러건, 한개의 컬럼정의

create or replace procedure pro_09 is

	-- 1st step : 테이블타입을 정의
	type e_table_type is table of hr.employees.first_name%type index by binary_integer;
	
	-- 2nd setp : 새로 정의된 데이터타입 즉, 테이블타입으로 변수를 선언
	v_tab_type   e_table_type;    -- 2차원배열
	idx          binary_integer := 0;
begin

	for name in (select first_name ||'.'|| last_name as empname from hr.employees order by first_name) loop
		idx := idx + 1;
		v_tab_type(idx) := name.empname;  -- name %rowtype으로 처리가 되기 때문에 name.컬럼명
	end loop;
	
	for i in 1..idx loop
		dbms_output.put_line('사원이름 = ' || v_tab_type(i));
	end loop;
	
end pro_09;

-- 3) 여러건, 여러개의 컬럼정의
-- emp테이블에서 사원명과 직급을 출력하기
create or replace procedure pro_10 is

  -- 2개의 테이블타입 정의 즉, 사원명을 저장할 테이블타입과 직급을 저장할 테이블타입
	type tab_name_type is table of emp.ename%type index by binary_integer;
	type tab_job_type is table of emp.job%type index by binary_integer;
	
	-- 2개의 테이블타입을 사용할 변수를 선언
	v_name_table   tab_name_type;
	v_job_table    tab_job_type;
	idx            binary_integer := 0;
begin

	for name_job in (select ename, job from emp order by ename) loop
		idx := idx + 1;
		v_name_table(idx) := name_job.ename;
		v_job_table(idx) := name_job.job;
	end loop;
	
	dbms_output.put_line('======================');
	dbms_output.put_line('사원이름' || chr(9) || '직급');
	dbms_output.put_line('======================');
	
	for i in 1..idx loop
		dbms_output.put_line(v_name_table(i) || chr(9) || v_job_table(i));
	end loop;

exception when others then
	dbms_output.put_line('예외가 발생했습니다!!!');
	
end pro_10;

-- 실습1. hr.employees와 hr.departments를 읽어서
-- 사원이름(first_name.last_name)과 부서명을 출력
-- '사원명' || chr(9) || '부서명'
-- procedure명 : pro_ex_01
select first_name||'.'||last_name 사원명, department_name 부서명
  from hr.employees emp, hr.departments dpt
 where emp.department_id = dpt.department_id;

create or replace procedure pro_ex_01 is
  -- 2개의 테이블타입 정의 즉, 사원명을 저장할 테이블타입과 직급을 저장할 테이블타입
	type tab_ename is table of hr.employees.first_name%type index by binary_integer;
	type tab_dname is table of hr.departments.department_name%type index by binary_integer;
	
	-- 2개의 테이블타입을 사용할 변수를 선언
	v_ename   tab_ename;
	v_dname   tab_dname;
	idx       binary_integer := 0;
begin

	for data in (select first_name||'.'||last_name 사원명, department_name 부서명
                 from hr.employees emp, hr.departments dpt
                where emp.department_id = dpt.department_id) loop
		idx := idx + 1;
		v_ename(idx) := data.사원명;
		v_dname(idx) := data.부서명;								
	end loop;
		
	dbms_output.put_line('======================');
	dbms_output.put_line('사원명' || chr(9) || '부서명');
	dbms_output.put_line('======================');
	
	for i in 1..idx loop
		dbms_output.put_line(v_ename(i) || chr(9) || v_dname(i));
	end loop;	
		
exception when others then
	dbms_output.put_line('예외가 발생했습니다!!!');	
	
end pro_ex_01;

-- 7. table타입을 %rowtype으로 선언하기
-- dept테이블의 내용을 출력
create or replace procedure pro_11 is

	type t_dept is table of dept%rowtype index by binary_integer;
	v_dept    t_dept;
	idx       binary_integer := 0;
begin

	for l_dept in (select * from dept order by dname) loop
		idx := idx + 1;
-- 		v_dept(idx).deptno := l_dept.deptno;
-- 		v_dept(idx).dname  := l_dept.dname;
-- 		v_dept(idx).loc    := l_dept.loc;
		v_dept(idx) := l_dept; -- 2개 모두 dept의 %rowtype이기 때문에 대입가능
	end loop;
	
	for i in 1..idx loop
		dbms_output.put_line('부서번호 = ' || v_dept(i).deptno || chr(9) ||
		                     '부서이름 = ' || v_dept(i).dname  || chr(9) ||
												 '부서위치 = ' || v_dept(i).loc);
	end loop;
	
exception when others then
	dbms_output.put_line('예외가 발생했습니다!!!');	
	
end pro_11;

/*
	C. 제어문(if, case)
	
	1. 단순 if ~ end if;
	2. if ~ then ~ else end if;
	3. if ~ elsif ~... end if;
	4. case
*/

-- 1. 단순if
-- hr.employees에서 10=총무부, ... 40=인사부
select * from hr.departments where department_id < 50;

create or replace procedure pro_12 is
	
	v_emp_id     hr.employees.employee_id%type;
	v_name       hr.employees.first_name%type;
	v_dept_id    hr.employees.department_id%type;
	v_dname      varchar2(20);
begin

	select employee_id, first_name||'.'||last_name 사원명, department_id
	  into v_emp_id, v_name, v_dept_id
	  from hr.employees
	 where employee_id = 203;		

	-- 단순if
	if(v_dept_id = 10) then
		v_dname := '총무부';
	end if;
	
	if(v_dept_id = 20) then
		v_dname := '마케팅';
	end if;
	
	if(v_dept_id = 30) then
		v_dname := '구매부';
	end if;
	
	if(v_dept_id = 40) then
		v_dname := '인사부';
	end if;
	
	dbms_output.put_line(v_name || '의 부서는 ' || v_dname || '입니다!');
	
exception when others then
	dbms_output.put_line('예외가 발생했습니다!!!');	
	
end pro_12;

-- 2. if ~ then ~ else ~ end if;
-- hr.employees에서 commission이쓰면 보너스를 지급, 없으면 지급하지 않음
create or replace procedure pro_13 is

	v_emp_id     hr.employees.employee_id%type;
	v_name       hr.employees.first_name%type;
	v_sal        hr.employees.salary%type;
	v_comm       hr.employees.commission_pct%type;
	v_bonus      number;
	
begin
	
	select employee_id
	     , first_name||'.'||last_name 사원명
			 , salary
			 , nvl(commission_pct, 0)
			 , salary * nvl(commission_pct, 0)
	  into v_emp_id
		   , v_name
		   , v_sal
			 , v_comm
			 , v_bonus
	  from hr.employees
	 where employee_id = 157;
	
	if(v_comm > 0)
	then dbms_output.put_line(v_name ||'사원의 보너스는 '|| v_bonus ||'원 입니다!');	
	else dbms_output.put_line(v_name ||'사원의 보너스는 없습니다!');	
	end if;

end pro_13;

-- 3. if ~ elsif ~ elsif ~ end if;
-- hr.employees에서 10=총무부, ... 40=인사부
create or replace procedure pro_14 is

	v_emp_id     hr.employees.employee_id%type;
	v_name       hr.employees.first_name%type;
	v_dept_id    hr.employees.department_id%type;
	v_dname      varchar2(20);
	
begin

	select employee_id, first_name||'.'||last_name 사원명, department_id
	  into v_emp_id, v_name, v_dept_id
	  from hr.employees
	 where employee_id = 203;	
	 
	 if    (v_dept_id = 10) then v_dname := '총무부';
	 elsif (v_dept_id = 20) then v_dname := '마케팅';
	 elsif (v_dept_id = 30) then v_dname := '구매부';
	 elsif (v_dept_id = 40) then v_dname := '인사부';
	 end if;
	 
	dbms_output.put_line(v_name || '의 부서는 ' || v_dname || '입니다!');
	
exception when others then
	dbms_output.put_line('예외가 발생했습니다!!!');	
		 
end pro_14;

-- 4. case
create or replace procedure pro_15 is

	v_emp_id     hr.employees.employee_id%type;
	v_name       hr.employees.first_name%type;
	v_dept_id    hr.employees.department_id%type;
	v_dname      varchar2(20);
	
begin

	select employee_id, first_name||'.'||last_name 사원명, department_id
	  into v_emp_id, v_name, v_dept_id
	  from hr.employees
	 where employee_id = 203;	
	 
	-- if elsif를 case문으로 정의
	v_dname := case v_dept_id 
							 when 10 then '총무부'
							 when 20 then '마케팅'
							 when 30 then '구매부'
							 when 40 then '인사부'
	           end;
						
	dbms_output.put_line(v_name || '의 부서는 ' || v_dname || '입니다!');
	
exception when others then
	dbms_output.put_line('예외가 발생했습니다!!!');							
						
end pro_15;

/*
	D. 반복문(loop, for, while)
	
	1. loop          -> JavaScript의 do while 동일
	   end loop;
  
	2. for i in 1..10 loop
	   end loop;
		 
  3. while 조건 loop
	   end loop;
	
*/

-- 1. loop(do whil)
create or replace procedure pro_16 is

	cnt   number := 0;
begin

	loop
		cnt := cnt + 1;
		dbms_output.put_line('현재번호 = ' || cnt);		
		exit when cnt >= 10;
	end loop;
	
exception when others then
	dbms_output.put_line('예외가 발생했습니다!!!');			
		
end pro_16;

-- 2. while

create or replace procedure pro_17 is
	cnt   number := 0;
begin
	
	while cnt < 10 loop
		cnt := cnt + 1;
		dbms_output.put_line('현재번호 = ' || cnt);		
	end loop;
	
exception when others then
	dbms_output.put_line('예외가 발생했습니다!!!');			
		
end pro_17;

-- 함수나 프로시저 호출방법
call pro_17();

-- 3. fot
-- 1) for 카운트 in [reverse] start..end loop
--    end loop;
-- 2) for 객체리스트(%rowtype) in (select ~~~) loop
--    end loop;
create or replace procedure pro_18 is
begin
	
	for cnt in 1..10 loop
		dbms_output.put_line('현재번호 = ' || cnt);	
	end loop;
	
exception when others then
	dbms_output.put_line('예외가 발생했습니다!!!');			
		
end pro_18;

call pro_18();

/*
	E. 매개변수(in)가 있는 프로시저
	
	create or replace procedure 프로시저명(arg1 in 데이터타입, ... argn in 데이터타입) is
	begin
	end 프로시저명;
	
	call 프로시저명(10, '홍길동', '조선한양');
*/

-- 1. 사원번호와 급여인상율(10%)을 전달 받아서 해당사원의 급여를 인상하는 procedure 작성하기
create or replace procedure update_sal_emp(p_empno in number, p_percent in number) is
	v_bef_sal  number;
	v_aft_sal  number;
	v_ename    emp.ename%type;
begin
	
	dbms_output.put_line('사원번호 = '   || p_empno);	
	dbms_output.put_line('급여인상율 = ' || p_percent);	
	
	select sal
	  into v_bef_sal
		from emp
	 where empno = p_empno;
	 
	dbms_output.put_line('인상전 급여 = ' || v_bef_sal);	
	
	update emp
	   set sal = sal + (sal * p_percent / 100)
	 where empno = p_empno;
	 
  commit;
	
	select sal
	  into v_aft_sal
		from emp
	 where empno = p_empno;	

	dbms_output.put_line('인상후 급여 = ' || v_aft_sal);	
		
exception when others then
  rollback;
	dbms_output.put_line('예외가 발생했습니다!!!');	
		
end update_sal_emp;

call update_sal_emp(7369, 10);

-- 실습. emp에서 10번부서의 사원 급여를 15%인상후 급여를 출력
-- 프로시저명 : pro_sal_raise
-- for문, type is table of
-- '사원번호 chr(9) 사원이름 chr(9) 인상급여' 형태로 출력해 보기
create or replace procedure pro_sal_raise(p_deptno in number, p_percent in number) is
	
	type t_emp is table of emp%rowtype index by binary_integer;
	v_emp   t_emp;
	idx     binary_integer := 0;
begin

	dbms_output.put_line('부서번호 = '   || p_deptno);	
	dbms_output.put_line('급여인상율 = ' || p_percent);	

  update emp
	   set sal = sal + (sal * p_percent / 100)
	 where deptno = p_deptno;
	 
  commit;
	
	for l_emp in (select * from emp where deptno = p_deptno) loop
		idx        := idx + 1;
		v_emp(idx) := l_emp;
	end loop;
	
	dbms_output.put_line('==================================');	
	dbms_output.put_line('사원번호' || chr(9) || '사원이름' || chr(9) || '인상급여');	
	dbms_output.put_line('==================================');	

	for i in 1..idx loop
		dbms_output.put_line(v_emp(i).empno || chr(9) || v_emp(i).ename || chr(9) || v_emp(i).sal);	
	end loop;
	
exception when others then
  rollback;
	dbms_output.put_line('예외가 발생했습니다!!!');	
		
end pro_sal_raise;

call pro_sal_raise(10, 15);
call pro_sal_raise(20, 5);
call pro_sal_raise(30, 8);







